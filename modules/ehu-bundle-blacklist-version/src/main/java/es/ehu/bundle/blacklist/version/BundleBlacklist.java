/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */

package es.ehu.bundle.blacklist.version;

										
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.framework.BundleEvent;
import org.osgi.framework.BundleListener;
import org.osgi.framework.SynchronousBundleListener;
import org.osgi.framework.startlevel.BundleStartLevel;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.lpkg.deployer.LPKGDeployer;

/**
 * @author UPV/EHU
 */
@Component(
	configurationPid = "es.ehu.bundle.blacklist.version.BundleBlacklistConfiguration",
	immediate = true, service = BundleBlacklist.class
)
public class BundleBlacklist {

	public List<String> getBlacklistBundleSymbolicNames() {
		return new ArrayList<>(_uninstalledBundles.keySet());
	}

	@Activate
	@Modified
	protected void activate(
			BundleContext bundleContext, Map<String, String> properties)
		throws Exception {

		Bundle bundle = bundleContext.getBundle();

		_blacklistFile = bundle.getDataFile(_BLACKLIST_FILE_NAME);

		Bundle systemBundle = bundleContext.getBundle(0);

		BundleContext systemBundleContext = systemBundle.getBundleContext();

		if (_selfMonitorBundleListener == null) {
			_selfMonitorBundleListener = new SelfMonitorBundleListener(
				bundle, systemBundleContext, _lpkgDeployer,
				_uninstalledBundles);
		}

		systemBundleContext.addBundleListener(_selfMonitorBundleListener);

		_loadFromBlacklistFile();

		BundleBlacklistConfiguration bundleBlacklistConfiguration =
			ConfigurableUtil.createConfigurable(
				BundleBlacklistConfiguration.class, properties);

		_blacklistBundleSymbolicNames = new HashSet<>(
			Arrays.asList(
				bundleBlacklistConfiguration.blacklistBundleSymbolicNames()));

		_blacklistBundleSymbolicNames.remove(BundleUtil.getSymbolicNameAndVersion(bundle));

		bundleContext.addBundleListener(_bundleListener);

		_scanBundles(bundleContext);

		Set<Map.Entry<String, UninstalledBundleData>> entrySet =
			_uninstalledBundles.entrySet();

		Iterator<Map.Entry<String, UninstalledBundleData>> iterator =
			entrySet.iterator();

		while (iterator.hasNext()) {
			Map.Entry<String, UninstalledBundleData> entry = iterator.next();

			String symbolicName = entry.getKey();

			if (!_blacklistBundleSymbolicNames.contains(symbolicName)) {
				if (_log.isInfoEnabled()) {
					_log.info("Reinstalling bundle " + symbolicName);
				}

				UninstalledBundleData uninstalledBundleData = entry.getValue();

				BundleUtil.installBundle(
					bundleContext, _lpkgDeployer,
					uninstalledBundleData.getLocation(),
					uninstalledBundleData.getStartLevel());		

				iterator.remove();

				_removeFromBlacklistFile(symbolicName);
			}
		}
	}

	private void _addToBlacklistFile(
			String symbolicName, UninstalledBundleData uninstalledBundleData)
		throws IOException {

		Properties blacklistProperties = new Properties();

		if (_blacklistFile.exists()) {
			try (InputStream inputStream = new FileInputStream(
					_blacklistFile)) {

				blacklistProperties.load(inputStream);
			}
		}

		blacklistProperties.setProperty(
			symbolicName, uninstalledBundleData.toString());

		try (OutputStream outputStream = new FileOutputStream(_blacklistFile)) {
			blacklistProperties.store(outputStream, null);
		}
	}

	private void _loadFromBlacklistFile() throws IOException {
		if (!_blacklistFile.exists()) {
			return;
		}

		Properties blacklistProperties = new Properties();

		try (InputStream inputStream = new FileInputStream(_blacklistFile)) {
			blacklistProperties.load(inputStream);
		}

		Set<Map.Entry<Object, Object>> entries = blacklistProperties.entrySet();

		for (Map.Entry<Object, Object> entry : entries) {
			String value = (String)entry.getValue();

			Matcher matcher = _pattern.matcher(value);

			if (matcher.matches()) {
				_uninstalledBundles.put(
					(String)entry.getKey(),
					new UninstalledBundleData(
						matcher.group(1), Integer.valueOf(matcher.group(2))));
			}
		}
	}

	private boolean _processBundle(Bundle bundle) {
		String symbolicNameAndVersion = BundleUtil.getSymbolicNameAndVersion(bundle);
		
		if (_blacklistBundleSymbolicNames.contains(symbolicNameAndVersion)) {
			if (_log.isInfoEnabled()) {
				_log.info("Stopping blacklisted bundle " + bundle);
			}

			BundleStartLevel bundleStartLevel = bundle.adapt(
				BundleStartLevel.class);

			UninstalledBundleData uninstalledBundleData =
				new UninstalledBundleData(
					bundle.getLocation(), bundleStartLevel.getStartLevel());

			_uninstalledBundles.put(symbolicNameAndVersion, uninstalledBundleData);

			try {
				bundle.uninstall();

				_addToBlacklistFile(symbolicNameAndVersion, uninstalledBundleData);
			}
			catch (Exception exception) {
				_log.error("Unable to uninstall " + bundle, exception);

				_uninstalledBundles.remove(symbolicNameAndVersion);
			}

			return true;
		}

		return false;
	}

	private void _removeFromBlacklistFile(String symbolicName)
		throws IOException {

		Properties blacklistProperties = new Properties();

		if (_blacklistFile.exists()) {
			try (InputStream inputStream = new FileInputStream(
					_blacklistFile)) {

				blacklistProperties.load(inputStream);
			}
		}

		blacklistProperties.remove(symbolicName);

		try (OutputStream outputStream = new FileOutputStream(_blacklistFile)) {
			blacklistProperties.store(outputStream, null);
		}
	}

	private void _scanBundles(
		BundleContext bundleContext) {

		List<Bundle> uninstalledBundles = new ArrayList<>();

		for (Bundle bundle : bundleContext.getBundles()) {
			if ((bundle.getState() != Bundle.UNINSTALLED) &&
				_processBundle(bundle)) {

				uninstalledBundles.add(bundle);
			}
		}

		if (!uninstalledBundles.isEmpty()) {
			BundleUtil.refreshBundles(bundleContext, uninstalledBundles);
		}
	}

	private static final String _BLACKLIST_FILE_NAME = "blacklist-ehu.properties";

	private static final Log _log = LogFactoryUtil.getLog(
		BundleBlacklist.class);

	private static final Pattern _pattern = Pattern.compile(
		"\\{location=([^,]+), startLevel=(\\d+)\\}");

	private Set<String> _blacklistBundleSymbolicNames;
	private File _blacklistFile;

	private final BundleListener _bundleListener =
		new SynchronousBundleListener() {

			@Override
			public void bundleChanged(BundleEvent bundleEvent) {
				if (bundleEvent.getType() == BundleEvent.INSTALLED) {
					_processBundle(bundleEvent.getBundle());
				}
			}

		};

	@Reference
	private LPKGDeployer _lpkgDeployer;

	private BundleListener _selfMonitorBundleListener;
	private final Map<String, UninstalledBundleData> _uninstalledBundles =
		new ConcurrentHashMap<>();

}
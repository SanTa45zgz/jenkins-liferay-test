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

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.util.HashMapDictionary;
import com.liferay.portal.kernel.util.SetUtil;
import com.liferay.portal.kernel.util.StringUtil;

import java.io.IOException;

import java.util.Collection;
import java.util.Collections;
import java.util.Dictionary;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.function.Function;

import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.framework.FrameworkUtil;
import org.osgi.framework.ServiceEvent;
import org.osgi.framework.ServiceListener;
import org.osgi.framework.ServiceReference;
import org.osgi.service.cm.Configuration;
import org.osgi.service.cm.ConfigurationAdmin;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author UPV/EHU
 */
@Component(immediate = true, service = BundleBlacklistManager.class)
public class BundleBlacklistManagerImpl implements BundleBlacklistManager {

	@Override
	public void addToBlacklistAndUninstall(String... bundleSymbolicNames)
		throws IOException {

		_updateProperties(
			blacklistBundleSymbolicNames -> {
				if (blacklistBundleSymbolicNames == null) {
					return bundleSymbolicNames;
				}

				Set<String> blacklistBundleSymbolicNamesSet = SetUtil.fromArray(
					blacklistBundleSymbolicNames);

				Collections.addAll(
					blacklistBundleSymbolicNamesSet, bundleSymbolicNames);

				return blacklistBundleSymbolicNamesSet.toArray(new String[0]);
			});
	}

	@Override
	public Collection<String> getBlacklistBundleSymbolicNames() {
		return _bundleBlacklist.getBlacklistBundleSymbolicNames();
	}

	@Override
	public void removeFromBlacklistAndInstall(String... bundleSymbolicNames)
		throws IOException {

		_updateProperties(
			blacklistBundleSymbolicNames -> {
				if (blacklistBundleSymbolicNames == null) {
					return null;
				}

				Set<String> blacklistBundleSymbolicNamesSet = SetUtil.fromArray(
					blacklistBundleSymbolicNames);

				for (String bundleSymbolicName : bundleSymbolicNames) {
					blacklistBundleSymbolicNamesSet.remove(bundleSymbolicName);
				}

				return blacklistBundleSymbolicNamesSet.toArray(new String[0]);
			});
	}

	private void _updateConfiguration(
			Configuration configuration, Dictionary<String, Object> properties)
		throws IOException {

		Bundle bundle = FrameworkUtil.getBundle(BundleBlacklistManager.class);

		BundleContext bundleContext = bundle.getBundleContext();

		CountDownLatch countDownLatch = new CountDownLatch(1);

		ServiceListener serviceListener = new ServiceListener() {

			@Override
			public void serviceChanged(ServiceEvent serviceEvent) {
				if (serviceEvent.getType() != ServiceEvent.MODIFIED) {
					return;
				}

				ServiceReference<?> serviceReference =
					serviceEvent.getServiceReference();

				Object service = bundleContext.getService(serviceReference);

				if (_bundleBlacklist == service) {
					countDownLatch.countDown();
				}

				bundleContext.ungetService(serviceReference);
			}

		};

		bundleContext.addServiceListener(serviceListener);

		try {
			configuration.update(properties);

			countDownLatch.await();
		}
		catch (InterruptedException interruptedException) {
		}
		finally {
			bundleContext.removeServiceListener(serviceListener);
		}
	}

	private void _updateProperties(Function<String[], String[]> updateFunction)
		throws IOException {

		Configuration configuration = _configurationAdmin.getConfiguration(
			BundleBlacklistConfiguration.class.getName(), StringPool.QUESTION);

		Dictionary<String, Object> properties = configuration.getProperties();

		String[] blacklistBundleSymbolicNames = null;

		if (properties == null) {
			properties = new HashMapDictionary<>();
		}
		else {
			// LPS-114840

			Object value = properties.get("blacklistBundleSymbolicNames");

			if (value instanceof String) {
				blacklistBundleSymbolicNames = StringUtil.split((String)value);
			}
			else {
				blacklistBundleSymbolicNames = (String[])properties.get(
					"blacklistBundleSymbolicNames");
			}
		}

		blacklistBundleSymbolicNames = updateFunction.apply(
			blacklistBundleSymbolicNames);

		if (blacklistBundleSymbolicNames == null) {
			return;
		}

		if (blacklistBundleSymbolicNames.length == 0) {
			properties.remove("blacklistBundleSymbolicNames");
		}
		else {
			properties.put("blacklistBundleSymbolicNames", blacklistBundleSymbolicNames);
		}

		_updateConfiguration(configuration, properties);
	}

	@Reference
	private BundleBlacklist _bundleBlacklist;

	@Reference
	private ConfigurationAdmin _configurationAdmin;

}
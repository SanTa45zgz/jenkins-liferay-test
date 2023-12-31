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

										
import com.liferay.osgi.util.bundle.BundleStartLevelUtil;
import com.liferay.petra.reflect.ReflectionUtil;
import com.liferay.portal.lpkg.deployer.LPKGDeployer;

import java.util.Map;

import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.framework.BundleEvent;
import org.osgi.framework.BundleListener;

/**
 *@author UPV/EHU
 */
public class SelfMonitorBundleListener implements BundleListener {

	public SelfMonitorBundleListener(
		Bundle bundle, BundleContext systemBundleContext,
		LPKGDeployer lpkgDeployer,
		Map<String, UninstalledBundleData> uninstalledBundles) {

		_bundle = bundle;
		_systemBundleContext = systemBundleContext;
		_lpkgDeployer = lpkgDeployer;
		_uninstalledBundles = uninstalledBundles;
	}

	@Override
	public void bundleChanged(BundleEvent bundleEvent) {
		Bundle bundle = bundleEvent.getBundle();

		if (!bundle.equals(_bundle)) {
			return;
		}

		if (bundleEvent.getType() == BundleEvent.STARTED) {

			// In case of STARTED, that means the blacklist bundle was updated
			// or refreshed, we must unregister the self monitor listener to
			// release the previous bundle revision

			_systemBundleContext.removeBundleListener(this);

			return;
		}

		if (bundleEvent.getType() != BundleEvent.UNINSTALLED) {
			return;
		}

		for (UninstalledBundleData uninstalledBundleData :
				_uninstalledBundles.values()) {

			try { 
				BundleUtil.installBundle(
											 
					_systemBundleContext, _lpkgDeployer,
					uninstalledBundleData.getLocation(),
					uninstalledBundleData.getStartLevel());
			}
			catch (Throwable t) {
				ReflectionUtil.throwException(t);
			}
		}

		_systemBundleContext.removeBundleListener(this);
	}

	private final Bundle _bundle;
	private final LPKGDeployer _lpkgDeployer;
	private final BundleContext _systemBundleContext;
	private final Map<String, UninstalledBundleData> _uninstalledBundles;

	static {
		ClassLoader classLoader =
			SelfMonitorBundleListener.class.getClassLoader();

		try {
			classLoader.loadClass(BundleStartLevelUtil.class.getName());
			classLoader.loadClass(BundleUtil.class.getName());
		}
		catch (ClassNotFoundException classNotFoundException) {
			throw new ExceptionInInitializerError(classNotFoundException);
		}
	}

}
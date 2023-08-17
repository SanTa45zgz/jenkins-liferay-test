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

import java.io.IOException;

import java.util.Collection;

/**
 * @author UPV/EHU
 */
public interface BundleBlacklistManager {

	public void addToBlacklistAndUninstall(String... bundleSymbolicNames)
		throws IOException;

	public Collection<String> getBlacklistBundleSymbolicNames();

	public void removeFromBlacklistAndInstall(String... bundleSymbolicNames)
		throws IOException;

}
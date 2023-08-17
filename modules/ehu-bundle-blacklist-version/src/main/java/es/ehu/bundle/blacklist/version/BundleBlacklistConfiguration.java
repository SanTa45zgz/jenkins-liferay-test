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

import aQute.bnd.annotation.metatype.Meta;

import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;

/**
 * @author UPV/EHU
 */
@ExtendedObjectClassDefinition(category = "module-container")
@Meta.OCD(
	id = "es.ehu.bundle.blacklist.version.BundleBlacklistConfiguration",
	localization = "content/Language",
	name = "ehu-portal-bundle-blacklist-service-configuration-name"
)
public interface BundleBlacklistConfiguration {

	@Meta.AD(
		deflt = "", name = "blacklist-bundle-symbolic-names", required = false
	)
	public String[] blacklistBundleSymbolicNames();

}
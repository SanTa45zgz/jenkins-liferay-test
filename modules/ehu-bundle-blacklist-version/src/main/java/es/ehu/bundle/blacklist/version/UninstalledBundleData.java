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

import com.liferay.petra.string.StringBundler;

/**
 * @author UPV/EHU
 */
public class UninstalledBundleData {

	public UninstalledBundleData(String location, int startLevel) {
		_location = location;
		_startLevel = startLevel;
	}

	public String getLocation() {
		return _location;
	}

	public int getStartLevel() {
		return _startLevel;
	}

	@Override
	public String toString() {
		StringBundler sb = new StringBundler(5);

		sb.append("{location=");
		sb.append(_location);
		sb.append(", startLevel=");
		sb.append(_startLevel);
		sb.append("}");

		return sb.toString();
	}

	private final String _location;
	private final int _startLevel;

}
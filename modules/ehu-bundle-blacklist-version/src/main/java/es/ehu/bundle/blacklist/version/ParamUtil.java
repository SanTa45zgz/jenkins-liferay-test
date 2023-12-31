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

import com.liferay.petra.string.CharPool;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.util.ArrayUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * @author UPV/EHU
 */
public class ParamUtil {

	public static Map<String, String[]> getParameterMap(String location) {
		int index = location.indexOf(CharPool.QUESTION);

		if (index == -1) {
			return Collections.emptyMap();
		}

		String queryString = location.substring(index + 1);

		if (Validator.isNull(queryString)) {
			return Collections.emptyMap();
		}

		String[] parameters = StringUtil.split(queryString, CharPool.AMPERSAND);

		Map<String, String[]> parameterMap = new HashMap<>();

		for (String parameter : parameters) {
			if (parameter.length() > 0) {
				String[] kvp = StringUtil.split(parameter, CharPool.EQUAL);

				if (kvp.length == 0) {
					continue;
				}

				String key = kvp[0];

				String value = StringPool.BLANK;

				if (kvp.length > 1) {
					value = kvp[1];
				}

				String[] values = parameterMap.get(key);

				if (values == null) {
					parameterMap.put(key, new String[] {value});
				}
				else {
					parameterMap.put(key, ArrayUtil.append(values, value));
				}
			}
		}

		return parameterMap;
	}

}
package es.ehu.doc.web.core.util;

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
//import com.liferay.portal.kernel.util.StringPool;
//import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;


public class QueryParserUtil {

	private static Log _log = LogFactoryUtil.getLog(QueryParserUtil.class);
	
	private final static String USERID = "[$USERID$]";
	private final static String SCREENNAME = "[$SCREENNAME$]";
	private final static String LOCALE = "[$LOCALE$]";
	private final static String COUNTRY = "[$COUNTRY$]";
	private final static String LANGUAGE = "[$LANGUAGE$]";
	private final static String COMPANYID = "[$COMPANYID$]";
	private final static String GROUPID = "[$GROUPID$]";


	public static String parse(String query, ThemeDisplay themeDisplay) {

		if (query != null && query != StringPool.BLANK) {

			if (query.contains(USERID)) {
				query = query.replace(USERID, themeDisplay.getUserId() + "");
			}
			if (query.contains(SCREENNAME)) {
				query = query.replace(SCREENNAME, themeDisplay.getUser().getScreenName());
			}
			if (query.contains(LOCALE)) {
				query = query.replace(LOCALE, themeDisplay.getLocale() + "");
			}
			if (query.contains(COUNTRY)) {
				query = query.replace(COUNTRY, themeDisplay.getLocale().getCountry() + "");
			}
			if (query.contains(LANGUAGE)) {
				query = query.replace(LANGUAGE, themeDisplay.getLocale().getLanguage() + "");
			}
			if (query.contains(COMPANYID)) {
				query = query.replace(COMPANYID, themeDisplay.getCompanyId() + "");
			}
			if (query.contains(GROUPID)) {
				query = query.replace(GROUPID, themeDisplay.getScopeGroupId() + "");
			}

		}

		return query;
	}

}

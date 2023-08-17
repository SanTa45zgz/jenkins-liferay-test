package es.ehu.doc.web.core.util;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.TimeZone;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil;

public class CustomDateFormatFactoryUtil {
	
	private static Log _log = LogFactoryUtil.getLog(CustomDateFormatFactoryUtil.class);
	
	private static SimpleDateFormat dtEs = new SimpleDateFormat("dd-MM-yyyy / HH:mm:ss");
	private static SimpleDateFormat dtEu = new SimpleDateFormat("yyyy-MM-dd / HH:mm:ss");
	

	public static Format getDateTime(Locale locale, TimeZone timeZone) {
		
		if (locale.equals(new Locale("es","ES"))) {
			return dtEs;
		} else if (locale.equals(new Locale("eu","ES"))) {
			return dtEu;
		} else {
			return FastDateFormatFactoryUtil.getDateTime(locale, timeZone);
//			return DateFormatFactoryUtil.getDateTime(locale, timeZone);			
		}

	}
	
}
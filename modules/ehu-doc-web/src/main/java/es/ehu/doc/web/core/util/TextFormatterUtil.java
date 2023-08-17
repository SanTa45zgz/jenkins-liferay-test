package es.ehu.doc.web.core.util;

import java.text.NumberFormat;
import java.util.Locale;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class TextFormatterUtil {
	
	private static Log _log = LogFactoryUtil.getLog(TextFormatterUtil.class);

	
	public static String formatKB(int size, Locale locale) {
		
		return formatKB((double)size, locale);
	}
	

	public static String formatKB(double size, Locale locale) {
		
		String text = "";
		// Liferay
//		text = TextFormatter.formatKB(size, locale) + "k";		
		// Custom
		if (size < (1024 * 1024.0)) {
			NumberFormat numberFormat = NumberFormat.getInstance(locale);
			numberFormat.setMaximumFractionDigits(1);
			numberFormat.setMinimumFractionDigits(1);
			text = numberFormat.format(size / 1024.0) + " KB";
			
		} else {
			NumberFormat numberFormat = NumberFormat.getInstance(locale);
			numberFormat.setMaximumFractionDigits(1);
			numberFormat.setMinimumFractionDigits(1);
			text = numberFormat.format(size / 1024.0 / 1024.0) + " MB";
		}

		return text;
	}
	
}
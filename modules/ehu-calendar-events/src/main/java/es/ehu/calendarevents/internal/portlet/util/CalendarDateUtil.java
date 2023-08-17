package es.ehu.calendarevents.internal.portlet.util;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;

public class CalendarDateUtil {
	
	public static final String MADRID_TIMEZONE_ID = "Europe/Madrid";

	public static final Date getLocalDate() {
		return new Date(getLocalCalendar().getTimeInMillis());
	}

	public static final Calendar getLocalCalendar() {
		Calendar calendar = Calendar.getInstance();
		DateTime localDateTime = getLocalDateTime();
		calendar.set(localDateTime.getYear(), localDateTime.getMonthOfYear() - 1, localDateTime.getDayOfMonth(),
				localDateTime.getHourOfDay(), localDateTime.getMinuteOfHour(), localDateTime.getSecondOfMinute());
		return calendar;
	}

	public static final DateTime getLocalDateTime() {
		Date now = new Date();
		TimeZone tz = TimeZone.getTimeZone(MADRID_TIMEZONE_ID);
		DateTimeZone jodaTz = DateTimeZone.forID(tz.getID());
		DateTime dateTime = new DateTime(now, jodaTz);
		return dateTime;
	}
}

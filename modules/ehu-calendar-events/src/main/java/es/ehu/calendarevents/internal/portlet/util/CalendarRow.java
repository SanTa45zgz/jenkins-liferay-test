package es.ehu.calendarevents.internal.portlet.util;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.liferay.journal.model.JournalArticle;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.DateUtil;
import com.liferay.portal.kernel.util.LocaleUtil;

import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;
import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;

public class CalendarRow {

	private static final Log _log = LogFactoryUtil.getLog( CalendarRow.class );

	private String _html	= "";
	private int _numDias	= 0;
	private GregorianCalendar _calendar = new GregorianCalendar();
	
	public CalendarRow( Date date ) {
		_calendar.setTime( date );
		String _calendarString = DateUtil.getDate(_calendar.getTime(),  "dd/MM/yyyy", LocaleUtil.SPAIN);
		String dateString = DateUtil.getDate(date, "dd/MM/yyyy", LocaleUtil.SPAIN);
		_log.debug( "Dia: " + _calendarString + ". Dia date: " + dateString );
	};
	
	public void GeneraHtml(  List<JournalArticle> listArticlesMes, int indSemana, int diaDelMes, int tipoVista ) {
		StringBuilder sbRow = new StringBuilder();
		int numDiasMes = _calendar.getActualMaximum( Calendar.DATE );
		int indPrimerDiaSem = CalendarUtils.GetWeekIndexFromCalendar( _calendar );
		_log.debug( "numDiasMes: " + numDiasMes + ". indPrimerDiaSem: " + indPrimerDiaSem );
		int numDias = 0;
		if( diaDelMes <= numDiasMes ) {
			sbRow.append( GetHtmlCalendarNewRow( CalendarEventsPortletKeys.cHtmlTagTipo_Abrir ) );
			
			for( int indDiaSemana=CalendarEventsPortletKeys.cInd_PrimerDiaSemana; indDiaSemana<=CalendarEventsPortletKeys.cInd_UltimoDiaSemana; indDiaSemana++ ) {
				boolean noDia = false;
				if( ( indSemana == 0 && indDiaSemana < indPrimerDiaSem ) || ( diaDelMes > numDiasMes ) ) {
					sbRow.append( CalendarUtils.GetHtmlCalendarDayEmpty( indDiaSemana ) );
					noDia = true;
				} else {
					boolean festivo = ( indDiaSemana == CalendarEventsPortletKeys.cInd_UltimoDiaSemana );
					numDias++;
				}
				diaDelMes++;
			}

			sbRow.append( GetHtmlCalendarNewRow( CalendarEventsPortletKeys.cHtmlTagTipo_Cerrar ) );
		}
		
		_html = sbRow.toString();
		_numDias = numDias;
		
		return;
	}

	public String GetHtml() { return _html; }
	
	public int GetNumDias() { return _numDias; }
	
	private static String GetHtmlCalendarNewRow( int tipo ) {
		if( tipo == CalendarEventsPortletKeys.cHtmlTagTipo_Abrir ) return( "<tr class=\"yui3-calendar-row\">" );
		if( tipo == CalendarEventsPortletKeys.cHtmlTagTipo_Cerrar ) return( "</tr>" );

		return( "" );
	}
	

}

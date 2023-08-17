package es.ehu.calendarevents.internal.portlet.calendar.command;

import java.util.GregorianCalendar;
import java.util.List;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.journal.model.JournalArticle;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.JSONPortletResponseUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.Validator;

import es.ehu.calendarevents.configuration.CalendarEventsConfiguration;
import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;
import es.ehu.calendarevents.internal.display.context.CalendarEventsDisplayContext;
import es.ehu.calendarevents.internal.portlet.manager.SearchManager;
import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;
import es.ehu.calendarevents.internal.portlet.util.CommonUtils;

@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name="+ CalendarEventsPortletKeys.EHUCALENDAREVENTS,
	        "mvc.command.name=/changeMonthCal"
	    },
	    service = MVCResourceCommand.class
	)
public class ChangeMonthCalMVCResourceCommand extends BaseMVCResourceCommand{
	
	private static final Log _log = LogFactoryUtil.getLog(ChangeMonthCalMVCResourceCommand.class);
	
	@Reference
	private SearchManager _searchManager;
	@Reference
	private CommonUtils commonUtils;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {

		final JSONArray responseJSON = JSONFactoryUtil.createJSONArray();
				
		final String mesActual = ParamUtil.getString(resourceRequest, "calmes", "");
		final String anioActual = ParamUtil.getString(resourceRequest, "calanio", "");
		final String monthPrevNext = ParamUtil.getString(resourceRequest, "monthPrevNext", "");
		
		final String typesSelect = ParamUtil.getString(resourceRequest, "typesSelected", null); 
		final String catgsSelect = ParamUtil.getString(resourceRequest, "catgsSelected", null);
		
		int mes = 0;
		int anio = 0;
		
		if (Validator.isNotNull(mesActual) && Validator.isNotNull(anioActual)) {
			mes = Integer.parseInt( mesActual );
			anio = Integer.parseInt( anioActual );
			if( monthPrevNext.contentEquals( "prevMonth" ) ) {
				if( mes > 1 )
					mes--;
				else {
					mes = 12; anio--;
				}
			} else { // nextMonth
				if( mes < 12 )
					mes++;
				else {
					mes = 1; anio++;
				}
			}
			String strMes = String.valueOf( mes );
			String strAnio = String.valueOf( anio );
			GregorianCalendar fechaMes = new GregorianCalendar( anio, mes - 1, 1 );
			final List<JournalArticle> articlesCalendario = _searchManager.findJournalArticles( resourceRequest, typesSelect, catgsSelect, fechaMes, null, SearchManager.cSearchType_All );
			
			//Se recupera y guarda en la request el tipo de vista
			CalendarEventsConfiguration calendarEventsConfiguration = (CalendarEventsConfiguration)resourceRequest.getAttribute(CalendarEventsConfiguration.class.getName());
			CalendarEventsDisplayContext displayContext = new CalendarEventsDisplayContext(calendarEventsConfiguration, PortalUtil.getHttpServletRequest(resourceRequest));			
			int tipoVista = displayContext.getCalendarEventsPortletInstanceConfiguration().tipoVista();			
			_log.debug("tipoVista:" + tipoVista);
			final String calendariopinta = CalendarUtils.getEventsByMonth(resourceRequest,articlesCalendario, strAnio, strMes, tipoVista);
			
			final JSONArray calendarioPrevMonth = JSONFactoryUtil.createJSONArray();
			calendarioPrevMonth.put(calendariopinta);
			
			final JSONArray mesPrev = JSONFactoryUtil.createJSONArray();
			mesPrev.put(strMes);
			final HttpServletRequest origrequest = PortalUtil.getOriginalServletRequest(PortalUtil.getHttpServletRequest(resourceRequest));
			final String mesName = LanguageUtil.get(origrequest, "calendar.mes"+strMes);
			mesPrev.put(mesName);
			final JSONArray anioPrev = JSONFactoryUtil.createJSONArray();
			anioPrev.put(strAnio);
			
			responseJSON.put(calendarioPrevMonth);
			responseJSON.put(mesPrev);
			responseJSON.put(anioPrev);
		}
		
		JSONPortletResponseUtil.writeJSON(resourceRequest, resourceResponse, responseJSON);
	}

}

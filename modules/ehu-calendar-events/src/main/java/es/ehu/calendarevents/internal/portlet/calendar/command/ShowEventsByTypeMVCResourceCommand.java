package es.ehu.calendarevents.internal.portlet.calendar.command;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.journal.model.JournalArticle;
import com.liferay.journal.service.JournalArticleLocalService;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.JSONPortletResponseUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.util.DateUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;

import es.ehu.calendarevents.configuration.CalendarEventsConfiguration;
import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;
import es.ehu.calendarevents.internal.display.context.CalendarEventsDisplayContext;
import es.ehu.calendarevents.internal.portlet.manager.SearchManager;
import es.ehu.calendarevents.internal.portlet.util.CalendarDateUtil;
import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;
import es.ehu.calendarevents.internal.portlet.util.CommonUtils;


@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name="+ CalendarEventsPortletKeys.EHUCALENDAREVENTS,
	        "mvc.command.name=/showEventsByType"
	    },
	    service = MVCResourceCommand.class
	)
public class ShowEventsByTypeMVCResourceCommand  extends BaseMVCResourceCommand{

	private static final Log _log = LogFactoryUtil.getLog( ShowEventsByTypeMVCResourceCommand.class );
	@Reference
	private SearchManager _searchManager;
	@Reference
	private CommonUtils _commonUtils;
	@Reference
	JournalArticleLocalService _journalArticleLocalService;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		JSONArray responseJSON = JSONFactoryUtil.createJSONArray();
		
		Calendar currentDate = CalendarDateUtil.getLocalCalendar();
	
		String mes = ParamUtil.getString(resourceRequest, "calmes", null);
		String anio = ParamUtil.getString(resourceRequest, "calanio", null);
		if (mes == null && anio == null){
			mes = Integer.toString(currentDate.get(Calendar.MONTH)+1);
			anio = Integer.toString(currentDate.get(Calendar.YEAR));
		}

		String typesSelect = ParamUtil.getString(resourceRequest, "typesSelected", null);
		String catgsSelect = ParamUtil.getString(resourceRequest, "catgsSelected", null);
		
		GregorianCalendar fechaMes = new GregorianCalendar( Integer.valueOf( anio ), Integer.valueOf( mes ) - 1, 1 );
		final List<JournalArticle> articlesCalendario = _searchManager.findJournalArticles( resourceRequest, typesSelect, catgsSelect, fechaMes, null, SearchManager.cSearchType_All );


		//Se recupera y guarda en la request el tipo de vista
		CalendarEventsConfiguration calendarEventsConfiguration = (CalendarEventsConfiguration)resourceRequest.getAttribute(CalendarEventsConfiguration.class.getName());
		CalendarEventsDisplayContext displayContext = new CalendarEventsDisplayContext(calendarEventsConfiguration, PortalUtil.getHttpServletRequest(resourceRequest));			
		int tipoVista = displayContext.getCalendarEventsPortletInstanceConfiguration().tipoVista();			
		_log.debug("tipoVista:" + tipoVista);	
		
		String calendariopinta = CalendarUtils.getEventsByMonth(resourceRequest, articlesCalendario, anio, mes, tipoVista);
		
		JSONArray calendarioEventType = JSONFactoryUtil.createJSONArray();
		calendarioEventType.put(calendariopinta);
		
		List<JournalArticle> articlesListadoCal = _searchManager.findJournalArticles( resourceRequest, typesSelect, catgsSelect, null, currentDate, SearchManager.cSearchType_All );

		String listadoEventos = CalendarUtils.getListadoEventosActual(resourceRequest, articlesListadoCal, currentDate, false, tipoVista, _commonUtils);
		
		JSONArray eventosByType = JSONFactoryUtil.createJSONArray();
		eventosByType.put(listadoEventos);
		
		responseJSON.put(calendarioEventType);
		responseJSON.put(eventosByType);
		
		JSONPortletResponseUtil.writeJSON(resourceRequest, resourceResponse, responseJSON);
	}

}

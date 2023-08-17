package es.ehu.calendarevents.internal.portlet.calendar.command;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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

import com.liferay.portal.kernel.util.ParamUtil;

import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;
import es.ehu.calendarevents.internal.portlet.manager.SearchManager;
import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;
import es.ehu.calendarevents.internal.portlet.util.CommonUtils;

@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name="+ CalendarEventsPortletKeys.EHUCALENDAREVENTS,
	        "mvc.command.name=/showEventsByDay"
	    },
	    service = MVCResourceCommand.class
	)
public class ShowEventsByDayMVCResourceCommand extends BaseMVCResourceCommand{
	
	private static final Log _log = LogFactoryUtil.getLog(ShowEventsByDayMVCResourceCommand.class);
	@Reference
	private SearchManager _searchManager;
	@Reference
	private JournalArticleLocalService _journalArticleLocalService;
	@Reference
	private CommonUtils _commonUtils;

	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		int dia = ParamUtil.getInteger(resourceRequest, "dia");
		int mes = ParamUtil.getInteger(resourceRequest, "mes") - 1;
		int anyo = ParamUtil.getInteger(resourceRequest, "anyo");
		int tipoVista = ParamUtil.getInteger(resourceRequest, "tipoVista");
		String typesSelect = ParamUtil.getString(resourceRequest, "typesSelected", null);
		String catgsSelect = ParamUtil.getString(resourceRequest, "catgsSelected", ""); 
		
		Calendar fechaSelect = Calendar.getInstance();
		
		Date date = new GregorianCalendar(anyo, mes, dia).getTime();
		fechaSelect.setTime(date);

		JSONArray responseJSON = JSONFactoryUtil.createJSONArray();
		
		List<JournalArticle> articlesCalendario = _searchManager.findJournalArticles( resourceRequest, typesSelect, catgsSelect, null, fechaSelect, SearchManager.cSearchType_Redu );
		
		String listadoEventos = CalendarUtils.getListadoEventosActual(resourceRequest, articlesCalendario, fechaSelect, true, tipoVista, _commonUtils);		

		JSONArray eventosByDay = JSONFactoryUtil.createJSONArray();
		eventosByDay.put(listadoEventos);
		responseJSON.put(eventosByDay);
		
		if( tipoVista == CalendarEventsPortletKeys.cEventsViewTipo_Popup ) {
			//cabecera
			JSONArray headerPopupEventosByDay = JSONFactoryUtil.createJSONArray();						
			String dateFormat = (resourceRequest.getLocale().toString().equals("es_ES") ? "dd/MM/yyyy":"yyyy/MM/dd");
			SimpleDateFormat showDateSdf =  new SimpleDateFormat(dateFormat);
			String dateShow = showDateSdf.format(date.getTime());						
			headerPopupEventosByDay.put(dateShow);			
			responseJSON.put(headerPopupEventosByDay);
		}
		
		JSONPortletResponseUtil.writeJSON(resourceRequest, resourceResponse, responseJSON);
	}

}

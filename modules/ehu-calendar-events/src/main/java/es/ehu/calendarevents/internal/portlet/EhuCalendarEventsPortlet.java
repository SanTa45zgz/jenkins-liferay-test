package es.ehu.calendarevents.internal.portlet;

import com.liferay.journal.model.JournalArticle;
import com.liferay.journal.service.JournalArticleLocalService;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.module.configuration.ConfigurationException;
import com.liferay.portal.kernel.module.configuration.ConfigurationProvider;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.GroupLocalService;
import com.liferay.portal.kernel.service.LayoutLocalService;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.IOException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.calendarevents.configuration.CalendarEventsConfiguration;
import es.ehu.calendarevents.configuration.CalendarEventsPortletInstanceConfiguration;
import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;
import es.ehu.calendarevents.internal.display.context.CalendarEventsDisplayContext;
import es.ehu.calendarevents.internal.portlet.manager.SearchManager;
import es.ehu.calendarevents.internal.portlet.util.CalendarDateUtil;
import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;
import es.ehu.calendarevents.internal.portlet.util.CommonUtils;

@Component(
	configurationPid = "es.ehu.calendarevents.configuration.CalendarEventsPortletInstanceConfiguration",
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.cms",
		"com.liferay.portlet.header-portlet-css=/css/calendar.css",
		"com.liferay.portlet.instanceable=false",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.init-param.config-template=/configuration.jsp",
		"javax.portlet.name=" + CalendarEventsPortletKeys.EHUCALENDAREVENTS,
		"javax.portlet.supported-public-render-parameter=calmes",
		"javax.portlet.supported-public-render-parameter=calanio",
		"javax.portlet.supported-public-render-parameter=monthPrevNext",
		"javax.portlet.supported-public-render-parameter=showEventByDate",
		"javax.portlet.supported-public-render-parameter=day",
		"javax.portlet.supported-public-render-parameter=mesConsultar",
		"javax.portlet.supported-public-render-parameter=year",
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)


/**
 * 
 * @author UPV/EHU
 *
 */
public class EhuCalendarEventsPortlet extends MVCPortlet {
	
	
	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {

		try {
			renderRequest.setAttribute(
					CalendarEventsConfiguration.class.getName(),
					_configurationProvider.getCompanyConfiguration(CalendarEventsConfiguration.class,_portal.getCompanyId(renderRequest)));
			
			renderRequest.setAttribute(
					CalendarEventsPortletInstanceConfiguration.class.getName(),
					_getCalendarEventsPortletInstanceConfiguration(renderRequest));
			
			defaultRenderCommand(renderRequest, renderResponse);
		}
		catch (ConfigurationException configurationException) {
			throw new PortletException(configurationException);
		}
		_log.debug("EhuCalendarEventsPortlet - render");
		super.render(renderRequest, renderResponse);
		
	}
	
	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {

		try {
			renderRequest.setAttribute(
					CalendarEventsConfiguration.class.getName(),
					_configurationProvider.getCompanyConfiguration(CalendarEventsConfiguration.class,_portal.getCompanyId(renderRequest)));
			
			renderRequest.setAttribute(
					CalendarEventsPortletInstanceConfiguration.class.getName(),
					_getCalendarEventsPortletInstanceConfiguration(renderRequest));
		}
		catch (ConfigurationException configurationException) {
			throw new PortletException(configurationException);
		}
		_log.debug("EhuCalendarEventsPortlet - doView");
		super.doView(renderRequest, renderResponse);
		
	}
	
	/**
	 * 
	 * @param renderRequest
	 * @return
	 * @throws PortletException
	 */
	private CalendarEventsPortletInstanceConfiguration
	_getCalendarEventsPortletInstanceConfiguration(RenderRequest renderRequest)
		throws PortletException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay)renderRequest.getAttribute(
			WebKeys.THEME_DISPLAY);
		
		PortletDisplay portletDisplay = themeDisplay.getPortletDisplay();
		
		try {
			return portletDisplay.getPortletInstanceConfiguration(
					CalendarEventsPortletInstanceConfiguration.class);
		}
		catch (ConfigurationException configurationException) {
			throw new PortletException(configurationException);
		}
	}

	/**
	 * 
	 * @param renderRequest
	 * @param renderResponse
	 * @throws PortletException
	 */
	private void defaultRenderCommand(RenderRequest renderRequest, RenderResponse renderResponse) throws PortletException {
		try {						
			ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);

			Map<Long, String> namesKey = _commonUtils.getTypeNamesEventsSelected(themeDisplay);
			Map<Long, String[]> mapCategories = _commonUtils.GetCategoriesSelected( themeDisplay );
			
			
			CalendarEventsConfiguration calendarEventsConfiguration = (CalendarEventsConfiguration)renderRequest.getAttribute(CalendarEventsConfiguration.class.getName());

			//String typesSelect = "7916186";
			//String catgsSelect = "33902105, 33902133";
			String typesSelect = "7916186";
			String catgsSelect = "33902105, 33902133";
			if (Validator.isNotNull(calendarEventsConfiguration.idStructures())) {
				_log.error("typesSelect debe ser 7916186 y es :" + typesSelect);
				typesSelect = StringUtil.merge(calendarEventsConfiguration.idStructures());
				_log.error("typesSelect debe ser 7916186 y es :" + typesSelect);
			}
			if (Validator.isNotNull(calendarEventsConfiguration.idCategories())) {
				_log.error("catgsSelect debe ser 33902105, 33902133 y es :" + catgsSelect);
				catgsSelect = StringUtil.merge(calendarEventsConfiguration.idCategories());
				_log.error("catgsSelect debe ser 33902105, 33902133 y es :" + catgsSelect);
			}
			
			
			Calendar currentDate = CalendarDateUtil.getLocalCalendar();
			
			List<String> meses = CalendarUtils.getMeses();
			
			String mes = ParamUtil.getString(renderRequest, "calmes", null);
			String anio = ParamUtil.getString(renderRequest, "calanio", null);
			if( mes == null && anio == null ) {
				mes = Integer.toString(currentDate.get(Calendar.MONTH)+1);
				anio = Integer.toString(currentDate.get(Calendar.YEAR));
			}
			
			GregorianCalendar fechaMes = new GregorianCalendar( Integer.valueOf( anio ), Integer.valueOf( mes ) - 1, 1 );
			List<JournalArticle> articlesCalendario = _searchManager.findJournalArticles( renderRequest, typesSelect, catgsSelect, fechaMes, null, SearchManager.cSearchType_All );

		
			//Se recupera y guarda en la request el tipo de vista
			CalendarEventsDisplayContext displayContext = new CalendarEventsDisplayContext(calendarEventsConfiguration, PortalUtil.getHttpServletRequest(renderRequest));			
			int tipoVista = displayContext.getCalendarEventsPortletInstanceConfiguration().tipoVista();			
			_log.debug("tipoVista:" + tipoVista);
			renderRequest.setAttribute("tipoVista", tipoVista);
			
			String calendariopinta = CalendarUtils.getEventsByMonth(renderRequest, articlesCalendario, anio, mes, tipoVista);
			
			renderRequest.setAttribute("mesConsultar", mes);
			renderRequest.setAttribute("anioConsultar", anio);
			renderRequest.setAttribute("meses", meses);
			renderRequest.setAttribute("calendario", calendariopinta);
						
			List<JournalArticle> articlesListadoCal = _searchManager.findJournalArticles( renderRequest, typesSelect, catgsSelect, null, currentDate, SearchManager.cSearchType_All );
			String listadoCal = CalendarUtils.getListadoEventosActual(renderRequest, articlesListadoCal, currentDate, false, tipoVista, _commonUtils);						
			renderRequest.setAttribute("listadoCal", listadoCal);
			
			renderRequest.setAttribute( "filtroCal",  namesKey );
			renderRequest.setAttribute( "filtroCatgsCal",  mapCategories );
			renderRequest.setAttribute( "typesSelected", typesSelect );
			renderRequest.setAttribute( "catgsSelected", catgsSelect );
			renderRequest.setAttribute( "windowState",  renderRequest.getWindowState() );
			
			
			//se recuperar la friendly de la pagina en la que se encontrara el publicador con todos los eventos, esta friendlyURL estara configurada en el campo personaliazado de sitio FriendlyPageEvents
			long groupId = themeDisplay.getScopeGroupId();
			Group sitio = _groupLocalService.fetchGroup(groupId);			
			String friendlyURLEvents = Validator.isNotNull(sitio.getExpandoBridge().getAttribute(CalendarEventsPortletKeys.EXPANDO_URL_PAGE_EVETNS))?sitio.getExpandoBridge().getAttribute(CalendarEventsPortletKeys.EXPANDO_URL_PAGE_EVETNS).toString():StringPool.BLANK;
			
			Layout layout = _layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURLEvents);			
			if(Validator.isNotNull(layout)) {
				String urlLayoutEvents = PortalUtil.getLayoutFriendlyURL(layout, themeDisplay);
				renderRequest.setAttribute("friendlyURLEvents", urlLayoutEvents);
			}			
		} catch (Exception e) {
			throw new PortletException(e);
		}
		
		
	}
	 
	
	@Reference
	private ConfigurationProvider _configurationProvider;
	
	@Reference
	private SearchManager _searchManager;
	@Reference
	private JournalArticleLocalService _journalArticleLocalService;
	@Reference
	private CommonUtils _commonUtils;
	@Reference
	private GroupLocalService _groupLocalService;
	@Reference
	private LayoutLocalService _layoutLocalService;
	
	@Reference
	private Portal _portal;
	
	private static final Log _log = LogFactoryUtil.getLog(EhuCalendarEventsPortlet.class);
	
	
}
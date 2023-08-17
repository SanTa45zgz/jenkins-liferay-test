package es.ehu.calendarevents.internal.portlet.util;

import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.model.AssetVocabulary;
import com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetEntryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetVocabularyLocalService;
import com.liferay.asset.kernel.service.AssetVocabularyLocalServiceUtil;
import com.liferay.journal.model.JournalArticle;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.LayoutTypePortlet;
import com.liferay.portal.kernel.model.Portlet;
import com.liferay.portal.kernel.service.GroupLocalServiceUtil;
import com.liferay.portal.kernel.service.LayoutLocalServiceUtil;
import com.liferay.portal.kernel.service.PortletLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.CalendarFactoryUtil;
import com.liferay.portal.kernel.util.DateUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.LayoutTypePortletFactoryUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.xml.Document;
import com.liferay.portal.kernel.xml.DocumentException;
import com.liferay.portal.kernel.xml.SAXReaderUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

import javax.portlet.PortletRequest;
import javax.servlet.http.HttpServletRequest;

import org.joda.time.DateTimeComparator;
import org.osgi.service.component.annotations.Reference;

import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;

public class CalendarUtils {
	
	/* constantes */

	private static final Log _log = LogFactoryUtil.getLog( CalendarUtils.class );
	
	private static final String NAME_VOCABULARY_LOCALIZATION	= "Kokalekuak";																
	private static final int cCalNumDias						= 7;																
	private static final int cCalNumSemanas						= 6;																
	
	/* metodos */

	// ================================================================================================
	/**
	 * El metodo obtiene y devuelve una lista con aquellas categorias pertenecientes al vocabulario
	 * "Agenda" con las que esten categorizados los contenidos de la lista "eventosMes" y que ademas
	 * esten vigentes en el dia "fecha".<p>
	 * Se presupone que los contenidos de la lista "eventosMes" son contenidos de tipo evento y tienen
	 * vigencia dentro de un mes concreto.<p>
	 * En la lista de categorias a devolver no habra categorias repetidas.<p>
	 * @author 				Alberto Soto
	 * @since				15/11/2021
	 * @param	eventosMes	lista de contenidos de tipo evento con vigencia en un mes concreto
	 * @param	fecha		fecha en la que debe estar vigente un contenido para ser considerado valido
	 * @return				lista de categorias del vocabulario "Agenda" que poseen los contenidos
	 */
	// ================================================================================================
	public static List<AssetCategory> GetAgendaCategories( List<JournalArticle> eventosMes, Calendar fecha ) {
		//se recorren los journals de este dia y se devuelve la lista de categorias del vocabulario Agenda que tienen asociadas dichos articulos

		List<JournalArticle> journalsDay = _GetEventListByDay( eventosMes, fecha  );
		List<AssetCategory> lisCategories = new ArrayList<AssetCategory>();
		for( JournalArticle article : journalsDay ) {
			CommonUtils.ListaCategoriesAddUnique( lisCategories, GetAgendaCategories( article ) );
		}
		
		return( lisCategories );
	}
	
	// ================================================================================================
	/**
	 * El metodo obtiene y devuelve una lista con aquellas categorias pertenecientes al vocabulario
	 * "Agenda" con las que esta categorizado el contenido "article".<p>
	 * En la lista de categorias a devolver no habra categorias repetidas.<p>
	 * @author 				Alberto Soto
	 * @since				15/11/2021
	 * @param	article		contenido para el que obtener la lista de categorias del vocabulario "Agenda"
	 * @return				lista de categorias del vocabulario "Agenda" que posee el contenido
	 */
	// ================================================================================================
	public static List<AssetCategory> GetAgendaCategories( JournalArticle article ) {
		//se devuelve la lista de categorias del vocabulario Agenda que tiene asociadas "article"

		final String cJournalModel = JournalArticle.class.getName();
		List<AssetCategory> lisCategories = new ArrayList<AssetCategory>();
		List<AssetCategory> articleCategories = AssetCategoryLocalServiceUtil.getCategories( cJournalModel, article.getResourcePrimKey() );
		for( AssetCategory category : articleCategories ) {
			try {
				AssetVocabulary vocabulary = AssetVocabularyLocalServiceUtil.getVocabulary( category.getVocabularyId() );
				if( vocabulary.getTitle( LocaleUtil.fromLanguageId("eu")  ).equals( CalendarEventsPortletKeys.cVocabularyName_Agenda ) ) {
					
					CommonUtils.ListaCategoriesAddUnique( lisCategories, category );
				}
			}
			catch( PortalException pe ) {
				_log.warn( "Ha habido un problema al obtener el vocabulario para la categoria " + category.getCategoryId() + ": " + pe.getMessage() );
				if( _log.isDebugEnabled() ) pe.printStackTrace();
			}

		}
		
		return( lisCategories );
	}
	
	public static String getEventsByMonth(PortletRequest request, List<JournalArticle> eventosMes, String anyoActual, String mesActual, int tipoVista) throws PortalException {
		Calendar fechaHoy = CalendarDateUtil.getLocalCalendar();

		fechaHoy.set(Calendar.YEAR, fechaHoy.get(Calendar.YEAR));
		fechaHoy.set(Calendar.MONTH, fechaHoy.get(Calendar.MONTH));
		fechaHoy.set(Calendar.DATE, fechaHoy.get(Calendar.DATE));

		String anyo = anyoActual;
		String mes = mesActual;
		int mesInt = Integer.parseInt(mesActual);
		mesInt -= 1;
		mes = Integer.toString(mesInt);
		if (anyo.equals("")) {
			anyo = new Integer(fechaHoy.get(Calendar.YEAR)).toString();
		}
		if (mes.equals("")) {
			mes = new Integer(fechaHoy.get(Calendar.MONTH)).toString();
		}
		Calendar fechaInicio = Calendar.getInstance();
		fechaInicio.set(Calendar.YEAR, new Integer(anyo).intValue());
		fechaInicio.set(Calendar.MONTH, new Integer(mes).intValue());
		fechaInicio.set(Calendar.DATE, 1);
		
		
		String[][] calendarioEventosMes = _GetCalendario(eventosMes, anyo, mes, fechaHoy.getTimeInMillis() );
		String calendario = _PaintCalendario(request, calendarioEventosMes, fechaInicio, fechaHoy, tipoVista);
		return calendario;
	}
	
	public static String GetHtmlCalendarDayEmpty( int indice ) {
		return( "<td style=\"pointer-events: none;\" class=\"vacio calendar_col" + indice + " yui3-calendar-day\"></td>");
	}

	public static String getListadoEventosActual(PortletRequest request, List<JournalArticle> eventosMes, Calendar fecha, boolean isADay, int tipoVista, CommonUtils commonUtils) throws PortalException {	
		final HttpServletRequest servletRequest = PortalUtil.getHttpServletRequest( request );
		
		StringBuilder listadoCal = new StringBuilder();
		String listadoFutureEvents = "";
		boolean showNextEvents = !isADay;
		int maxEvents = CalendarEventsPortletKeys.cListado_NumMaxEvents;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String dateFormat = (request.getLocale().toString().equals("es_ES") ? "dd/MM/yyyy":"yyyy/MM/dd");
		SimpleDateFormat showDateSdf =  new SimpleDateFormat(dateFormat);
		 
		if(!eventosMes.isEmpty()){
			List<JournalArticle> eventosHoy = new ArrayList<JournalArticle>();
			List<JournalArticle> eventosFuturos = new ArrayList<JournalArticle>();
			
			for( JournalArticle ja : eventosMes ) {
				try {
					Document document = SAXReaderUtil.read(ja.getContentByLocale(request.getLocale().toString()));
					
					Date dateIni = CommonUtils.EventDocumentGetDate( document, CalendarEventsPortletKeys.cDateTipo_Start, CalendarEventsPortletKeys.cEventDocFieldFormat_Date );
					if( Validator.isNotNull( dateIni ) )  {
						Calendar calIni = Calendar.getInstance();
						calIni.setTime( dateIni );
						DateTimeComparator dateTimeComparator = DateTimeComparator.getDateOnlyInstance();
						if( dateTimeComparator.compare( fecha, calIni ) == 0 ) { // evento inicia en fecha actual
							eventosHoy.add( ja );
						} else if( dateTimeComparator.compare( fecha, calIni ) < 0 ) { // fecha actual anterior a la fecha del evento
							eventosFuturos.add( ja );
						} 
						Date dateFin = CommonUtils.EventDocumentGetDate( document, CalendarEventsPortletKeys.cDateTipo_End, CalendarEventsPortletKeys.cEventDocFieldFormat_Date );
						if( Validator.isNotNull( dateFin ) )  {
							Calendar calFin = Calendar.getInstance();
							calFin.setTime( dateFin );
							if( dateTimeComparator.compare( fecha, calFin ) == 0 || 
								(	dateTimeComparator.compare( fecha, calFin ) < 0 &&
									dateTimeComparator.compare( fecha, calIni ) > 0 )
								) {
								if( !eventosHoy.contains( ja ) )
									eventosHoy.add( ja );
							} 
						}
					}
				} catch( Exception e ) {
					_log.warn( "Ha habido un problema con el tratamiento, dentro de los eventos del mes, del contenido (id: " + ja.getArticleId() + "): " + e.getMessage() );
					if( _log.isDebugEnabled() ) e.printStackTrace();
				}
			}
			getOrderEventsList(eventosHoy, false, request.getLocale().toString());
			getOrderEventsList(eventosFuturos, false, request.getLocale().toString());
			
			if( tipoVista != CalendarEventsPortletKeys.cEventsViewTipo_Popup ) {
				String dateShow = CommonUtils.GetTextDate( fecha, false, false, servletRequest );
				

				if( isADay ) {
					listadoCal.append( "<h2 class=\"display-" + maxEvents + "\">" + dateShow + "</h2>" );
				} else if( !eventosHoy.isEmpty() ) {
					listadoCal.append( "<h2 class=\"display-" + maxEvents + "\">" + LanguageUtil.get( servletRequest, "ehu.calendarevents.today" ) +
						" (" + StringUtil.lowerCase( dateShow) + ")" + "</h2>" );
				}
			}
			
			if (!eventosHoy.isEmpty()) {
				listadoCal.append("<ul  class=\"list-group list-group-flush\" style=\"margin: 0 0 0 0 !important;\">");
				for( JournalArticle j : eventosHoy ) {
					listadoCal.append( _ListadoGetHtmlElem( request, j, CalendarEventsPortletKeys.cListado_LenMaxTitle ) );
				}
				listadoCal.append("</ul>");
			} else {
//				listadoCal.append("<li class=\"list-group-item\">"+LanguageUtil.get(servletRequest, "no.events.today")+"</li>");
//				listadoCal.append("</ul>");
			}
			
			// Se controla que si los eventos del dia de hoy no son mas de maxEvents se mostraran los eventos futuros.
			int numHoy = eventosHoy.size();
			if( numHoy < maxEvents && !isADay ) {
				if( !eventosFuturos.isEmpty() ) {
					int numFuturos = eventosFuturos.size();
					int numFuturosShow = maxEvents - numHoy;
					int sizeList = ( numFuturos < numFuturosShow ) ? numFuturos : numFuturosShow;
					for( int i=0; i<sizeList; i++ ) {
						listadoFutureEvents += _ListadoGetHtmlElem( request, eventosFuturos.get( i ), CalendarEventsPortletKeys.cListado_LenMaxTitle );
					}
				}
			} else {
				showNextEvents = false;
			}

		}
				
		if( showNextEvents ) {
			listadoCal.append("<h2>"+LanguageUtil.get(servletRequest, "ehu.calendarevents.coming-soon")+"</h2>");
			listadoCal.append("<ul  class=\"list-group list-group-flush\" style=\"margin: 0 0 0 0 !important;\">");
			if( listadoFutureEvents == "" ) {
				listadoCal.append( "<li class=\"list-group-item\">" + LanguageUtil.get( servletRequest, "ehu.calendarevents.no-events") + "</li>" );
			} else {
				listadoCal.append( listadoFutureEvents );
			}
			listadoCal.append( "</ul>" );
		}
		
		return listadoCal.toString();
		
	}	
	
	public static List<String> getMeses() {
		List<String> meses = new LinkedList<String>();
		for (int i = 1; i < 13; i++) {
			meses.add(Integer.toString(i));
		}
		return meses;
	}

	public static List<JournalArticle> getOrderEventsList(List<JournalArticle> eventsList, boolean reversed, String langStr){
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		eventsList.sort((s1, s2) -> {
			try {
				Document doc1 = SAXReaderUtil.read(s1.getContentByLocale(langStr));
				
				final String fIniStr1 = GetterUtil.getString(doc1.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-content/text()"));
				final String [] fIniStrArray1 = fIniStr1.split("-");
				final int horaIni1 = GetterUtil.getInteger(doc1.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-element[@name='ehustartdatehourhh']/dynamic-content/text()"));
				final int minIni1 = GetterUtil.getInteger(doc1.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-element[@name='ehustartdatehourmm']/dynamic-content/text()"));

				Document doc2 = SAXReaderUtil.read(s2.getContentByLocale(langStr));
				final String fIniStr2 = GetterUtil.getString(doc2.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-content/text()"));
				final String [] fIniStrArray2 = fIniStr2.split("-");
				final int horaIni2 = GetterUtil.getInteger(doc2.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-element[@name='ehustartdatehourhh']/dynamic-content/text()"));
				final int minIni2 = GetterUtil.getInteger(doc2.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-element[@name='ehustartdatehourmm']/dynamic-content/text()"));

				
				Calendar fechaInicioCalendar1 = CalendarFactoryUtil.getCalendar(new Integer(fIniStrArray1[0]).intValue(), new Integer(fIniStrArray1[1]).intValue() - 1, new Integer(fIniStrArray1[2]).intValue(), horaIni1, minIni1, 0);
				Calendar fechaInicioCalendar2 = CalendarFactoryUtil.getCalendar(new Integer(fIniStrArray2[0]).intValue(), new Integer(fIniStrArray2[1]).intValue() - 1, new Integer(fIniStrArray2[2]).intValue(), horaIni2, minIni2, 0);

				return fechaInicioCalendar1.compareTo(fechaInicioCalendar2);
				
			} catch (DocumentException e) {
				_log.error(e);
			}
			return 0;
		});

		return eventsList;
		
	}

	public static int GetWeekIndexFromCalendar( Calendar calendar ) {
		int firstDay = calendar.get( Calendar.DAY_OF_WEEK );
		if( firstDay == Calendar.SUNDAY ) return( 6 );
		return( firstDay - 2 );
	}

	/* ************************************************************************** */
	/* *********************        metodos privados        ********************* */
	/* ************************************************************************** */

	private static String[][] _GetCalendario(List<JournalArticle> eventosMes, String anyoActual, String mesActual, long fechaActual ) throws PortalException {
		String[][] calendario = new String[ cCalNumSemanas ][ cCalNumDias ];
		for( int i=0; i<cCalNumSemanas; i++ )
			for( int j=0; j<cCalNumDias; j++ )
				calendario[ i ][ j ] = "noDia";
		
		Calendar calendar = CalendarDateUtil.getLocalCalendar();
		Date dtMes = null;
		int intMesActual = 0;
		int intAnioActual = 0;
		try {
			intMesActual = Integer.parseInt( mesActual ) + 1;
			intAnioActual = Integer.parseInt( anyoActual );
			dtMes = DateUtil.parseDate( String.format( "01/%02d/%04d", intMesActual, intAnioActual ), LocaleUtil.SPAIN );
		}
		catch( ParseException pe ) {
			_log.error( "Error en la generacion de la date para el calendario (" + mesActual + "/" + anyoActual + "): " + pe.getMessage() );
			return( calendario );
		}
		calendar.setTime( dtMes );
		int numDiasMes = calendar.getActualMaximum( Calendar.DATE );
		

		int primerDia = GetWeekIndexFromCalendar( calendar );
		int diaDelMes = 1;
		for (int i = primerDia; i < 7; i++) {
			calendar.set( Calendar.DATE, diaDelMes );
			List<AssetCategory> listEventCategories = GetAgendaCategories( eventosMes, calendar );
			int numEventCategories = listEventCategories.size();
			
			if (calendar.getTimeInMillis() < fechaActual) {
				if (i == 6) {
					if (_GetEventByDay(eventosMes, calendar )) {	
						if( numEventCategories > 1  ) {
							calendario[0][i] = "existeAmbos";
						} else {
							calendario[0][i] = _GetNameEvent(eventosMes, calendar, false);
						} 
					} else {
						calendario[0][i] = "festivoVacioPasado";
					}
				} else if (_GetEventByDay(eventosMes, calendar )) {	
					if( numEventCategories > 1 ) {
						calendario[0][i] = "existeAmbos";
					} else {
						calendario[0][i] = _GetNameEvent(eventosMes, calendar, false);
					}
				} else {
					calendario[0][i] = "vacioPasado";
				}
			} else if (_GetEventByDay(eventosMes, calendar )) {
				if (i == 6) {
					if( numEventCategories > 1 ) {
						calendario[0][i] = "festivoExisteAmbos";
					} else {
						calendario[0][i] = _GetNameEvent(eventosMes, calendar, true);
					}
				} else {
					if( numEventCategories > 1 ) {
						calendario[0][i] = "existeAmbos";
					} else {
						calendario[0][i] = _GetNameEvent(eventosMes, calendar, false);
					}
				}
			} else if (i == 6) {
				calendario[0][i] = "festivoVacio";
			} else if (calendar.getTimeInMillis() == fechaActual) {
				calendario[0][i] = "hoyVacio";
			} else {
				calendario[0][i] = "vacio";
			}
			diaDelMes++;
		}
		for (int semana = 1; semana < 6; semana++) {
			for (int diaSemana = 0; diaSemana < 7; diaSemana++) {
				calendar.set(Calendar.DATE, diaDelMes);
				List<AssetCategory> listEventCategories = GetAgendaCategories( eventosMes, calendar );
				int numEventCategories = listEventCategories.size();
				if (diaDelMes <= numDiasMes) {
					
					if (calendar.getTimeInMillis() < fechaActual) {
						
						if (diaSemana == 6) {
							if (_GetEventByDay(eventosMes, calendar )) {	
								if( numEventCategories > 1 ) {
									calendario[semana][diaSemana] = "existeAmbos";
								} else {
									calendario[semana][diaSemana] = _GetNameEvent(eventosMes, calendar, false);
								}
							} else {
								calendario[semana][diaSemana] = "festivoVacioPasado";
							}
						} else if (_GetEventByDay(eventosMes, calendar )) {	
							if( numEventCategories > 1 ) {
								calendario[semana][diaSemana] = "existeAmbos";
							} else {
								calendario[semana][diaSemana] = _GetNameEvent(eventosMes, calendar, false);
							}
						} else {
							calendario[semana][diaSemana] = "vacioPasado";
						}
					} else if (_GetEventByDay(eventosMes, calendar )) {
						if (diaSemana == 6) {
							if( numEventCategories > 1 ) {
								calendario[semana][diaSemana] = "festivoExisteAmbos";
							} else {
								calendario[semana][diaSemana] = _GetNameEvent(eventosMes, calendar, true);
							}
						} else {
							if( numEventCategories > 1 ) {
								calendario[semana][diaSemana] = "existeAmbos";
							} else {
								calendario[semana][diaSemana] = _GetNameEvent(eventosMes, calendar, false);
							}
						}
					} else if (diaSemana == 6) {
						calendario[semana][diaSemana] = "festivoVacio";
					} else if (calendar.getTimeInMillis() == fechaActual) {
						calendario[semana][diaSemana] = "hoyVacio";
					} else {
						calendario[semana][diaSemana] = "vacio";
					}
				} else {
					calendario[semana][diaSemana] = "noDia";
				}
				diaDelMes++;
			}
		}
		
		return calendario;
	}

	private static List<JournalArticle> _GetEventListByDay( List<JournalArticle> eventosMes, Calendar fecha ) {
		Iterator<JournalArticle> it = eventosMes.iterator();
		SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
		Date dtActual = fecha.getTime();
		String fechaActual = sdf.format( dtActual );
		
		List<JournalArticle> journalsDay = new ArrayList<JournalArticle>();
		
		while( it.hasNext() ) {
			JournalArticle articulo = it.next();

			Document document;
			String fechainicioString = "";
			String fechafinString = "";
			try {
				document = SAXReaderUtil.read( articulo.getContent() );
				fechainicioString = document.valueOf( "//dynamic-element[@name='ehustartdatehour']/dynamic-content/text()" );
				fechafinString = document.valueOf( "//dynamic-element[@name='ehuenddatehour']/dynamic-content/text()" );
				if( Validator.isNull( fechainicioString ) )	fechainicioString = "";
			} catch( DocumentException de ) {
				_log.warn( "Se ha producido un error al intentar acceder al contenido del articulo " + articulo.getArticleId() + ": " + de.getMessage() );
				if( _log.isDebugEnabled() ) de.printStackTrace();
				continue;
			}
			if(  fechafinString == "" ) fechafinString = fechainicioString;
			if( fechainicioString.equals( fechaActual ) || fechafinString.equals( fechaActual ) ) {
				journalsDay.add( articulo );
			}
			else {
				try {
					Date dtIni = sdf.parse( fechainicioString );
					Date dtFin = sdf.parse( fechafinString );
					if( dtIni.before( dtActual ) && dtFin.after( dtActual ) ) {
						journalsDay.add( articulo );
					}
				}
				catch( ParseException pe ) {
					_log.warn( "Se ha producido un error con el formato de las fechas para el articulo " + articulo.getArticleId() + ": " + pe.getMessage() );
					if( _log.isDebugEnabled() ) pe.printStackTrace();
				}
			}
		}

		return( journalsDay );
	}
	
	private static boolean _GetEventByDay( List<JournalArticle> eventosMes, Calendar fecha ) {
		
		boolean hayEventos = ( _GetEventListByDay( eventosMes, fecha ).isEmpty() ) ? false : true;
		return( hayEventos );
	}
	
	private static String _GetHtmlCalendar( PortletRequest request, List<JournalArticle> listArticlesMes, int year, int mes, int tipoVista ) {
		HttpServletRequest servletRequest = PortalUtil.getHttpServletRequest( request );
		StringBuilder sbCalendario = new StringBuilder();
		
		Date dtMes = null;
		try {
			dtMes =  DateUtil.parseDate( String.format( "01/%02d/%04d", mes, year ), LocaleUtil.SPAIN );
		}
		catch( ParseException pe ) {
			_log.error( "Error en la generacion de la date (" + mes + "/" + year + "): " + pe.getMessage() );
			return( sbCalendario.toString() );
		}
		int diaDelMes = 1;
		
		for( int indSemana=0; indSemana<=5; indSemana++ ) {
			CalendarRow row = new CalendarRow( dtMes );
			row.GeneraHtml( listArticlesMes, indSemana, diaDelMes, tipoVista );
			sbCalendario.append( row.GetHtml() );
			diaDelMes += row.GetNumDias();
		}

		return sbCalendario.toString();
	}
	
	private static String _GetLocalizationEvent(JournalArticle article) throws PortalException {
		StringBuilder lugar = new StringBuilder();
		
		AssetEntry entry = AssetEntryLocalServiceUtil.getEntry(JournalArticle.class.getName(), article.getResourcePrimKey());
		
		if(Validator.isNotNull(entry)) {
			
			List<AssetCategory> categories = entry.getCategories();
			
			long companyId = article.getCompanyId();
			//se ha comprobado que para el site de global el groupKey coincide con el companyId
			String groupKeyGlobal = String.valueOf(companyId);
			Group sitioGlobal = GroupLocalServiceUtil.getGroup(companyId, groupKeyGlobal);
			
			AssetVocabulary vocabularyLocalization = AssetVocabularyLocalServiceUtil.fetchGroupVocabulary(sitioGlobal.getGroupId(),NAME_VOCABULARY_LOCALIZATION);
			
			if(Validator.isNotNull(vocabularyLocalization)) {			
				for (AssetCategory category : categories) {					
					if(category.getVocabularyId()==vocabularyLocalization.getVocabularyId()) {
						lugar.append(StringPool.SPACE+StringPool.DASH+StringPool.SPACE+category.getName());
					}										
				}
			}
		}			
				
		return lugar.toString();
	}		
		
	private static String _GetNameEvent(List<JournalArticle> eventosMes, Calendar fecha, boolean isFestivo) {
		
		String nameEvent = "existe";
		
		List<AssetCategory> listEventCategories = GetAgendaCategories( eventosMes, fecha );
		if( listEventCategories.size() > 0 ) {
			if( CommonUtils.ListaCategoriesEsta( listEventCategories, CalendarEventsPortletKeys.cCategoryName_Academic ) )
				nameEvent = "existeAcademico";
			else
				nameEvent = "existeGeneral";
			if( isFestivo )
				nameEvent = nameEvent.replace( "existe", "festivoExiste" );
		}

		return( nameEvent );
	}

	private static String _GetUrlArticle(JournalArticle journal, PortletRequest request) {
		
		String friendlyEventURL = StringPool.BLANK;
		try {
		//se recuperar la página de visualización del contenido
			Layout layoutView = journal.getLayout();				
			String urlTitle = journal.getUrlTitle(request.getLocale());
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			Long groupId = themeDisplay.getScopeGroupId();
			Group site = GroupLocalServiceUtil.fetchGroup(groupId);	
			Locale locale = themeDisplay.getLocale();
			
			if(Validator.isNotNull(layoutView)) {
				//tiene página de visualización, por lo tanto, el contenido se mostrará en ella
				Layout currentLayout = themeDisplay.getLayout();
				String currentUrl = PortalUtil.getLayoutFriendlyURL(currentLayout, themeDisplay);
				String currentUrlwithout = currentUrl.replace(currentLayout.getFriendlyURL(locale), "");
				friendlyEventURL = currentUrlwithout + "/-/" + urlTitle;
			}
			else {
				AssetEntry entry = AssetEntryLocalServiceUtil.fetchEntry(JournalArticle.class.getName(), Long.valueOf(journal.getResourcePrimKey()));
				if (Validator.isNotNull(entry)) {
					//no tiene página de visualización, por lo que deberemos construir la url de visualización atendiendo al campo personalizado FriendlyPageEvents configurado en el propio site							
					
					if (Validator.isNotNull(site) && Validator.isNotNull(site.getExpandoBridge())) {
						//recupero el valor del expando "FriendlyPageEvents" de página de eventos del sitio, es decir, la friendlyURL de la página de visualización de los eventos
						String friendlyLayoutURL = GetterUtil.getString(site.getExpandoBridge().getAttribute("FriendlyPageEvents"));					
						
						if (Validator.isNotNull(friendlyLayoutURL)) {														
							Layout layout = LayoutLocalServiceUtil.fetchLayoutByFriendlyURL(groupId, false, friendlyLayoutURL);
							String urlLayout = PortalUtil.getLayoutFriendlyURL(layout, themeDisplay); 
									
							//portlets en esa página, en principio, sólo debería estar un assetpublisher
							LayoutTypePortlet layoutTypePortlet  = LayoutTypePortletFactoryUtil.create(layout);
							//listado de portlets en la página de eventos
							List<String> portletIdList = layoutTypePortlet.getPortletIds();
																			
							for (String id : portletIdList) {
								if (id.contains("_AssetPublisherPortlet_")) {
										Portlet portlet = PortletLocalServiceUtil.fetchPortletById(themeDisplay.getCompanyId(), id);
										  String instanceId = portlet.getInstanceId();
										  Layout currentLayout = themeDisplay.getLayout();
										  String urlRedirect = PortalUtil.getLayoutFriendlyURL(currentLayout, themeDisplay);//página actual, que servirá de página de redirecciónLayout currentLayout = themeDisplay.getLayout();
										  
										  StringBuilder urlFull = new StringBuilder();
										  urlFull.append(urlLayout);
										  urlFull.append("/-/asset_publisher/");
										  urlFull.append(instanceId);
										  urlFull.append("/content/"+urlTitle+"?");
										  urlFull.append("_"+id+"_assetEntryId="+entry.getEntryId()+"&");
										  urlFull.append("_"+id+"_redirect="+urlRedirect);
							
										friendlyEventURL =  urlFull.toString();															
								}
							}
						}						
					}
				}	
			}
		} catch (Exception e) {
			_log.error("Recuperando la url del evento, para ser visualizado a modo completo", e);
		}
		return friendlyEventURL;				
	}	
	
	private static String _ListadoGetHtmlElem( PortletRequest request, JournalArticle article ) {
		return( _ListadoGetHtmlElem( request, article, 100 ) );
	}
				
	private static String _ListadoGetHtmlElem( PortletRequest request, JournalArticle article, int lenMaxTitle ) {
		StringBuilder htmlElem = new StringBuilder();
		if( Validator.isNull( article ) ) return( htmlElem.toString() );
		
		HttpServletRequest servletRequest = PortalUtil.getHttpServletRequest( request );
		String languageId = request.getLocale().toString();
		
		try {
			Document document = SAXReaderUtil.read( article.getContentByLocale( languageId ) );
			
			// title (se recorta a 100 caracteres)
			String title = article.getTitle( languageId );
			if( lenMaxTitle > 4 ) {
				if( title.length() > lenMaxTitle )
					title = title.substring( 0, lenMaxTitle - 4 ) + "...";
			}
			
			//si el articulo, tiene página de visualización se mostará directamente en esa página de visualización
			final String urlArticle = _GetUrlArticle( article, request );
			
			boolean isAcademic = CommonUtils.ListaCategoriesEsta( GetAgendaCategories( article ), CalendarEventsPortletKeys.cCategoryName_Academic );
			final String cssClass = ( isAcademic ) ? "evento-academico" : "evento-general";
			final String titleEventoKey = ( isAcademic ) ? "events.academic" : "events.general";
			
			htmlElem.append( "<li class=\"list-group-item " + cssClass + "\">" );
			htmlElem.append( "<a href='" + urlArticle + "' title='" + LanguageUtil.get( servletRequest, titleEventoKey ) + "'><strong>" + title + "</strong>" );
			htmlElem.append( "<p>" );
	
			htmlElem.append( CommonUtils.EventDocumentGetTextDatesRange( document, true, false, servletRequest ) );
	
			
			String lugar = _GetLocalizationEvent( article );
			if( Validator.isNotNull( lugar ) )
				htmlElem.append( lugar );
			
			htmlElem.append( "</p></a></li>" );							
		} catch( Exception e ) {
			_log.warn( "Ha habido un problema con el tratamiento del contenido (id: " + article.getArticleId() + "): " + e.getMessage() );
			if( _log.isDebugEnabled() ) e.printStackTrace();
		}
		
		return( htmlElem.toString() );
	}
		
	private static String _PaintCalendario(PortletRequest request, String[][] calendarioEventosMes, Calendar fechaInicio,
			Calendar fechaActual, int tipoVista) {
		final HttpServletRequest servletRequest = PortalUtil.getHttpServletRequest(request);
		StringBuilder calendario = new StringBuilder();
		int diaMes = 1;
		try {

			for (int semana = 0; semana < 6; semana++) {
				if ((semana != 5) || (semana == 5 && (!calendarioEventosMes[semana][0].equals("noDia")))) {
					calendario.append("<tr class=\"yui3-calendar-row\">");
					for (int diaSemana = 0; diaSemana < 7; diaSemana++) {
						if (calendarioEventosMes[semana][diaSemana].equals("noDia")) {
							calendario.append(
									"<td style=\"pointer-events: none;\" class=\"vacio calendar_col" + diaSemana + " yui3-calendar-day\"></td>");
						} else {
							if (calendarioEventosMes[semana][diaSemana].equals("vacioPasado")) {
								calendario.append("<td style=\"pointer-events: none;\" class=\"pasado calendar_col" + diaSemana
										+ " yui3-calendar-day\">" + diaMes + "</td>");
							} else if (calendarioEventosMes[semana][diaSemana].equals("festivoVacioPasado")) {
								calendario.append("<td style=\"pointer-events: none;\" class=\"pasado calendar_col" + diaSemana
										+ " yui3-calendar-day\"><strong>" + diaMes + "</strong></td>");
							} else if (calendarioEventosMes[semana][diaSemana].equals("vacio")) {
								calendario.append("<td style=\"pointer-events: none;\" class=\"vacio calendar_col" + diaSemana + " yui3-calendar-day\">"
										+ diaMes + "</td>");
							} else if (calendarioEventosMes[semana][diaSemana].equals("festivoVacio")) {
								calendario.append("<td style=\"pointer-events: none;\" class=\"vacio calendar_col" + diaSemana
										+ " yui3-calendar-day\"><strong>" + diaMes + "</strong></td>");
							} else if (calendarioEventosMes[semana][diaSemana].equals("hoyVacio")) {
								calendario.append("<td style=\"pointer-events: none;\" class=\"vacio calendar_col" + diaSemana
										+ " yui3-calendar-day\"><strong>" + diaMes + "</strong></td>");
							}

							else {
								fechaInicio.set(Calendar.DATE, diaMes);
								SimpleDateFormat formatFI = new SimpleDateFormat("dd/MM/yyyy");
								String stringFormatFI = formatFI.format(fechaInicio.getTime());
								String stringFormatFA = formatFI.format(fechaActual.getTime());
								Date dateFormatFI = formatFI.parse(stringFormatFI);
								Date dateFormatFA = formatFI.parse(stringFormatFA);
								String anyo = Integer.toString(fechaInicio.get(Calendar.YEAR));
								String mes = Integer.toString(fechaInicio.get(Calendar.MONTH) + 1);
								
								
								if (calendarioEventosMes[semana][diaSemana].equals("festivoExiste")) {
									calendario.append("<td class=\"eventoHoy calendar_col" + diaSemana
											+ " yui3-calendar-day\"><a title =\"" + diaMes + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
											+ "\"><strong>" + diaMes + "</strong></a></td>");
								} else if (dateFormatFI.getTime() == dateFormatFA.getTime()) {
									if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteAcademico") || 
											calendarioEventosMes[semana][diaSemana].equals("existeAcademico")) {
										calendario.append("<td class=\"eventoHoy calendar_col" + diaSemana
												+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.academic") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
												+ "\"><span class='color academico'><strong>" + diaMes + "</strong></span></a></td>");
									} else if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteGeneral") || 
											calendarioEventosMes[semana][diaSemana].equals("existeGeneral")) {
										calendario.append("<td class=\"eventoHoy calendar_col" + diaSemana
												+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.general") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
												+ "\"><span class='color general'><strong>" + diaMes + "</strong></span></a></td>");
									} else if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteAmbos") || 
											calendarioEventosMes[semana][diaSemana].equals("existeAmbos")) {
										calendario.append("<td class=\"eventoHoy calendar_col" + diaSemana
												+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.both") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');"
												+ "\"><span class='color ambos'><strong>" + diaMes + "</strong></span></a></td>");
									} else {
										calendario.append("<td class=\"eventoHoy calendar_col" + diaSemana
												+ " yui3-calendar-day\"><a title =\"" + diaMes + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
												+ "\">" + diaMes + "</a></td>");
									}
								} else if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteAcademico") || 
										calendarioEventosMes[semana][diaSemana].equals("existeAcademico")) {
									calendario.append("<td class=\"evento calendar_col" + diaSemana
											+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.academic") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
											+ "\"><span class='color academico'><strong>" + diaMes + "</strong></span></a></td>");
								} else if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteGeneral") || 
										calendarioEventosMes[semana][diaSemana].equals("existeGeneral")) {
									calendario.append("<td class=\"evento calendar_col" + diaSemana
											+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.general") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
											+ "\"><span class='color general'><strong>" + diaMes + "</strong></span></a></td>");
								} else if (calendarioEventosMes[semana][diaSemana].equals("festivoExisteAmbos") || 
										calendarioEventosMes[semana][diaSemana].equals("existeAmbos")) {
									calendario.append("<td class=\"evento calendar_col" + diaSemana
											+ " yui3-calendar-day\"><a title =\"" + LanguageUtil.get(servletRequest, "events.both") + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
											+ "\"><span class='color ambos'><strong>" + diaMes + "</strong></span></a></td>");
								} else {
									calendario.append("<td class=\"evento calendar_col" + diaSemana
											+ " yui3-calendar-day\"><a title =\"" + diaMes + "\" href=\"javascript:showEventsByDay('"+diaMes+"','"+mes+"','"+anyo+"','"+tipoVista+"');" 
											+ "\">" + diaMes + "</a></td>");
								}
							}
							diaMes++;
						}
					}
					calendario.append("</tr>");
				}
			}
		} catch (ParseException e) {
			_log.error(e);
		} 
		return calendario.toString();
	}

	@Reference
	AssetVocabularyLocalService _assetVocabularyLocalService;
	
	@Reference
	AssetEntryLocalService _assetEntryLocalService;
}

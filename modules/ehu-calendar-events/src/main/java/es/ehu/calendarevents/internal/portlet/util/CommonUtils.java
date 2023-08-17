package es.ehu.calendarevents.internal.portlet.util;

import com.liferay.asset.category.property.service.AssetCategoryPropertyLocalServiceUtil;
import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.service.AssetCategoryLocalService;
import com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetVocabularyLocalService;
import com.liferay.dynamic.data.mapping.model.DDMStructure;
import com.liferay.dynamic.data.mapping.service.DDMStructureLocalService;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.module.configuration.ConfigurationException;
import com.liferay.portal.kernel.module.configuration.ConfigurationProvider;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ArrayUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.xml.Document;

import java.text.MessageFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;


@Component(immediate = true, service = CommonUtils.class)
public class CommonUtils {
	
	/* constantes */

	private static final Log _log = LogFactoryUtil.getLog( CommonUtils.class );
	private static final String dotSpace = StringPool.PERIOD + StringPool.SPACE;

	
	
	/* metodos */

	// ================================================================================================
	/**
	 * Obtiene el valor de la propiedad "property" para la categoria "categoryId".<p>
	 * Si hay algun problema devuelve la cadena vacia.<p>
	 * @author 				UPV/EHU
	 * @since				25/11/2021
	 * @param	categoryId	id de la categoria
	 * @param	property	nombre de la propiedad para la que obtener el valor
	 * @return				valor de la propiedad para la categoria especificada
	 */
	// ================================================================================================
	public static String CategoryGetPropertyValue( String categoryId, String property ) {
		String value = "";
		if( categoryId == "" ) return( value );
		
		try {
			value = AssetCategoryPropertyLocalServiceUtil.getCategoryProperty( Long.parseLong( categoryId ), CalendarEventsPortletKeys.cCategoryProperty_Class ).getValue();
		}
		catch( PortalException pe ) {
			_log.warn( "No se ha podido obtener el valor de la propiedad " + CalendarEventsPortletKeys.cCategoryProperty_Class +
				" para la categoria " + categoryId  + ": " + pe.getMessage() );
		}
		
		return( value );
	}


	// ================================================================================================
	/**
	 * Devuelve, en un "Date", el valor encontrado en el documento xml "doc", correspondiente a un
	 * contenido de tipo Evento, para la fecha del tipo "type" y que supuestamente esta en el formato
	 * especificado por "formato".<p>
	 * El tipo se refiere a si es una fecha de inicio o una fecha de fin.<p>
	 * Si hay algun problema (no encuentra la fecha en el documento, el tipo es incorrecto, ...)
	 * devuelve null.<p>
	 * @author 				UPV/EHU
	 * @since				02/12/2021
	 * @param	doc			documento xml
	 * @param	type		tipo de fecha: inicio, fin
	 * @param	formato		formato en el que se encuentra la fecha en el documento
	 * @return				fecha encontrada en el documento o null si ocurre algun error
	 */
	// ================================================================================================
	public static Date EventDocumentGetDate( Document doc, int type, String formato ) {
		Date fecha = null;
		String fieldNameFecha = "";
		if( type == CalendarEventsPortletKeys.cDateTipo_Start ) {
			fieldNameFecha = CalendarEventsPortletKeys.cEventDocFieldName_StartDate;
		} else if( type == CalendarEventsPortletKeys.cDateTipo_End ) {
			fieldNameFecha = CalendarEventsPortletKeys.cEventDocFieldName_EndDate;
		} else {
			_log.warn( "El tipo especificado (" + type + ") no es correcto" );
			return( fecha );
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat( formato );
		
		String fieldNameHora = fieldNameFecha + "hh";
		String fieldNameMin = fieldNameFecha + "mm";
		
		String strFecha = GetterUtil.getString( doc.valueOf( "//dynamic-element[@name='" + fieldNameFecha + "']/dynamic-content/text()" ), "" );
		if( strFecha  == "" ) return( fecha );
		
		try {
			fecha = sdf.parse( strFecha );
		}
		catch( ParseException pe ) {
			_log.warn(  "Ha habido un problema con el formato especificado (" + formato + "): " + pe.getMessage() );
			return( fecha );
		}
		
		int hora = GetterUtil.getInteger( doc.valueOf( "//dynamic-element[@name='" + fieldNameHora + "']/dynamic-content/text()" ), 0 );
		int min = GetterUtil.getInteger( doc.valueOf( "//dynamic-element[@name='" + fieldNameMin + "']/dynamic-content/text()"  ), 0 );
		
		GregorianCalendar calendar = new GregorianCalendar();
		calendar.setTime( fecha );
		calendar.add( Calendar.HOUR_OF_DAY, hora );
		calendar.add( Calendar.MINUTE, min );
		fecha =	calendar.getTime();
		

		return( fecha );
	}

	// ================================================================================================
	/**
	 * Devuelve una cadena con el rango de las fechas (inicio y fin) existentes en el documento xml
	 * "doc", correspondiente a un contenido de tipo Evento.<p>
	 * Si hay algun problema con la fecha de inicio devuelve la cadena vacia, pues se supone que esta
	 * fecha es obligatoria y debe de estar.<p>
	 * Si no hay fecha de fin, solo se pone en la cadena la fecha de inicio.<p>
	 * Solo se ainade la hora para las fechas si:<p>
	 *	- El parametro "getHour" es true<p>
	 *	- La hora esta especificada y ademas no es "00:00".<p> 
	 * La cadena se generara completamente en mayusculas si el parametro "upper" es true.<p>
	 * El parametro "servletRequest" se necesita para la obtencion de los textos en los diferentes
	 * idiomas, dependiendo de la sesion desde la que se llama al metodo.<p>
	 * @author 					UPV/EHU
	 * @since					02/12/2021
	 * @param	doc				documento xml
	 * @param	getHour			indica que se quiere especificar tambien la hora
	 * @param	upper			indica que la especificacion sea en mayusculas
	 * @param	servletRequest	servletRequest
	 * @return					cadena con la especificacion del rango de fechas del documento
	 */
	// ================================================================================================
	public static String EventDocumentGetTextDatesRange( Document doc, boolean getHour, boolean upper, HttpServletRequest servletRequest ) {
		String strRango = "";
		Date dateIni = EventDocumentGetDate( doc, CalendarEventsPortletKeys.cDateTipo_Start, CalendarEventsPortletKeys.cEventDocFieldFormat_Date );
		if( Validator.isNull( dateIni ) ) return( strRango );

		Date dateFin = EventDocumentGetDate( doc, CalendarEventsPortletKeys.cDateTipo_End, CalendarEventsPortletKeys.cEventDocFieldFormat_Date );
		return( GetTextDatesRange( dateIni, dateFin,  getHour, upper, servletRequest ) );
	}

	
	
	public Map<Long, String[]> GetCategoriesSelected( ThemeDisplay themeDisplay ) throws PortalException {
		Map<Long, String[]> mapCategories = new HashMap<Long, String[]>();
		String[] idsCategories = {"33902105, 33902133"};
		if( Validator.isNotNull( idsCategories ) ) {			
			for( String id : idsCategories ) {
				try {
					AssetCategory category = AssetCategoryLocalServiceUtil.getCategory( Long.parseLong( id ) );
					if( Validator.isNotNull( category ) ) {
						String[] arrValues = new String[ 2 ];
						arrValues[ 0 ] = category.getTitle( themeDisplay.getLocale() );
						arrValues[ 1 ] = CategoryGetPropertyValue( id, CalendarEventsPortletKeys.cCategoryProperty_Class );
						mapCategories.put( category.getCategoryId(), arrValues );
					}
				}
				catch( Exception e ) {}
			}
		}
		return( mapCategories );
	}
	
	public Map<Long, String> getTypeNamesEventsSelected(ThemeDisplay themeDisplay) throws PortalException {
		
		Map<Long, String> namesKey = new HashMap<Long, String>();
		String[] idsEstructuras = {"33902105", "33902133"};
		
		if(Validator.isNotNull(idsEstructuras)) {			
			for (String id : idsEstructuras) {
				DDMStructure estructura = ddmStructureLocalService.fetchDDMStructure(new Long(id));
				if(Validator.isNotNull(estructura)) {
					long structureId = estructura.getStructureId();
					namesKey.put(structureId, estructura.getName(themeDisplay.getLocale()));
				}
			}
		}
		return namesKey;
	}
	
	public List<DDMStructure> getStructures(ThemeDisplay themeDisplay) throws ConfigurationException{
		String[] idsEstructuras = {"33902105", "33902133"};
		
		List<DDMStructure> estructuras = new ArrayList<DDMStructure>();
			
		if(Validator.isNotNull(idsEstructuras)) {			
			for (String id : idsEstructuras) {
				DDMStructure estructura = ddmStructureLocalService.fetchDDMStructure(new Long(id));
				if (Validator.isNotNull(estructura)) {
					estructuras.add(estructura);
				}
			}		
		}
		return estructuras;
	}
	
	
	public List<DDMStructure> getStructures(String ddmStructureKeyConf) throws ConfigurationException{
		final List<DDMStructure> estructuras = new ArrayList<DDMStructure>();
		
		if (!Validator.isBlank(ddmStructureKeyConf)) {
			final List<String> ddmStructureKeyList =  Arrays.asList(ddmStructureKeyConf.split(StringPool.COMMA));
				
			if (Validator.isNotNull(ddmStructureKeyList)) {			
				for (String key : ddmStructureKeyList) {
					final DDMStructure estructura = ddmStructureLocalService.fetchDDMStructure(new Long(key));
					if (Validator.isNotNull(estructura)) {
						estructuras.add(estructura);
					}
				}		
			}
		}
		
		return estructuras;
	}


	// ================================================================================================
	/**
	 * Devuelve una cadena con la especificacion de la fecha contenida en "date".<p>
	 * Si "date" es nulo, devuelve la cadena vacia.<p>
	 * La cadena se generara completamente en mayusculas si el parametro "upper" es true.<p>
	 * El parametro "getHour" sirve para que en la especificacion aparezca tambien la hora (si es que
	 * procede).<p>
	 * El parametro "servletRequest" se necesita para la obtencion de los textos en los diferentes
	 * idiomas, dependiendo de la sesion desde la que se llama al metodo.<p>
	 * @author 			UPV/EHU
	 * @since			02/12/2021
	 * @param	date			fecha a especificar, en formato Date
	 * @param	getHour			indica que se quiere especificar tambien la hora
	 * @param	upper			indica que la especificacion sea en mayusculas
	 * @param	servletRequest	servletRequest
	 * @return					cadena con la especificacion de la fecha contenida en "date"
	 */
	// ================================================================================================
	public static String GetTextDate( Date date, boolean getHour, boolean upper, HttpServletRequest servletRequest ) {
		if( Validator.isNull( date ) ) return( "" );

		GregorianCalendar calendar = new GregorianCalendar();
		calendar.setTime( date );		
		return( GetTextDate( calendar, getHour, upper, servletRequest ) );
	}

	// ================================================================================================
	/**
	 * Devuelve una cadena con la especificacion de la fecha contenida en "calendar".<p>
	 * La cadena se generara:
	 *	- Completamente en mayusculas si el parametro "upper" es true.<p>
	 *	- Unicamente el primer caracter en mayusculas, en caso contrario.<p>
	 * Solo se ainade la hora en la especificacion si:<p>
	 *	- El parametro "getHour" es true<p>
	 *	- El valor para la hora no es "00:00".<p>
	 * El parametro "servletRequest" se necesita para la obtencion de los textos en los diferentes
	 * idiomas, dependiendo de la sesion desde la que se llama al metodo.<p>
	 * @author 					UPV/EHU
	 * @since					14/12/2021
	 * @param	calendar		calendar con la fecha a especificar
	 * @param	getHour			indica que se quiere especificar tambien la hora
	 * @param	upper			indica que la especificacion sea en mayusculas
	 * @param	servletRequest	servletRequest
	 * @return					cadena con la especificacion de la fecha contenida en "calendar"
	 */
	// ================================================================================================
	public static String GetTextDate( Calendar calendar, boolean getHour, boolean upper, HttpServletRequest servletRequest ) {
		String dia = String.format( "%d", calendar.get( Calendar.DAY_OF_MONTH ) );
		String mes = Integer.toString( calendar.get( Calendar.MONTH ) + 1 );
		String strDate = MessageFormat.format( LanguageUtil.get( servletRequest, "ehu.calendarevents.date.day-monthname" ),
			dia, LanguageUtil.get( servletRequest, "calendar.mes" + mes ) );
		if( getHour ) {
			SimpleDateFormat horaMin		= new SimpleDateFormat( "HH:mm" );
			String hora = horaMin.format(calendar.getTime());
			if( !hora.contentEquals( CalendarEventsPortletKeys.cHoraCero ) )
				strDate += ", " + hora;
		}
		
		if( upper ) return( StringUtil.toUpperCase( strDate) );
		return( StringUtil.lowerCase(strDate) );
	}

	// ================================================================================================
	/**
	 * Devuelve una cadena con el rango de las fechas "dateIni" y "dateFin".<p>
	 * Si "dateFin" es nulo y "dateIni" no, solo se pone en la cadena la fecha de inicio.<p>
	 * Si "dateIni" es nulo y "dateFin" no, se pone en la cadena la fecha de fin precedida por "- ".<p>
	 * Si tanto "dateIni" como "dateFin" son nulos, se devuelve la cadena vacia.<p>
	 * En caso contrario, se devuelve una cadena con las dos fechas unidas por " - ". 
	 * La cadena se generara completamente en mayusculas si el parametro "upper" es true.<p>
	 * El parametro "getHour" sirve para que en la especificacion aparezcan tambien las horas (si es
	 * que procede).<p>
	 * El parametro "servletRequest" se necesita para la obtencion de los textos en los diferentes
	 * idiomas, dependiendo de la sesion desde la que se llama al metodo.<p>
	 * @author 			UPV/EHU Soto
	 * @since			02/12/2021
	 * @param	doc		documento xml
	 * @param	getHour	indica si se quiere especificar tambien la hora en las fechas
	 * @return			cadena con la especificacion del rango de fechas existentes en el documento
	 * @param	dateIni			fecha de inicio para el rango
	 * @param	dateFin			fecha de fin para el rango
	 * @param	getHour			indica que se quiere especificar tambien la hora
	 * @param	upper			indica que la especificacion sea en mayusculas
	 * @param	servletRequest	servletRequest
	 * @return					cadena con la especificacion del rango entre las fechas especificadas
	 */
	// ================================================================================================
	public static String GetTextDatesRange( Date dateIni, Date dateFin, boolean getHour, boolean upper, HttpServletRequest servletRequest ) {
		String strFechaIni = GetTextDate( dateIni, getHour, upper, servletRequest );
		String strFechaFin = GetTextDate( dateFin, getHour, upper, servletRequest );
		String nexo = "";
		if( strFechaFin != "" ) { 
			if( strFechaIni == "")
				nexo = "- ";
			else
				nexo = " - ";
		}
		return( strFechaIni + nexo + strFechaFin );
	}

	

	
	// ================================================================================================
	/**
	 * Ainade a la lista de categorias "listaDest" la categoria "category", pero teniendo en cuenta que
	 * la categoria no debe repetirse en la lista.<p>
	 * Ademas devuelve true o false dependiendo de si se ha ainadido la categoria.<p>
	 * Para comprobar la existencia de la categoria, mira el campo "categoryId".<p>
	 * La lista "listaDest" debe estar inicializada, es decir, no puede ser nula. En dicho caso, no la
	 * actualiza y devuelve el valor false.<p>
	 * @author 				UPV/EHU
	 * @since				15/11/2021
	 * @param	listaDest	lista de categorias en la que ainadir la nueva categoria
	 * @param	category	categoria a ainadir a la lista
	 * @return				true o false dependiendo de si se ha ainadido la categoria a la lista
	 */
	// ================================================================================================
	public static boolean ListaCategoriesAddUnique( List<AssetCategory> listaDest, AssetCategory category ) {
		if( ListaCategoriesEsta( listaDest, category ) ) return( false );
		if( Validator.isNull( category ) ) return( false );
		if( Validator.isNull( listaDest ) ) return( false );
		
		listaDest.add( category );
		return( true );
	}

	// ================================================================================================
	/**
	 * Ainade a la lista de categorias "listaDest" las categorias de la lista "listaOrig", pero
	 * teniendo en cuenta que las categorias no deben repetirse en la lista destino, y devuelve el
	 * numero de categorias que se han ainadido.<p>
	 * La lista "listaDest" debe estar inicializada, es decir, no puede ser nula. En dicho caso, no la
	 * actualiza y devuelve el valor 0.<p>
	 * @author 				UPV/EHU
	 * @since				15/11/2021
	 * @param	listaDest	lista de categorias en la que ainadir las categorias
	 * @param	listaOrig	lista de categorias a ainadir
	 * @return				numero de categorias que se han ainadido a la lista
	 */
	// ================================================================================================
	public static int ListaCategoriesAddUnique( List<AssetCategory> listaDest, List<AssetCategory> listaOrig ) {
		int numAdded = 0;
		if( Validator.isNull( listaOrig ) ) return( numAdded );
		if( Validator.isNull( listaDest ) ) return( numAdded );

		for( AssetCategory category : listaOrig ) {
			if( ListaCategoriesAddUnique( listaDest, category ) ) numAdded++;
		}
		
		return( numAdded );
	}

	// ================================================================================================
	/**
	 * Comprueba si "categoryName" es el nombre de alguna de las categorias de la lista
	 * "lisCategories".<p>
	 * @author 					UPV/EHU
	 * @since					15/11/2021
	 * @param	lisCategories	lista de categorias en la que mirar
	 * @param	categoryName	nombre de la categoria a comprobar si esta en la lista
	 * @return					true si alguna categoria de la lista tiene el nombre "categoryName"
	 */
	// ================================================================================================
	public static boolean ListaCategoriesEsta( List<AssetCategory> lisCategories, String categoryName ) {
		if( Validator.isNull( lisCategories ) ) return( false );
		
		for( AssetCategory category : lisCategories ) {
			if( category.getName().contentEquals( categoryName ) ) return( true );
		}
		
		return( false );
	}
	
	// ================================================================================================
	/**
	 * Comprueba si "categoryId" es el id de alguna de las categorias de la lista "lisCategories".<p>
	 * @author 					UPV/EHU
	 * @since					15/11/2021
	 * @param	lisCategories	lista de categorias en la que mirar
	 * @param	categoryId		id de la categoria a comprobar si esta en la lista
	 * @return					true si alguna categoria de la lista tiene el id "categoryId"
	 */
	// ================================================================================================
	public static boolean ListaCategoriesEsta( List<AssetCategory> lisCategories, long categoryId ) {
		if( Validator.isNull( lisCategories ) ) return( false );
		
		for( AssetCategory category : lisCategories ) {
			if( categoryId == category.getCategoryId() ) return( true );
		}
		
		return( false );
	}
	
	// ================================================================================================
	/**
	 * Comprueba si "category" se encuentra en la lista de categorias "lisCategories".<p>
	 * Para ver si esta, mira el campo "categoryId" de las categorias.<p>
	 * @author 					UPV/EHU
	 * @since					15/11/2021
	 * @param	lisCategories	lista de categorias en la que mirar
	 * @param	category		categoria a comprobar si esta en la lista
	 * @return					true si la categoria esta en la lista de categorias
	 */
	// ================================================================================================
	public static boolean ListaCategoriesEsta( List<AssetCategory> lisCategories, AssetCategory category ) {
		if( Validator.isNull( category ) ) return( false );
		return( ListaCategoriesEsta( lisCategories, category.getCategoryId() ) );
	}
	
	// ================================================================================================
	/**
	 * Comprueba si alguna de las categorias de la lista "lisCategories" se encuentra dentro de la
	 * lista "lisDonde".<p>
	 * Para la comprobacion de las categorias, se mira el campo "categoryId" de las mismas.<p>
	 * @author 					UPV/EHU
	 * @since					15/11/2021
	 * @param	lisDonde		lista de categorias en la que mirar
	 * @param	lisCategories	lista de categorias a comprobar si estan
	 * @return					true si alguna categoria de "lisCategories" esta en "lisDonde"
	 */
	// ================================================================================================
	public static boolean ListaCategoriesEsta( List<AssetCategory> lisDonde, List<AssetCategory> lisCategories ) {
		if( Validator.isNull( lisDonde ) ) return( false );
		if( Validator.isNull( lisCategories ) ) return( false );
		
		int sizeDonde = lisDonde.size();
		if( sizeDonde == 0 ) return( false );

		long[] arrDonde = new long[ sizeDonde ];
		int i = 0;
		for( AssetCategory category : lisDonde ) {
			arrDonde[ i ] = category.getCategoryId();
			i++;
		}

		for( AssetCategory category : lisCategories ) {
			if( ArrayUtil.contains(arrDonde, category.getCategoryId())) return( true );
		}
		
		return( false );
	}
	
	
	@Reference
	AssetCategoryLocalService assetCategoryLocalService;
	@Reference
	AssetVocabularyLocalService assetVocabularyLocalService;
	@Reference
	DDMStructureLocalService ddmStructureLocalService;
	@Reference
	AssetEntryLocalService assetEntryLocalService;
	@Reference
	protected ConfigurationProvider _configurationProvider;
	
}

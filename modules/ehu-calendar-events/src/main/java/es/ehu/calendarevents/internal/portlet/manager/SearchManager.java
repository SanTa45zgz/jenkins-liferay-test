package es.ehu.calendarevents.internal.portlet.manager;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import javax.portlet.PortletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.calendarevents.internal.portlet.util.CalendarUtils;
import es.ehu.calendarevents.internal.portlet.util.CommonUtils;

import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.service.AssetCategoryLocalService;
import com.liferay.dynamic.data.mapping.model.DDMStructure;
import com.liferay.dynamic.data.mapping.util.DDMIndexer;
import com.liferay.journal.model.JournalArticle;
import com.liferay.journal.service.JournalArticleLocalService;
import com.liferay.journal.service.JournalArticleLocalServiceUtil;
import com.liferay.petra.string.StringBundler;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.DateFormatFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ListUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.search.document.Document;
import com.liferay.portal.search.hits.SearchHit;
import com.liferay.portal.search.hits.SearchHits;
import com.liferay.portal.search.query.BooleanQuery;
import com.liferay.portal.search.query.DateRangeTermQuery;
import com.liferay.portal.search.query.NestedQuery;
import com.liferay.portal.search.query.Queries;
import com.liferay.portal.search.query.TermQuery;
import com.liferay.portal.search.searcher.SearchRequest;
import com.liferay.portal.search.searcher.SearchRequestBuilder;
import com.liferay.portal.search.searcher.SearchRequestBuilderFactory;
import com.liferay.portal.search.searcher.SearchResponse;
import com.liferay.portal.search.searcher.Searcher;
import com.liferay.portal.search.sort.FieldSort;
import com.liferay.portal.search.sort.NestedSort;
import com.liferay.portal.search.sort.Sort;
import com.liferay.portal.search.sort.SortBuilderFactory;
import com.liferay.portal.search.sort.Sorts;



@Component(immediate = true, service = SearchManager.class)
public class SearchManager {

	/* constantes */

	public static final int cSearchType_None	= 0;
	public static final int cSearchType_Redu	= 1;
	public static final int cSearchType_Prev	= 2;
	public static final int cSearchType_Next	= 3;
	public static final int cSearchType_All		= 4;
	public static final int cSearchType_Def		= cSearchType_Redu;

	/* variables */
	private static final Log _log = LogFactoryUtil.getLog( SearchManager.class );

	@Reference
	private volatile AssetCategoryLocalService assetCategoryLocalService;	
	@Reference
	private JournalArticleLocalService journalArticleLocalService;

	@Reference
	private CommonUtils commonUtils;
	
	@Reference
	protected Queries queries;

	@Reference
	protected Searcher searcher;

	@Reference
	protected SearchRequestBuilderFactory searchRequestBuilderFactory;

	@Reference
	protected DDMIndexer ddmIndexer;

	@Reference
	protected Sorts sorts;

	@Reference
	protected SortBuilderFactory sortBuilderFactory;
	
	/* metodos */

	/*
	 * Devuelve aquellos eventos que se encuentran entre un determinado rango de fechas.
	 * Para el calendario busca los eventos del mes que se esta consultando.
	 * 
	 * filtrar los de 1 día concreto
	 * 
	 * filtrar los de 1 mes
	 * 
	 * filtrar por tipo
	 * 
	 * obtener los próximos
	 * 
	 */	
	public List<JournalArticle> findJournalArticles( PortletRequest request, String ddmStructureKeyConf, String idsCategories, Calendar fechaMes ) throws Exception {
		return( findJournalArticles( request, ddmStructureKeyConf, idsCategories, fechaMes, null, false ) );
	}

	public List<JournalArticle> findJournalArticles( PortletRequest request, String ddmStructureKeyConf, String idsCategories, Calendar fechaMes, Calendar fechaDia, boolean proximos ) throws Exception {
		List<JournalArticle> newLisArticles = new ArrayList<JournalArticle>();
		if( idsCategories == "" ) return( newLisArticles );
		
		List<String> listIdsCategories =  Arrays.asList( idsCategories.split( StringPool.COMMA ) );
		List<JournalArticle> articles = findJournalArticles( request, ddmStructureKeyConf, fechaMes, fechaDia, proximos );
		for( JournalArticle article : articles ) {
			List<AssetCategory> listArticleCategories = CalendarUtils.GetAgendaCategories( article );
			for( AssetCategory category : listArticleCategories ) {
				if( listIdsCategories.contains( String.valueOf( category.getCategoryId() ) ) ) {
					newLisArticles.add( article );
					break;
				}
			}
		}
		return( newLisArticles );
	}

	public List<JournalArticle> findJournalArticles( PortletRequest request, String ddmStructureKeyConf, String idsCategories, Calendar fechaMes, Calendar fechaDia, int searchType ) throws Exception {
		List<JournalArticle> lisArticles = new ArrayList<JournalArticle>();
		if( searchType == cSearchType_None )	return( lisArticles );

		if( searchType == cSearchType_Redu || searchType == cSearchType_All ) {
			lisArticles.addAll( findJournalArticles( request, ddmStructureKeyConf, idsCategories, fechaMes, fechaDia, false ) );
		}
		if( searchType == cSearchType_Prev || searchType == cSearchType_Next || searchType == cSearchType_All ) {
			lisArticles.addAll( findJournalArticles( request, ddmStructureKeyConf, idsCategories, fechaMes, fechaDia, true ) );
		}
			
		return( lisArticles );
	}
	
	public List<JournalArticle> findJournalArticles(PortletRequest request, String ddmStructureKeyConf, Calendar fechaMes) throws Exception {
		return findJournalArticles(request, ddmStructureKeyConf, fechaMes, null, false);
	}
	public List<JournalArticle> findJournalArticles(PortletRequest request, String ddmStructureKeyConf, Calendar fechaMes, Calendar fechaDia, boolean proximos) throws Exception {
		List<SearchHits> searchHits = findArticles(request, ddmStructureKeyConf, fechaMes, fechaDia, proximos);
		return getJournalArticles(searchHits);
	}
	
	
	// ================================================================================================
	/**
	 * Proximos:
	 *	- Para el caso en que "fechaMes" no es nulo:
	 *		- Si es true, coge los articulos del mes con una fecha de inicio anterior al mes marcado
	 *		por esa fecha y que ademas tienen una fecha de fin en el mes marcado por "fechaMes" o en
	 *		meses posteriores.
	 *		- Si es false, solo coge los articulos con fecha de inicio dentro del mes marcado por la
	 *		fecha. 
	 *	- Para el caso en que "fechaMes" es nulo y "fechaDia" no lo es:
	 *		- Si es true, coge los articulos con fecha de inicio posterior al mes marcado por esa fecha
	 *		- Si es false, coge los articulos vigentes en la fecha "fechaDia", es decir, aquellos con
	 *		fecha de inicio igual a dicha fecha y los que, teniendo fecha de inicio anterior a la
	 *		misma, su fecha de fin es posterior a aquella.
	 */
	// ================================================================================================
	private SearchHits findArticles(PortletRequest request, DDMStructure ddmStructure, Calendar fechaMes, Calendar fechaDia, boolean proximos ) throws Exception {
		final ThemeDisplay td = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		final Group site = td.getScopeGroup();
		final Locale localeDef  = td.getSiteDefaultLocale();
		final Locale locale  = td.getLocale();
		
		final DateFormat sdfAnyoMes = DateFormatFactoryUtil.getSimpleDateFormat("yyyy-MM", locale, td.getTimeZone());
		final DateFormat sdfAnyoMesDia = DateFormatFactoryUtil.getSimpleDateFormat("yyyy-MM-dd", locale, td.getTimeZone());
		
		String fieldArrayName = StringBundler.concat( DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, DDMIndexer.DDM_FIELD_NAME );

		final String key = ddmStructure.getStructureKey();

		final BooleanQuery queryEstructura = queries.booleanQuery();
		queryEstructura.addMustQueryClauses(queries.term("ddmStructureKey", key));

		final String fieldStartName = getStartDateFieldName(ddmStructure.getStructureId(), localeDef );
		final String fieldEndName = getEndDateFieldName(ddmStructure.getStructureId(), localeDef );
		
		
		if (fechaMes!=null) {
			// restriccion por mes
			// TODO : falta distinguir entre estructuras
			final String anyoMes = sdfAnyoMes.format( fechaMes.getTime() );
			String firstDay = anyoMes + "-" + "01";
			String lastDay = anyoMes + "-" + fechaMes.getActualMaximum( Calendar.DAY_OF_MONTH );
			if( proximos ) {
				if (ddmIndexer.isLegacyDDMIndexFieldsEnabled()) {
					final DateRangeTermQuery queryDiaStart = queries.dateRangeTerm( fieldStartName, true, false, null, firstDay );
					final DateRangeTermQuery queryDiaEnd = queries.dateRangeTerm( fieldEndName, true, true, firstDay, null );
					queryEstructura.addMustQueryClauses( queryDiaStart, queryDiaEnd );
				} else {
					final String[] ddmStructureFieldNamePartsStart = StringUtil.split( fieldStartName, DDMIndexer.DDM_FIELD_SEPARATOR );
					final String valueFieldNameStart = ddmIndexer.getValueFieldName( ddmStructureFieldNamePartsStart[ 1 ], localeDef );

					final String[] ddmStructureFieldNamePartsEnd = StringUtil.split( fieldEndName, DDMIndexer.DDM_FIELD_SEPARATOR  );
					final String valueFieldNameEnd = ddmIndexer.getValueFieldName( ddmStructureFieldNamePartsEnd[ 1 ], localeDef );

					final BooleanQuery queryDiaStart = queries.booleanQuery();
					queryDiaStart.addMustQueryClauses(
						queries.term( fieldArrayName, fieldStartName ),
						queries.dateRangeTerm( StringBundler.concat( DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameStart ), true, false, null, firstDay ) );
					final NestedQuery queryDiaStartNested = queries.nested( DDMIndexer.DDM_FIELD_ARRAY, queryDiaStart );
							
					final BooleanQuery queryDiaEnd = queries.booleanQuery();
					queryDiaEnd.addMustQueryClauses(
						queries.term( fieldArrayName, fieldEndName ),
						queries.dateRangeTerm(StringBundler.concat( DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameEnd ), true, true, firstDay, null ) );
					final NestedQuery queryDiaEndNested = queries.nested( DDMIndexer.DDM_FIELD_ARRAY, queryDiaEnd );

					queryEstructura.addMustQueryClauses( queryDiaStartNested, queryDiaEndNested );
				}
			} else {
				if (ddmIndexer.isLegacyDDMIndexFieldsEnabled()) {
					final DateRangeTermQuery queryMes = queries.dateRangeTerm( fieldStartName, true, true, firstDay, lastDay );
					queryEstructura.addMustQueryClauses(queryMes);
				} else {
					final BooleanQuery queryMesBoolean = queries.booleanQuery();
					final String[] ddmStructureFieldNameParts = StringUtil.split(fieldStartName, DDMIndexer.DDM_FIELD_SEPARATOR);
		
					final String valueFieldName = ddmIndexer.getValueFieldName(ddmStructureFieldNameParts[1], localeDef );
		
					queryMesBoolean.addMustQueryClauses(
						queries.term( fieldArrayName, fieldStartName),
						queries.dateRangeTerm(StringBundler.concat( DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldName ), true, true, firstDay, lastDay ) );
						
					final NestedQuery nestedQuery = queries.nested(DDMIndexer.DDM_FIELD_ARRAY, queryMesBoolean);
					queryEstructura.addMustQueryClauses(nestedQuery);
				}
			}
		} else if (fechaDia!=null) {
			final String anyoMesDia = sdfAnyoMesDia.format( fechaDia.getTime() );
			if( proximos ) {
				if (ddmIndexer.isLegacyDDMIndexFieldsEnabled()) {
					final DateRangeTermQuery queryDia = queries.dateRangeTerm(fieldStartName, false, true, anyoMesDia, null);
					queryEstructura.addMustQueryClauses(queryDia);
				} else {
					final BooleanQuery queryDia = queries.booleanQuery();
					final String[] ddmStructureFieldNameParts = StringUtil.split(fieldStartName, DDMIndexer.DDM_FIELD_SEPARATOR);
	
					final String valueFieldName = ddmIndexer.getValueFieldName(ddmStructureFieldNameParts[1], localeDef );
	
					queryDia.addMustQueryClauses(
						queries.term( fieldArrayName, fieldStartName),
						queries.dateRangeTerm(StringBundler.concat(DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldName), false, true, anyoMesDia, null));
					
					final NestedQuery nestedQuery = queries.nested(DDMIndexer.DDM_FIELD_ARRAY, queryDia);
					queryEstructura.addMustQueryClauses(nestedQuery);
				}
			} else {
				if (ddmIndexer.isLegacyDDMIndexFieldsEnabled()) {
					final DateRangeTermQuery queryDiaStart = queries.dateRangeTerm(fieldStartName, true, true, null, anyoMesDia);
					final DateRangeTermQuery queryDiaEnd = queries.dateRangeTerm(fieldEndName, true, true, anyoMesDia, null);
	
					final BooleanQuery queryRango = queries.booleanQuery();
					queryRango.addMustQueryClauses(queryDiaStart, queryDiaEnd);
					
					final TermQuery queryDia = queries.term(fieldStartName, anyoMesDia);
					
					final BooleanQuery queryFechas = queries.booleanQuery();
					queryFechas.addShouldQueryClauses(queryRango, queryDia);
	
					queryEstructura.addMustQueryClauses(queryFechas);
				} else {
					final String[] ddmStructureFieldNamePartsStart = StringUtil.split(fieldStartName, DDMIndexer.DDM_FIELD_SEPARATOR);
					final String valueFieldNameStart = ddmIndexer.getValueFieldName(ddmStructureFieldNamePartsStart[1], localeDef );

					final String[] ddmStructureFieldNamePartsEnd = StringUtil.split(fieldEndName, DDMIndexer.DDM_FIELD_SEPARATOR);
					final String valueFieldNameEnd = ddmIndexer.getValueFieldName(ddmStructureFieldNamePartsEnd[1], localeDef );

					final BooleanQuery queryDiaStart = queries.booleanQuery();
					queryDiaStart.addMustQueryClauses(
							queries.term( fieldArrayName, fieldStartName),
							queries.dateRangeTerm(StringBundler.concat(DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameStart), true, true, null, anyoMesDia));
					final NestedQuery queryDiaStartNested = queries.nested(DDMIndexer.DDM_FIELD_ARRAY, queryDiaStart);
							
					final BooleanQuery queryDiaEnd = queries.booleanQuery();
					queryDiaEnd.addMustQueryClauses(
							queries.term( fieldArrayName, fieldEndName),
							queries.dateRangeTerm(StringBundler.concat(DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameEnd), true, true, anyoMesDia, null));
					final NestedQuery queryDiaEndNested = queries.nested(DDMIndexer.DDM_FIELD_ARRAY, queryDiaEnd);
					
					final BooleanQuery queryRango = queries.booleanQuery();
					queryRango.addMustQueryClauses(queryDiaStartNested, queryDiaEndNested);
					
					final BooleanQuery queryDia = queries.booleanQuery();
					queryDia.addMustQueryClauses(
						queries.term( fieldArrayName, fieldStartName),
						queries.term(StringBundler.concat(DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameStart), anyoMesDia));
					final NestedQuery queryDiaNested = queries.nested(DDMIndexer.DDM_FIELD_ARRAY, queryDia);
					
					final BooleanQuery queryFechas = queries.booleanQuery();
					queryFechas.addShouldQueryClauses(queryRango, queryDiaNested);
					queryEstructura.addMustQueryClauses(queryFechas);
				}
			}
		}
		
		
		// la query padre
		final BooleanQuery query = queries.booleanQuery();
	
		query.addMustQueryClauses(queryEstructura);
	
		// restriccion de que pertenezca al site actual o tenga la categoria de publicación del site actual
		final BooleanQuery queryCategoria = queries.booleanQuery();
		queryCategoria.addShouldQueryClauses(queries.term(Field.GROUP_ID, site.getGroupId()));
		
		
		query.addMustQueryClauses(queryCategoria);
		
		if( _log.isDebugEnabled() )
			_log.debug( "query: " + query.toString() );
		
		Sort [] ordenacionArray = null;
		if (ddmIndexer.isLegacyDDMIndexFieldsEnabled()) {
			ordenacionArray = new Sort[]{sortBuilderFactory.getSortBuilder().field(fieldStartName).build()};
		} else {
			final String[] ddmStructureFieldNamePartsStart = StringUtil.split(fieldStartName, DDMIndexer.DDM_FIELD_SEPARATOR);
			final String valueFieldNameStart = ddmIndexer.getValueFieldName(ddmStructureFieldNamePartsStart[1], localeDef );
	
			final NestedSort nestedSort = sorts.nested(DDMIndexer.DDM_FIELD_ARRAY);
			nestedSort.setFilterQuery(queries.term( fieldArrayName, fieldStartName));
	
			final FieldSort fieldSort = sorts.field(StringBundler.concat(DDMIndexer.DDM_FIELD_ARRAY, StringPool.PERIOD, valueFieldNameStart+ "_String_sortable"));
			fieldSort.setNestedSort(nestedSort);
			
			ordenacionArray = new Sort[]{fieldSort};
		}
		
		// configuracion de la busqueda
		final SearchRequestBuilder searchRequestBuilder = searchRequestBuilderFactory.builder()
				.emptySearchEnabled(true)
				.modelIndexerClasses(JournalArticle.class)
				.withSearchContext(searchContext -> {
					searchContext.setCompanyId(td.getCompanyId());
					if (proximos) {
						searchContext.setStart(0);
						searchContext.setEnd(4);
					}
				})
				.fields("uid", "entryClassPK", "companyId", "entryClassName")
				.sorts(ordenacionArray);
		
		final SearchRequest searchRequest = searchRequestBuilder.query(query).build();

		// ejecución de la busqueda
		final SearchResponse searchResponse = searcher.search(searchRequest);
	
		return searchResponse.getSearchHits();
	}
	
	
	
	
	private List<SearchHits> findArticles(PortletRequest request, String ddmStructureKeyConf, Calendar fechaMes, Calendar fechaDia, boolean proximos) throws Exception {
		final ThemeDisplay td = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);

		// restriccion de al menos una de las estructuras
		List<DDMStructure> ddmStructureList = ddmStructureKeyConf==null ? commonUtils.getStructures(td) : commonUtils.getStructures(ddmStructureKeyConf);

		List<SearchHits> resultados = new ArrayList<>();
		if (ListUtil.isEmpty(ddmStructureList)) {
			return resultados;
		}


		ExecutorService executorService = null;
		try {
			executorService = Executors.newFixedThreadPool(ddmStructureList.size());
			List<Callable<SearchHits>> callables = new ArrayList<>();
			
			for (final DDMStructure ddmStructure : ddmStructureList) {
				callables.add(new Callable<SearchHits>() {
					@Override
					public SearchHits call() throws Exception {
						// TODO Auto-generated method stub
						return findArticles(request, ddmStructure, fechaMes, fechaDia, proximos);
					}
				});
			}
			
			
			 final List<Future<SearchHits>> futures = executorService.invokeAll(callables, 5, TimeUnit.SECONDS);
			 
			 for (Future<SearchHits> future : futures) {
				 resultados.add(future.get());
			 }
		} finally {
			if (executorService!=null) {
				executorService.shutdown();
			}
		}
		return resultados;
	
	}
	

	private String getStartDateFieldName(long structureId, Locale locale) {
		return ddmIndexer.encodeName(structureId, "ehustartdatehour", locale);
	}
	
	private String getEndDateFieldName(long structureId, Locale locale) {
		return ddmIndexer.encodeName(structureId, "ehuenddatehour", locale);
	}
//	private String getEndDateFieldName(long structureId, Locale locale) {
//		return Field.getSortableFieldName(ddmIndexer.encodeName(structureId, "ehuenddatehour", locale) +"_String");
//	}
	

	public List<JournalArticle> getJournalArticles(final List<SearchHits> searchHits) {
		List<JournalArticle> articles = new ArrayList<>();
		for (SearchHits hits : searchHits) {
			articles.addAll(getJournalArticles(hits));
		}
		return articles;
	}
	
	/**
	 * Conversión de resultados de búsqueda Lucene a entidades
	 */
	public List<JournalArticle> getJournalArticles(final SearchHits hits) {
		final List<JournalArticle> journalArticles = new ArrayList<JournalArticle>();
		for (final SearchHit searchHit : hits.getSearchHits()) {
			final Document doc = searchHit.getDocument();
            final long entryClassPk = GetterUtil.getLong(doc.getLong(Field.ENTRY_CLASS_PK));

            try {
            	final JournalArticle journalArticle = journalArticleLocalService.getLatestArticle(entryClassPk);
            	journalArticles.add(journalArticle);
            } catch (PortalException | SystemException pe) {
                _log.error(pe.getLocalizedMessage());
            }
	    }
		return journalArticles;
	}
}

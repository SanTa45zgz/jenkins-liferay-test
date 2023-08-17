package es.ehu.doc.web.core.cmis.alfresco;

import java.util.HashSet;
import java.util.Set;

import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.Folder;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.commons.PropertyIds;

import es.ehu.doc.web.core.cmis.BaseCmisModule;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;


public abstract class AlfrescoCmisModule extends BaseCmisModule {

	private static Log _log = LogFactoryUtil.getLog(AlfrescoCmisModule.class);
	
	private static final String ALFRESCO_PROPERY_ID_TITLE =  "cm:title";
	private static final String ALFRESCO_PROPERY_ID_DESCRIPTION =  "cm:description";
	
	
	public String getDocumentFileName(Document document) {

		return document.getName();
	}
	
	public String getDocumentFileName(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.NAME);
	}
	
	public String getDocumentTitle(Document document) {

		return document.getPropertyValue(ALFRESCO_PROPERY_ID_TITLE);
	}
	
	public String getDocumentTitle(QueryResult queryResult) {

		return queryResult.getPropertyValueById(ALFRESCO_PROPERY_ID_TITLE);
	}

	public String getDocumentDescription(Document document) {

		return document.getPropertyValue(ALFRESCO_PROPERY_ID_DESCRIPTION);
	}
	
	public String getDocumentDescription(QueryResult queryResult) {

		return queryResult.getPropertyValueById(ALFRESCO_PROPERY_ID_DESCRIPTION);
	}
	
	public String getFolderFileName(Folder folder) {

		return folder.getName();
	}
	
	public String getFolderFileName(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.NAME);
	}
	
	public String getFolderTitle(Folder folder) {

		return folder.getPropertyValue(ALFRESCO_PROPERY_ID_TITLE);
	}
	
	public String getFolderTitle(QueryResult queryResult) {

		return queryResult.getPropertyValueById(ALFRESCO_PROPERY_ID_TITLE);
	}
	
	public String getFolderDescription(Folder folder) {

		return folder.getPropertyValue(ALFRESCO_PROPERY_ID_DESCRIPTION);
	}
	
	public String getFolderDescription(QueryResult queryResult) {

		return queryResult.getPropertyValueById(ALFRESCO_PROPERY_ID_DESCRIPTION);
	}
	
	// En Alfresco 5 parece que han cambiado la gestion del SkipTo. 
//	public long getNavigationSkipTo(int cur, int delta) {
//		
//		return cur - 1; 
//	}

	public String getNavigationOrder(String orderByCol, String orderByType) {
		
		String order = null;
		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + ALFRESCO_PROPERY_ID_TITLE + " DESC," + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + ALFRESCO_PROPERY_ID_TITLE + " ASC," + PropertyIds.NAME + " ASC";
		}
		
		_log.debug("order: " + order);
		
		return order;
	}
	
	public Set<String> getNavigationFilter() {

		Set<String> filter = new HashSet<String>();
		
		filter = new HashSet<String>();
		filter.add(PropertyIds.OBJECT_ID);
		filter.add(PropertyIds.NAME);
		filter.add(PropertyIds.LAST_MODIFICATION_DATE);
		filter.add(PropertyIds.CONTENT_STREAM_LENGTH);
		filter.add(PropertyIds.CONTENT_STREAM_FILE_NAME);
		filter.add(ALFRESCO_PROPERY_ID_TITLE);
		filter.add(ALFRESCO_PROPERY_ID_DESCRIPTION);
		
		return filter;
	}
	
	/* 
	 * *************************
	 * QUERIES
	 * *************************
	 */
	public String getQueryFoldersByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType) {
		 
		String query = "SELECT ";
		query += "F." + PropertyIds.OBJECT_ID + ", ";
		query += "F." + PropertyIds.BASE_TYPE_ID + ", ";
		query += "F." + PropertyIds.NAME + ", ";
		query += "F." + PropertyIds.LAST_MODIFICATION_DATE + ", ";
		query += "T." + ALFRESCO_PROPERY_ID_TITLE + ", ";
		query += "T." + ALFRESCO_PROPERY_ID_DESCRIPTION + " ";
		
		query += "FROM cmis:folder F join cm:titled T on F.cmis:objectId = T.cmis:objectId ";
		
		// query simple sin join (hay que quitar tambien los select y el order title)
//		query += "WHERE CONTAINS('cmis:name:\\'" + keywords + "\\'') AND IN_TREE('" + rootNodeId + "')";
		
		// Meter todo en un mismo CONTAINS? Parece que no se puede mezclar tablas.
		query += "WHERE (CONTAINS(F, 'cmis:name:\\'" + keywords + "\\'') OR CONTAINS(T, 'cm:title:\\'" + keywords + "\\' OR cm:description:\\'" + keywords + "\\'')) AND IN_TREE(F, '" + rootNodeId + "')";

		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			query += " ORDER BY " + "F." + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			query += " ORDER BY " + "F." + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			query += " ORDER BY " + "F." + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			query += " ORDER BY " + "F." + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			query += " ORDER BY " + "T." + ALFRESCO_PROPERY_ID_TITLE + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			query += " ORDER BY " + "T." + ALFRESCO_PROPERY_ID_TITLE + " ASC";
		} else {
			// si no se especifica es por relevancia (en el caso de busqueda de documentos). Llega viene como valor "score" y "desc".
		}
		
		return query;
	}
	
	public String getQueryDocumentsByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType) {
		 
		String query = "SELECT ";
		query += "D." + PropertyIds.OBJECT_ID + ", ";
		query += "D." + PropertyIds.BASE_TYPE_ID + ", ";
		query += "D." + PropertyIds.NAME + ", ";
		query += "D." + PropertyIds.LAST_MODIFICATION_DATE + ", ";
		query += "D." + PropertyIds.CONTENT_STREAM_LENGTH + ", ";
		query += "D." + PropertyIds.CONTENT_STREAM_FILE_NAME + ", ";
		query += "T." + ALFRESCO_PROPERY_ID_TITLE + ", ";
		query += "T." + ALFRESCO_PROPERY_ID_DESCRIPTION + " ";
		
		query += "FROM cmis:document D join cm:titled T on D.cmis:objectId = T.cmis:objectId ";
		
		// query simple sin join (hay que quitar tambien los select y el order title)
//		query += "WHERE CONTAINS('\\'" + keywords + "\\' OR cmis:name:\\'" + keywords + "\\'') AND IN_TREE('" + rootNodeId + "')";
	
		// Meter todo en un mismo CONTAINS? Parece que no se puede mezclar tablas.
		query += "WHERE (CONTAINS(D, '\\'" + keywords + "\\' OR cmis:name:\\'" + keywords + "\\'') OR CONTAINS(T, 'cm:title:\\'" + keywords + "\\' OR cm:description:\\'" + keywords + "\\'')) AND IN_TREE(D, '" + rootNodeId + "')";

		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			query += " ORDER BY " + "D." + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			query += " ORDER BY " + "D." + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			query += " ORDER BY " + "D." + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			query += " ORDER BY " + "D." + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			query += " ORDER BY " + "T." + ALFRESCO_PROPERY_ID_TITLE + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			query += " ORDER BY " + "T." + ALFRESCO_PROPERY_ID_TITLE + " ASC";
		} else {
			// si no se especifica es por relevancia (en el caso de busqueda de documentos). Llega viene como valor "score" y "desc".
		}
		
		return query;
	}

}




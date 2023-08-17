package es.ehu.doc.web.core.cmis;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.Folder;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.commons.PropertyIds;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;


/**
 * Implementacion estandar cmis.
 * 
 */
public abstract class BaseCmisModule implements CmisModule {

	private static Log _log = LogFactoryUtil.getLog(BaseCmisModule.class);

	
	public Map<String, String> getAdditionalSessionParameters() {

		Map<String, String> parameters = new HashMap<String, String>();
		return parameters;
	}
	
	public String getDocumentFileName(Document document) {

		return document.getContentStreamFileName();
	}
	
	public String getDocumentFileName(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.CONTENT_STREAM_FILE_NAME);
	}
	
	public String getDocumentTitle(Document document) {

		return document.getName();
	}
	
	public String getDocumentTitle(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.NAME);
	}
	
	public String getDocumentDescription(Document document) {

		return null;
	}
	
	public String getDocumentDescription(QueryResult queryResult) {

		return null;
	}
	
	public String getFolderFileName(Folder folder) {

		return folder.getName();
	}
	
	public String getFolderFileName(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.NAME);
	}
	
	public String getFolderTitle(Folder folder) {

		return folder.getName();
	}
	
	public String getFolderTitle(QueryResult queryResult) {

		return queryResult.getPropertyValueById(PropertyIds.NAME);
	}
	
	public String getFolderDescription(Folder folder) {

		return null;
	}
	
	public String getFolderDescription(QueryResult queryResult) {

		return null;
	}

	public long getNavigationSkipTo(int cur, int delta) {
		
		return (cur - 1) * delta; 
	}
	
	public String getNavigationOrder(String orderByCol, String orderByType) {
		
		String order = null;
		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			// esto realmente ordena por CONTENT_STREAM_FILE_NAME??? en las querys esa propiedad no es ordenable.
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.CONTENT_STREAM_FILE_NAME + " DESC," + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			// esto realmente ordena por CONTENT_STREAM_FILE_NAME??? en las querys esa propiedad no es ordenable.
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.CONTENT_STREAM_FILE_NAME + " ASC," + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			// esto realmente ordena por CONTENT_STREAM_FILE_NAME??? en las querys esa propiedad no es ordenable.
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.NAME + " DESC," + PropertyIds.CONTENT_STREAM_FILE_NAME + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			// esto realmente ordena por CONTENT_STREAM_FILE_NAME??? en las querys esa propiedad no es ordenable.
			order = PropertyIds.BASE_TYPE_ID + " DESC," + PropertyIds.NAME + " ASC," + PropertyIds.CONTENT_STREAM_FILE_NAME + " ASC";
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
		
		return filter;
	}
	
	
	/* 
	 * *************************
	 * QUERIES
	 * *************************
	 */
	public String getQueryFoldersByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType) {
	
		String query = "SELECT ";
		query += PropertyIds.OBJECT_ID + ", ";
		query += PropertyIds.BASE_TYPE_ID + ", ";
		query += PropertyIds.NAME + ", ";
		query += PropertyIds.LAST_MODIFICATION_DATE + " ";
		
		query += "FROM cmis:folder ";
		
		query += "WHERE cmis:name LIKE '%" + keywords + "%' AND IN_TREE('" + rootNodeId + "')";					

		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			query += " ORDER BY " + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			query += " ORDER BY " + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			// CONTENT_STREAM_FILE_NAME es una propiedad no ordenable, asi que se ordena por name.
			query += " ORDER BY " + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			// CONTENT_STREAM_FILE_NAME es una propiedad no ordenable, asi que se ordena por name.
			query += " ORDER BY " + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			query += " ORDER BY " + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			query += " ORDER BY " + PropertyIds.NAME + " ASC";
		} else {
			// si no se especifica es por relevancia (en el caso de busqueda de documentos). Llega viene como valor "score" y "desc".
		}
		
		return query;
	}
	
	
	public String getQueryDocumentsByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType) {
		 
		String query = "SELECT ";
		query += PropertyIds.OBJECT_ID + ", ";
		query += PropertyIds.BASE_TYPE_ID + ", ";
		query += PropertyIds.NAME + ", ";
		query += PropertyIds.LAST_MODIFICATION_DATE + ", ";
		query += PropertyIds.CONTENT_STREAM_LENGTH + ", ";
		query += PropertyIds.CONTENT_STREAM_FILE_NAME + " ";
		
		query += "FROM cmis:document ";
		
		query += "WHERE CONTAINS('" + keywords + "') AND IN_TREE('" + rootNodeId + "')";

		if (orderByCol.equals("modified-date") && orderByType.equals("desc")) {
			query += " ORDER BY " + PropertyIds.LAST_MODIFICATION_DATE + " DESC";
		} else if (orderByCol.equals("modified-date") && orderByType.equals("asc")) {
			query += " ORDER BY " + PropertyIds.LAST_MODIFICATION_DATE + " ASC";
		} else if (orderByCol.equals("name") && orderByType.equals("desc")) {
			// CONTENT_STREAM_FILE_NAME es una propiedad no ordenable, asi que se ordena por name.
			query += " ORDER BY " + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("name") && orderByType.equals("asc")) {
			// CONTENT_STREAM_FILE_NAME es una propiedad no ordenable, asi que se ordena por name.
			query += " ORDER BY " + PropertyIds.NAME + " ASC";
		} else if (orderByCol.equals("title") && orderByType.equals("desc")) {
			query += " ORDER BY " + PropertyIds.NAME + " DESC";
		} else if (orderByCol.equals("title") && orderByType.equals("asc")) {
			query += " ORDER BY " + PropertyIds.NAME + " ASC";
		} else {
			// si no se especifica es por relevancia (en el caso de busqueda de documentos). Llega viene como valor "score" y "desc".
		}
		
		return query;
	}
	
}


package es.ehu.doc.web.core.cmis;

import java.util.Map;
import java.util.Set;

import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.Folder;
import org.apache.chemistry.opencmis.client.api.QueryResult;


/**
 * para la logica dependiente del proveedor de cmis 
 *
 */
public interface CmisModule {
	
	
	/**
	 * Parametros adicionales para la construccion de la session
	 */
	public Map<String, String> getAdditionalSessionParameters();
	
	// tratamiento del Title y Description
	public String getDocumentFileName(Document document);
	public String getDocumentFileName(QueryResult queryResult);
	public String getDocumentTitle(Document document);
	public String getDocumentTitle(QueryResult queryResult);
	public String getDocumentDescription(Document document);
	public String getDocumentDescription(QueryResult queryResult);
	public String getFolderFileName(Folder folder);
	public String getFolderFileName(QueryResult queryResult);
	public String getFolderTitle(Folder folder);
	public String getFolderTitle(QueryResult queryResult);
	public String getFolderDescription(Folder folder);
	public String getFolderDescription(QueryResult queryResult);
	
	/**
	 * En Alfresco en el api de navegacion la propiedad "skipTo" funciona distinta que en la busqueda. En la navegacion hace referencia a
	 * páginas mientras que en la busqueda a registros. En nuxeo en ambos casos funciona como registros.
	 * 
	 * @param cur
	 * @param delta
	 * @return
	 */
	public long getNavigationSkipTo(int cur, int delta);
	
	public Set<String> getNavigationFilter();
	/**
	 * 
	 * @param orderByCol Ordenacion que proviene de la UI (search-container principalmente). Puede contener los valores: "name", "title" o "modified-date".
	 * @param orderByType Ordenacion que proviene de la UI (search-container principalmente). Puede contener los valores: "asc" o "desc".
	 * @return
	 */
	public String getNavigationOrder(String orderByCol, String orderByType);

	public String getQueryFoldersByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType);
	public String getQueryDocumentsByKeyword(String repoType, String keywords, String rootNodeId, String orderByCol, String orderByType);

}

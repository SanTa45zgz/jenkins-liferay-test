	<div class="col-8">       
	            <div class="listadoCal">
	            	<c:choose>
					   <c:when test="${windowState eq 'normal'}">
					   	<%-- el evento tiene configurada una pagina de visualizacion, por lo que se mostrara sobre el publicador de esa pagina --%>
					   		${listadoCal}
					   </c:when>
					   <c:when test="${windowState eq 'maximized'}">	
					   	<%-- al no tener una pagina de visualizacion configurada, el evento se mostrara sobre el mismo portlet maximizado
					   	con la plantilla que tenga configurada, por defecto, si no se cambia sera la de contenido completo --%>				  
					   	<liferay-journal:journal-article articleId="${journal.getArticleId()}" groupId="${journal.getGroupId()}"/>
					   </c:when>
	            	</c:choose>	            						
			</div>
			</div>	
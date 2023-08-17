<%@ include file="/init.jsp" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>

<%@page import="com.liferay.dynamic.data.mapping.kernel.DDMStructureManagerUtil"%>
<%@page import="com.liferay.dynamic.data.mapping.kernel.DDMStructure"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@page import="com.liferay.portal.kernel.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ taglib prefix="liferay-journal" uri="http://liferay.com/tld/journal" %>

<portlet:resourceURL id="/changeMonthCal" var="changeMonthCalURL" />
<portlet:resourceURL id="/showEventsByDay" var="showEventsByDayURL" />
<portlet:resourceURL id="/showEventsByType" var="showEventsByTypeURL" />

<div class="portlet-column portlet-column-last column-right-calendar" id="ehu-calendar">
	<div class="container-fluid">
		<div class="row">
			<c:choose>
				<c:when test="${ tipoVista == '1' }">
					<%-- popup --%>
					<div class="col-12 calendar-popup">
				</c:when> 
			    <c:otherwise>
					<div class="col-4">
			    </c:otherwise>
			</c:choose>	
				<%-- Muestra el calendario --%>
					<div class="yui3-u yui3-calendar-pane" id="calendaryui_patched_v3_18_1_1_1525951310844158">
						<div class="yui3-g yui3-calendar-header" id="yui___18_1_1_1525951310844158">
							<a class="yui3-u yui3-calendarnav-prevmonth" href="javascript:void(0)" role="button" aria-label='<liferay-ui:message key="calendar.previus.month"/>' tabindex="0"></a>
							<div class="yui3-u yui3-calendar-header-label" id="calendaryui___18_1_1_1525951310844_62_header" role="heading" aria-level="2"><liferay-ui:message key="calendar.mes${mesConsultar}"/> ${anioConsultar}</div>
							<a class="yui3-u yui3-calendarnav-nextmonth" href="javascript:void(0)" role="button" aria-label='<liferay-ui:message key="calendar.next.month"/>' tabindex="0" id="yui___18_1_1_1525951310844_157"></a>
																																																	
							<input type="text" id="defMonth" class="hidden" value="${ mesConsultar }" />
							<input type="text" id="defYear" class="hidden" value="${ anioConsultar }" />
							<aui:input name="mesAux" type="hidden" id="mesAux" value="${ mesConsultar }" />
							<aui:input name="anioAux" type="hidden" id="anioAux" value="${ anioConsultar }" />
						</div>
						<div class="yui3-u-1-1">
							<table class="yui3-calendar-grid" id="calendaryui_patched_v3_18_1_1_1525951310844_4510_pane_0" role="grid" aria-readonly="true" aria-label='<liferay-ui:message key="calendar.mes${mesConsultar}"/> ${anioConsultar}' tabindex="1">
								<thead>
									<tr class="yui3-calendar-weekdayrow" >
									<%
										for( int i=1; i<=7; i++ ) {
											String dayName = StringUtil.lowerCase( LanguageUtil.get( request, "ehu.calendarevents.day-name." + i ) );
											String dayAcron = StringUtil.lowerCase( LanguageUtil.get( request, "calendar.dia." + i ));
									%>
										<th class="yui3-calendar-weekday" aria-label="<%= dayName %>"><liferay-ui:message key="<%= dayAcron %>"/></th>
									<% } %>
									</tr>
								</thead>
								<tbody class="tbodyAux">
									${calendario}
								</tbody>
							</table>
						</div>
					</div>
					<div class="filterCal">						
						<%--  Estas opciones se tienen que crear dinamicamente --%>
						<%--  Eliminado. Se utilizaba para diferentes tipos de contenido Evento
						<c:if test="${not empty filtroCal}">
							<c:set var="structureIdEventAcad" value="${structureIdEventAcad}"/>
						   	<c:forEach var="entry" items="${filtroCal}">
						   		<c:choose>
								    <c:when test="${entry.key eq structureIdEventAcad}">
								        <c:set var="eventClass" value="evento-academico"/>
								        <c:set var="eventTypeName"><liferay-ui:message key="events.academic"/></c:set>
								    </c:when>
								    <c:otherwise>
								        <c:set var="eventClass" value="evento"/>
								        <c:set var="eventTypeName"><liferay-ui:message key="events.general" /></c:set>
								    </c:otherwise>
								</c:choose>
						   	
							   	<div class="form-check">							   									   	
							  	  <label class="form-check-label" for="<c:out value="${entry.key}"/>">
							        <input type="checkbox" class="form-check-input tipoEvents ${eventClass}" id="<c:out value="${entry.key}"/>" name="<c:out value="${entry.value}"/>" value="<c:out value="${entry.key}"/>" checked="checked"> ${eventTypeName}
							      </label>
							     </div>
							</c:forEach>
						</c:if>
						--%>
					    <%-- END  Estas opciones se tienen que crear dinamicamente --%>
					    
						<%--  Estas opciones se tienen que crear dinamicamente --%>
						<c:if test="${ not empty filtroCatgsCal }">
						   	<c:forEach var="entry" items="${ filtroCatgsCal }">
						        <c:set var="categId" value="${entry.key}"/>
						        <c:set var="arrValues" value="${entry.value}"/>
						        <c:set var="categName" value="${arrValues[ 0 ]}"/>
						        <c:set var="categClass" value="${arrValues[ 1 ]}"/>
							   	<div class="form-check">							   									   	
							  	  <label class="form-check-label" for="<c:out value="${categId}"/>">
							        <input type="checkbox" class="form-check-input tipoEvents ${categClass}" id="<c:out value="${categId}"/>" name="<c:out value="${categName}"/>" value="<c:out value="${categId}"/>" checked="checked"> ${categName}
							      </label>
							     </div>
							</c:forEach>
						</c:if>
					    <%-- END  Estas opciones se tienen que crear dinamicamente --%>
					    <input type="hidden" id="catgsSeleted" value="${catgsSelected}" />
					    <input type="hidden" id="typesSeleted" value="${typesSelected}" />
					    
					   <div class="form-check">							  	   		  
					      <a class="btn btn-more" href="${friendlyURLEvents}" role="button"><liferay-ui:message key="events.all"/><i class="fa fa-chevron-right" aria-hidden="true"></i></a>																    
					    </div>
					</div>
			</div>			
					<c:choose>
					    <c:when test="${ tipoVista == '1' }">
							<%-- popup --%>
							<div id="modalEvents"></div>
					    </c:when>       
					    <c:otherwise>
					        <%@ include file="/listado.jsp" %>
					    </c:otherwise>
					</c:choose>											
	    </div>    
	</div>
</div>

<%@ include file="/js/javascript-ext.jsp" %>


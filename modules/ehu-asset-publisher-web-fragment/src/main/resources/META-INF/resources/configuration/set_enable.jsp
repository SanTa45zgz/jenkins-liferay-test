<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */
--%>

<%--
/**
 * UPV/EHU
 * Excepto para onmiadmin:
 *	- Ocultar las opciones del apartado Establecer y Habilitar en Preferencias de Presentacion
 *		- Muestra solo los activos con XXXX como su plantilla de pagina de visualizacion.
 *		- Incluir etiquetas especificadas en la URL.
 *  - Ocultar las opciones de configuracion dinamica:
 *		mostrar solo contenidos con Inicio como pagina de visualizacion (false)
 *		Incluir las etiquetas especificadas a traves de la URL (true)
 *
 *  - Ocultar las preferencias de presentacion:
 *     - Check para permitir ainadir o no asset (chequeado)
 *     - Mostrar descripciones de metadatos (chequeado)
 *     - Mostrar traducciones disponibles (deschequeado)
 *     - Establecer como publicador por defecto, para usuarios no OmniAdmin deschequeado y oculto por defecto.
 *		 OmniAdmin puede gestionar el publicador por defecto de la Content Display Page (pagina para mostrar los contenidos desde un publicador)
 *     - Activar las valoraciones (deschequeado)
 *     - Activar comentarios (deschequeado)
 *     - Permitir valorar los comentarios (deschequeado)
 *     - Activar la navegacion por etiquetas en la configuracion manual (deschequeado) 
 *     - Activar el incremento de contador de vistas (chequeado)
 *     - Activar conversiones a pdf, rtf,... (deschequeados)
 *     - Activar notificacion de abuso (deschequeado) 
 *  - Por defecto NO se habilitan los contenidos relacionados
 *  - Se permite imprimir y ocultar
 */
--%>

<%@ include file="/init.jsp" %>

<p class="h4 sheet-tertiary-title">
	<liferay-ui:message key="show-and-set" />
</p>

<%-- UPV/EHU --%>
<%	if( permissionChecker.isOmniadmin() ) {  %>
	<c:if test="<%= assetPublisherDisplayContext.isShowEnableAddContentButton() %>">
		<aui:input helpMessage="show-add-content-button-help" name="preferences--showAddContentButton--" type="checkbox" value="<%= assetPublisherDisplayContext.isShowAddContentButton() %>" />
	</c:if>
<%	} %>
<%-- UPV/EHU --%>
<%
String helpMessage1 = "<em>" + LanguageUtil.format(request, "content-related-to-x", StringPool.DOUBLE_PERIOD, false) + "</em>";
String helpMessage2 = "<em>" + LanguageUtil.format(request, "content-with-tag-x", StringPool.DOUBLE_PERIOD, false) + "</em>";
%>

<%-- UPV/EHU --%>
<%	if( permissionChecker.isOmniadmin() ) {  %>
	<aui:input helpMessage='<%= LanguageUtil.format(request, "such-as-x-or-x", new Object[] {helpMessage1, helpMessage2}, false) %>' name="preferences--showMetadataDescriptions--" type="checkbox" value="<%= assetPublisherDisplayContext.isShowMetadataDescriptions() %>" />
	
	<aui:input name="preferences--showAvailableLocales--" type="checkbox" value="<%= assetPublisherDisplayContext.isShowAvailableLocales() %>" />
	
	<c:if test="<%= assetPublisherDisplayContext.isEnableSetAsDefaultAssetPublisher() %>">
		<aui:input helpMessage="set-as-the-default-asset-publisher-for-this-page-help" label="set-as-the-default-asset-publisher-for-this-page" name="defaultAssetPublisher" type="checkbox" value="<%= assetPublisherWebHelper.isDefaultAssetPublisher(layout, portletDisplay.getId(), assetPublisherDisplayContext.getPortletResource()) %>" />
	
		<aui:input label='<%= LanguageUtil.format(request, "show-only-assets-with-x-as-its-display-page-template", HtmlUtil.escape(layout.getName(locale)), false) %>' name="preferences--showOnlyLayoutAssets--" type="checkbox" value="<%= assetPublisherDisplayContext.isShowOnlyLayoutAssets() %>" />
	</c:if>
	
	<aui:input label="include-tags-specified-in-the-url" name="preferences--mergeUrlTags--" type="checkbox" value="<%= assetPublisherDisplayContext.isMergeURLTags() %>" />
<%	} %>
<%-- UPV/EHU --%>

<p class="h4 sheet-tertiary-title">
	<liferay-ui:message key="enable" />
</p>

<clay:row>
	<clay:col
		md="6"
	>
		<%-- UPV/EHU --%>
		<%	if( permissionChecker.isOmniadmin() ) {  
				boolean _enablePrint = GetterUtil.getBoolean(portletPreferences.getValue("enablePrint", "1"));%>
		<%--<aui:input label="print" name="preferences--enablePrint--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnablePrint() %>" />--%>

		<aui:input label="print" name="preferences--enablePrint--" type="checkbox" value="<%= _enablePrint %>" />
		
		<aui:input label="flags" name="preferences--enableFlags--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableFlags() %>" />

		<aui:input label="ratings" name="preferences--enableRatings--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableRatings() %>" />
		
		<%	} %>
		<%-- UPV/EHU --%>
		
		<%-- UPV/EHU --%>
		<% boolean _enableRelatedAssets = GetterUtil.getBoolean(portletPreferences.getValue("enableRelatedAssets", null));%>
		<%-- UPV/EHU --%>
		<c:choose>
			<c:when test="<%= !assetPublisherDisplayContext.isShowEnableRelatedAssets() %>">
				<%-- UPV/EHU --%>
				<%--<aui:input label="related-assets" name="preferences--enableRelatedAssets--" type="hidden" value="<%= assetPublisherDisplayContext.isEnableRelatedAssets() %>" /> --%>
				<aui:input label="related-assets" name="preferences--enableRelatedAssets--" type="hidden" value="<%= _enableRelatedAssets %>" />
				<%-- UPV/EHU --%>
			</c:when>
			<c:otherwise>
				<%-- UPV/EHU --%>
				<%--<aui:input label="related-assets" name="preferences--enableRelatedAssets--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableRelatedAssets() %>" />--%>
				<aui:input label="related-assets" name="preferences--enableRelatedAssets--" type="checkbox" value="<%= _enableRelatedAssets %>" />
				<%-- UPV/EHU --%>
			</c:otherwise>
		</c:choose>
	</clay:col>

	<clay:col
		md="6"
	>
		<aui:input label="subscribe" name="preferences--enableSubscriptions--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableSubscriptions() %>" />

		<%-- UPV/EHU --%>
		<%	if( permissionChecker.isOmniadmin() ) {  %>
			<aui:input label="comments" name="preferences--enableComments--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableComments() %>" />
	
			<aui:input label="comment-ratings" name="preferences--enableCommentRatings--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableCommentRatings() %>" />
	
			<c:if test="<%= ViewCountManagerUtil.isViewCountEnabled() %>">
				<aui:input label="view-count-increment" name="preferences--enableViewCountIncrement--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableViewCountIncrement() %>" />
			</c:if>
	
			<c:if test="<%= assetPublisherDisplayContext.isSelectionStyleManual() %>">
				<aui:input helpMessage="enable-tag-based-navigation-help" label="tag-based-navigation" name="preferences--enableTagBasedNavigation--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnableTagBasedNavigation() %>" />
			</c:if>
		<%	} %>
		<%-- UPV/EHU --%>
		<c:choose>
			<c:when test="<%= !assetPublisherDisplayContext.isShowEnablePermissions() %>">
				<aui:input label="permissions" name="preferences--enablePermissions--" type="hidden" value="<%= assetPublisherDisplayContext.isEnablePermissions() %>" />
			</c:when>
			<c:otherwise>
				<aui:input label="permissions" name="preferences--enablePermissions--" type="checkbox" value="<%= assetPublisherDisplayContext.isEnablePermissions() %>" />
			</c:otherwise>
		</c:choose>
	</clay:col>
</clay:row>

<c:if test="<%= assetPublisherDisplayContext.isOpenOfficeServerEnabled() %>">

	<%
	String[] conversions = DocumentConversionUtil.getConversions("html");
	%>

	<p class="h4 sheet-tertiary-title">
		<liferay-ui:message key="enable-conversion-to" />

		<clay:icon
			aria-label='<%= LanguageUtil.get(request, "enabling-openoffice-integration-provides-document-conversion-functionality") %>'
			cssClass="lfr-portal-tooltip"
			symbol="question-circle-full"
			title='<%= LanguageUtil.get(request, "enabling-openoffice-integration-provides-document-conversion-functionality") %>'
		/>
	</p>

	<clay:row>
		<clay:col
			md="6"
		>

			<%
			for (int i = 0; i < (conversions.length / 2); i++) {
				String conversion = conversions[i];
			%>

				<aui:input checked="<%= ArrayUtil.contains(assetPublisherDisplayContext.getExtensions(), conversion) %>" id='<%= "extensions" + conversion %>' label="<%= StringUtil.toUpperCase(conversion) %>" name="extensions" type="checkbox" value="<%= conversion %>" />

			<%
			}
			%>

		</clay:col>

		<clay:col
			md="6"
		>

			<%
			for (int i = conversions.length / 2; i < conversions.length; i++) {
				String conversion = conversions[i];
			%>

				<aui:input checked="<%= ArrayUtil.contains(assetPublisherDisplayContext.getExtensions(), conversion) %>" id='<%= "extensions" + conversion %>' label="<%= StringUtil.toUpperCase(conversion) %>" name="extensions" type="checkbox" value="<%= conversion %>" />

			<%
			}
			%>

		</clay:col>
	</clay:row>
</c:if>

<p class="h4 sheet-tertiary-title">
	<liferay-ui:message key="social-bookmarks" />
</p>

<liferay-social-bookmarks:bookmarks-settings
	displayStyle="<%= assetPublisherDisplayContext.getSocialBookmarksDisplayStyle() %>"
	types="<%= assetPublisherDisplayContext.getSocialBookmarksTypes() %>"
/>
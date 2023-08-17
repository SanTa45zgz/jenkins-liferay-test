<#assign journalArticleModel = "com.liferay.journal.model.JournalArticle" >
<#assign assetCategLocService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService") >
<#assign assetCategPropLocService = serviceLocator.findService("com.liferay.asset.category.property.service.AssetCategoryPropertyLocalService") >
<#assign assetVocabLocService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService") >
<#assign articleService	= serviceLocator.findService( "com.liferay.journal.service.JournalArticleLocalService" ) >
<#assign groupService	= serviceLocator.findService( "com.liferay.portal.kernel.service.GroupLocalService") >
<#assign dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService") >



<#assign isRequestOnLine = upvlibs.isRequestOnLine() >
<#assign portalURL = upvlibs.obtenerPortalUrl()>

<#assign currentGroup = groupService.getGroup( groupId ) >

<#-- Styles -->
<#assign cStBorderNo			= "border:none" >
<#assign cStFontBold			= "font-weight:bold" >
<#assign cStTextNoDeco			= "text-decoration:none" >
<#assign cStTextUpper			= "text-transform:uppercase" >
<#assign cStGen_MarginLeft		= "margin-left:16px" >
<#assign cStGen_FontFamily		= "font-family:'Helvetica Neue',Helvetica,Arial,sans-serif" >
<#assign cStGen_FontFamilyEHU	= "font-family:EHUSans,'Helvetica Neue',Helvetica,Arial,sans-serif" >
<#assign cStGen_TableBorder		= "${cStBorderNo}" >
<#assign cSt_CambioIdioma		= "margin-top:1em;margin-bottom:1.5em;${cStGen_MarginLeft}" >
<#assign cSt_CambioIdiomaHRef	= "color:#6a6a6a;${cStGen_FontFamily};${cStTextNoDeco};${cStTextUpper}" >
<#assign cSt_Logo				= "margin-top:1em;${cStGen_MarginLeft}" >
<#assign cSt_LogoHRef			= "color:black;${cStGen_FontFamilyEHU};font-size:26px;font-weight:bold;${cStTextNoDeco}" >
<#assign cSt_NewsTitle			= "${cStGen_FontFamilyEHU};margin-top:15px;margin-bottom:5px;${cStGen_MarginLeft}" >
<#assign cSt_ModifiedDate		= "${cStGen_FontFamily};${cStFontBold};font-size:13px;margin-top:5px;margin-bottom:15px;${cStGen_MarginLeft}" >
<#assign cSt_TablaNews			= "${cStGen_TableBorder};${cStGen_MarginLeft}" >
<#assign cSt_ImgConte			= "${cStGen_TableBorder};vertical-align:top;padding-right:1em;padding-bottom:1em;padding-left:0em" >
<#assign cSt_ImgConteWidth		= "230" >
<#assign cSt_ImgConteHeight		= "148" >
<#assign cSt_ImgConteImg		= "width:${cSt_ImgConteWidth}px;max-width:${cSt_ImgConteWidth}px" >
<#assign cSt_InfoConte			= "${cStGen_TableBorder};vertical-align:top" >
<#assign cSt_Categoria			= "color:#FFFFFF;${cStGen_FontFamily};font-size:10px;${cStFontBold};letter-spacing:1px;${cStTextUpper};padding:0.2em 0.4em 0.2em 0.4em" >
<#assign cSt_LinkConte			= "color:black;${cStTextNoDeco}" >
<#assign cSt_Titulo				= "${cStGen_FontFamilyEHU};font-size:20px;${cStFontBold};margin-top:15px;margin-bottom:12px" >
<#assign cSt_Resumen			= "${cStGen_FontFamily};font-size:14px;margin-top:0px" >
<#assign cSt_Unsubscribe		= "${cStGen_FontFamily};font-size:12px;margin-top:15px;margin-bottom:25px;${cStGen_MarginLeft}" >
<#assign txtUnsubscribeHRef		= "color:black" >





<#--
# ===============================================================================
# Devuelve el valor para "utm_campaign" (parametro de Google Analytics) asociado
# a la newsletter con numero "number".
# El parametro "number" en realidad es un string que representa un numero.
# Si "number" es nulo, lo toma como si tuviera el valor 000.
# Parametros:
#	number			numero para componer el valor del parametro
# Retorno:			valor para la campaina de Google Analytics
# ===============================================================================
-->
<#function getUtmCampaign number = "null">
	<#if  number == "null" >
		<#local numero = "000" >
	<#else>
		<#local numero = number >
	</#if>
	<#return "Campusa-newsletter-" + numero >
</#function>

<#--
# ===============================================================================
# Realiza la presentacion de los articulos presentes en el contenido que se
# va a visualizar.
# Se pueden presentar en dos idiomas, dependiendo del valor de los parametros
# "langPri" y "langSec".
# Parametros:
#	langPri		codigo de lenguage primario
#	langSec		codigo de lenguage secundario
# Retorno:		codigo HTML con la presentacion
# ===============================================================================
-->
<#macro viewArticles langPri = "" langSec = "" > 
	<#if langPri == "" >	<#return > </#if>

	<#local langRef = "lang-" + langPri >
	<#if langPri == "en">
		<#local countryCode = "GB" >
	<#else>
		<#local countryCode = "ES" >
	</#if>
	<#local thisLocale =   localeUtil.fromLanguageId( langPri + "_" + countryCode) >
	<#if langSec == "" >
		<#local cambioIdioma = getterUtil.getBoolean( "false") >
	<#else>
		<#local cambioIdioma = getterUtil.getBoolean( "true") >
	</#if>
	<#local txtOpenNewWindow = languageUtil.get( thisLocale, "opens-new-window" ) >
	<#local txtClickToOpen = languageUtil.get( thisLocale, "ehu.click-to-open-the-link" ) >
	<#local txtImgNotFound = languageUtil.get( thisLocale, "ehu.image-not-found" ) >
	<#local txtNoImg = languageUtil.get( thisLocale, "ehu.image-not" ) >
	<#local noImage = "https://via.placeholder.com/" +
		cSt_ImgConteWidth + "x" + cSt_ImgConteHeight + ".png" +
		"/E6E6E6/294C4C?text=" + txtImgNotFound?replace( " ", "+" ) >
	
	<a id="${langRef}" name="${langRef}"></a>
	<#local nw_number = ehu_content_list_number.getData() >
	<#local utm_source = "newsletter" >
	<#local utm_campaign = getUtmCampaign( nw_number ) >
	<#if isRequestOnLine >
		<#local utm_medium = "web" >
	<#else>
		<#local utm_medium = "email" >
	</#if>
	<#if isRequestOnLine >
		<#if nw_number != "" >
			<#local nwTitle = "Newsletter: " + languageUtil.format( thisLocale, "ehu.copy-number-x", nw_number ) >
			<h1 style="${cSt_NewsTitle};">${nwTitle}</h1>	
			
			<#assign articleModifiedDate = .vars['reserved-article-modified-date'].data!"" >
			<#if locale == "eu_ES">
				<#assign dateFormat = "yyyy/MM/dd">
			<#else>
			    <#assign dateFormat = "dd/MM/yyyy">
			</#if>
			<#setting date_format=dateFormat >
			<#assign currentLocale = locale>
			<#setting locale = localeUtil.getDefault() >
			<#if articleModifiedDate?? && articleModifiedDate != "" >
				<#assign modifiedDate = ( articleModifiedDate?datetime( "EEE, dd MMM yyyy hh:mm:ss" ) )?date >
				<#assign txtModifiedDate = modifiedDate?string >
			<#else>
					<#assign txtModifiedDate = "" >
			</#if>
			<#setting locale = currentLocale>
			
			<p id="modified-date" style="${cSt_ModifiedDate};">${txtModifiedDate}</p>
		</#if>
	<#else >
		<#if cambioIdioma >
			<div class="cambio-idioma" style="${cSt_CambioIdioma};">
				<#if langSec == "en">
					<#local countryCodeSec = "GB" >
				<#else>
					<#local countryCodeSec = "ES" >
				</#if>

				<#local hrefLang = langSec + "-" + countryCodeSec >
				<#local localeSec =  localeUtil.fromLanguageId(langSec + "_" + countryCodeSec)>
				<#local txtRef = languageUtil.get( localeSec, "ehu.go-to-the-.lang.-version" ) >
				<a href='#lang-${langSec}' hreflang='${hrefLang}' lang="${langSec}" target="_self" style="${cSt_CambioIdiomaHRef};">${txtRef}</a>
			</div>
		</#if>
	</#if>

	<div lang="${langPri}">
		<#-- NOTICIAS -->
		
		<#if ehu_content_list_articleId.getSiblings()?has_content && ehu_content_list_articleId.getSiblings()[0].getData()?has_content>
			<table class="table-news" width="100%" cellspacing="0" cellpadding="0" border="0" style="margin-left:16px;">
				<tbody>
					<tr>
						<td class="table-news-container" bgcolor="#ffffff" align="left">
							<div style="width:100%;max-width:775px;margin-top:10px;">
								<#list ehu_content_list_articleId.getSiblings() as current_new>
									<#if current_new.getData()?has_content>
										<#local articleId = getterUtil.getString( current_new.getData() ) >
										
										<#attempt>
											<#local article = articleService.getArticle( getterUtil.getLong( groupId ), articleId ) >
										<#recover>
											<#-- todo -->
										</#attempt>
										<#if article?? >
											<#local content = article.getContentByLocale( thisLocale ) >
											<#local document = saxReaderUtil.read( content ) >
											<#local rootElement = document.getRootElement() >
											<#local imageUrl = "" >
											<#local altImage = "" >
											<#local titulo = "" >
											<#local subtitulo = "" >
											<#local firstLevelFieldSet = getChild(rootElement, "ehuimagesFieldSet")>
											<#if firstLevelFieldSet?has_content>
											  <#local secondLevelFieldSet = getChild(firstLevelFieldSet, "ehuimagesFieldSetFieldSet")>
												<#if secondLevelFieldSet?has_content>
												    <#local titulo = getChildValue(secondLevelFieldSet, "ehuhighlighttitle")>
														<#local subtitulo = getChildValue(secondLevelFieldSet, "ehuhighlightsubtitle")>
														<#local ehuhighlightimageFieldSet = getChild(secondLevelFieldSet, "ehuhighlightimageFieldSet")>
															<#if ehuhighlightimageFieldSet?has_content>
															<#local ehuhighlightimage = getChildValue(ehuhighlightimageFieldSet, "ehuhighlightimage")>
															  <#if ehuhighlightimage?has_content>
																<#local image = ( ( "\"" + ehuhighlightimage?json_string + "\"" )?eval )?eval >
																<#local fileEntry = dLFileEntryLocalService.getDLFileEntryByUuidAndGroupId( image.uuid?string, image.groupId?number ) >
																<#local imageUrl = fileEntry.getFolderId() + "/" + fileEntry.getTitle() >
																<#local ehuhighlightimageFieldSetFieldSet = getChild(ehuhighlightimageFieldSet, "ehuhighlightimageFieldSetFieldSet")>
																	<#if ehuhighlightimageFieldSetFieldSet?has_content>
																	<#local ehuhighlightimagealttext = getChild(ehuhighlightimageFieldSetFieldSet, "ehuhighlightimagealttext")>
																		<#if ehuhighlightimagealttext?has_content >
																			<#local altImage = ehuhighlightimagealttext.element("dynamic-content").getText() >
																		</#if>
																	</#if> <#-- ehuhighlightimageFieldSetFieldSet??   -->
																	</#if> <#-- ehuhighlightimage??   -->
															</#if> <#-- ehuhighlightimageFieldSet??   -->
                         </#if> <#-- secondLevelFieldSet??   -->
												</#if><#-- firstLevelFieldSet??   -->
											
											<#if titulo?has_content || subtitulo?has_content >
												<#if imageUrl != ""  >
														<#local imageUrl = portalURL + "/documents/" + groupId + "/" + imageUrl >
												<#else>
														<#local imageUrl = noImage >
														<#local altImage = txtNoImg >
												</#if>


												<#local groupFriendlyURL = currentGroup.getFriendlyURL() >
												<#local href = portalURL + "/" + langPri + "/web" + groupFriendlyURL + "/-/" + article.getUrlTitle() >
												<#local articleCategories = assetCategLocService.getCategories( journalArticleModel, article.getResourcePrimKey() ) >
												<#local categoryName = "" >
												<#local categoryProperty = "" >
												<#local utm_content = "" >
												<#list articleCategories as category >
													<#if categoryName == "" >
														<#local vocabulary = assetVocabLocService.getVocabulary( getterUtil.getLong( category.getVocabularyId() ) ) >
														<#if vocabulary?? >
															<#if vocabulary.getTitle("eu") == "Campusa" >
																<#local categoryName = category.getTitle( thisLocale ) >
																<#local categoryId = category.getCategoryId() >
																<#local categoryProperty = assetCategPropLocService.getCategoryProperty( getterUtil.getLong( categoryId ), "category-color" ) >
																<#local categoryColor = categoryProperty.getValue() >
																<#local utm_content = category.getTitle("eu") + "_" + langPri >
															</#if>
														</#if>
													</#if>
												</#list> <#-- articleCategories -->

												<#local href = href + "?utm_source=" + utm_source + "&utm_campaign=" + utm_campaign + "&utm_medium=" + utm_medium + "&utm_content=" + utm_content >
												<@printTableNewsRow refImage=imageUrl altImage=altImage catColor=categoryColor catName=categoryName txtNewWindow=txtOpenNewWindow href=href
														rowTitle=titulo rowSubtitle=subtitulo />
														
											</#if> <#--  !Cadena.IsBlank( titulo ) -->
										
										</#if> <#--  article?? -->
									</#if> <#--  current_new.getData() -->
								</#list> <#--  ehu_content_list_articleId.getSiblings() -->
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</#if>

<#-- EVENTOS -->
		<#if ehu_event_list_articleId.getSiblings()?has_content && ehu_event_list_articleId.getSiblings()[0].getData()?has_content>

			<table class="table-news" width="100%" cellspacing="0" cellpadding="0" border="0" style="margin-top:16px;margin-left:16px;">
				<tbody>
					<tr>
						<td class="table-news-container" bgcolor="#ffffff" align="left">
							<div style="width:100%;max-width:775px;margin-top:10px;">
								<#list ehu_event_list_articleId.getSiblings() as current_event>
									<#if current_event.getData()?has_content>
										
										<#local articleId = getterUtil.getString( current_event.getData() ) >
										<#attempt>
											<#local article = articleService.getArticle( getterUtil.getLong( groupId ), articleId ) >
											<#recover>
											<#-- todo -->
										</#attempt>
										
										<#if article?? >
										
											<#local content = article.getContentByLocale( thisLocale ) >
											<#local document = saxReaderUtil.read( content ) >
											<#local rootElement = document.getRootElement() >
											<#local imageUrl = "" >
											<#local altImage = "" >
											<#local titulo = "" >
											<#local subtitulo = "" >
											
                      <#attempt>
											  <#local ehuimagesFieldSet = getChild(rootElement, "ehuimagesFieldSet")>
											  <#if ehuimagesFieldSet?has_content>
											    <#local ehuimagesFieldSetFieldSet = getChild(ehuimagesFieldSet, "ehuimagesFieldSetFieldSet") >
												  <#if ehuimagesFieldSetFieldSet?has_content>
												    <#local titulo = getChildValue(ehuimagesFieldSetFieldSet, "ehuhighlighttitle") >
											      <#local subtitulo = getChildValue(ehuimagesFieldSetFieldSet, "ehuhighlightsubtitle") >
												  </#if>
										 	  </#if>
											<#recover>
												<#local titulo = "" >
												<#local subtitulo = "" >
											</#attempt>
												
                      <#if titulo?has_content || subtitulo?has_content >
											<#attempt>
											
											  <#local ehuhighlightimageFieldSet = getChild(ehuimagesFieldSetFieldSet, "ehuhighlightimageFieldSet") >
												<#local ehuhighlightimage = getChildValue(ehuhighlightimageFieldSet, "ehuhighlightimage") >
												<#local image = ( ( "\"" + ehuhighlightimage?json_string + "\"" )?eval )?eval >
											  <#local fileEntry = dLFileEntryLocalService.getDLFileEntryByUuidAndGroupId( image.uuid?string, image.groupId?number ) >
												<#local imageUrlEvent = portalURL + "/documents/" + groupId + "/" + fileEntry.getFolderId() + "/" + fileEntry.getTitle() >
												
												<#local ehuhighlightimageFieldSetFieldSet = getChild(ehuhighlightimageFieldSet, "ehuhighlightimageFieldSetFieldSet") >
												<#local altImage = getChildValue(ehuhighlightimageFieldSetFieldSet, "ehuhighlightimagealttext") >
											<#recover>
												<#local imageUrlEvent = noImage >
												<#local altImage = txtNoImg >
											</#attempt>
											
													
											<#attempt>

												<#local fecha = "">
												<#local hora = "">
												<#local minutos = "">

												<#local ehugeneraldataFieldSet = getChild(rootElement, "ehugeneraldataFieldSet") >
												<#local ehugeneraldataFieldSetFieldSet = getChild(ehugeneraldataFieldSet, "ehugeneraldataFieldSetFieldSet") >
												<#local ehustartdatehourFieldSet = getChild(ehugeneraldataFieldSetFieldSet, "ehustartdatehourFieldSet") >
												<#if getChild(ehustartdatehourFieldSet, "ehustartdatehour")?has_content>
													<#local fecha = getChildValue(ehustartdatehourFieldSet, "ehustartdatehour")?date("yyyy-MM-dd") >														
												</#if>
												<#if getChild(ehugeneraldataFieldSetFieldSet, "ehustartdatehourhh")?has_content >
													<#local hora = getChildValue(ehugeneraldataFieldSetFieldSet, "ehustartdatehourhh") >
												</#if>
												<#if getChild(ehugeneraldataFieldSetFieldSet, "ehustartdatehourmm")?has_content >
													<#local minutos = getChildValue(ehugeneraldataFieldSetFieldSet, "ehustartdatehourmm") >
												</#if>
												<#if hora?has_content>
													<#if hora?number lt 10>
														<#local hora = "0" + hora />
													</#if>
												</#if>
												<#if minutos?has_content>
													<#if minutos?number lt 10>
														<#local minutos = "0" + minutos />
													</#if>
												</#if>

												<#if langPri == "es">
													<#local fechaEvento = fecha?string("dd/MM/yyyy") + " " + hora + ":" + minutos >
												<#else>
													<#local fechaEvento = fecha?string("yyyy/MM/dd") + " " + hora + ":" + minutos >
												</#if>
											<#recover>
												<#local fechaEvento = "" >
											</#attempt>
											<#local groupFriendlyURL = currentGroup.getFriendlyURL() >
											<#local href = portalURL + "/" + langPri + "/web" + groupFriendlyURL + "/-/" + article.getUrlTitle() >
											<#local articleCategories = assetCategLocService.getCategories( journalArticleModel, article.getResourcePrimKey() ) >
											<#local categoryName = "" >
											<#local categoryProperty = "" >
											<#local utm_content = "" >
											
											
											<#list articleCategories as category >
												<#if categoryName == "" >
													<#local vocabulary = assetVocabLocService.getVocabulary( getterUtil.getLong( category.getVocabularyId() ) ) >
													<#if vocabulary?? >
														<#if vocabulary.getTitle("eu") == "Campusa" >
															<#local categoryName = category.getTitle( thisLocale ) >
															<#local categoryId = category.getCategoryId() >
															<#local categoryProperty = assetCategPropLocService.getCategoryProperty( getterUtil.getLong( categoryId ), "category-color" ) >
															<#local categoryColor = categoryProperty.getValue() >
															<#local utm_content = category.getTitle("eu") + "_" + langPri >
														</#if>
													</#if>
												</#if>
											</#list>
												
											<#local href = href + "?utm_source=" + utm_source + "&utm_campaign=" + utm_campaign + "&utm_medium=" + utm_medium + "&utm_content=" + utm_content >
											<@printTableNewsRow refImage=imageUrlEvent altImage=altImage catColor=categoryColor catName=categoryName txtNewWindow=txtOpenNewWindow href=href
														rowTitle=titulo rowSubtitle=subtitulo />
											</#if> <#--  !Cadena.IsBlank( titulo ) -->	
										</#if><#--  article?? -->
									</#if><#--  current_event.getData() -->
									</#list> <#-- ehu_event_list_articleId -->
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			
		</#if> <#-- ehu_event_list_articleId?? && ehu_event_list_articleId.getSiblings()?has_content ... -->

		<#if !isRequestOnLine >
			<#local txtUnsubscribe = languageUtil.get( thisLocale, "ehu.campusa.newsletter-this-is" ) + ". " +
				languageUtil.get( thisLocale, "ehu.campusa.newsletter-to-unsubscribe" ) >
			<#local txtHref = languageUtil.get( thisLocale, "ehu.campusa.newsletter-go-to-unsuscribe-form" ) >
			<#local txtHref = txtHref?substring( 0, 1 )?lower_case + txtHref?substring( 1 ) >
			<#local groupFriendlyURL = currentGroup.getFriendlyURL() >
			<#local webSiteUrl = portalURL + "/" + langPri + "/web" + groupFriendlyURL>
			<#if langPri == "en">
				<#local path = "" >
			<#else>
				<#local path = "campusa/" >
			</#if>
			<#local refPagina = path + "no-newsletter" >
			<#local linkUnsubscribe = webSiteUrl + "/" + refPagina >
			<p class="unsubscribe" style="${cSt_Unsubscribe};">
				<span>${txtUnsubscribe}</span>
				<a title="${txtOpenNewWindow}" href="${linkUnsubscribe}" target="_blank" style="${txtUnsubscribeHRef};">${txtHref}</a>.
			</p>
		</#if>
	</div>
</#macro>


<#function getChild node childName >
 <#return (node??)?then(node.elements()?filter(element -> element.attributeValue("name") == childName)?first!"", "")>
</#function>

<#function getChildValue node childName>
 <#assign childNode = getChild(node, childName)>
 <#return (childNode?has_content)?then(getChild(node, childName).element("dynamic-content").getTextTrim(), "")>
</#function>
<#--
#
# ===============================================================================
# Realiza la presentacion del logo correspondiente a Campusa.
# El parametro "nw_languages" se utiliza para componer la URL a la que da acceso
# el logo.
# Parametros:
#	nw_languages	lenguages seleccionados para la visualizacion
# Retorno:
#					codigo HTML con la presentacion del logo
# ===============================================================================
-->
<#macro printLogo nw_languages = "" >
	<#local groupFriendlyURL = currentGroup.getFriendlyURL() >
	<#local webSiteUrl = portalURL + "/web" + groupFriendlyURL>
	<#if nw_languages == "eu-es">
		<#local path = "campusa/" >
	<#else>
		<#local path = "" >
	</#if>
	<#if nw_languages == "en">
		<#local localeId = "en_GB" >
	<#else>
		<#local localeId = "eu_ES" >
	</#if>

	<#local refPagina = path + "newsletter-online" >
	<#local urlOnLine = webSiteUrl + "/" + refPagina >
	<#local thisLocale = localeUtil.fromLanguageId( localeId) >
	<#local txtOpenNewWindow = languageUtil.get( thisLocale, "opens-new-window" ) >

	<#local utm_source = "newsletter" >
	<#local nw_number = ehu_content_list_number.getData() >
	<#local utm_campaign = getUtmCampaign( nw_number ) >
	<#local utm_medium = "email" >
	<#local utm_content = "Goiburua" >
	<#local href = urlOnLine + "?utm_source=" + utm_source + "&utm_campaign=" + utm_campaign + "&utm_medium=" + utm_medium + "&utm_content=" + utm_content >
	
	<div class="logo" style="${cSt_Logo};">
		<h1>
			<a id="enlace-logo" title="${txtOpenNewWindow}" href="${href}" target="_blank" style="${cSt_LogoHRef};">
				<img src='${portalURL}/o/upv-ehu-campusa-theme/images/custom/campusa/campusa_newsletter.gif' moz-do-not-send="true"
					alt="Campusa Newsletter" style="width:100%;max-width:453px;height:auto;" width="453px" height="52px">
			</a>
		</h1>
	</div>
</#macro>
	
<#--
# ===============================================================================
# Realiza la presentacion de la tabla para cada row de articulo.
# Parametros:
#	refImage		referencia (url) a la imagen a presentar
#	altImage		texto alternativo a la imagen a presentar
#	catColor		codigo de color de la categoria
#	catName			nombre del color de la categoria
#	txtNewWindow	texto para decir que se va a abrir una nueva ventana
#	rowTitle		titulo asociado a la row
#	rowSubtitle		subtitulo asociado a la row
# Retorno:			codigo HTML con la presentacion del articulo
# ===============================================================================
-->
<#macro printTableNewsRow refImage = "" altImage = "" catColor = "" catName = "" href = "" txtNewWindow = "" rowTitle = "" rowSubtitle = "">
	<table class="table-news-row" style="width:100%;max-width:775px;background-color:#ffffff;margin-bottom:1em;"
		width="775" cellspacing="0" cellpadding="0" border="0">
		<tbody>
			<tr>
				<td bgcolor="#ffffff" align="left">
				<!--[if (gte mso 9)|(IE)]>
					<table width="230" align="left" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:15px;margin-right:5px;">
						<tr>
							<td>
				<![endif]-->
				<table class="content-image" style="width:100%;max-width:230px;margin-right:15px;"
					cellspacing="0" cellpadding="0" border="0" align="left">
					<tbody>
					<tr>
						<td>
						<!--[if (gte mso 9)|(IE)]>
							<table width="230" align="left" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td>
						<![endif]-->
						<table style="width:100%;max-width:230px;" cellspacing="0" cellpadding="0" border="0">
							<tbody>
							<tr>
								<td valign="top" bgcolor="#ffffff">
									<table width="100%" cellspacing="0" cellpadding="0" border="0">
									<tbody>
										<tr>
											<td valign="top" align="left">
												<img src="${refImage}" moz-do-not-send="true" alt="${altImage}"
													width="${cSt_ImgConteWidth}" height="${cSt_ImgConteHeight}">
											</td>
										</tr>
									</tbody>
									</table>
								</td>
							</tr>
							</tbody>
						</table>
						<!--[if (gte mso 9)|(IE)]>
									</td>
								</tr>
							</table>
						<![endif]-->
						</td>
					</tr>
					</tbody>
				</table>
				<!--[if (gte mso 9)|(IE)]>
							</td>
						</tr>
					</table>
				<![endif]-->
				<!--[if (gte mso 9)|(IE)]>
						<table width="500" align="left" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
				<![endif]-->
				<table class="content-info" style="width:100%;max-width:530px;"
					cellspacing="0" cellpadding="0" border="0" align="left">
					<tbody>
					<tr>
						<td>
						<!--[if (gte mso 9)|(IE)]>
							<table width="500" align="left" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td>
						<![endif]-->
						<table style="width:100%;max-width:530px;" cellspacing="0" cellpadding="0" border="0">
							<tbody>
								<tr>
									<td valign="top" bgcolor="#ffffff">
										<table width="100%" cellspacing="0" cellpadding="0" border="0">
											<tbody>
												<tr>
													<td valign="top" align="left">
														<div>
															<#if catColor != "" >
																<span class="categoria" style="${cSt_Categoria};background-color:#${catColor};">${catName}</span>
															</#if>
															<#-- <a class="enlace-contenido" title="${txtNewWindow}" href="${href}" target="_blank" style="${cSt_LinkConte};"> -->
															<a class="enlace-contenido" href="${href}" style="${cSt_LinkConte};">									
																<h2 class="titulo" style="${cSt_Titulo};">${rowTitle}</h2>
																<p class="resumen" style="${cSt_Resumen};">${rowSubtitle}</p>										
															</a>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
						<!--[if (gte mso 9)|(IE)]>
									</td>
								</tr>
							</table>
						<![endif]-->
						</td>
					</tr>
					</tbody>
				</table>
				<!--[if (gte mso 9)|(IE)]>
							</td>
						</tr>
					</table>
				<![endif]-->
				</td> 
			</tr>
		</tbody>
	</table>
</#macro>

<#--
# ----
# html
# ----
-->
<#if !isRequestOnLine >
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<#-- Facebook sharing information tags -->
		<meta property="og:title" content="Newsletter Campusa">

		<#-- Required meta tags (BootStrap) -->
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<#-- Bootstrap CSS -->
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
			integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		
		<title>Newsletter Campusa</title>
		
		<style type="text/css">
			#enlace-logo:hover,
			#enlace-logo:focus,
			a.enlace-contenido:hover,
			a.enlace-contenido:focus,
			p.unsubscribe a:hover,
			p.unsubscribe a:focus			{
				opacity: 0.4;
			}
			.cambio-idioma a:hover,
			.cambio-idioma a:focus {
				color: lightgrey;
				opacity: 0.6;
			}
			
			.content-image img {
				max-width: 230px;
			}
			<#-- niapa para Apple Mail -->
			@media only screen and (min-width: 776px) {
				.content-image {width: 230px !important;}
				.content-info {width: 530px!important;}
			}
		</style>

	</head>
	<body>
</#if>
		<div class="news-list-nwlt-campusa">
			<#if isRequestOnLine >
				<#assign languageCode = locale.getLanguage () >
				<@viewArticles languageCode "" />
			<#else>
				<#assign nw_languages = ehu_content_list_languages.getData() >
				<@printLogo nw_languages />
				<#if nw_languages == "eu-es" >
					<@viewArticles "eu", "es"  />
					<@viewArticles "es", "eu" />
				<#else>
					<@viewArticles "en", "" />
				</#if>
			</#if>
		</div>
<#if !isRequestOnLine >
		<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
			integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous">
		</script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
			integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous">
		</script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
			integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous">
		</script>
	</body>
</html>
</#if>
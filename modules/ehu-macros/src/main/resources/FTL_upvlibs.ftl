<#--
# ===============================================================================
# Indica si un campo repetible tiene contenidos
# ===============================================================================
-->
<#function hasElement element>
	<#assign hayArrElems = getterUtil.getBoolean("false")>
 	<#if element?? && element.getSiblings()??>
   		<#assign arrElems = element.getSiblings() >	
		<#if ((arrElems?size >= 1)?c)?boolean>
			<#if arrElems[0]?? && arrElems[0].getData()!= "">
				<#assign hayArrElems = getterUtil.getBoolean("true")>
			</#if>
		</#if>
	</#if>
	<#return hayArrElems>
</#function>

<#--
# ===============================================================================
# Borra un elemento de un array
# ===============================================================================
-->
<#function removeFromArray array index>
	<#assign nuevoArray = []>
	<#list array as item>
		<#if item?index != index>
			<#assign nuevoArray = nuevoArray + [item] />
		</#if>
	</#list>
	<#return nuevoArray>
</#function>


<#--
# ===============================================================================
# Devuelve si la peticion (la request) se realiza on-line o no (a traves de un
# enlace en un correo, documento...). Para newsletter
# ===============================================================================
-->
<#function isRequestOnLine>
	<#local contextThread= staticUtil["com.liferay.portal.kernel.service.ServiceContextThreadLocal"]>
	<#local serviceContext = contextThread.getServiceContext() >
	<#local themeDisplay = serviceContext.getThemeDisplay()>
	<#local isRender = themeDisplay.isLifecycleRender() >
	<#if isRender >
	    <#return true >
	<#else>  
	    <#local httpServletRequest = serviceContext.getRequest() >
	    <#list httpServletRequest.getHeaderNames() as headerName >
	           <#if headerName == "referer" >
	               <#local valueHeaderName = httpServletRequest.getHeader( headerName )  >
	                <#if valueHeaderName == "">
	                	<#return true>
	                <#else>
	                	<#return false>
	                </#if>
	           </#if>
	    </#list>
		
	</#if>
</#function>

<#--
# ===============================================================================
# Devuelve portalUrl Para newsletter
# ===============================================================================
-->
<#function obtenerPortalUrl>
	<#local contextThread= staticUtil["com.liferay.portal.kernel.service.ServiceContextThreadLocal"]>
	<#local serviceContext = contextThread.getServiceContext() >
	<#local themeDisplay = serviceContext.getThemeDisplay()>
	<#return themeDisplay.getPortalURL()>
</#function>


<#macro formatAttachment documentField documentTitleField>
	<#assign formatedDocument = "">
	<#assign documentData = documentField.getData()>
	<#assign arrayURL = documentData?split( "/" ) >
	<#if arrayURL?? &&  arrayURL[2]?? &&  arrayURL[3]?? &&  arrayURL[4]??>
		<#assign fileName = arrayURL[4]>
		<#--assign fileName = httpUtil.decodeURL(fileName)-->
		<#assign existsTitleField = documentField.containsKey(documentTitleField)>
		<#assign document_title = fileName>
	
		<#attempt>
			<#if documentTitleField?? && documentField['${documentTitleField}']??>
				<#assign document_tmp = documentField['${documentTitleField}'].getData()>
				<#if document_tmp?has_content >
					<#assign document_title = documentField['${documentTitleField}'].getData()>
				</#if>
			</#if>
		<#recover>
			<#-- si falla no se hace nada y el titulo del documento, sera el del documento -->
		</#attempt>
	
		<#assign groupId = getterUtil.getLong(arrayURL[2])>
		<#assign folderId = getterUtil.getLong(arrayURL[3])>
	
		<#assign dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService") >
	
		<#if dLFileEntryLocalService?has_content>
			<#assign dlFileEntry = dLFileEntryLocalService.fetchFileEntryByFileName(groupId,folderId,fileName)!"">
		</#if>
		<#if !dlFileEntry?? || !dlFileEntry?has_content>
			<#assign formatedDocument = '<p class="file-not-found">' + document_title + ' (' + languageUtil.get( locale, "the-document-could-not-be-found" ) + ')' + '</p>' >
		<#else>
			<#assign fileExtension = dlFileEntry.getExtension()>
			<#assign fileExtensionLanguage = "ehu.ext." + fileExtension>
			<#assign fileExtensionDescription = languageUtil.get(locale,fileExtensionLanguage)>
			<#assign fileSize = dlFileEntry.getSize()>
			<#assign fileSizeAbbr = "">
			<#assign fileSizeAbbrLanguage = "">
			<#assign reSize = fileSize/1024.0>
			<#if ((reSize > 1024)?c)?boolean >
				<#assign reSize = reSize/1024.0>
				<#assign fileSizeAbbr = "Mb">
				<#assign fileSizeAbbrLanguage = "ehu.ext.Mb">
			<#else>
				<#assign fileSizeAbbr = "Kb">
				<#assign fileSizeAbbrLanguage = "ehu.ext.Kb">
			</#if>
				<#assign fileSizeDescription = languageUtil.get(locale,fileSizeAbbrLanguage)>
				<#assign formatCharacter = "#">
				 <#assign numberFormat = "#,##0.00" >
				 <#setting locale = .locale>
				 <#assign sizeFormated = reSize?string(numberFormat)>
				<#assign document_link_title = languageUtil.get(locale,'opens-new-window')>
				<#assign a_link_class = "bullet bullet-" + fileExtension>
	
				<#-- si es el nuevo theme -->
				<#assign theme_image_path = (themeDisplay.getPathThemeImages())!"" >
				<#if theme_image_path?? && theme_image_path?contains('/upv-ehu-theme/images')>
					<#assign formatedDocument = '<a href="' + documentData + '" target="_blank" class="' + a_link_class + '">' + document_title + '<span class="hide-accessible">' + document_link_title + '(<abbr title="' + fileExtensionDescription + '">' + fileExtension + ' </abbr>,' + sizeFormated + ' <abbr title="' + fileSizeDescription + '">' + fileSizeAbbr + '</abbr>)</span>' +' <span class="icon-external-link"></span>' +'</a>'>
				<#else>
					<#assign formatedDocument = '<a href="' + documentData + '" target="_blank" class="' + a_link_class + '">' +
													'<span class="hide-accessible">' + document_link_title + '</span><span>' +
													document_title + ' </span><span>&nbsp;(<abbr title="' + fileExtensionDescription + '">' + fileExtension + ' </abbr>,' +
													sizeFormated + ' <abbr title="' + fileSizeDescription + '">' + fileSizeAbbr + '</abbr>)</span>' +
													' <span class="icon-external-link"></span>' +
												'</a>'>
	
				</#if>
		</#if>
	</#if>
	<#return>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Lista de propiedades asociadas a la categoria parametro
 # Parametros:
 #	categorId		Identificador de categoria
 #	propertiesArr	Array de propiedades relacionado con categorias de un
 #					determinado nivel de profundidad
 # Salida:
 #	propertiesStr	valor de la propiedad asociada a la categoria
 # ------------------------------------------------------------------------------
-->
<#macro formatCategoryProperties categoryId propertiesArr >
	<#assign propertiesStr = "">
	<#assign categPropertiesLocalService = serviceLocator.findService("com.liferay.asset.category.property.service.AssetCategoryPropertyLocalService") >
	<#list propertiesArr as property>
		<#if categoryId?? && property?? && property != "">
				<#attempt>
					<#assign categoryProperty = categPropertiesLocalService.getCategoryProperty(categoryId,property)>
				<#recover>
					<#-- si falla no se hace nada -->
				</#attempt>
				<#if categoryProperty?? && categoryProperty?has_content>
					<#assign propertyKey = categoryProperty.getKey()>
					<#assign propertyValue = categoryProperty.getValue()>
					<#if propertyValue?has_content>
						<#-- Propiedad direccion postal del vocabulario global localización -->
						<#if propertyKey == 'Address'>
							<#assign propertiesStr = " (" + propertyValue + ",">
						<#-- Propiedad código postal del vocabulario global localización -->
						<#elseif propertyKey == 'PostalCode'>
							<#assign propertiesStr = propertiesStr + " " + languageUtil.get(locale,propertyKey) + ": " + propertyValue + ")">
						<#-- Propiedad piso del vocabulario global localizacion -->
						<#elseif propertyKey == 'Floor'>
							<#assign propertiesStr = " (" + languageUtil.get(locale,propertyKey) + ": " + propertyValue + ")" >
						<#--Propiedad color asociado a la categoria del vocabulario local campusa -->
						<#elseif propertyKey == 'category-color'>
							<#assign propertiesStr = propertyValue>
						</#if>
					</#if>
					<#assign propertyValue = ''>
				</#if>
			</#if>
	</#list>
	<#return>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Lista de categoria/s seleccionada/s
 #	- Seleccionar cualquier categoria supone su aparicion en la lista de
 # categorias seleccionadas.
 # Parametros:
 #	vocabularyName		Nombre del vocabulario
 # Salida:
 #	categoriesListStr	Cadena de texto de salida
 # ------------------------------------------------------------------------------
-->
<#macro formatVocabularyCategoriesProperties vocabularyName >
	<#assign catLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService") >
	<#assign assetCategPropLocService = serviceLocator.findService("com.liferay.asset.category.property.service.AssetCategoryPropertyLocalService") >
	<#assign vocabularyLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService") >
	<#assign journalLocalService	= serviceLocator.findService( "com.liferay.journal.service.JournalArticleLocalService" ) >
	<#assign groupService	= serviceLocator.findService( "com.liferay.portal.kernel.service.GroupLocalService") >

	<#if themeDisplay?? >
		<#assign scopeId = themeDisplay.scopeGroupId>
	</#if>
	<#assign globalGroupId = getterUtil.getLong(company.getGroup().getGroupId())>
	<#if journalLocalService?? >
		<#assign contentId = .vars['reserved-article-id'].data>
		<#if journalLocalService.fetchArticle(getterUtil.getLong(scopeId), contentId)??>
			<#assign articlePrimKey = journalLocalService.getArticle(getterUtil.getLong(scopeId), contentId).resourcePrimKey>
		</#if>
	</#if>
	<#if catLocalService?? && catLocalService.getCategories??>
		<#assign articleCategories = catLocalService.getCategories("com.liferay.journal.model.JournalArticle", getterUtil.getLong(articlePrimKey))>
	</#if>
	<#assign initListStr = "<ul>">
	<#assign initItemListStr = "<li>">
	<#assign endtItemListStr = "</li>">
	<#assign endListStr = "</ul>">
	<#assign categoriesListStr = initListStr>

	<#assign campusaVocabularyName = "Campusa">
	<#assign propertiesCampusaDefaultStr = 'FFF'>
	<#if articleCategories?? >
		<#list articleCategories as category>
			<#assign vocabulary = vocabularyLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
			<#assign categoryId = category.getCategoryId()>
			<#assign parentCategId = category.getParentCategoryId()>

			<#-- Comprobamos si estamos en Campusa -->
			<#assign is_isCampusa = themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-campusa-theme">

			<#-- Si es el vocabulario local de campusa -->
			<#if vocabulary.getGroupId() != globalGroupId &&
				  vocabulary.getName() == vocabularyName && is_isCampusa >
				<#assign propertiesCampusaStr = ''>
				<#-- Array con la unica propiedad (color de la categoria) del vocabulario campusa -->
				<#assign propertiesCampusaArr = ['category-color']>

				<#if categoryId?has_content && propertiesCampusaArr?has_content>
					<@formatCategoryProperties categoryId=categoryId propertiesArr=propertiesCampusaArr />
					<#assign propertiesCampusaStr = propertiesStr >
				</#if>

				<#-- Si la categoria campusa tiene color asociado DIFERENTE al por defecto se muestra -->
				<#if propertiesCampusaStr != propertiesCampusaDefaultStr>
					<#assign categoriesListStr = categoriesListStr + initItemListStr + '<span class="c' + propertiesCampusaStr + '">' + category.getTitle(locale) + '</span>' + endtItemListStr>
				</#if>

			<#-- Si es un vocabulario global -->
			<#elseif vocabulary.getGroupId() == globalGroupId &&
					vocabulary.getName() == vocabularyName>

				<#assign categoriesListStr = categoriesListStr + initItemListStr>
				<#-- Si la categoria tiene categoria padre -->
				<#if !validator.isNull(parentCategId)>
					<#assign parentCateg = catLocalService.getAssetCategory(parentCategId)>
					<#assign grandParentCategId = parentCateg.getParentCategoryId()>

					<#-- Si la categoria padre NO tiene categoria padre, la categoria seleccionada es de segundo nivel de vocabulario -->
					<#if validator.isNull(grandParentCategId)>
						<#assign categoriesListStr = categoriesListStr + category.getTitle(locale) + " - " + parentCateg.getTitle(locale)>
					<#else>
						<#assign grandParentCateg = catLocalService.getAssetCategory(grandParentCategId)>
						<#assign greatGrandParentCategId = grandParentCateg.getParentCategoryId()>

						<#-- Si la categoria abuelo NO tiene categoria padre, la categoria seleccionada es de tercer nivel de vocabulario -->
						<#if validator.isNull(greatGrandParentCategId)>
							<#assign propertiesThirdLevelStr = ''>
							<#-- Array de propiedades de las categorias de 3er nivel -->
							<#assign propertiesThirdLevelArr = ['Address','PostalCode']>
							<#if categoryId?has_content && propertiesThirdLevelArr?has_content>
								<@formatCategoryProperties categoryId=categoryId propertiesArr=propertiesThirdLevelArr />
								<#assign propertiesThirdLevelStr = propertiesStr >
							</#if>
							<#if propertiesThirdLevelStr?has_content >
								<#assign categoriesListStr = categoriesListStr + category.getTitle(locale) + propertiesThirdLevelStr + " - " + parentCateg.getTitle(locale) + " - " + grandParentCateg.getTitle(locale)>
							<#else>
								<#assign categoriesListStr = categoriesListStr + category.getTitle(locale) + " - " + parentCateg.getTitle(locale) + " - " + grandParentCateg.getTitle(locale)>
							</#if>
							<#-- Si la categoria abuelo tiene categoria padre, la categoria seleccionada es de cuarto nivel de vocabulario -->
						<#else>
							<#assign greatGrandParentCateg = catLocalService.getAssetCategory(greatGrandParentCategId)>
							<#assign propertiesThirdLevelStr = ''>
							<#-- Array de propiedades de las categorias de 3er nivel -->
							<#assign propertiesThirdLevelArr = ['Address','PostalCode']>
							<#if parentCategId?has_content && propertiesThirdLevelArr?has_content>
								<@formatCategoryProperties categoryId=parentCategId propertiesArr=propertiesThirdLevelArr />
								<#assign propertiesThirdLevelStr = propertiesStr>
							</#if>

							<#if propertiesThirdLevelStr?has_content>
								<#assign categoriesListThirdLevelStr = parentCateg.getTitle(locale) + propertiesThirdLevelStr>
							<#else>
								<#assign categoriesListThirdLevelStr = parentCateg.getTitle(locale)>
							</#if>
							<#assign propertiesFourthLevelStr = ''>
							<#-- Array de propiedades de las categorias de 4. nivel -->
							<#assign propertiesFourthLevelArr = ['Floor']>
							<#if categoryId?has_content && propertiesFourthLevelArr?has_content>
								<@formatCategoryProperties categoryId=categoryId propertiesArr=propertiesFourthLevelArr />
								<#assign propertiesFourthLevelStr = propertiesStr>
							</#if>

							<#if propertiesFourthLevelStr?has_content >
								<#assign categoriesListFourthLevelStr = category.getTitle(locale) + propertiesFourthLevelStr>
							<#else>
								<#assign categoriesListFourthLevelStr = category.getTitle(locale)>
							</#if>
							<#assign categoriesListStr = categoriesListStr + categoriesListFourthLevelStr + " - " + categoriesListThirdLevelStr + " - " + grandParentCateg.getTitle(locale) + " - " + greatGrandParentCateg.getTitle(locale)>
						</#if> <#-- validator.isNull(greatGrandParentCategId) -->
					</#if> <#-- validator.isNull(grandParentCategId) -->
				</#if> <#-- !validator.isNull(parentCategId) -->

				<#assign categoriesListStr = categoriesListStr + endtItemListStr>
			</#if>
		</#list>
	</#if>
	<#assign categoriesListStr = categoriesListStr + endListStr>
	<#return>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Realiza el paragrafeado html de "texto", es decir, encierra "texto" dentro
 # de un bloque o paragrafo identificado por "paragrafo"
-->
<#macro htmlParagraph texto paragrafo comprueba >
	<#if !paragrafo?has_content>
		<#assign paragrafeado = texto >
	<#else>
		<#assign tagIni = "<" + paragrafo + ">" >
		<#assign tagFin = "</" + paragrafo + ">" >
		<#if !texto?has_content>
			<#assign paragrafeado = tagIni + tagFin >
		<#else>
			<#if !(comprueba?boolean) >
				<#assign paragrafeado = tagIni + texto + tagFin >
			<#else>
				<#if texto?has_content>
					<@HtmlGetHeaderType txtHtml=texto/>
					<#assign parType = hght_type >
				<#else>
					<#assign parType = "" >
				</#if>
				<#if paragrafo == parType >
					<#assign paragrafeado = texto >
				<#else>
					<#assign paragrafeado = tagIni + texto >
				</#if>
				<#if !texto?ends_with(tagFin ) >
					<#assign paragrafeado = paragrafeado + tagFin >
				</#if>
			</#if>
		</#if>
	</#if>
	<#return>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # macro utilizada en el contenido "outstanding / destacado".
 # Se encarga de formatear los enlaces en base a su titulo, su referencia y su
 # target
 # ------------------------------------------------------------------------------
-->
<#macro hrefOptions new_tab link_title href_title href_target >
	<#if new_tab >
		<#assign href_target = "_blank" >
		<#assign hrefOptions_txt_link = languageUtil.get(locale, "opens-new-window" )>
	<#else>
		<#assign href_target = "_self" >
		<#assign hrefOptions_txt_link = "" >
	</#if>

	<#if link_title?has_content>
		<#assign href_title = link_title>
		<#assign href_title += hrefOptions_txt_link>
	<#else>
		<#assign href_title = hrefOptions_txt_link >
	</#if>
	<#return>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Visualiza el apartado de documentos
 # Parametros:
 #	documentsField		campo de tipo document-library. Puede ser repetible o no
 #	documentTitleField	campo de tipo texto para indicar el nombre descriptivo
 #						asociado a un documento
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro documentSection documentsField documentTitleField>
	<#local themeIsGlobal = themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme"> 
	<#if !themeIsGlobal >
		<p><strong><@liferay.language key="documents" /></strong></p>
		<#local iTag = "" >
	<#else>
		<#if documentsField.getSiblings()?size gt 1>
			<h2><@liferay.language key="documents" /></h2>
		<#else>
			<h2><@liferay.language key="document" /></h2>
		</#if>
		
		<#local iTag = '<i class="icon-file-alt"></i>' >
	</#if>
	<ul>
		<#list documentsField.getSiblings() as document >
			<#if document.getData()?has_content >
				<li>
					${ iTag }
					<@formatAttachment documentField=document documentTitleField=documentTitleField />
					<#assign formatedDocument = formatedDocument >
					${ formatedDocument }
				</li>
			</#if>
		</#list>
	</ul>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # A partir de la informacion recibida en los parametros, genera el codigo html
 # asociado a la parte download de una imagen que forma parte de una galeria de
 # imagenes.
 # El parametro "urlImage" es una url con la informacion de acceso a la imagen.
 # Si se pasa el parametro "__urlImageAlt" se utilizara para ponerlo como texto
 # alternativo asociado a la imagen en el html generado.
 # Si se pasa el parametro "__fileEntry", y no es null, se utilizara como objeto
 # FileEntry base para obtener la informacion sobre la imagen. En caso contrario
 # la macro debe obtener el objeto FileEntry utilizando la url de entrada.
 # Parametros:
 #	urlImage		url con la informacion de acceso a la imagen
 #	[__fileEntry]	objeto FileEntry con informacion sobre la imagen
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro imageGalleryDownloadSection urlImage  fileEntry >
	<#local cFileSizeFormat		= "#,##0.00" >
	<#local cUrlFileImgDownload	= "/o/ehu-theme/images/common/download.png" >
	<#local cUrlDirecPosUuid	= 5 >
	<#local cUrlDirecPosGrId	= 2 >


	<#if fileEntry??>
		<#local imgFileEntry = fileEntry >
	<#else>
		<p> ${urlImage} </p>
		<#local imgFileEntry = null >
		<#if imgFileEntry??  || imgFileEntry == "null">
			<#return>
		</#if>
	</#if>

	<#local imageId = imgFileEntry.getFileEntryId() >
	<#local imageVersion = imgFileEntry.getVersion() >
	<#local imageType = imgFileEntry.getExtension() >
	<#local imageSize = imgFileEntry.getSize() >
	<#local reSize = imageSize / 1024.0 >
	<#if ( reSize > 1024 ) >
		<#local reSize = reSize / 1024.0 >
		<#local fileSizeType = "Mb" >
		<#local entLangFileSizeType = "ehu.ext.Mb" >
	<#else>
		<#local fileSizeType = "Kb" >
		<#local entLangFileSizeType = "ehu.ext.Kb" >
	</#if>
	<#local fileSizeTypeText = languageUtil.get( locale, entLangFileSizeType ) >
	<#local fileSize = reSize?string( cFileSizeFormat ) >
	<#local altTxt = languageUtil.get( locale, "ehu.file-to-download" ) >
	

	<#local classId = "_downloadImage_" + imageId >
	<#local tagHtml =
		'<a class="taglib-icon" href="' + urlImage + '&amp;' + 'version=' + imageVersion + '&amp;' + 'download=true">' +
			'<img class="icon" src="' + cUrlFileImgDownload + '" alt="' + altTxt + '">' +
			'<span class="taglib-text"> ' + languageUtil.get( locale, 'ehu.file-download' ) +
				'(' + imageType + ', ' + fileSize + '<abbr title="' + fileSizeTypeText + '">' + fileSizeType + '</abbr>)' +
			'</span>' +
		'</a>' >

	<div class="aui-helper-hidden hide" id="${ classId }">
		<div class="buttons-container float-container">
			<span>${ tagHtml }</span>
		</div>
	</div>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # A partir de la informacion recibida en el parametro "slides" genera el codigo
 # para visualizar dicha informacion como una galeria de imagenes.
 # Si se pasa una cadena de identificacion en el parametro "__ident", y esa
 # cadena no es vacia, personaliza el cogido generado con dicho identificador.
 # Lo normal seria que fuera el identificador de articulo que llama a esta macro
 # (articleId), de manera que se puedan visualizar de forma correcta, para una
 # misma pagina, varias galerias de imagenes de diferentes contenidos, aunque
 # puede darse el caso de que en un mismo contenido puedan generarse varias
 # galerías de imágenes, como es el caso del Timeline.
 # Si no se pasa dicho parametro, se coge el articleId de articulo que llama a
 # esta macro para personalizar el codigo que se genera.
 # Con el parametro "__showFoot" se marca si el pie de las imagenes se va a
 # mostrar o no. Por defecto, se muestra.
 # El parametro "__elemsRow" sirve para definir el numero de imagenes que se
 # quieren mostrar por linea. Por defecto se muestran 4.
 # Parametros:
 #	slides			estructura con la informacion para la galeria de imagenes
 #	[__ident]		identificador para personalizar el codigo que se genera
 #	[__showFoot]	indica si se quiere mostrar el pie de las imagenes o no
 #	[__elemsRow]	indica el numero de imagenes a mostrar por linea
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro imageGallerySection slides	__ident	 __showFoot __elemsRow>
	<#if !(slides??)>					<#return> </#if>

	<#local arrSlides = slides.getSiblings() >
	<#if ( arrSlides?size <= 0 ) >					<#return> </#if>
	<#if !arrSlides[ 0 ].ehuimagegalleryimage?? >	<#return> </#if>

	<#local firstImage = arrSlides[ 0 ].ehuimagegalleryimage.getData() >
	<#if firstImage == "" >				<#return> </#if>

	<#-- La primera diapositiva tiene una imagen -->
	<#if  __ident?? || __ident?has_content>
		<#if __ident?is_hash >
			<#local ident = __ident.getData() >
		<#else>
			<#local ident = getterUtil.getString(__ident) >
		</#if>
	<#else>
		<#assign scopeId = themeDisplay.scopeGroupId>
		<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
		<#assign ident = journalLocalService.getArticle(scopeId, .vars['reserved-article-id'].data).articleId > 
	</#if>
	<#local showFoot = getterUtil.getBoolean( __showFoot, true ) >
	<#local elemsRow = getterUtil.getInteger( __elemsRow, 4 ) >
	<#local themeIsGlobal =  (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
	<#local themeIsCampusa =  (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-campusa-theme") >

	<div class="image-gallery">
		<#if !themeIsGlobal >
			<header id="image-gallery-title">
				<h2><span class="icon-camera"></span><@liferay.language key="ehu.image-gallery" /></h2>
			</header>
		<#else>
			<h2><@liferay.language key="ehu.image-gallery" /></h2>
		</#if>
		<#local myGalleryId = "myGallery" >
		<#local thumbnailLink = "image-thumbnail" >
		<#local thumbnailId = thumbnailLink + "_" + ident >
		<#if ident != ""  >
			<#local myGalleryId = myGalleryId + "_" + ident >
			<#local thumbnailLink = "a." + thumbnailId >
		<#else>
			<#local thumbnailLink = "a." + thumbnailLink >
		</#if>
		<#if themeIsCampusa>
			<div id="${ myGalleryId }" class="gallery_images">
		<#else>
			<div id="${ myGalleryId }">
		</#if>
		
			<#local cont = 0 >
			<#if arrSlides?? && (arrSlides?size >= 1)>
				<ul class="row">
			</#if>
			<#list arrSlides as slide >
				<#if !slide.ehuimagegalleryimage?? >	<#continue> </#if>
				<#local elemItemImage = slide.ehuimagegalleryimage >
				<#local url = elemItemImage.getData() >
				<#if url == "" >			<#continue> </#if>

				<#local imageAltText = "">
				<#local imageFootText = "" >
				<#if elemItemImage.ehuimagegalleryimagealttext?? >
					<#local imageAltText = getterUtil.getString( elemItemImage.ehuimagegalleryimagealttext.getData(), "" ) >
				</#if>
				<#if imageAltText == "" >
					<#local imageAltText = languageUtil.get( locale, "image" ) >
				</#if>
				<#if slide.ehuimagegalleryimagefoottext?? >
					<#local imageFootText = getterUtil.getString( slide.ehuimagegalleryimagefoottext.getData(), "" ) >
				</#if>
				
				<#assign dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")>
				<#local arrayUrl = url?split("/")>
				<#local strGroup = arrayUrl[2] >
				<#local arrayUuid = arrayUrl[5]?split("?")>
				<#local uuid = arrayUuid[0]>
				<#assign grpId = strGroup?number >
				<#local imgFile = dLFileEntryLocalService.getFileEntryByUuidAndGroupId( uuid, grpId ) >

				
				<#if imgFile??>
					<#local largeImage = ' data-largeimageid="${ imgFile.getFileEntryId() }"' >
				<#else>
					<#local largeImage = "" >
				</#if>

				<#local showDiv = ( cont % elemsRow == 0 ) && !themeIsCampusa>
				<#if showDiv >
					<#if ( cont > 0 )  >
						<#-- cierra el div row anterior -->
						</div>
					</#if>
					
						<div class="row">
	
				</#if>

				<#if themeIsGlobal >
					<#local class = "image-thumbnail" >
				<#elseif themeIsCampusa>
					<#local class = "image-thumbnail aui-image-viewer-link" >
				<#else>
					<#local class = "image-thumbnail aui-image-viewer-link span2" >
				</#if>
				<#if showFoot >
					<#local figCaption = "<figcaption>" + imageFootText + "</figcaption>">
				<#else>
					<#local figCaption = "" >
				</#if>
				<#if themeIsCampusa>
					<li class="col-12 col-sm-6 col-md-3 col-lg-2">
				</#if>
				<a id="${ thumbnailId }_${slide?index}" class="${ class } ${ thumbnailId }" href="${ url }" title="${ imageFootText }"${ largeImage }>
					<figure>
						<img id="img-${ thumbnailId }_${slide?index}" src="${ url }" alt="${ imageAltText }"/>
						${ figCaption }
					</figure>
				</a>
				<#if themeIsCampusa>
					<@upvlibs.imageGalleryDownloadSection url imgFile />
					</li>
				<#else>
					<@upvlibs.imageGalleryDownloadSection url imgFile />
				</#if>
				
				<#local cont = cont + 1 >
			</#list>
			<#if ( cont > 0 ) > <#-- cierra el ultimo div row -->
				<#if themeIsCampusa>
					</ul>
				<#else>
					</div>
				</#if>
			</#if>
		</div> <#-- myGallery -->
	</div> <#-- image-gallery -->
	<#if ident != "" >
		<@AUIImageViewer myGalleryId thumbnailLink />
	</#if>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Visualiza una imagen segun los parametros recibidos. Realiza el tratamiento
 # con la autoria de la imagen (parametro "imageAuthor).
 # Parametros:
 #	image				imagen a visualizar
 #	altText				texto alternativo de la imagen
 #	footText			texto del pie
 #	imageAuthor			autoria de la foto
 #	imageDisposition	alineacion de la imagen
 #	imageUrl			direccion asociada a la imagen
 #	imageUrlTitle		titulo de la direccion asociada a la imagen
 #	imageUrlNewTab		para abrir en nueva ventana la direccion asociada
 #	imgClass			clase (o clases) asociadas al tag img que se crea
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro imageAuthorSection image altText footText imageAuthor imageDisposition elemImageUrl imageUrlTitle imageUrlNewTab imgClass >
	<#-- Comprobamos si estamos en Campusa -->
	<#assign is_isCampusa = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-campusa-theme")>

	<#if validator.isNotNull(image) && !validator.isBlank(image) >

		<#if elemImageUrl?has_content>
			<#assign imageUrl = elemImageUrl.getData()!"">
			<#-- Si la URL no es vacia -->
			<#if !validator.isBlank(imageUrl)>
				<#assign formatedURL = ''>
				<#if elemImageUrl?is_hash >
					<#assign aux = elemImageUrl.getData() >
				<#else>
					<#assign aux = getterUtil.getString(elemImageUrl) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign formatedURL = aux>
				</#if>
				

				<#-- Si la URL introducida es valida -->
				
				<#if imageUrlTitle?has_content>
					<#assign title = imageUrlTitle>
				<#else>
					<#assign title = "">
				</#if>

				<#if imageUrlNewTab>
					<#-- Por accesibilidad si el title es vacío no debe pintarse nada, ni siquiera title -->
					<#if !(title == "")>
						<a href="${formatedURL}" target="_blank" title="${title}" >
						<span class="hide-accessible">${languageUtil.get(locale, 'opens-new-window')}</span>
					<#else>
						<a href="${formatedURL}" target="_blank" >
						<span class="hide-accessible">${languageUtil.get(locale, 'opens-new-window')}</span>
					</#if>
				<#else>
					<#-- Por accesibilidad si el title es vacío no debe pintarse nada, ni siquiera title -->
					<#if !(title == "")>
						<a href="${formatedURL}" title="${title}">
					<#else>
						<a href="${formatedURL}">
					</#if>
				</#if>
			
			</#if>
 		</#if>

		<#-- Si estamos en Campusa no hay que poner span4 -->
		<#if !is_isCampusa && (imageDisposition == "right" || imageDisposition == "left" )>
			<figure class="${imageDisposition} span4">
		<#else>
			<figure class="${imageDisposition}">
		</#if>

		<#assign alt = ' '>
		<#if altText?has_content >
			<#assign alt = altText>
		</#if>
		<#if validator.isNull( imgClass )>
			<img src="${image}" alt="${alt}" />
		<#else>
			<img class="${imgClass}" src="${image}" alt="${alt}" />
		</#if>

		<#if footText != "" || imageAuthor != ""  >
			<#if footText = "" >
				<#assign txtPhoto = "">
			<#else>
				<#assign txtPhoto = footText >
			</#if>

			<#if imageAuthor != "" >
				<#if footText != "" >
					<#assign txtPhoto = txtPhoto + " | " +	 languageUtil.get( locale, "ehu.photo" ) + ": " + imageAuthor >
				<#else>
					<#assign txtPhoto = languageUtil.get( locale, "ehu.photo" ) + ": " + imageAuthor >
				</#if>
			</#if>
			<figcaption>${txtPhoto}</figcaption>
		</#if>

	</figure>

		<#-- Si la URL no es vacia -->
		<#if imageUrl?has_content >	
			</a>
		</#if>
	</#if>
</#macro>

<#-- Macro para la nueva galeria de imagenes con carousel -->

<#macro imageGallerySectionCarousel	slides __ident __showFoot __elemsRow>
	<#if !(slides??) >					<#return> </#if>

	<#local arrSlides = slides.getSiblings() >
    <#local arrSlidesSize = arrSlides?size >
	<#if (  arrSlidesSize <= 0 ) >					<#return> </#if>
	<#if !arrSlides[ 0 ].ehuimagegalleryimage?? >	<#return> </#if>

	<#local firstImage = arrSlides[ 0 ].ehuimagegalleryimage.getData() >
	<#if firstImage == "" >				<#return> </#if>

	<#-- La primera diapositiva tiene una imagen -->
	<#if  __ident??>
		<#if __ident?is_hash >
			<#local ident = __ident.getData() >
		<#else>
			<#local ident = getterUtil.getString(__ident) >
		</#if>
		
	<#else>
		<#assign scopeId = themeDisplay.scopeGroupId>
		<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
		<#local ident = journalLocalService.getArticle(scopeId, .vars['reserved-article-id'].data).articleId > 
	</#if>
	<#local showFoot = getterUtil.getBoolean( __showFoot, true ) >
	<#local elemsRow = getterUtil.getInteger( __elemsRow, 4 ) >
	<#local themeIsGlobal =  (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme")>
		<#local myGalleryId = "myGallery" >
		<#local thumbnailLink = "image-thumbnail" >
		<#local thumbnailId = thumbnailLink + "_" + ident >
		<#if ident != "" >
			<#local myGalleryId = myGalleryId + "_" + ident >
			<#local thumbnailLink = "a." + thumbnailId >
		<#else>
			<#local thumbnailLink = "a." + thumbnailLink >
		</#if>
		<div id="${ myGalleryId }">
			<#local cont = 0 >

            <#assign indicatorId = stringUtil.randomString() />
            <div id="image-gallery-carousel_${indicatorId}" class="carousel slide" data-ride="carousel" data-touch="true" data-interval="false">
                <#if arrSlidesSize gt 1>
                	<input type="hidden" class="showing-image" value='<@liferay.language key="showing" /> <@liferay.language key="image" />'/>
                    <ol class="carousel-indicators">
                    	<#if arrSlidesSize gt 3>
                    		<#local numberIndicators = 2 />
                    	<#else>
                    		<#local numberIndicators = arrSlidesSize-1 />
                    	</#if>
                        <#list 0..numberIndicators as i>
                            <#assign activeIndicator = "" />
                            <#if i?is_first>
                                <#assign activeIndicator = "active" />
                            </#if>
                                <li tabindex="0" data-target="#image-gallery-carousel_${indicatorId}" data-slide-to="${i}"  class="${activeIndicator}"><span class="hide-accesible"><span class="img-showing"></span>${arrSlides[i].ehuimagegalleryimagefoottext.getData()}</span></li>
                        </#list>
                        <#if arrSlidesSize gt 3>
                        	<li tabindex="0" id="${thumbnailId}_liShowMore" onClick="javascript:showMore();" class="btn-carousel-showmore">
								<script>
									function showMore() {
										$("#${myGalleryId} .carousel-item.active a")[0].click();
									}
									$(document).ready(function(){
										$("#${myGalleryId} .carousel-indicators").keyup(function(){
											if($("#${thumbnailId}_liShowMore").hasClass("active")){
												showMore();
											}
										});
                    				});
								</script>
								<span class="hide-accesible"><@liferay.language key="ehu.galeria-carousel.mostrar-todas" /></span>
							</li>
						</#if>
                    </ol>
                </#if>
                <div class="carousel-inner">

                    <#list arrSlides as slide >
                        <#if !slide.ehuimagegalleryimage?? >	<#continue> </#if>
                        <#local elemItemImage = slide.ehuimagegalleryimage >
                        <#local url = elemItemImage.getData() >
                        <#if url == "" >			<#continue> </#if>

                        <#local imageAltText = "" >
                        <#local imageFootText = "" >
                        <#if elemItemImage.ehuimagegalleryimagealttext?? >
                            <#local imageAltText = getterUtil.getString( elemItemImage.ehuimagegalleryimagealttext.getData(), "" ) >
                        </#if>
                        <#if imageAltText == "" >
                            <#local imageAltText = languageUtil.get( locale, "image" ) >
                        </#if>
                        <#if slide.ehuimagegalleryimagefoottext?? >
                            <#local imageFootText = getterUtil.getString( slide.ehuimagegalleryimagefoottext.getData(), "" ) >
                        </#if>
                    
                        <#assign dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")>
						<#local arrayUrl = url?split("/")>
						<#local strGroup = arrayUrl[2] >
						<#local arrayUuid = arrayUrl[5]?split("?")>
						<#local uuid = arrayUuid[0]>
						<#assign grpId = strGroup?number >
						<#local imgFile = dLFileEntryLocalService.getFileEntryByUuidAndGroupId( uuid, grpId ) >
                        <#if  imgFile?? >
                            <#local largeImage = ' data-largeimageid="${ imgFile.getFileEntryId() }"' >
                        <#else>
                            <#local largeImage = "" >
                        </#if>

                        <#if themeIsGlobal >
							<#local class = "image-thumbnail" >
						<#else>
							<#local class = "image-thumbnail aui-image-viewer-link span2" >
						</#if>	
                        
						<#if showFoot >
							<#local figCaption = "<figcaption>" + imageFootText + "</figcaption>" >
						<#else>
							<#local figCaption = "" >
						</#if>	
                            <#assign activeItem = "" />
                            <#if slide?is_first>
                                <#assign activeItem = "active" />
                            </#if>
                            <#if slide?index lte 3>
                            	<div class="carousel-item ${activeItem}">
                            </#if>
                            <#if slide?index gt 3>
                            	 <#local class = class + " d-none" >
                            </#if>
                                <a id="${thumbnailId}_${slide?index}" href="${url}" class="${class} ${thumbnailId} image-gallery-carousel__listbox-button" title="${ imageFootText }" ${largeImage}>
                          			<i class="icon-fullscreen"></i>
                                    <img id="img-${thumbnailId}_${slide?index}" src="${url}" alt="${imageAltText}"/>
                                </a>
                            <#if slide?index lt 3>		    
                            	</div>
                            </#if>
                        	<@upvlibs.imageGalleryDownloadSection url imgFile />
                        <#local cont = cont + 1 >
                    </#list>

                </div>
            </div>
		</div> <#-- myGallery -->

	<#if ident != "" >
		<@AUIImageViewer myGalleryId thumbnailLink />
	</#if>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Visualiza el apartado de enlaces
 # Parametros:
 #	linksField			campo de tipo texto para indicar URLs. Puede ser
 #						repetible o no
 #	linkNewTabField		campo de tipo check para indicar si URL a la que esta
 #						asociado se abre en nueva ventana
 #	linkTitleField		campo de tipo texto para indicar el nombre descriptivo
 #						asociado a la URL
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro linkSection linksField linkNewTabField linkTitleField>
	

	<#local themeIsGlobal =  (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
	<#if !themeIsGlobal >
		<p><strong><@liferay.language key="links" /></strong></p>
		<#local iTag = "" >
	<#else>
		<#if linksField.getSiblings()?size gt 1>
			<h2><@liferay.language key="ehu.web-addresses" /></h2>
		<#else>
			<h2><@liferay.language key="ehu.web-address" /></h2>
		</#if>
        
		<#local iTag = '<i class="icon-link"></i>' >
	</#if>

	<ul>
		<#list linksField.getSiblings() as elemLink >
			<#local urlFormated = "" >
			<#if elemLink?is_hash >
				<#local aux = elemLink.getData() >
			<#else>
				<#local aux = getterUtil.getString(elemLink) >
			</#if>
			<#if aux?has_content && aux != "">
				<#local urlFormated = aux>
			</#if>
		
			
			

			<li>
				${ iTag }
				<#local new_tab = false >
				<#local link_title = urlFormated >
				<#if elemLink.containsKey( linkTitleField ) >
					<#local linkItem = elemLink.get( linkTitleField ) >
					<#if linkItem?? >
						<#local link = linkItem.getData() >
						<#if  link != "" >
							<#local link_title = link >
						</#if>
					</#if>
				</#if>

				<#if elemLink.containsKey( linkNewTabField ) >
					<#local linkItem = elemLink.get( linkNewTabField ) >
					<#if linkItem?? >
						<#local new_tab = getterUtil.getBoolean( linkItem.getData(), false ) >
					</#if>
				</#if>

				<#if new_tab >
					<a href="${ urlFormated }" target="_blank">
						<span class="hide-accessible">${ languageUtil.get( locale, 'opens-new-window' ) }</span>
				<#else>
					<a href="${urlFormated}">
				</#if>
						${link_title}
					</a>

				<#if !themeIsGlobal >
					<#if new_tab >
						<span class="icon-external-link"></span>
					</#if>
				</#if>
			</li>
		</#list>
	</ul>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # A partir del contenido del campo "field" existente en una estructura, que
 # debe ser de tipo date, genera una cadena con su valor en el formato
 # "dateFormat".
 # Si el campo es vacio, se genera la cadena vacia.
 # Parametros:
 #	field		campo, de tipo fecha, dentro de una estructura de contenido
 #	dateFormat		formato en el que generar la fecha
 #	llocale			locale
 # Salida:
 #	fDate		fecha correspondiente al campo, en el formato deseado
 # ------------------------------------------------------------------------------
-->
<#macro getFormatedDate field dateFormat llocale >
		<#assign fieldContent = field.getData()>
		<#if !fieldContent?has_content >
			<#assign fDate = "" >
		<#else>
			<#setting date_format=dateFormat>
			<#setting locale = llocale>
			<#assign modifiedDate = (fieldContent?datetime("yyyy-MM-dd"))?date>
			<#assign fDate = modifiedDate?string>
		</#if>
		<#return>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Genera el html correspondiente a la informacion contenida en el elemento
 # multivaluado "entradaInfo", considerando que dicha informacion sera de tipo
 # docs (documentos).
 # Parametros:
 #	entradaInfo		entrada para el elemento multivaluado
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) por cada
 #					subelemento
 #	nomEntradaVal	nombre de la entrada con el valor por cada subelemento
 #	nivelHIni		nivel de inicio para los posibles tag <h>
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForDocs entradaInfo nomEntradaTit nomEntradaVal nivelHIni>
	<#if entradaInfo?has_content && nomEntradaTit?has_content && nomEntradaVal?? && nivelHIni?? >
		<@writeHtmlForEntrada tipo=1 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTit cabDefecto="" nomEntradaVal=nomEntradaVal entLangTitGenSing="document" entLangTitGenPlu="" nivelHIni=nivelHIni nomEntrNewTab="" newTab=""/>
	</#if>

</#macro>


<#macro writeHtmlForEntrada tipo class entradaInfo nomEntradaTit cabDefecto nomEntradaVal
	entLangTitGenSing entLangTitGenPlu nivelHIni nomEntrNewTab newTab >
	<#assign local_class = "" >
	<#if !class?has_content >
		<#if tipo??>
			<#if tipo == 1 >
				<#assign local_class = "documents" >
			<#elseif tipo == 2 >
				<#assign local_class = "fax" >
			<#elseif tipo == 3 >
				<#assign local_class = "links" >
			<#elseif tipo == 4 >
				<#assign local_class = "mails" >
			<#elseif tipo == 5 >
				<#assign local_class = "phones" >
			<#elseif tipo == 6 >
				<#assign local_class = "webs" >
			</#if>
		</#if>
	<#else>
		<#assign local_class = class >
	</#if>
	<#if tipo?has_content>
		<#if tipo == 2 || tipo == 4 || tipo == 5 || tipo == 6 >		
			<#assign isContact = true >
		<#else>
			<#assign isContact = false >
		</#if>

	</#if>

	<#if isContact >
		<#assign local_class = "method " + local_class >
	</#if>

	<div class="${local_class}">
		<#if entradaInfo?has_content && nomEntradaVal??>
			<#assign numElems = entradaInfo.getSiblings()?size >
		<#else>
			<#assign numElems = 0 >
		</#if>

		<#if numElems?has_content && (numElems > 0) >
			<#assign nivelHIni = getterUtil.getInteger(nivelHIni, 0 ) >

			 <#if nivelHIni?? && (nivelHIni > 0) >
				<#assign entLangTituloGen = entLangTitGenSing >
				<#if ((numElems > 1)?c)?boolean >
					<#if entLangTitGenPlu?has_content >
						<#assign entLangTituloGen = entLangTitGenPlu >
					<#else>
						<#assign entLangTituloGen = entLangTituloGen + "s" >
					</#if>
				</#if>

				<#assign tagHIni = "h" + nivelHIni >
				<#if entLangTituloGen?has_content && tagHIni?has_content >
					
					<#assign auxtagIni = "<" + tagHIni + ">" >
					<#assign auxtagFin = "</" + tagHIni + ">" >
					<#assign paragrafeado = auxtagIni + languageUtil.get(locale, entLangTituloGen ) + auxtagFin >
					<#assign titulo = paragrafeado >
				</#if>

				${titulo}
			</#if>
			<ul>
				<#assign arrInfo = entradaInfo.getSiblings() >
				<#assign count = 0>
				<#list arrInfo as info >

					<#assign count = count + 1 >
						<#if tipo == 3 >
							<#-- <#if info?has_content && cabDefecto?? && nomEntradaTit?has_content && nomEntradaVal?? && nomEntrNewTab?has_content && newTab?has_content> -->	
							<#if info?has_content && cabDefecto?? && nomEntradaTit?has_content && nomEntrNewTab?has_content && newTab?has_content>
								<@writeHtmlForWebPage entWebPage=info cab=cabDefecto nomEntradaTxt=nomEntradaTit nomEntradaVal=nomEntradaVal nomEntrNewTab=nomEntrNewTab newTab=newTab/>
							</#if>							
						<#elseif tipo == 6 >
							<#-- <#if info?has_content && cabDefecto?? && nomEntradaTit?has_content && nomEntradaVal?? && nomEntrNewTab?has_content && newTab?has_content>  -->
							<#if info?has_content && cabDefecto?? && nomEntradaVal?? && nomEntrNewTab?has_content && newTab?has_content>
								<@writeHtmlForWebPage entWebPage=info cab=cabDefecto nomEntradaTxt=nomEntradaTit nomEntradaVal=nomEntradaVal nomEntrNewTab=nomEntrNewTab newTab=newTab/>
							</#if>
						<#elseif tipo == 1 >
							<#if info?has_content && cabDefecto?? && nomEntradaTit?has_content && nomEntradaTit?has_content && nomEntradaVal??>
								<@writeHtmlForDoc entInfoElem=info cab=cabDefecto nomEntradaTit=nomEntradaTit nomEntradaVal=nomEntradaVal />
							</#if>
						<#else>
								<@writeHtmlForGeneral tipo=tipo entInfoElem=info nomEntradaTit=nomEntradaTit cabDefecto=cabDefecto nomEntradaVal=nomEntradaVal/>
						</#if>
				</#list>
			</ul>
		</#if>
	</div>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Muestra el html correspondiente a la informacion contenida en el elemento
 # simple "entInfoElem".
 # Este elemento se supone que es de tipo documento.
 # Parametros:
 #	entInfoElem		entrada de informacion del elemento
 #	cab				cabecera para el elemento
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) para el
 #					elemento
 #	nomEntradaVal	nombre de la entrada con el valor para el elemento
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForDoc entInfoElem cab nomEntradaTit nomEntradaVal >
	<#if entInfoElem?is_hash>
		<#assign valor = entInfoElem.getData() >
	<#else>
		<#assign valor = getterUtil.getString(entInfoElem) >
	</#if>
		
	<#if valor?contains( "/" ) >
		<#assign formatedDoc = "" >
		<@formatAttachment documentField=entInfoElem documentTitleField=nomEntradaTit />
		<#assign formatedDoc = formatedDocument >
		<li>
			<#if cab?has_content >
				<strong>${cab}:</strong>
			</#if>
			${formatedDoc}
		</li>

	</#if>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Genera el html correspondiente a la informacion contenida en el elemento
 # multivaluado "entradaInfo", considerando que dicha informacion sera de tipo
 # docs (documentos).
 # Parametros:
 #	entradaInfo		entrada para el elemento multivaluado
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) por cada
 #					subelemento
 #	nomEntradaVal	nombre de la entrada con el valor por cada subelemento
 #	nivelHIni		nivel de inicio para los posibles tag <h>
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForFaxes entradaInfo nomEntradaTit nomEntradaVal nivelHIni >
	<@writeHtmlForEntrada tipo=2 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTit
		cabDefecto=nomEntradaTit nomEntradaVal=nomEntradaVal entLangTitGenSing="ehu.fax" entLangTitGenPlu=""
		nivelHIni=nivelHIni nomEntrNewTab="" newTab="" />
</#macro>


<#macro writeHtmlForGeneral tipo entInfoElem nomEntradaTit cabDefecto nomEntradaVal>
	<#if entInfoElem.getChild( nomEntradaVal )?? >
		<#assign entValor = entInfoElem.getChild( nomEntradaVal ) >
	<#else>
		<#assign entValor = "null" >
	</#if>	
	<#if entValor?? >
		<#if entValor?is_hash >
			<#assign valor = entValor.getData() >
		<#else>
			<#assign valor = getterUtil.getString(entValor) >
		</#if>
	</#if>
	<#if valor?? >
		<#if tipo?? && tipo == 5 >
			<#assign valorTel = valor>
			<#assign valorTel = valorTel?replace(' ', '', 'i')>
			<#assign valorTel = valorTel?replace('  ', '', 'i')>
			<#assign valorTel = valorTel?replace('.', '', 'i')>
			<#assign valorTel = valorTel?replace('-', '', 'i')>
			<#assign valorTel = valorTel?replace('/', '', 'i')>
		</#if>
		<#assign title = "">
		<#if entInfoElem?is_hash >
			<#assign title = entInfoElem.getData() >
		<#else>
			<#assign title = getterUtil.getString(entInfoElem) >
		</#if>
		<#if title == "" >
			<#assign cab = cabDefecto >
		<#else>
			<#assign cab = title >
		</#if>
		<li>
			<#if cab?has_content && cab != valor >
				<strong>${cab}:</strong>
			<#elseif cabDefecto?has_content>
				<strong>${cabDefecto}:</strong>
			</#if>
			<#-- se evita que el nombre del apartado, sea igual al valor, en este caso no se pinta nombre del apartado -->
			<#if tipo?? && tipo == 4 >
				<a href="mailto:${ valor }">${ valor }</a>
			<#elseif tipo?? && tipo == 5 >
				<a href="tel:${ valorTel }">${ valor }</a>
			<#else>
				${ valor }
			</#if>
		</li>
	</#if>

</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Muestra el html correspondiente a la informacion contenida en el elemento
 # simple "entInfoElem".
 # La informacion a mostrar varia un poco dependiendo del tipo de elemento, que
 # viene en el parametro "tipo".
 # Parametros:
 #	tipo			tipo de elemento
 #	entInfoElem		entrada de informacion del elemento
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) para el
 #					elemento
 #	cabDefecto		cabecera (titulo) por defecto para el elemento
 #	nomEntradaVal	nombre de la entrada con el valor para el elemento
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForGeneralEvento tipo entInfoElem cabDefecto>
	<#if entInfoElem?? >
		<#if entInfoElem?is_hash >
			<#assign valor = entInfoElem.getData() >
		<#else>
			<#assign valor = getterUtil.getString(entInfoElem) >
		</#if>
	</#if>
	<#if valor?? >
		<#if tipo?? && tipo == 5 >
			<#assign valorTel = valor>
			<#assign valorTel = valorTel?replace(' ', '', 'i')>
			<#assign valorTel = valorTel?replace('  ', '', 'i')>
			<#assign valorTel = valorTel?replace('.', '', 'i')>
			<#assign valorTel = valorTel?replace('-', '', 'i')>
			<#assign valorTel = valorTel?replace('/', '', 'i')>
		</#if>
		<#assign cab = cabDefecto >
		<li>
			<#if cab?has_content && cab != valor >
				<strong>${cab}:</strong>
			<#elseif cabDefecto?has_content>
				<strong>${cabDefecto}:</strong>
			</#if>
			<#-- se evita que el nombre del apartado, sea igual al valor, en este caso no se pinta nombre del apartado -->
			<#if tipo?? && tipo == 4 >
				<a href="mailto:${ valor }">${ valor }</a>
			<#elseif tipo?? && tipo == 5 >
				<a href="tel:${ valorTel }">${ valor }</a>
			<#else>
				${ valor }
			</#if>
		</li>
	</#if>

</#macro>


<#macro writeHtmlForLinks entradaInfo nomEntradaTit nomEntradaVal nivelHIni nomEntrNewTab newTab>
	<@writeHtmlForEntrada tipo=3 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTit
		cabDefecto="" nomEntradaVal=nomEntradaVal entLangTitGenSing="ehu.link" entLangTitGenPlu=""
		nivelHIni=nivelHIni nomEntrNewTab=nomEntrNewTab newTab=newTab
		/>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Genera el html correspondiente a la informacion contenida en el elemento
 # multivaluado "entradaInfo", considerando que dicha informacion sera de tipo
 # mail (correo electronico).
 # Parametros:
 #	entradaInfo		entrada para el elemento multivaluado
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) por cada
 #					subelemento
 #	nomEntradaVal	nombre de la entrada con el valor por cada subelemento
 #	nivelHIni		nivel de inicio para los posibles tag <h>
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForMails entradaInfo nomEntradaTit nomEntradaVal nivelHIni >
		<@writeHtmlForEntrada tipo=4 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTit
			cabDefecto="" nomEntradaVal=nomEntradaVal entLangTitGenSing="ehu.email" entLangTitGenPlu=""
			nivelHIni=nivelHIni nomEntrNewTab="" newTab=""/>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Genera el html correspondiente a la informacion contenida en el elemento
 # multivaluado "entradaInfo", considerando que dicha informacion sera de tipo
 # phone (telefono).
 # Parametros:
 #	entradaInfo		entrada para el elemento multivaluado
 #	nomEntradaTit	nombre de la entrada con la cabecera (titulo) por cada
 #					subelemento
 #	nomEntradaVal	nombre de la entrada con el valor por cada subelemento
 #	nivelHIni		nivel de inicio para los posibles tag <h>
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForPhones entradaInfo nomEntradaTit nomEntradaVal nivelHIni >
		 <@writeHtmlForEntrada tipo=5 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTit
			cabDefecto=nomEntradaTit nomEntradaVal=nomEntradaVal entLangTitGenSing="ehu.phone" entLangTitGenPlu=""
			nivelHIni=nivelHIni nomEntrNewTab="" newTab=""/>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Muestra el html correspondiente a la informacion contenida en el elemento
 # simple "entWebPage".
 # Este elemento se supone que es de tipo enlace a pagina web.
 # La informacion se muestra solo si el elemento contiene una url.
 # Parametros:
 #	entWebPage		entrada de informacion del elemento
 #	cab				cabecera para el elemento
 #	nomEntradaTxt	nombre de la entrada con el texto por el elemento
 #	nomEntradaVal	nombre de la entrada con el valor para el elemento
 #	nomEntrNewTab	nombre de la entrada para opcion sobre nueva pagina (web)
 #	newTab			opcion sobre nueva pagina (web)
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForWebPage entWebPage cab nomEntradaTxt nomEntradaVal nomEntrNewTab newTab >
	 
	<#if entWebPage?is_hash>
		<#assign url = entWebPage.getData() >
	<#else>
		<#assign url = getterUtil.getString(entWebPage) >
	</#if>
	
	<#--
	<#if entWebPage.ehucompanyurl?has_content >
		<#assign url = entWebPage.ehucompanyurl.getData() >		
	</#if>
	 -->

	<#if url?has_content >
		<#assign formatedURL = "" >
		
		<#if url?is_hash >
			<#assign aux = url.getData() >
		<#else>
			<#assign aux = getterUtil.getString(url) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign formatedURL = aux>
		</#if>
			
		<#assign text = "" >
		<#--
		<#if entWebPage?has_content >
			<#if entWebPage?is_hash>		
					<#assign text = entWebPage.getData() >		
			<#else>
				<#assign text = getterUtil.getString(entWebPage) >
			</#if>
		</#if>
		-->
		 
		<#if nomEntradaTxt?? && nomEntradaTxt?has_content >
			<#if entWebPage.getChild( nomEntradaTxt )?? >
				<#assign entEntradaTxt = entWebPage.getChild( nomEntradaTxt ) >
			<#else>
				<#assign entEntradaTxt = "null" >
			</#if>	
			<#if entEntradaTxt?is_hash>
				<#assign text = entEntradaTxt.getData() >
			<#else>
				<#assign text = getterUtil.getString(entEntradaTxt) >
			</#if>
		</#if>
		 
		 
		<#if text == "">
			<#assign text = formatedURL>
		</#if>	
		<li>
			<#if cab?has_content >
				<strong>${cab}:</strong>
			</#if>
	
					
			<#if entWebPage?has_content && nomEntrNewTab??>
				<#if entWebPage.getChild( nomEntrNewTab )?? >
					<#assign entNewTab = entWebPage.getChild( nomEntrNewTab ) >
				<#else>
					<#assign entNewTab = "null" >
				</#if>
			</#if>
			<#if entNewTab?is_hash>
				<#assign newTabStr = entNewTab.getData() >
			<#else>
				<#assign newTabStr = getterUtil.getString(entNewTab) >
			</#if>

			<#assign newTab = getterUtil.getBoolean(newTabStr ) >
			<#if newTab>
				<#assign target = ' target="_blank"'>
			<#else>
				<#assign target = ''>
			</#if>
			<a href="${ formatedURL }" class="bullet bullet-url"${ target }>
				<#if newTab >
					<span class="hide-accessible"><@liferay.language key="opens-new-window"/></span>
				</#if>
				${ text }
				<#if newTab >
					<span class="icon-external-link"></span>
				</#if>
			</a>
		</li>
		
	</#if>
</#macro>

<#--
 # ------------------------------------------------------------------------------
 # Genera el html correspondiente a la informacion contenida en el elemento
 # multivaluado "entradaInfo", considerando que dicha informacion sera de tipo
 # webPage (pagina web).
 # Parametros:
 #	entradaInfo		entrada para el elemento multivaluado
 #	nomEntradaTxt	nombre de la entrada con el texto por cada subelemento
 #	nomEntradaVal	nombre de la entrada con el valor por cada subelemento
 #	nivelHIni		nivel de inicio para los posibles tag <h>
 #	nomEntrNewTab	nombre de la entrada para opcion sobre nueva pagina (web)
 #	newTab			opcion sobre nueva pagina (web)
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro writeHtmlForWebPages entradaInfo nomEntradaTxt nomEntradaVal nivelHIni nomEntrNewTab newTab >
	<@writeHtmlForEntrada tipo=6 class="" entradaInfo=entradaInfo nomEntradaTit=nomEntradaTxt
		cabDefecto="" nomEntradaVal=nomEntradaVal entLangTitGenSing="ehu.web-page" entLangTitGenPlu=""
		nivelHIni=nivelHIni nomEntrNewTab=nomEntrNewTab newTab=newTab />
</#macro>

<#--
 # ==========================================================================================================
 #                                               MACROS DE VOCABULARIOS (Vocab)
 # ==========================================================================================================
-->
<#--
 # ------------------------------------------------------------------------------
 # Formatea (con html) la informacion asociada a las diferentes categorias del
 # vocabulario especificado con "vocabularyName" y la devuelve en el
 # parametro "vfc_catString".
 # Si el parametro "divClass" no es vacio, se pone un tag <div> a la informacion
 # generada, con la o las clases de dicho parametro.
 # Si el parametro "show" es $true la macro ademas muestra la informacion.
 # Parametros:
 #	vocabularyName	nombre del vocabulario a tratar
 #	show			indica si se quiere mostrar la informacion (html) generada
 #	divClass		clase(s) para el tag "<div>"
 # Salida:
 #	vfc_catString	string con el html generado (solo en ciertos vocabularios)
 # ------------------------------------------------------------------------------
-->
<#macro VocabFormatCategories vocabularyName show divClass>
	<#assign assetCategLocService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService") >
	<#assign assetCategPropLocService = serviceLocator.findService("com.liferay.asset.category.property.service.AssetCategoryPropertyLocalService") >
	<#assign assetVocabLocService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService") >
	<#assign articleService	= serviceLocator.findService( "com.liferay.journal.service.JournalArticleLocalService" ) >
	<#assign groupService	= serviceLocator.findService( "com.liferay.portal.kernel.service.GroupLocalService") >
	
	<#assign catString = "" >
	<#assign globalGroupId = getterUtil.getLong(company.getGroup().getGroupId() ) >

	<#assign scopeId = themeDisplay.getScopeGroupId() >
	
	<#assign hasArticle = articleService.hasArticle(getterUtil.getLong(scopeId ) , .vars['reserved-article-id'].data)>
	<#if hasArticle>
		<#assign article = articleService.getArticle(getterUtil.getLong(scopeId ) , .vars['reserved-article-id'].data) >
	<#else>
		<#assign currentGroup = groupService.getGroup( getterUtil.getLong(scopeId ) ) >
		<#assign parentId = getterUtil.getLong( currentGroup.getParentGroupId() ) >
		<#assign hasArticleParent = articleService.hasArticle(parentId, .vars['reserved-article-id'].data)>
		<#if hasArticleParent>
			<#assign article = articleService.getArticle( parentId, .vars['reserved-article-id'].data) >
		</#if>
	</#if>

	<#if article?? && article?has_content >
		<#assign articlePrimKey = getterUtil.getLong(article.resourcePrimKey ) >
	</#if>
	<#if articlePrimKey?? && articlePrimKey?has_content >
		<#assign articleCategories = assetCategLocService.getCategories( "com.liferay.journal.model.JournalArticle", articlePrimKey )>
	</#if>
	
	<#if articleCategories?? && vocabularyName?? && vocabularyName == "Kokalekuak" >
		<#assign cont = 0 >
		<#list articleCategories as category>
			<#assign vocFromCatId = getterUtil.getLong(category.getVocabularyId() )>
			<#assign vocFromCat = assetVocabLocService.getVocabulary(vocFromCatId ) >
			<#assign vocFromCatName = vocFromCat.getName() >
			<#assign vocFromCatGroupId = vocFromCat.getGroupId() >
			<#if vocFromCatName == vocabularyName && vocFromCatGroupId == globalGroupId >
				<#assign depth = 0 >
				<#assign arrCatNames = [] >
				<#assign arrCatIds = [] >
				<#if cont == 0 >
					<#assign catString = "<h2>" + languageUtil.get(locale, "ehu.location" ) + "</h2>" >
				</#if>
				<#assign categoryId = getterUtil.getLong(category.getCategoryId() ) >
				<#assign parentCategoryId = getterUtil.getLong(category.getParentCategoryId() ) >
				<#assign arrCatNames = arrCatNames + [category.getTitle(locale )] >
				<#assign arrCatIds = arrCatIds + [categoryId] >
				<#assign depth = depth + 1 >
				<#-- depth=one -->
				<#if parentCategoryId != 0 >
					<#assign parentCategory = assetCategLocService.getCategory(parentCategoryId )>
					<#assign parentCategoryIdTwo = getterUtil.getLong(parentCategory.getParentCategoryId() ) >
					<#assign arrCatNames = arrCatNames + [parentCategory.getTitle(locale )] >
					<#assign arrCatIds = arrCatIds + [parentCategoryId]>
					<#assign depth = depth + 1 >
					<#-- depth=two -->
					<#if ((parentCategoryIdTwo != 0)?c)?boolean >
						<#assign parentCategoryTwo = assetCategLocService.getCategory(parentCategoryIdTwo )>
						<#assign parentCategoryIdThree = getterUtil.getLong(parentCategoryTwo.getParentCategoryId() ) >
						<#assign arrCatNames = arrCatNames + [parentCategoryTwo.getTitle(locale )] >
						<#assign arrCatIds = arrCatIds + [parentCategoryIdTwo] >
						<#assign depth = depth + 1 >
						<#-- depth=three -->
						<#if parentCategoryIdThree != 0 >
							<#assign parentCategoryThree = assetCategLocService.getCategory(parentCategoryIdThree ) >
							<#assign parentCategoryIdFour = getterUtil.getLong( parentCategoryThree.getParentCategoryId()) >
							<#assign arrCatNames = arrCatNames + [parentCategoryThree.getTitle(locale )] >
							<#assign arrCatIds = arrCatIds + [parentCategoryIdThree]>
							<#assign depth = depth + 1 >
						</#if><#-- depth=three -->
					</#if> <#-- depth=two -->
				</#if><#-- depth=onw -->

				<#assign catString = catString + '<p>' >
				<#if ((depth == 4)?c)?boolean >
					<#-- floor / room -->
					<#assign catName = arrCatNames?first >
					<#assign catId = getterUtil.getLong(arrCatIds?first )>
					<#assign catKey = "Floor" >
					<#assign floor = (assetCategPropLocService.fetchCategoryProperty(catId, catKey).getValue())!"" >
					<#if !floor?has_content >
						<#assign catTxt = catName >
					<#else>
						<#assign catTxt = languageUtil.get(locale, "upv-ehu-floor" ) + ": " + floor >
					</#if>
					<#assign catTxt = catTxt + " - " >
					<#assign catString = catString + '<span class="room">' + catTxt + '</span>' >
					<#assign arrCatNames = removeFromArray(arrCatNames, 0) >
					<#assign arrCatIds = removeFromArray(arrCatIds, 0 ) >
					<#assign depth = depth - 1 >
				</#if><#-- floor -->

				<#if ((depth == 3)?c)?boolean >
					<#-- building -->
					<#assign catName = arrCatNames?first >
					<#assign catId = getterUtil.getLong(arrCatIds?first ) >
					<#assign catKey = "Address" >
					<#assign address = (assetCategPropLocService.fetchCategoryProperty(catId, catKey ).getValue())!"" >

					<#assign catKey = "PostalCode" >
					<#assign postalCode = (assetCategPropLocService.fetchCategoryProperty(catId, catKey ).getValue())!"" >

					<#assign catString = catString + '<strong><span class="building">' + catName + '</span></strong><br>' >
					<#if address?has_content >
						<#assign catTxt = '<span class="address">' + address + '</span>' + "." >
						<#if postalCode?has_content >
							<#assign catTxt = catTxt + " -" + '<span class="postalCode">' + postalCode + '</span>' + "-" >
						</#if>
						<#assign catString = catString + catTxt + " " >
					</#if>
					<#assign arrCatNames = removeFromArray(arrCatNames, 0 ) >
					<#assign arrCatIds = removeFromArray(arrCatIds, 0 ) >
					<#assign depth = depth - 1 >
				</#if><#-- building -->

				<#if ((depth == 2)?c)?boolean >
					<#-- city -->
					<#assign city = arrCatNames?first >
					<#if !city?has_content >
						<#assign catTxt = "" >
					<#else>
						<#assign catTxt = '<span class="city">' + city + '</span>' >
					</#if>
					<#assign arrCatNames = removeFromArray(arrCatNames, 0 ) >
					<#assign arrCatIds = removeFromArray(arrCatIds, 0 ) >
					<#assign depth = depth - 1 >
				</#if><#-- city -->

				<#if depth == 1 >
					<#-- province / state -->
					<#assign province = arrCatNames?first >
					<#if !catTxt?has_content >
						<#if province?has_content >
							<#assign catTxt = '<span class="province">' + province + '</span>' >
						</#if>
					<#else>
						<#if province?has_content >
							<#assign catTxt = catTxt + '<span class="province">' + " (" + province + ")" + '</span>' >
						</#if>
					</#if>
					<#if catTxt?has_content >
						<#assign catString = catString + catTxt >
					</#if>
				</#if><#-- province / state -->
				<#assign catString = catString + '</p>' >
				<#assign cont = cont + 1 >
			</#if>
		</#list>
	<#elseif articleCategories?? && vocabularyName?? && vocabularyName == "Hartzaileak" >
		<#assign cont = 0 >
		<#if articleCategories?? >
			<#list articleCategories as category >
				<#assign vocFromCatId = getterUtil.getLong(category.getVocabularyId() ) >
				<#assign vocFromCat = assetVocabLocService.getVocabulary(vocFromCatId ) >
				<#assign vocFromCatName = vocFromCat.getName() >
				<#assign vocFromCatGroupId = vocFromCat.getGroupId() >
				<#if vocFromCatName == vocabularyName && vocFromCatGroupId == globalGroupId >
				<#if cont == 0 >
					<#assign catString = "<dt>" + languageUtil.get(locale, "ehu.receivers" ) + ":</dt>" >
				</#if>
				<#assign parentCategoryId = getterUtil.getLong(category.getParentCategoryId() ) >
				<#if parentCategoryId == 0 >
					<#assign parentCatTxt = "" >
				<#else>
					<#assign parentCategory = assetCategLocService.getCategory(parentCategoryId ) >
					<#assign parentCatTxt = parentCategory.getTitle(locale ) + " - " >
				</#if>
					<#assign catString = catString +"<dd>" + parentCatTxt + category.getTitle(locale ) +"</dd>" >
					<#assign cont = cont + 1 >
				</#if>
			</#list>
		</#if>
		<#if ((cont > 0)?c)?boolean >
			<#assign catString = catString >
		</#if>
	<#elseif articleCategories?? && vocabularyName?? && (vocabularyName == "Erakundeak" || vocabularyName == "Gobernu organoak" ) >
		<#assign cont = 0 >
		<#if articleCategories?? >
			<#list articleCategories as category>
				<#assign vocFromCatId = getterUtil.getLong(category.getVocabularyId() ) >
				<#assign vocFromCat = assetVocabLocService.getVocabulary(vocFromCatId ) >
				<#assign vocFromCatName = vocFromCat.getName() >
				<#assign vocFromCatGroupId = vocFromCat.getGroupId() >
				<#if vocFromCatName == vocabularyName && vocFromCatGroupId == globalGroupId>
					<#assign categoryId = getterUtil.getLong(category.getCategoryId() ) >
					<#assign parentCategoryId = getterUtil.getLong(category.getParentCategoryId() ) >
					<#if ((parentCategoryId == 0 )?c)?boolean >
						<#assign parentCatTxt = "" >
					<#else>
						<#assign parentCategory = assetCategLocService.getCategory(parentCategoryId ) >
						<#assign parentCatTxt = " - " + parentCategory.getTitle(locale ) >
						<#assign parentCategoryIdTwo = getterUtil.getLong(parentCategory.getParentCategoryId() ) >
						<#-- categoria de tercer nivel (limite maximo para este vocabulario) -->
						<#if parentCategoryIdTwo != 0 >
							<#assign parentCategoryTwo = assetCategLocService.getCategory(parentCategoryIdTwo ) >
							<#assign parentCatTxt = parentCatTxt + " - " + parentCategoryTwo.getTitle(locale ) >
						</#if>
					</#if>
					<#if ((cont == 0)?c)?boolean >
						<#assign sepString = "" >
					<#else>
						<#assign sepString = " | " >
					</#if>
					<#assign catString = catString + sepString + category.getTitle(locale) + parentCatTxt >
					<#assign cont = cont + 1 >
				</#if>
			</#list>
		</#if>
	</#if>
	<#if catString?has_content >
		<#if divClass?has_content >
			<#assign catString = '<div class="' + divClass + '">' + catString + '</div>' >
		</#if>
		<#if show?? && (!show?has_content || show ) >
			${catString}
		</#if>
	</#if>
	<#return>
	
</#macro>


<#--
 # ==========================================================================================================
 #                                               MACROS DE ALLOYUI (AUI)
 # ==========================================================================================================
-->
<#--
 # ------------------------------------------------------------------------------
 # Genera el codigo alloyui de tratamiento de imagenes (aui-image-viewer).
 # El parametro "galleryId" es el identificador htlm del div donde va la
 # informacion de la galeria.
 # El parametro "thumbnailLink" es el link a los thumbnails de la galeria.
 # Para que se puedan visualizar de forma correcta, para una misma pagina, varias
 # galerias de imagenes de diferentes contenidos, es conveniente que estos dos
 # parametros sean personalizados por contenido, por ejemplo, incluyendo el
 # articleId.
 # Parametros:
 #	galleryId		identificador del div donde va la informacion de la galeria
 #	thumbnailLink	link a los thumbnails de la galeria
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro AUIImageViewer galleryId thumbnailLink>
	<#if galleryId == "" || thumbnailLink = "" > <#return> </#if>

	<script>
	YUI().use(
	  'aui-image-viewer',
	  function(A) {
		var imgViewer = new A.ImageViewer(
		  {
			after: {
				render: function() {
					/*! BEGIN Trello - wek: 581 */
					var TPL_CAPTION = this.TPL_CAPTION.replaceAll( 'h4', 'p' ),
						TPL_INFO = this.TPL_INFO.replaceAll( 'h5', 'p' );
					var footerContent = A.Node.create( this.TPL_FOOTER_CONTENT ),
						footerButtons = A.Node.create( this.TPL_FOOTER_BUTTONS ),
						footerThumbnails = A.Node.create( this.TPL_THUMBNAILS );

					this.setStdModContent( 'footer', footerContent );

					this._captionEl = A.Node.create( TPL_CAPTION );
					this._captionEl.selectable();
					footerContent.append( this._captionEl );

					this._infoEl = A.Node.create( TPL_INFO );
					this._infoEl.selectable();
					footerContent.append( this._infoEl );

					// Player button
					if( this.get( 'showPlayer' ) ) {
						if( !this._player ) {
							this._player = A.Node.create( this.TPL_PLAYER );
						}
						footerButtons.append( this._player );
					}

					footerContent.append( footerButtons );

					// Evento click para thumbnails
					footerThumbnails.on( 'click', function( event ) {
						imgViewer._afterThumbnailsIndexChange()
						imgViewer.show();
						imgViewer._showCurrentImage();
					} );
					this._thumbnailsEl = footerThumbnails;
					footerContent.append( this._thumbnailsEl );
					this._renderThumbnailsWidget();
					/*! END Trello - wek: 581 */

					//Download button
					this._actions = A.Node.create( '<div class="image-download"></div>' );
					this.footerNode.append( this._actions );
					var elements = document.getElementById( "${ galleryId }" ).getElementsByClassName( "taglib-icon" );
					var images = document.getElementsByClassName("image-viewer-base-image-container");
					var names = '';
					var alt;
					var imagesDottet = document.querySelectorAll('.image-viewer-thumbnails .image-viewer-base-image-container .image-viewer-base-image');
					var linktext = document.querySelectorAll('.image-viewer-base-image-list-inner .image-viewer-base-image-container .image-download-button');
					for(var i=0; i<elements.length; i++) {

						links = elements[i].href;
                        var link = document.createElement("a");
                        
                        try {
	                        if(document.getElementById("img-image-thumbnail_${ galleryId?replace('myGallery_','')}_"+i).getAttribute("alt")!==null && document.getElementById("img-image-thumbnail_${ galleryId?replace('myGallery_','')}_"+i).getAttribute("alt")!==undefined){
	                            alt=document.getElementById("img-image-thumbnail_${ galleryId?replace('myGallery_','')}_"+i).getAttribute("alt");
	                            var newContent = document.createElement("span");
	    						var newText=document.createTextNode(alt);
	    						newContent.classList.add("sr-only");
	    						newContent.appendChild(newText);
	    
	                            link.appendChild(newContent);
	                            images[i].firstChild.setAttribute("alt",alt);
	                            imagesDottet[i].setAttribute("alt",alt);
	                        }
	                    }
	                    catch(e) {
	                    	
	                    }

						link.setAttribute("class", "image-download-button glyphicon glyphicon-download");
						link.href=links;
						
                        
						images[i].appendChild(link);

					}
				},
				request: function( i ) {
				}
			},
			captionFromTitle: true,
			centered: true,
			links: '#${galleryId} ${thumbnailLink}',
			playing: false,
			preloadAllImages: true,
			preloadNeighborImages: true,
			showInfo: true,
			showPlayer: false,
			zIndex: 1
		  }
		).render();
	  }
	);
	</script>

</#macro>

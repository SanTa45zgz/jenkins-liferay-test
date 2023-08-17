<#-- GENERAL-->
<#assign cTxtArticle			= languageUtil.get( locale, "article" ) >
<#assign cTxtAutoria			= languageUtil.get( locale, "ehu.authors" ) >
<#assign cTxtDoi				= languageUtil.get( locale, "ehu.doi" ) >
<#assign cTxtDoiTitle			= languageUtil.get( locale, "ehu.digital-object-identifier" ) >
<#assign cTxtNewWindow			= languageUtil.get( locale, "opens-new-window" ) >
<#assign cTxtPhoto				= languageUtil.get( locale, "ehu.photo" ) >
<#assign cTxtPublishing			= languageUtil.get( locale, "publishing" ) >

<#assign cUrlDoiOrg				= "https://doi.org/" >
<#assign scopeId = themeDisplay.scopeGroupId>
<#assign isCampusa = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-campusa-theme") >
<#assign isGlobal = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#if .vars['reserved-article-id']?has_content>
	<#assign articleId = .vars['reserved-article-id'] > 
<#else>
	<#assign articleId = ""> 
</#if>

<#if !isGlobal >
	<#assign articleClass		= "new" >
	<#assign preTitleClass		= "pretitle" >
	<#assign titleClass			= "new-title" >
	<#assign subTitleClass		= "subtitle" >
	<#assign entryClass			= "entry" >
	<#assign descriptionClass	= "description" >
	<#assign documentsClass		= "documents" >
	<#assign linksClass			= "links" >
	<#assign bibliographyClass	= "bibliographic-reference" >
	<#assign headerTag			= "div" >
	<#assign headerBloqueTag	= "p" >
	<#assign htmlHeaderTagClass	= ' class="content-header"' >
<#else>
	<#assign articleClass		= "new-detail" >
	<#assign preTitleClass		= "new-detail__pretitle" >
	<#assign titleClass			= "new-detail__title" >
	<#assign subTitleClass		= "new-detail__subtitle" >
	<#assign entryClass			= "new-detail__body__entry" >
	<#assign descriptionClass	= "new-detail__body__description" >
	<#assign documentsClass		= "new-detail__documents" >
	<#assign linksClass			= "new-detail__links" >
	<#assign bibliographyClass	= "new-detail__bibliographic-reference" >
	<#assign headerTag			= "header" >
	<#assign headerBloqueTag	= "div" >
	<#assign htmlHeaderTagClass	= "" >
</#if>

<#assign entGeneralData = ehugeneraldata >

<#-- HTML-->
<article class="${ articleClass }">
	<#-- PRETITLE, TITLE, SUBTITLE -->
	<#assign preTitle = "">
	<#if entGeneralData.ehupretitle??>
		<#if entGeneralData.ehupretitle?is_hash >
			<#assign aux = entGeneralData.ehupretitle.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entGeneralData.ehupretitle ) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign preTitle = aux>
		</#if>	
	</#if>
	
	<#assign title = "">
	<#if entGeneralData.ehunewtitle??>
		<#if entGeneralData.ehunewtitle?is_hash >
			<#assign aux = entGeneralData.ehunewtitle.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entGeneralData.ehunewtitle ) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign title = aux>
		</#if>	
	</#if>
	
	<#assign subTitle = "">
	<#if entGeneralData.ehunewsubtitle??>
		<#if entGeneralData.ehunewsubtitle?is_hash >
			<#assign aux = entGeneralData.ehunewsubtitle.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entGeneralData.ehunewsubtitle) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign subTitle = aux>
		</#if>
	</#if>
	<${ headerTag }${ htmlHeaderTagClass }>
		<#if preTitle != "" >
			<${ headerBloqueTag } class="${ preTitleClass }">${ preTitle }</${ headerBloqueTag }>
		</#if>
		<#if title != "" >
			<h1 class="${ titleClass }">${ title }</h1>   
		</#if>
		<#if subTitle != "" >
			<${ headerBloqueTag } class="${ subTitleClass }">${ subTitle }</${ headerBloqueTag }>
		</#if>
	</${ headerTag }>

	<#if !isGlobal >
		<div class="content-content">
	</#if>
	<#if isGlobal >
		<div class="new-detail__info-date-share">
	</#if>

	<#-- CAMPUSA VOCABULARY -->
	<#assign vocabularyName = "Campusa" >
	<#assign tag_init = "<ul></ul>" >
	<#assign categories = tag_init >
	<@upvlibs.formatVocabularyCategoriesProperties vocabularyName=vocabularyName />
	<#assign categories = upvlibs.categoriesListStr >
	
	<#if  categories != tag_init  >
		<div class="campusa-category">${ categories }</div>
	</#if>

	<#-- FIRST PUBLICATION DATE -->
	<#if locale == "eu_ES">
		<#assign dateFormat = "yyyy/MM/dd">
	<#else>
		<#assign dateFormat = "dd/MM/yyyy">
	</#if>
	<#if isGlobal >
		<#assign articlePublicationDate = .vars['reserved-article-display-date'].data!"" >
		<#if articlePublicationDate != "" >
			
			<#setting date_format=dateFormat >
			<#assign currentLocale = locale>
			<#setting locale = localeUtil.getDefault() >
			<#if articlePublicationDate?? && articlePublicationDate != "" >
				<#assign publicationDate = ( articlePublicationDate?datetime( "EEE, dd MMM yyyy hh:mm:ss" ) )?date >
				<#assign publicationDateStr = publicationDate?string >
				<div class="new-detail__info-date-share__date">
					<p class="publication_date">
						<strong class="text"> <@liferay.language key="ehu.first-publication-date" />:</strong>
					
							<span class="date">${ publicationDateStr }</span>
					
					</p>
				</div>
			</#if>
			<#setting locale = currentLocale>
		</#if>
	<#else>
		<#assign articlePublicationDate = .vars['reserved-article-display-date'].data!"" >
		<#if articlePublicationDate != "" >		
			<#setting date_format=dateFormat >
			<#assign currentLocale = locale>
			<#setting locale = localeUtil.getDefault() >
			<#if articlePublicationDate?? && articlePublicationDate != "" >
				<#assign publicationDate = ( articlePublicationDate?datetime( "EEE, dd MMM yyyy hh:mm:ss" ) )?date >
				<#assign publicationDateStr = publicationDate?string >
				<p class="publication_date">
					<strong class="text"> <@liferay.language key="ehu.first-publication-date" />:</strong>
					<span class="date">${ publicationDateStr }</span>
				</p>
			</#if>
			<#setting locale = currentLocale>
		</#if>
	</#if>



	<#-- REDES SOCIALES -->
	<#if isGlobal >
		<#if entGeneralData.ehusocialbookmarks?? >
		
			<#if entGeneralData.ehusocialbookmarks?is_hash >
				<#assign aux = entGeneralData.ehusocialbookmarks.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entGeneralData.ehusocialbookmarks ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign showRedesSociales = getterUtil.getBoolean(aux) >
			<#else>
				<#assign showRedesSociales = getterUtil.getBoolean( "false")>
			</#if>
			<#assign classRS = "share-social-bar__item" >
			<#if showRedesSociales >
				<#assign urlEnCurso = themeDisplay.getURLPortal() + themeDisplay.getURLCurrent() >
				<#-- SHARE SOCIAL BAR -->
				<div class="share-social-bar">
					<a href="https://www.facebook.com/share.php?u=${urlEnCurso?replace(' ','%20')}&amp;t=www.ehu.eus" target="_blank" title="Facebook" class="${ classRS }">
						<i class="icon-facebook"></i>
						<span class="sr-only"><@liferay.language key="social-bookmark-facebook-ehu" /> - ${ cTxtNewWindow }</span>
					</a>
					<a href="https://twitter.com/intent/tweet?text=www.ehu.eus%20-%20${urlEnCurso?replace(' ','%20')}%20" target="_blank" title="Twitter" class="${ classRS }">
						<i class="icon-twitter"></i>
						<span class="sr-only"><@liferay.language key="social-bookmark-twitter-ehu" /> - ${ cTxtNewWindow }</span>
					</a>
					<a href="https://www.linkedin.com/shareArticle?mini=true&amp;url=${urlEnCurso?replace(' ','%20')}&amp;title=${title?replace(' ','%20')}&amp;summary=" target="_blank" title="LinkedIn" class="${ classRS }">
						<i class="icon-linkedin"></i>
						<span class="sr-only"><@liferay.language key="social-bookmark-linkedin" /> - ${ cTxtNewWindow }</span>
					</a>
					<a href="whatsapp://send?text=${ urlEnCurso }" data-action="share/whatsapp/share" target="_blank" class="${ classRS } svg-icon" title="WhatsApp">
						<svg><use xlink:href="${ themeDisplay.getPathThemeImages() }/icons/fontawesome-brands.svg#whatsapp" /></svg> 
						<span class="sr-only">WhatsApp - ${ cTxtNewWindow }</span>
					</a>
					<a href="mailto:?subject=${title?replace(' ','%20')}&amp;body=%20-%20${urlEnCurso?replace(' ','%20')}" target="_blank" title="Email" class="${ classRS }">
						<i class="icon-envelope"></i>
						<span class="sr-only"><@liferay.language key="ehu.send-email" /> - ${ cTxtNewWindow }</span>
					</a>
					<a href="javascript:void(0)" onclick="window.print();" target="_blank" title='<@liferay.language key="ehu.print" />' class="${ classRS }">
						<i class="icon-print"></i>
						<span class="sr-only"><@liferay.language key="centros.accesibilidad.imprimir" /> - ${ cTxtNewWindow }</span>
					</a>
				</div>
			</#if>
		</#if>
	</#if>

	<#if isGlobal >
		</div> <#-- class="new-detail__info-date-share" -->
		<div class="new-detail__body">
	</#if>

	<#-- IMAGE -->
	<#assign entImage = entGeneralData.ehunewtext.ehunewimage >
	<#if entImage?is_hash >
		<#assign aux = entImage.getData() >
	<#else>
		<#assign aux = getterUtil.getString( entImage ) >
	</#if>
	<#if aux?has_content && aux != "">
		<#assign imageSrc = aux>
	<#else>
		<#assign imageSrc = "">
	</#if>
	<#if imageSrc != "" >
		<#assign imageAltText = languageUtil.get( locale, "image" )>
		<#if  entImage.ehunewimagealt??>
			<#if entImage.ehunewimagealt?is_hash >
				<#assign aux = entImage.ehunewimagealt.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entImage.ehunewimagealt ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign imageAltText = aux>
			<#else>
				<#assign imageAltText = languageUtil.get( locale, "image" )>
			</#if>
		</#if>
		<#assign imageFootText = "">
		<#if entImage.ehunewimagefoot??>
			<#if entImage.ehunewimagefoot?is_hash >
				<#assign aux = entImage.ehunewimagefoot.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entImage.ehunewimagefoot ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign imageFootText = aux>
			<#else>
				<#assign imageFootText = "">
			</#if>
		</#if>
		<#assign imageAuthorText = "">
		<#if entImage.ehunewimageauthor??>
			<#if entImage.ehunewimageauthor?is_hash >
				<#assign aux = entImage.ehunewimageauthor.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entImage.ehunewimageauthor ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign imageAuthorText = aux>
			<#else>
				<#assign imageAuthorText = "">
			</#if>
		</#if>
		<#assign imageAlign = "">
		<#if entImage.ehuimagedisposition??>
			<#if entImage.ehuimagedisposition?is_hash >
				<#assign aux = entImage.ehuimagedisposition.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entImage.ehuimagedisposition ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign imageAlign = aux>
			<#else>
				<#assign imageAlign = "">
			</#if>
		</#if>
		
		<#assign imageUrl = "" >
		
		<#-- La OC decide que en GlobalTheme las imágenes también serán enlazables -->
		<#if entImage.ehunewimageurl?? && entImage.ehunewimageurl?has_content >
			<#assign entImageUrl = entImage.ehunewimageurl >
			<#assign imageUrl = entImageUrl.getData()>
		</#if>
		
		<#assign imageUrlTitle = "" >
		<#assign imageUrlNewTab = true >
		<#assign imageClass = "img-main" >

		<#-- Pasamos la imagen de la noticia directamente al og:image para que no haya problemas al compartirla
			 en redes sociales (Trello 273 - Trello 637) -->	
		<@liferay_util["html-top"]>
			<meta property="og:image" content="${ portalUtil.getAbsoluteURL( request, imageSrc ) }">
		</@>
		<#if !isGlobal >
			<@upvlibs.imageAuthorSection image=imageSrc altText=imageAltText footText=imageFootText imageAuthor=imageAuthorText
				imageDisposition=imageAlign elemImageUrl=entImageUrl imageUrlTitle=imageUrlTitle imageUrlNewTab=imageUrlNewTab imgClass=imageClass />
		<#else>
			
			<#if imageUrl != "">
				<a href="${ imageUrl }" target="_blank">
			</#if>
			<div class="new-detail__body__main-image ${ imageAlign }">
			<img src="${ imageSrc }" alt="${ imageAltText }" class="${ imageClass }"/> 
			
				<#if imageFootText != "" || imageAuthorText != "" >
					<div class="main-image__footer">
						<#if imageFootText == "" >
							<#assign txtPhoto = "" >
						<#else>
							<#assign txtPhoto = imageFootText >
						</#if>
						<#if imageAuthorText != "" >
							<#if imageFootText == "" >
								<#assign aux = "" >
							<#else>
								<#assign aux = " | " >
							</#if>
							<#assign txtPhoto = txtPhoto + aux + cTxtPhoto + ": " + imageAuthorText >
						</#if>
						<#if imageAlign == "" >
								<#assign classImageFootText = "center" >
						<#else>
								<#assign classImageFootText = imageAlign >
						</#if>
						<p class="${ classImageFootText }">${ txtPhoto }</p>					
				   </div>
				</#if>				
		  	 </div>
		   <#if imageUrl != "">
				</a>
			</#if>
		</#if>
	<#else>
		<#-- Si la imagen no tiene imagen metemos como imagen para redes sociales el logo de la universidad
			 proporcionado por la oficina de comunicación (Trello 565 - Trello 637) -->	
		<@liferay_util["html-top"]>
				<meta property="og:image" content="https://www.ehu.eus/documents/522485/1339603/avatar.jpg">
		</@>
	</#if>

	<#-- ENTRADILLA -->
	<#-- Desde la Oficina de Comunicacion piden para Campusa que la entradilla vaya despues de la imagen
		 Se hace el cambio para todos -->
	<#if entGeneralData.ehunewentradilla?is_hash >
		<#assign aux = entGeneralData.ehunewentradilla.getData() >
	<#else>
		<#assign aux = getterUtil.getString( entGeneralData.ehunewentradilla ) >
	</#if>
	<#if aux?has_content && aux != "">
		<#assign entradilla = aux>
	<#else>
		<#assign entradilla = "">
	</#if>
	<#if entradilla != "" >
		<div class="${ entryClass }">
			<p>${entradilla}</p>
		</div>
	</#if>

	<#-- DESCRIPTION -->
	<#if entGeneralData.ehunewtext?is_hash >
		<#assign aux = entGeneralData.ehunewtext.getData() >
	<#else>
		<#assign aux = getterUtil.getString( entGeneralData.ehunewtext ) >
	</#if>
	<#if aux?has_content && aux != "">
		<#assign description = aux>
	<#else>
		<#assign description = "">
	</#if>
	<#if  description != "" >
		<div class="${ descriptionClass }">
				${ description }
		</div>
	</#if>

	<#if isGlobal >
		<#-- IMAGE GALLERY -->
		<div class="new-detail__body__image-gallery">
			<#if ehuimagegallery?? >
				<#if ehuimagegallery.ehuslide??>
					<@upvlibs.imageGallerySection ehuimagegallery.ehuslide articleId false 4 />
				</#if>
			</#if>				
		</div>
	</#if>
	<#if isGlobal >
		</div> <#-- class="new-detail__body" -->
	</#if>
	
	<#assign entMoreInfo = ehumoreinfo >
	<#if entMoreInfo?? >
		<#-- DOCUMENTS -->		
		<#if entMoreInfo.ehunewdocument?? >
			<#assign entDocuments = entMoreInfo.ehunewdocument >
			<#if upvlibs.hasElement (entDocuments) >
				<div class="${ documentsClass }">
					<@upvlibs.documentSection documentsField=entDocuments documentTitleField="ehunewdocumenttitle"  />
				</div>
			</#if>
		</#if>
		
		<#-- LINKS -->	
		<#if entMoreInfo.ehunewurl??>
			<#assign entLinks = entMoreInfo.ehunewurl >
			<#if upvlibs.hasElement(entLinks) >
				<div class="${ linksClass }">
					<@upvlibs.linkSection linksField=entLinks linkNewTabField="" linkTitleField="ehunewurltitle" />
				</div>
			</#if>
		</#if>
	</#if>
	
	<#-- REFERENCE INFO -->
	<#-- Bibliografía -->
	<#assign entBibliography = ehunewbibliographicreference >
	<#assign hayBiblioArticles = getterUtil.getBoolean("false")>
	<#if entBibliography.ehubibliographicreferencearticle?? && entBibliography.ehubibliographicreferencepublication??>							   
		<#assign hayBiblioArticles = upvlibs.hasElement(entBibliography.ehubibliographicreferencearticle) && upvlibs.hasElement(entBibliography.ehubibliographicreferencepublication) >
	</#if>	
	<#if hayBiblioArticles >
		<div class="${ bibliographyClass }">
			<#if !isGlobal >
				<#assign htmlIconBibliography = '<i class="icon-book"></i>' >
			<#else>
				<#assign htmlIconBibliography = ""  >
			</#if>
			
			<h2>${ htmlIconBibliography }<@liferay.language key="ehu.bibliographic-reference" /></h2>
			<#if !isGlobal >
				<ul>
			</#if>
			<#if !isGlobal >
				<#assign htmlTxtArticle = "" >
				<#assign htmlTxtPublication = "" >
				<#assign htmlTxtAutoria = "" >
				<#assign htmlTagBiblio = "span" >
			<#else>
				<#assign htmlTxtArticle = "<strong>" + cTxtArticle + ":" + "</strong>" >
				<#assign htmlTxtPublication = "<strong>" + cTxtPublishing + ":" + "</strong>" >
				<#assign htmlTxtAutoria = "<strong>" + cTxtAutoria + ":" + "</strong>" >
				<#assign htmlTagBiblio = "p" >
			</#if>
			<#if !isGlobal >
				<#assign htmlTxtDoi = '<abbr title="' + cTxtDoiTitle + '">' + cTxtDoi + '</abbr>: ' >
			<#else>
				<#assign htmlTxtDoi = '<abbr title="' + cTxtDoiTitle + '">' + "<strong>" + cTxtDoi + "</strong>" + '</abbr>: ' >
			</#if>
			<#list entBibliography.getSiblings() as elemEntBibliography >
				<#if elemEntBibliography.ehubibliographicreferencearticle?is_hash >
					<#assign aux = elemEntBibliography.ehubibliographicreferencearticle.getData() >
				<#else>
					<#assign aux = getterUtil.getString( elemEntBibliography.ehubibliographicreferencearticle ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign biblioArticle = aux>
				<#else>
					<#assign biblioArticle = "">
				</#if>
				<#if elemEntBibliography.ehubibliographicreferencepublication?is_hash >
					<#assign aux = elemEntBibliography.ehubibliographicreferencepublication.getData() >
				<#else>
					<#assign aux = getterUtil.getString( elemEntBibliography.ehubibliographicreferencepublication ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign biblioPublication = aux>
				<#else>
					<#assign biblioPublication = "">
				</#if>
				<#if biblioArticle == "" ||  biblioPublication == "" >	<#continue> </#if>
				
				<#if elemEntBibliography.ehubibliographicreferenceauthors?is_hash >
					<#assign aux = elemEntBibliography.ehubibliographicreferenceauthors.getData() >
				<#else>
					<#assign aux = getterUtil.getString( elemEntBibliography.ehubibliographicreferenceauthors ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign biblioAuthors = aux>
				<#else>
					<#assign biblioAuthors = "">
				</#if>
				<#if elemEntBibliography.ehubibliographicreferencedoi?is_hash >
					<#assign aux = elemEntBibliography.ehubibliographicreferencedoi.getData() >
				<#else>
					<#assign aux = getterUtil.getString( elemEntBibliography.ehubibliographicreferencedoi ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign biblioDoi = aux>
				<#else>	
					<#assign biblioDoi = "">
				</#if>
				<#if isGlobal >					
					<div class="new-detail__bibliographic-reference__item">
				</#if>
				<#if  biblioAuthors != "" >
					<li>
						<${ htmlTagBiblio } class="authors">${ htmlTxtAutoria } ${ biblioAuthors }</${ htmlTagBiblio }>
					</li>
				</#if>
				<#if biblioArticle != "" >
					<#if biblioDoi == "" >
						<#assign htmlBiblioArticle = biblioArticle >
					<#else>
						<#assign htmlBiblioArticle = '<a target="_blank" href="' + cUrlDoiOrg + biblioDoi + '">' + biblioArticle + '</a>' >
					</#if>
					<li>
						<${ htmlTagBiblio } class="article">${ htmlTxtArticle } ${ htmlBiblioArticle }</${ htmlTagBiblio }>
					</li>
				</#if>
				<#if biblioPublication != "" >
					<li>
						<${ htmlTagBiblio } class="publication">${ htmlTxtPublication } ${ biblioPublication }</${ htmlTagBiblio }>
					</li>
				</#if>
				<#if biblioDoi != "" >
					<li>
						<${ htmlTagBiblio } class="doi">${ htmlTxtDoi } ${ biblioDoi }</${ htmlTagBiblio }>
					</li>
				</#if>

				<#if isGlobal >					
					</div> <#-- class="new-detail__bibliographic-reference__item" -->
				</#if>
			</#list>
			<#if !isGlobal >
				</ul>
			</#if>
		</div> <#-- class="${ bibliographyClass }" -->
	</#if>

	<#if !isGlobal >
		<#-- IMAGE GALLERY -->
		<#if ehuimagegallery?? >
			<#if ehuimagegallery.ehuslide??>
				<@upvlibs.imageGallerySection ehuimagegallery.ehuslide articleId true 4 />
			</#if>
		</#if>
		</div> <#-- class="content-content" -->

		<#-- LAST MODIFICATION DATE -->
		<#assign showLastModifDate = getterUtil.getBoolean( "false")>
		<#if entGeneralData.ehulastmodificationdate??>
			<#if entGeneralData.ehulastmodificationdate?is_hash >
				<#assign aux = entGeneralData.ehulastmodificationdate.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entGeneralData.ehulastmodificationdate ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign showLastModifDate = getterUtil.getBoolean(aux) >
			</#if>
		</#if>
		<#if showLastModifDate >
			<div class="content-footer">
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
					<#assign modifiedDateStr = modifiedDate?string >
				<#else>
						<#assign modifiedDateStr = "" >
				</#if>
				<#setting locale = currentLocale>
				
				<#if modifiedDateStr != "" >
					<p class="modification_date">
						<strong class="text"> <@liferay.language key="ehu.last-modification-date" />:</strong>
						<span class="date">${ modifiedDateStr }</span>
					</p>
				</#if>
			</div>
		</#if>

		<#-- CAMPUSA-->
		<#if isCampusa >
			<h2 class="social"><@liferay.language key="sharing" /></h2>
		</#if>
	</#if>

</article>

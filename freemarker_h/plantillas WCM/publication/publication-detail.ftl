<#--
Nombre contenido (ES): Publicación
Estructura: global > publication.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/publicacion
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign txtYearUnknown = "unknown" >
<#assign publicationYear = "" >
<#if ehupublicationyearseparator??>
	<#if ehupublicationyearseparator.ehupublicationyear?? >
		<#assign publicationYear = ehupublicationyearseparator.ehupublicationyear.getData() >
	</#if>
</#if>

<#if publicationYear == txtYearUnknown >
	<#assign txtPublicationYear = languageUtil.get(  locale , "unknown" )?lower_case>
<#else>
	<#assign txtPublicationYear = publicationYear >
</#if>

<#assign showYear = (publicationYear != "") && (publicationYear != txtYearUnknown) >

<article class="publication">
	<header class="publication-title">
		<h1>
		
			<#assign title = "" >
            <#if ehupublicationtitle??>
                <#assign title = ehupublicationtitle.getData()>
            </#if>
        	<#assign titleLang = "" >
            <#if ehupublicationtitle.ehutitlelang?? >
                <#assign titleLang = ehupublicationtitle.ehutitlelang.getData()>
            </#if>
            <#if titleLang != "" && title != "">
            	<span lang="${titleLang}">
            </#if>
            <#if title != "">
            	${title}
            </#if>
            <#if titleLang != "" && title != "">
            	</span>
            </#if>
		</h1>
	</header>
		
	<dl>
		<#if ehupublicationauthor?? && ehupublicationauthor.getData()?has_content >
			<dt><@liferay.language key="ehu.authors" />:</dt>
			<dd>${ehupublicationauthor.getData()}</dd>
		</#if>

		<#if showYear >
			<dt><@liferay.language key="year" />:</dt>
			<dd>${txtPublicationYear}</dd>
		</#if>			
				
		<#if ehupublicationpublishingmedia.getData()?has_content >			
			<#assign publicationType = ehupublicationtype.getData()>
			<#if publicationType?? && "upv-ehu-blank" != publicationType >
				<#if publicationType == "journal" >
					<#assign publication = languageUtil.get(locale, "ehu.journal")>
				<#elseif publicationType == "book" >
					<#assign publication = languageUtil.get(locale, "ehu.book")>
				<#elseif publicationType == "book-chapter" >
					<#assign publication = languageUtil.get(locale, "ehu.book")>
				<#elseif publicationType == "communication-congress" >
					<#assign publication = languageUtil.get(locale, "ehu.congress-communication")>		  
				<#elseif publicationType == "presentation-congress" >
					<#assign publication = languageUtil.get(locale, "ehu.congress-presentation")>	   
				<#elseif publicationType == "poster-congress" >
					<#assign publication = languageUtil.get(locale, "ehu.congress-poster")>				   
				<#else>
					<#assign publication = languageUtil.get(locale, "ehu.publishing-media")>
				</#if>
					<dt>${publication}:</dt>
					<dd>${ehupublicationpublishingmedia.getData()}</dd>
				<#else>
					<dt><@liferay.language key="ehu.publishing-media" />:</dt>
					<dd>${ehupublicationpublishingmedia.getData()}</dd>
				</#if>
			</#if>				
			
			<#-- 521) Error en el Impact Factor de las Publicaciones -->
			<#if ehupublicationimpactfactor?? && ehupublicationimpactfactor.getData()?has_content && ehupublicationimpactfactor.getData() !=  "0">
				<dt><@liferay.language key="ehu.impact-factor" />:</dt>
                <dd>${ehupublicationimpactfactor.getData()}</dd>
			</#if>		
						
			
			<#if ehupublicationquartile?? && ehupublicationquartile.getData()?has_content >
				<dt><@liferay.language key="ehu.quartile" />:</dt>
				<dd>${ehupublicationquartile.getData()}</dd>
			</#if>
			
			<#if ehupublicationeditor?? && ehupublicationeditor.getData()?has_content >
				<dt><@liferay.language key="ehu.publishing-editor" />:</dt>
				<dd>${ehupublicationeditor.getData()}</dd>		
			</#if>
			
			
			<#if ehupublicationcity?? && ehupublicationcity.getData()?has_content >
				<dt><@liferay.language key="ehu.publishing-city" />:</dt>
				<dd>${ehupublicationcity.getData()}</dd>		
			</#if>

			<#if ehupublicationvolume?? && ehupublicationvolume.getData()?has_content >
				<dt><@liferay.language key="ehu.publishing-volume" />:</dt>
				<dd>${ehupublicationvolume.getData()}</dd>	  
			</#if>
			
			<#if ehupublicationinitpage?? && ehupublicationendpage?? && ehupublicationinitpage.getData()?has_content && ehupublicationendpage.getData()?has_content >
				<dt><@liferay.language key="ehu.init-page" /> - <@liferay.language key="ehu.end-page" />:</dt>
				<dd>${ehupublicationinitpage.getData()} - ${ehupublicationendpage.getData()}</dd>		 
			</#if>
		
			<#if ehupublicationisbn?? && ehupublicationisbn.getData()?has_content >
				<dt><abbr title='<@liferay.language key="ehu.title.isbn" />'> <@liferay.language key="ehu.abbr.isbn" /></abbr>/<abbr title='<@liferay.language key="ehu.title.issn" />'><@liferay.language key="ehu.abbr.issn" /></abbr>:</dt>
				<dd>${ehupublicationisbn.getData()}</dd>		
			</#if>
				
			<#if ehupublicationdoi?? && ehupublicationdoi.getData()?has_content >
				<dt><abbr title='<@liferay.language key="ehu.digital-object-identifier" />'> <@liferay.language key="ehu.doi" /></abbr>:</dt>
				<dd><a href="https://doi.org/${ehupublicationdoi.getData()}" title="${ehupublicationtitle.getData()}">${ehupublicationdoi.getData()}</a></dd>
			</#if>
				
			<#if ehupublicationdescription?? && ehupublicationdescription.getData()?has_content >		   
				<dt class="clear"><@liferay.language key="ehu.description" />:</dt>
				<#assign text_box_data = ehupublicationdescription.getData()>
				<dd>
					<p>${text_box_data?replace("\n", "</p><p>")}</p>
				</dd>
			</#if>
		</dl>
				
		<#assign link = ehupublicationlink >
		<#if ehupublicationlink?? && ehupublicationlink.ehupublicationlinktitle?? && ehupublicationlink.ehupublicationlinktitle.getData()??>
			<#assign link_title= ehupublicationlink.ehupublicationlinktitle.getData()>
		</#if>
		<#if ehupublicationlink?? && ehupublicationlink.ehunewtab?? && ehupublicationlink.ehunewtab.getData()??>
			<#assign link_new_window= getterUtil.getBoolean(ehupublicationlink.ehunewtab.getData())>
		</#if>
		<#if ehudocument?? >
			<#assign document = ehudocument >
		</#if>
		<#assign formatedURL = "" >
		<#if link?is_hash >
			<#assign aux = link.getData() >
		<#else>
			<#assign aux = getterUtil.getString(link) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign formatedURL = aux>
		</#if>
			
		<#if (link?? && link.getData()?has_content) || (document?? && document.getData()?has_content) >
			<header>
				<h2><@liferay.language key="ehu.more-info" /></h2>
			</header>
			<div class="upv-ehu-aditional-info">
				<ul>
					<#if link.getData()?has_content >
						<#assign link_title_desc = formatedURL >
						<#if link_title?has_content >
							<#assign link_title_desc = link_title >
						</#if>
					<li class="link">
						<#if link_new_window?? && link_new_window >
							<a class="bullet bullet-url" href="${formatedURL}" target="_blank">
								<span class="hide-accessible"><@liferay.language key="opens-new-window" /> </span> 
								${link_title_desc} 
								<span class="icon-external-link"></span></a>
						<#else>
							<a class="bullet bullet-url" href="${formatedURL}">${link_title_desc}</a>
						</#if>
					</li>
				</#if>				   
				<#if document?? && document.getData()?has_content >
					<#assign formatedDocument="" >
					<#if document.getData()?contains("/") >
						<#assign documentTitleField = 'ehudocumenttitle' >
						<@upvlibs.formatAttachment documentField=document documentTitleField=documentTitleField />
							<#assign formatedDocument = upvlibs.formatedDocument >
							<#if formatedDocument?? >
								<li class="document">${formatedDocument}</li> 
							</#if>
					</#if>
				</#if>
			</ul>
		</div>
	</#if>
</article>
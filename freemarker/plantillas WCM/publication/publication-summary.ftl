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

<#if ehupublicationpublishingmedia?? && ehupublicationpublishingmedia.getData()??>
	<#assign publication_media = ehupublicationpublishingmedia.getData()>
</#if>
<#if ehupublicationimpactfactor?? && ehupublicationimpactfactor.getData() !=  "0" >
	<#assign impact_factor = ehupublicationimpactfactor.getData() >
</#if>
<#if ehupublicationquartile?? >
	<#assign quartile = ehupublicationquartile.getData()>
</#if>
<#assign publication_volumen = ehupublicationvolume.getData()>
<#assign publication_init_page = ehupublicationinitpage.getData()>
<#assign publication_end_page = ehupublicationendpage.getData()>
<#assign publication_isbn = ehupublicationisbn.getData()>

<#-- se añade un control previo para poder visualizar bien los separadores: , ; - -->
<#assign showYear = ( publicationYear != "" ) && (publicationYear != txtYearUnknown) >
<#assign showVolumen = publication_volumen?has_content >
<#assign showMedia = publication_media?has_content >
<#assign showImpact = impact_factor?has_content >
<#assign showQuartile = quartile?has_content >
<#assign showPage = publication_init_page?has_content && publication_end_page?has_content >
<#assign showIsbn = publication_isbn?has_content >

<span class="publication">
	<#if ehupublicationauthor.getData()?has_content >
		<span class="author">${ehupublicationauthor.getData()}&nbsp;</span> 
	</#if>
	<#assign titleLang = ehupublicationtitle.ehutitlelang.getData()>
	<#assign linkTitle = languageUtil.get(locale,"upv-ehu-extended-information") + " " + ehupublicationtitle.getData()>
	
	<#-- Solo pintamos el span del lang="XX" si se ha seleccionado un idioma en el desplegable (Trello 579)-->
	<#-- También controlamos que el contenido no tenga seleccionado upv-ehu-blank (opción antigua "Selecciona una opción") 
				para que no aparezca el lang con eso ya que da error de validación web (Trello 579)-->
	<#if titleLang?has_content && titleLang!="default" && titleLang!="upv-ehu-blank">
		<span lang="${titleLang}">
			<span class="template-title"><strong>${ehupublicationtitle.getData()}</strong></span>
		</span>
	<#else>
		<span class="template-title"><strong>${ehupublicationtitle.getData()}</strong></span>			 
	</#if>	
	<#if showMedia >
	   	<#if showYear || showVolumen || showPage || showIsbn >
			<#if showImpact && showQuartile >
				<span class="publication-media"><em>${publication_media} <abbr title="Impact Factor">IF</abbr>: ${impact_factor} (${quartile}),&nbsp;</em></span>
			<#elseif showImpact && !showQuartile >
				<span class="publication-media"><em>${publication_media} <abbr title="Impact Factor">IF</abbr>: ${impact_factor},&nbsp;</em></span>
			<#elseif showQuartile && !showImpact >
				<span class="publication-media"><em>${publication_media} (${quartile}),&nbsp;</em></span>
			<#else>
				<span class="publication-media"><em>${publication_media},&nbsp;</em></span>
			</#if>
		<#else>
			<#if showImpact && showQuartile >
				<span class="publication-media"><em>${publication_media} <abbr title="Impact Factor">IF</abbr>: ${impact_factor} (${quartile})</em></span>
			<#elseif showImpact && !showQuartile >
				<span class="publication-media"><em>${publication_media} <abbr title="Impact Factor">IF</abbr>: ${impact_factor}</em></span>
			<#elseif showQuartile && !showImpact >
				<span class="publication-media"><em>${publication_media} (${quartile})</em></span>
			<#else>
				<span class="publication-media"><em>${publication_media}</em></span>
			</#if> 
		</#if>
   	</#if>
		
	<#if showYear >
		<#if showVolumen || showPage || showIsbn >
			<span class="publication-year">${txtPublicationYear};&nbsp;</span>	  
		 <#else>
			<span class="publication-year">${txtPublicationYear}</span>	  
		 </#if>	 
	</#if>

	<#if showVolumen >
		 <#if showPage || showIsbn >
			 <span class="publication-volume">${publication_volumen},&nbsp;</span> 
		 <#else>
			<span class="publication-volume">${publication_volumen}</span> 
		 </#if>
	</#if>
	
	<#if showPage >
		 <#if showIsbn >
			  <span class="publication-pages">${publication_init_page} - ${publication_end_page}&nbsp;-&nbsp;</span>	
		 <#else>
			 <span class="publication-pages">${publication_init_page} - ${publication_end_page}</span>	
		 </#if>
	</#if>
	<#if showIsbn >
		<span class="publication-isbn">${publication_isbn}</span>		
	</#if>	
</span>
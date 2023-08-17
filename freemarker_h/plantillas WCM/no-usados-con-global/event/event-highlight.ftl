<#assign ddmTemplateLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMTemplateLocalService") >
<#assign globalGroupId = themeDisplay.getCompanyGroupId() />
<#assign lisTemplates = ddmTemplateLocalService.getTemplatesByGroupId(globalGroupId) >
<#assign nombreTpl =  "event-comun">
<#list lisTemplates as template >
	<#if validator.isNotNull(locale) >
			<#assign templateName = template.getName(locale ) >
	<#else>
			<#assign templateName = template.getNameCurrentValue() >
	</#if>
	<#if templateName == nombreTpl >
			<#assign templateKey = template.getTemplateKey() >
	</#if>
</#list>

<#include "${templatesPath}/" + "${templateKey}" />

	
	<#-- TITLE -->
	<#if  ehugeneraldata?? &&  ehugeneraldata.ehutitle?? &&  ehugeneraldata.ehutitle.getData()??>
	    <#assign main_title = ehugeneraldata.ehutitle.getData()>
	</#if>
	
	<#-- HIGHLIGHT TITLE-->
	<#if ehuimages?? && ehuimages.ehuhighlighttitle?? && ehuimages.ehuhighlighttitle.getData()?? >
	    <#assign title = ehuimages.ehuhighlighttitle.getData()>
	</#if>
	
	<#if !title?has_content && main_title?has_content>
	     <#assign title = main_title>
	</#if>
	
	<#-- SUBTITLE-->
	<#if ehuimages?? && ehuimages.ehuhighlightsubtitle?? && ehuimages.ehuhighlightsubtitle.getData()??>
	    <#assign subtitle = ehuimages.ehuhighlightsubtitle.getData()>
	</#if>
	
	<#-- IMAGE-->
	<#if ehuimages?? >
		<#assign entImages = ehuimages >
		<#if entImages?? && entImages.ehuhighlightimage?? >
			<#assign entImage = entImages.ehuhighlightimage >
				<#if entImage?? && entImage.getData()?? >
					<#assign image = entImage.getData() >
				</#if>
		</#if>
	</#if>
	<#if image?has_content>
		<#assign hayImage = true >   
	<#else>
		<#assign hayImage = false >
	</#if>
	<#if entImage?? && entImage.ehuhighlightimagealttext?? && entImage.ehuhighlightimagealttext.getData()??>
		<#assign imageAlt = entImage.ehuhighlightimagealttext.getData() >
		<#if imageAlt?? && imageAlt?has_content>
			<#assign txtAltImg = imageAlt>
		<#else>
			<#assign txtAltImg = " ">
		</#if>
		
	</#if>
	
	<#-- HTML-->
	<div class="event">
		<#if hayImage >
			<figure class="row">
				<#if txtAltImg?? >
					<img class="col-4" alt="${txtAltImg}" src="${image}">
				</#if>
				<figcaption class="col-8">
		</#if>
		<#if title?has_content >
            <p class="card-title"><strong>${title}</strong></p> 
        </#if>
        
        <#if subtitle?has_content >     
            <p class="subtitle">${subtitle}</p>
        </#if>
		
		<p>
			<#-- Si hay fecha de inicio pero no de fin se pinta la fecha de inicio y la hora de fin. Tampoco se pinta el "Desde". -->
			<#if dateStartStr?? && dateStartStr != "" && (!dateEndStr?? || dateEndStr == "") >
				<span class="date"> 
					${ dateStartStr }
					<#if dateEndHourStr?? && dateEndMinStr?? >
						- ${ dateEndHourStr }:${ dateEndMinStr }
					</#if>
				</span>
			</#if>
			
			<#-- Si hay fecha de inicio y de fin se pintan -->
			<#if dateStartStr?? && dateStartStr != "" && dateEndStr?? && dateEndStr != "" >
				<span class="date">
					<#-- Si hay hora de fin hay que pintar una coma dentro de la fecha para que no meta un espacio en blanco por detrás -->
					<#if dateStartHourStr?? && dateStartMinStr??>
						${ dateStartReduced } - ${ dateEndReduced + ","}
					<#else>
						${ dateStartReduced } - ${ dateEndReduced }
					</#if>
					<#if dateStartHourStr?? && dateStartMinStr?? && dateEndHourStr?? && dateEndMinStr?? >
						${ dateStartHourStr }:${ dateStartMinStr } - ${ dateEndHourStr }:${ dateEndMinStr }
					<#elseif dateStartHourStr?? && dateStartMinStr??>
						${ dateStartHourStr }:${ dateStartMinStr }						
					</#if>
				</span>
			</#if>			
			
			<#if hayCity || hayProvince >
				<span class="location">
					<#if hayCity >
						<span class="city">${city}</span>
					<#else>
						<span class="province">${province}</span>
					</#if>
				</span>
			</#if>
		</p>
		
		<#if hayImage >
				</figcaption>
			</figure>
		</#if>
	</div>

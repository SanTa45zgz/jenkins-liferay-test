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

	<div class="event">
		<p>
			<#-- Hasta nuevo aviso no se pinta el "Ttulo de la comunicacin" 
			<#if hayComTitle?? && (hayComTitle?c)?boolean  >
				<#assign preTitle = '<span class="communication">' + comTitle + '</span>' >
				<span class="pretitle">${preTitle}</span> - 
			</#if>
			 -->
			<#if title?? >
				${title}
			</#if>
		</p>
		<p><small>		
			<#-- Si hay fecha de inicio pero no de fin se pinta la fecha de inicio y la hora de fin. Tampoco se pinta el "Desde". -->
			<#if dateStartStr?? && (!dateEndStr?? || dateEndStr == "") >
				<#if !dateShowReduced >
					<span class="date"> 
						${ dateStartStr }
						<#if dateEndHourStr?? && dateEndMinStr?? >
							- ${ dateEndHourStr }:${ dateEndMinStr }
						</#if>
					</span>
				<#else>
					<span class="date"> ${ dateStartStr }</span>
				</#if>
			</#if>			
			
			<#-- Si hay fecha de inicio y de fin se pintan -->
			<#if dateStartStr?? && dateEndStr?? && dateEndStr != "" >
				<#if !dateShowReduced >
					<span class="date">
						<#-- Si hay hora de fin hay que pintar una coma dentro de la fecha para que no meta un espacio en blanco por detrs -->
						<#if dateStartHourStr?? && dateStartMinStr??>
							${ dateStartReduced } - ${ dateEndReduced + ","}
						<#else>
							${ dateStartReduced } - ${ dateEndReduced }
						</#if>
						<#-- Si hay hora de inicio y de fin se pintan --> 
						<#if dateStartHourStr?? && dateStartMinStr?? && dateEndHourStr?? && dateEndMinStr?? >
							${ dateStartHourStr }:${ dateStartMinStr } - ${ dateEndHourStr }:${ dateEndMinStr }
						<#-- Si solo hay hora de inicio se pinta. Si solo hay de fin no -->
						<#elseif dateStartHourStr?? && dateStartMinStr??>
							${ dateStartHourStr }:${ dateStartMinStr }						
						</#if>
					</span>
				<#else>
					<span class="date">
						${ dateStartReduced } - ${ dateEndReduced }
					</span>
				</#if>				
			</#if>
			
			
			<#if (hayCity?? && (hayCity?c)?boolean) || (hayProvince?? && (hayProvince?c)?boolean)  >
				<span class="location">
					<#if hayCity >
						<span class="city">${city}</span>
					<#else>
						<span class="province">${province}</span>
					</#if>
				</span>
			</#if>
		</small></p>

	</div>

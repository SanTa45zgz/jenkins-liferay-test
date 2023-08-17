<#assign ddmTemplateLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMTemplateLocalService") >
<#assign globalGroupId = themeDisplay.getCompanyGroupId() />
<#assign lisTemplates = ddmTemplateLocalService.getTemplatesByGroupId(globalGroupId) >
<#assign nombreTpl =  "help-dates-general">
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


<#include "${templatesPath}/${templateKey}" />

	<#assign entGeneralData = ehugeneraldata >
	<#assign title = entGeneralData.ehutitle.getData() >

	<#if hayErrorDates?? && hayErrorDates >
		<#if msgErrorDates?? >
			<p class="portlet-msg-error">${msgErrorDates}</p>
		</#if>
	<#else>
		<div>
			<#-- Cambio para que el nombre del link en el publicador no sea demasiado grande
			 # y salte error de accesibilidad en informe del ministerio.
			 # El título no se pinta aqui, sino en la plantilla resumen del publicador (isHelp).
			 #	<span class="help-title">${title}</span>
			-->
			<small>
				<#-- ESTADO, SITUACION-->
				<#if helpStateIcon?has_content && helpStateMsg?has_content>
					<img class="help-icon" src="${helpStateIcon}" alt=""/>
					<span class="help-state">${helpStateMsg}</span> 
				</#if>

				<#-- AVISO-->
				<#assign helpAdvice = entGeneralData.ehuadvice.getData() >
				<#if helpAdvice?has_content>
					<span class="portlet-msg-alert">${helpAdvice}</span>
				</#if>
			</small>
		</div>
	</#if>

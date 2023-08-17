<#--
Nombre contenido (ES): Ayuda, beca o subvención
Estructura: global > help.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/ayuda
Nota: Se usa con global-theme y con ehu-theme
-->

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
<#assign cEhuEntity = "UPV/EHU" >
<#assign cSepEntities = "|" >
<#assign cExpRegSepEntities = "[" + cSepEntities + "]" >

<#assign cHelpDescTypeText = "text" >
<#assign cHelpDescTypeInfo = "information" >
<#assign cHelpDescTypeAlert = "alert" >

<#assign entGeneralData = ehugeneraldata >
<#assign title = entGeneralData.ehutitle.getData() >

<#if hayErrorDates?? && (msgErrorDates?has_content || helpStateMsg?has_content)>
	<p class="portlet-msg-error">${helpStateMsg}</p>
</#if>
		
	
<article class="help">
	<header>
		<#-- TITULO-->
		<h1>${title}</h1>

		<#-- TIPO -->
		<#assign helpType = entGeneralData.ehutype.getData() >
		<#if helpType?has_content>
			<#if !validator.equals(helpType, cOptionBlank ) >
				<h2><small>${languageUtil.get(locale, helpType )}</small></h2>
			</#if>
		</#if>

		<#-- ESTADO, SITUACION -->
		<#if helpStateIcon?has_content >
			<p class="help-state">
				<img class="help-icon" src=${helpStateIcon} alt=""/>
					${helpStateMsg}
			</p> 
		</#if>
		<#-- ENTIDADES INVOLUCRADAS -->
		<@upvlibs.VocabFormatCategories vocabularyName="Gobernu organoak" show=false divClass="" />
		<#assign orgsOfGovern = upvlibs.catString>
					
		<#if orgsOfGovern?has_content>
			<@upvlibs.VocabFormatCategories vocabularyName="Erakundeak" show=false divClass="" />
			<#assign entities =  upvlibs.catString> 
			<#assign addEhuEntityStr = " - " + cEhuEntity >
			<#assign helpArrOrgs = orgsOfGovern?split(cSepEntities) >
			<#if helpArrOrgs??>
				<#assign numOrgs = helpArrOrgs?size >
			<#else>
				<#assign numOrgs = 0>
			</#if>
			<#assign aci_array = arrayUtil.append(helpArrOrgs, addEhuEntityStr) >
			<#assign helpArrOrgs = aci_array>
			<#assign orgsOfGovern = helpArrOrgs?join(", ") >
		
			<#assign helpEntities = orgsOfGovern + cSepEntities + entities >
			<#assign helpArrEntities = helpEntities?split(cSepEntities ) >
			<#if helpArrEntities??>
				<#assign numEntities = helpArrEntities?size >
			<#else>
				<#assign numEntities = 0>
			</#if>
		
			<#if numEntities?? && ((numEntities > 0)?c)?boolean>
				<div class="entities">
					<#if ((numEntities == 1)?c)?boolean>
						<#assign entLang = "ehu.calling-entity" >
					<#else>
						<#assign entLang = "ehu.calling-entities" >
					</#if>
					<h2>${languageUtil.get(locale, entLang )}</h2>
					<ul>
						<#assign ind = 0 >
						<#assign class = "organs_of_goverment" >
						<#list helpArrEntities as entity>
							<#if ((ind == numOrgs)?c)?boolean>
								<#assign class = "entity" >
							</#if>
							<li><span class=${class}>${entity}</span></li>
							<#assign ind = ind + 1 >
						</#list>
					</ul>
				</div>
			</#if>
		</#if>
	</header>

	<#-- AVISO -->
	<#assign helpAdvice = entGeneralData.ehuadvice.getData() >
	<#if helpAdvice?has_content>
		<p class="portlet-msg-info">${helpAdvice}</p>
	</#if>

	<#-- CONTACTO -->
	<#assign entHelpContactData = ehucontactdata >
	<#assign entHelpContact = entHelpContactData.ehucontact >
	<#assign entHelpMailData = entHelpContactData.ehuemailtext >
	<#assign entHelpPhoneData = entHelpContactData.ehuphonetext >
	
	<#assign hayArrElems = getterUtil.getBoolean("false")>
	<#if entHelpContact??>
		<#assign hayArrElems = upvlibs.hasElement(entHelpContact) >
	</#if>
	<#assign hayHelpContact = entHelpContact?? &&  hayArrElems >
		
	<#assign hayArrElemsMail = getterUtil.getBoolean("false")>
	<#if entHelpMailData.ehuemail??>
		<#assign hayArrElemsMail = upvlibs.hasElement(entHelpMailData.ehuemail) >
	</#if>	
	<#assign hayHelpMail = hayArrElemsMail >
	
	<#assign hayArrElemsPhone = getterUtil.getBoolean("false")>
	<#if entHelpPhoneData.ehuphone??>
		<#assign hayArrElemsPhone = upvlibs.hasElement(entHelpPhoneData.ehuphone) >
	</#if>
	<#assign hayHelpPhone = hayArrElemsPhone >
	
							
	<#assign hayDatosContact = hayHelpContact || hayHelpMail || hayHelpPhone >
	
	<#-- SECCIONES -->
	<#assign entHelpSections = ehusection >
	<#assign helpArrSections = entHelpSections.getSiblings() >

	<#-- SECCIONES: PESTAINAS -->
	<#assign hayArrSectionElems = getterUtil.getBoolean("false")>
	<#if entHelpSections.ehusectionname??>
		<#assign hayArrSectionElems = upvlibs.hasElement(entHelpSections.ehusectionname) >
	</#if>		
	<#assign hayHelpSectionsName = entHelpSections.ehusectionname?? &&  hayArrSectionElems>
	<#assign hayHelpSectionTabs = hayHelpSectionsName || hayDatosContact >
	
	<#if hayHelpSectionTabs >
		<section id="tab">
			<ul class="nav nav-tabs" role="tablist" aria-label='<@liferay.language key="ehu.content-sections-menu" />'>
	</#if>

	<#assign ind = 0 >
	<#list helpArrSections as tab>
		<#assign helpSectionTitle = tab.ehusectionname.getData() >
		<#if helpSectionTitle?has_content >
			<#assign tabHref = "#tab" + ind >
			<li>
				<a href=${tabHref}>${helpSectionTitle}</a>
			</li>
		</#if>
		<#assign ind = ind + 1 >
	</#list>
	<#if hayDatosContact >
		<#assign tabHref = "#tab" + ind >
		<li><a href=${tabHref}>${languageUtil.get(locale, "ehu.contact-data" )}</a></li>
	</#if>
	<#if hayHelpSectionTabs >
		</ul>
	</#if>

	<#-- SECCIONES: CONTENIDOS -->
	<#assign numHelpSections = helpArrSections?size>
	<#if ((numHelpSections > 0)?c)?boolean>
		<div class="tab-content">
	</#if>

	<#assign ind = 0 >
	<#list helpArrSections as tab>
		<#assign helpSectionTitle = tab.ehusectionname.getData() >
		<#if helpSectionTitle?has_content>
			<#assign tabId = "tab" + ind >
			<div id="${tabId}">
				<h2 class="hide-accessible">${helpSectionTitle}</h2>
				<#assign entHelpSectionDescs = tab.ehudescription >
				<#assign entHelpSectionDocs = tab.ehudocuments >
				<#assign entHelpSectionUrls = tab.ehuurls >
				
				<#assign hayHelpSectionDescs = getterUtil.getBoolean("false")>
				<#if entHelpSectionDescs??>
					<#assign hayHelpSectionDescs = upvlibs.hasElement(entHelpSectionDescs) >
				</#if> 
				<#assign hayHelpSectionDocs = getterUtil.getBoolean("false")>
				<#if entHelpSectionDocs??>
					<#assign hayHelpSectionDocs = upvlibs.hasElement(entHelpSectionDocs) >
				</#if> 
				<#assign hayHelpSectionUrls = getterUtil.getBoolean("false")>
				<#if entHelpSectionUrls??>
					<#assign hayHelpSectionUrls = upvlibs.hasElement(entHelpSectionUrls)>
				</#if>
				<#assign hayHelpSectionContent = hayHelpSectionDescs || hayHelpSectionDocs || hayHelpSectionUrls >
				
				<#if !hayHelpSectionContent >
					<p>${languageUtil.get(locale, "ehu.there-is-no-information-for-this-section" )}</p>
				<#else>
					<#if hayHelpSectionDescs >
						<#assign helpArrSectionDescs = entHelpSectionDescs.getSiblings() >
						<#list helpArrSectionDescs as elem>
							<#assign helpSectionDesc = elem.getData() >
							<#if helpSectionDesc?has_content> 	
								<#assign sectionDesc = helpSectionDesc?replace( "\n", "<br />" )>
								<#assign sectionDesc = sectionDesc?replace( "\\/", "/" )>
								<#assign helpSectionDescType = elem.ehudescriptiontype.getData() >
								<#assign classTxt = "" >
								<#if helpSectionDescType == cHelpDescTypeInfo >
									<#assign classTxt = ' class="portlet-msg-info"' >
								<#elseif helpSectionDescType == cHelpDescTypeAlert >
									<#assign classTxt = ' class="portlet-msg-alert"' >
								</#if>
								<#assign htmlTxt = "<p" + classTxt + ">" + sectionDesc + "</p>" >
								${htmlTxt}
							</#if>
						</#list>
					</#if>
					<#if hayHelpSectionDocs >
						<@upvlibs.writeHtmlForDocs entradaInfo=entHelpSectionDocs nomEntradaTit="ehudocumentname" nomEntradaVal="" nivelHIni=3 />
					</#if>
					<#if hayHelpSectionUrls >
						<@upvlibs.writeHtmlForLinks entradaInfo=entHelpSectionUrls nomEntradaTit="ehuurldescription" nomEntradaVal="" nivelHIni=3 nomEntrNewTab="ehunewtab" newTab=true />
					</#if>
				</#if>
			</div>
		</#if>
		<#assign ind = ind + 1 >
	</#list>
	
	<#if hayDatosContact >
		<#assign tabId = "tab" + ind >
		<div id="${tabId}">
			<h2 class="hide-accessible">${languageUtil.get(locale, "ehu.contact-data" )}</h2>
					
			<#if hayHelpContact?? && hayHelpContact>
				<#if entHelpContact?is_hash >
					<#assign valor = entHelpContact.getData() >
				<#else>
					<#assign valor = getterUtil.getString(entHelpContact) >
				</#if>
				<#if valor?? >
					<p><strong>${languageUtil.get(locale, "contact" )}: ${valor}</strong></p>
				<#else>
					<p><strong>${languageUtil.get(locale, "contact" )}</strong></p>
				</#if>
			</#if>
			<#if hayHelpMail?? && hayHelpMail>
				<@upvlibs.writeHtmlForMails entradaInfo=entHelpMailData nomEntradaTit="" nomEntradaVal="ehuemail" nivelHIni=3/>
			</#if>
			<#if hayHelpPhone?? && hayHelpPhone>
				<@upvlibs.writeHtmlForPhones entradaInfo=entHelpPhoneData nomEntradaTit="" nomEntradaVal="ehuphone" nivelHIni=3/>
			</#if>
		</div>
	</#if>

	<#if ((numHelpSections > 0)?c)?boolean>
		</div>
	</#if>
	<#if hayHelpSectionTabs >
		</section>
	</#if>
</article>



<#-- GESTION PESTAINAS -->
<script>
	AUI().use(
		'aui-tabview',
		function( A ) {
			var tabs = new A.TabView( { srcNode: '#tab' } );
			tabs.render();
		}
	);
</script>
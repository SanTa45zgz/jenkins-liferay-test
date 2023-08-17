<#assign upvEhuBlank = "upv-ehu-blank" >
<#assign langId = localeUtil.fromLanguageId(request.locale ) >
<#assign langIsEU = langId == "eu_ES" >
<#if langIsEU >
	<#assign genDateFormat = "yyyy-MM-dd" >
<#else>
	<#assign genDateFormat = "dd-MM-yyyy" >
</#if>

<#assign entGeneral = ehugeneraldata >
<#assign call_title = entGeneral.ehugeneraldatatitle.getData() >
<#assign call_type = entGeneral.ehutype.getData() >
<#assign call_phase_title_literal = languageUtil.get(locale, "ehu.bases" ) >
<#assign entLangPhaseState = "" >
<#assign callPhaseDateStr = "" >
<#assign arrPhases = ehuphases.getSiblings() >
<#assign numPhases = arrPhases?size>

<#if ((numPhases > 0)?c)?boolean >
	<#assign numCallPhase = numPhases - 1 >
	<#assign call_phase = arrPhases[numCallPhase] >
	<#assign call_phase_title = call_phase.ehuphasetitle.getData() >
	<#if call_phase_title?has_content >
		<#if call_phase_title != upvEhuBlank >
			<#assign entLanguage = "upv-ehu-" + call_phase_title >
			<#assign call_phase_title_literal = languageUtil.get(locale, entLanguage ) >
		</#if>
	</#if>

	<#-- Mirar el estado en el que se encuentra la fase. Se comienza a comprobar si se encuentra en el
	## estado final, luego en el estado provisional y finalmente en el estado inicial.
	## ---------------------------------------------------------------------------------------------------
	## Una fase esta en estado final si se muestra la fecha de publicacion o si existen documentos o notas 
	## Se reinicializan el numero de notas y documentos-->
	
	<#assign entFinalState = call_phase.ehufinalstate >
	<#assign existFinalPublicationDate = getterUtil.getBoolean("false")>
	<#if entFinalState.ehufinalstatedocument??>	
		<#assign existFinalPublicationDate = upvlibs.hasElement(entFinalState.ehufinalstatedocument) && entFinalState.ehufinalstatedate.getData() !="">
	</#if>
	<#assign existFinalDocuments = getterUtil.getBoolean("false")>
	<#if entFinalState.ehufinalstatedocument??>	
		<#assign existFinalDocuments = upvlibs.hasElement(entFinalState.ehufinalstatedocument)>
	</#if>
	<#assign existFinalNotes = getterUtil.getBoolean("false")>
	<#if entFinalState.ehufinalstatenotes??>	
		<#assign existFinalNotes = upvlibs.hasElement(entFinalState.ehufinalstatenotes)>
	</#if>

	
	<#if existFinalPublicationDate || existFinalNotes || existFinalDocuments >
		<#assign entLangPhaseState = "upv-ehu-final-result" >
		<#if existFinalPublicationDate >
		    <@upvlibs.getFormatedDate field=entFinalState.ehufinalstatedate dateFormat=genDateFormat llocale=locale />
		       <#assign callPhaseDateStr = upvlibs.fDate>
		</#if>
	<#else>
		<#---------------------------------------------------------------------------------------------------
		## Una fase esta en estado provisional si se muestra la fecha de publicacion o si existen documentos o notas 
		## Se reinicializan el numero de notas y documentos-->
		
		<#assign entProvisionalState = call_phase.ehuprovisionalstate >
		<#assign existProvisionalPublicationDate = getterUtil.getBoolean("false")>
		<#if entProvisionalState.ehuprovisionalstatedate??>
			<#assign existProvisionalPublicationDate = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatedate)>
		</#if>
		<#assign existProvisionalDocuments = getterUtil.getBoolean("false")>
		<#if entProvisionalState.ehuprovisionalstatedocument??>
			<#assign existProvisionalDocuments = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatedocument) >
		</#if>
		<#assign existProvisionalNotes = getterUtil.getBoolean("false")>
		<#if entProvisionalState.ehuprovisionalstatenotes??>
			<#assign existProvisionalNotes = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatenotes) >
		</#if>
		
		<#if existProvisionalPublicationDate || existProvisionalNotes || existProvisionalDocuments >
			<#assign entLangPhaseState = "upv-ehu-provisional-result" >
			<#if existProvisionalPublicationDate >
			    <@upvlibs.getFormatedDate field=entProvisionalState.ehuprovisionalstatedate dateFormat=genDateFormat llocale=locale />
			        <#assign callPhaseDateStr = upvlibs.fDate >
			</#if>
		<#else>
			<#---------------------------------------------------------------------------------------------------
			## Una fase esta en estado inicial (anuncio) si se muestra la fecha de publicacion o si existen documentos, direcciones web o notas 
			## Se reinicializan el numero de notas, documentos y direcciones web -->
			
			<#assign entInfoState = call_phase.ehuinfostate >
			<#assign existInfoPublicationDate = getterUtil.getBoolean("false")>
			<#if entInfoState.ehuinfostatedate??>
				<#assign existInfoPublicationDate = upvlibs.hasElement(entInfoState.ehuinfostatedate) && entInfoState.ehuinfostatedate.getData() !="">
			</#if>	
			<#assign existInfoDocuments = getterUtil.getBoolean("false")>
			<#if entInfoState.ehuinfostatedocument??>
				<#assign existInfoDocuments = upvlibs.hasElement(entInfoState.ehuinfostatedocument) >
			</#if>
			<#assign existInfoUrls = getterUtil.getBoolean("false")>
			<#if entInfoState.ehuurls??>
				<#assign existInfoUrls = upvlibs.hasElement(entInfoState.ehuurls) >
			</#if>
			<#assign existInfoNotes = getterUtil.getBoolean("false")>
			<#if entInfoState.ehuinfostatenotes??>
				<#assign existInfoNotes = upvlibs.hasElement(entInfoState.ehuinfostatenotes) >
			</#if>
			
			<#if existInfoPublicationDate || existInfoNotes || existInfoDocuments || existInfoUrls >
				<#assign entLangPhaseState = "upv-ehu-advertisement" >
				<#if existInfoPublicationDate >
				    <@upvlibs.getFormatedDate field=entInfoState.ehuinfostatedate dateFormat=genDateFormat llocale=locale />
				    <#assign callPhaseDateStr = upvlibs.fDate >
				</#if>
			</#if>
		</#if>
	</#if>
</#if>

<span class="call">
	<span class="summary-title">
		${call_title}
		<#if call_type != upvEhuBlank >
			<#assign entLangCallType = "upv-ehu-" + call_type >
			<#assign call_type_literal = "(" + languageUtil.get( locale, entLangCallType ) + ")" >
			<#assign callTypeTxt= "<small>" + call_type_literal + "</small>" >
			${callTypeTxt}
		</#if>
	</span>
	<br/>
	<small><strong>
		${call_phase_title_literal} 
		<#if entLangPhaseState?has_content> 
			- ${languageUtil.get( locale, entLangPhaseState )}
		</#if>
		<#if callPhaseDateStr?has_content >
			(${callPhaseDateStr})
		</#if>
	</strong></small>        
</span>

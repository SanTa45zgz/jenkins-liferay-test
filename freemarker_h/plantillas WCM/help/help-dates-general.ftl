<#--
Nombre contenido (ES): Ayuda, beca o subvención
Estructura: global > help.json
Plantilla (ES): help-dates-general
URL: https://dev74.ehu.eus/es/web/pruebas/ayuda
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign isGlobal = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
<#if !isGlobal >
	<#assign cIconPath = "/o/ehu-theme/images" >
<#else>
	<#assign cIconPath = "/o/upv-ehu-global-theme/images" >
</#if>
<#assign cIconSuccess = cIconPath + "/messages/success.png" >
<#assign cIconError = cIconPath + "/messages/error.png" >
<#assign cIconAlert = cIconPath + "/messages/alert.png" >
<#assign cIconAdvice = cIconPath + "/common/activate.png" >

<#assign cOptionBlank = "upv-ehu-blank" >
<#assign cHelpStateOpen = "upv-ehu-open" >
<#assign cHelpStateClosed = "upv-ehu-closed" >

<#assign cMsgError = languageUtil.get( locale, "ehu.error" ) + ". " >

<#assign nowDate = dateUtil.newDate() >

<#assign entGeneralData = ehugeneraldata >

<#-- FECHAS -->
<#if entGeneralData.ehuinitdate?? >
	<#assign entStartDate = entGeneralData.ehuinitdate >
</#if>
<#if entGeneralData.ehuenddate?? >
	<#assign entEndDate = entGeneralData.ehuenddate >
</#if>
<#if entGeneralData.ehuenddate.ehuenddatehourhh?? >
	<#assign entEndDatehh = entGeneralData.ehuenddate.ehuenddatehourhh >
</#if>
<#if entGeneralData.ehuenddate.ehuenddatehourmm?? >
	<#assign entEndDatemm = entGeneralData.ehuenddate.ehuenddatehourmm >
</#if>

<#if entStartDate?? && entStartDate?is_hash >
	<#assign startDateStr = entStartDate.getData() >
<#else>
	<#assign startDateStr = getterUtil.getString(entStartDate) >
</#if>

<#if entEndDatehh?? && entEndDatehh?is_hash >
	<#assign endDatehhStr = entEndDatehh.getData() >
<#else>
	<#assign endDatehhStr = getterUtil.getString(entEndDatehh) >
</#if>

<#if entEndDatemm?? && entEndDatemm?is_hash >
	<#assign endDatemmStr = entEndDatemm.getData() >
<#else>
	<#assign endDatemmStr = getterUtil.getString(entEndDatemm) >
</#if>

<#-- Si la hora o el minuto es 04 nos llega solo 4 así que hay que arreglarlo -->
<#if endDatehhStr??  && (endDatehhStr?length == 1) >
	<#assign endDatehhStr = 0 + endDatehhStr >
</#if>

<#if endDatemmStr??  && (endDatemmStr?length == 1) >
	<#assign endDatemmStr = 0 + endDatemmStr >
</#if>

<#if entEndDate?? && entEndDate?is_hash >
	<#assign endDateStr = entEndDate.getData() >
<#else>
	<#assign endDateStr = getterUtil.getString(entEndDate) >
</#if>

<#assign arrayStartDate = startDateStr?split( "-" ) >
<#assign yearS = arrayStartDate[0]>
<#assign monthS = arrayStartDate[1]>
<#assign dayS = arrayStartDate[2]>
<#assign arrayEndDate = endDateStr?split( "-" ) >
<#assign yearE = arrayEndDate[0]>
<#assign monthE = arrayEndDate[1]>
<#assign dayE = arrayEndDate[2]>

<#if entStartDate??>
	<#if languageUtil.getLanguageId(locale) == "eu_ES" >
		<#assign pattern = "yyyy/MM/dd" >
		<#assign startDateStr = yearS + "/" + monthS + "/" + dayS>
	<#else>
		<#assign pattern = "dd/MM/yyyy" >
		<#assign startDateStr = dayS + "/" + monthS + "/" + yearS>
	</#if>
	<#assign startDate = dateUtil.parseDate(pattern, startDateStr, locale)>
</#if>
	

<#if entEndDate??>	
	<#if languageUtil.getLanguageId(locale) == "eu_ES" >	
		<#assign endDateStr = yearE + "/" + monthE + "/" + dayE>		
		<#if entEndDatehh?? && endDatehhStr?has_content && entEndDatemm?? && endDatemmStr?has_content>
			<#assign patternEnd = "yyyy/MM/dd HH:mm" >
			<#assign endDateStr = endDateStr + " " + endDatehhStr + ":" +  endDatemmStr>
		<#else>
			<#assign patternEnd = "yyyy/MM/dd" >
		</#if>
	<#else>
		<#assign endDateStr = dayE + "/" + monthE + "/" + yearE>
		<#if entEndDatehh?? && endDatehhStr?has_content && entEndDatemm?? && endDatemmStr?has_content>
			<#assign patternEnd = "dd/MM/yyyy HH:mm" >
			<#assign endDateStr = endDateStr + " " + endDatehhStr + ":" +  endDatemmStr>
		<#else>
			<#assign patternEnd = "dd/MM/yyyy" >
		</#if>
	</#if>
	<#assign endDate = dateUtil.parseDate(patternEnd, endDateStr, locale)>	
</#if>

<#assign msgErrorDates = "" >	
<#if validator.isNotNull(startDate) && validator.isNotNull(endDate)>
	<#if (endDate?datetime < startDate?datetime)>
		<#assign msgErrorDates = languageUtil.get( locale, "ehu.error" )  +  ". " + languageUtil.get(locale, "ehu.deadline-presentation" ) + ": " + languageUtil.get(locale, "ehu.start-date-later-than-end-date ")>
	</#if>
</#if>

<#if entStartDate.ehushowinitdate?? && entStartDate.ehushowinitdate?has_content >
	<#-- <#assign showbulletinDate = getterUtil.getBoolean(entBulletinPublicationDate.ehubulletinpublicationdateshow.getData() ) > -->
	<#assign showInitDate = getterUtil.getBoolean(entStartDate.ehushowinitdate.getData(), false ) > 
	<#-- <#assign showInitDate = ehugeneraldata.ehuinitdate.ehushowinitdate.getData() > -->
</#if>
<#if entEndDate.ehushowenddate?? && entEndDate.ehushowenddate?has_content >
	<#assign showEndDate = getterUtil.getBoolean(entEndDate.ehushowenddate.getData(), false ) >
	<#-- <#assign showEndDate = ehugeneraldata.ehuenddate.ehushowenddate.getData() > -->
</#if>

<#if startDateStr?? && endDateStr?? && showInitDate && showEndDate >
	<#if startDateStr != endDateStr >
		<#assign msgRangoDates = " (" + startDateStr + " - " + endDateStr + ")" >
	<#else>
		<#assign msgRangoDates = " (" + startDateStr + ")" >
	</#if>
<#elseif startDateStr?has_content && showInitDate >
	<#assign msgRangoDates = " (" + languageUtil.get( locale, "ehu.deadline-init-date" ) + ": " + startDateStr + ")" >
<#elseif endDateStr?has_content && showEndDate >
	<#assign msgRangoDates = " (" + languageUtil.get( locale, "ehu.deadline-end-date" ) + ": " + endDateStr + ")" >
<#else>
	<#assign msgRangoDates = "" >
</#if>


<#-- ESTADO, SITUACION -->	
<#assign helpStateIcon = cIconSuccess >
<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-open" ) + msgRangoDates >
<#assign compruebaFechas = entStartDate?? && entEndDate?? >

<#assign helpState = entGeneralData.ehustate.getData() >
<#if helpState?has_content >
	<#if helpState == cHelpStateClosed >		
		<#assign helpStateIcon = cIconError >
		
		<#if showInitDate == true || showEndDate == true>
			<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-close" ) + msgRangoDates >
			<#assign compruebaFechas = true >
		<#else>
			<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-close" ) >
			<#assign compruebaFechas = false >
		</#if>
	</#if>
	<#if helpState == cHelpStateOpen >				
		<#if showInitDate == true || showEndDate == true>
			<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-open" ) + msgRangoDates >
			<#assign compruebaFechas = true >
		<#else>
			<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-open" ) >
			<#assign compruebaFechas = false >
		</#if>
		
	</#if>
	
</#if>

<#if compruebaFechas >
	<#-- Fecha actual anterior a la fecha de inicio del plazo-->
	<#if (nowDate?datetime < startDate?datetime) >
		<#assign helpStateIcon = cIconAdvice >
		<#if msgRangoDates?? >
			<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-not-open" ) + msgRangoDates >
		</#if>
	<#-- Fecha actual posterior a la fecha de fin del plazo-->
	<#elseif (nowDate?datetime > endDate?datetime) >
		<#assign helpStateIcon = cIconError >
		<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-presentation-close" ) + msgRangoDates >
	<#-- Fecha  inicio igual a fecha de fin-->
	<#elseif (startDate?datetime == endDate?datetime)  >
		<#assign helpStateIcon = cIconError >
		<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-init-date-equal-end-date" ) + msgRangoDates >
	<#-- Fecha  inicio mayor que fecha de fin-->
	<#elseif (startDate?datetime > endDate?datetime) >
		 <#assign helpStateIcon = cIconError >
		<#assign helpStateMsg = languageUtil.get( locale, "ehu.deadline-init-date-greater-than-end-date" ) + msgRangoDates >
	</#if>
</#if>
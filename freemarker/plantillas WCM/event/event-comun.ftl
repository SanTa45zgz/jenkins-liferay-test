<#--
 # Plantilla para importar por otras plantillas para el
 # tipo Evento.
 # Se debe definir sin estar asignada a ningun tipo de contenido:
 #		event-comun
-->

<#-- GENERAL -->
<#assign langIsEU = languageUtil.getLanguageId(locale) == "eu">
<#if langIsEU?? >
	<#if langIsEU >
		<#assign genDateFormatMY = "yyyy/MM" >
	<#else>
		<#assign genDateFormatMY = "MM/yyyy" >
	</#if>
	<#if langIsEU >
		<#assign genDateFormatDMY = "${ genDateFormatMY }/dd" >
	<#else>
		<#assign genDateFormatDMY = "dd/${ genDateFormatMY }" >
	</#if>
</#if>

<#-- PRETITLE -->

<#if (ehucommunicationinformation.ehucommunicationtitle.getData())??  >
	<#if ehucommunicationinformation.ehucommunicationtitle.getData()?? && ehucommunicationinformation.ehucommunicationtitle.getData() != "" >
		<#assign comTitle = ehucommunicationinformation.ehucommunicationtitle.getData() >
	<#else>
		<#assign comTitle = "" >
	</#if>
</#if>
<#if comTitle?? && (comTitle != "")  >
	<#assign hayComTitle = getterUtil.getBoolean("true" )>
<#else>
	<#assign hayComTitle = getterUtil.getBoolean("false" ) >
</#if>

<#-- TITLE -->
<#assign entGeneralData = ehugeneraldata >
<#assign title = entGeneralData.ehutitle.getData() >

<#-- DATES -->
<#assign entDateStart = entGeneralData.ehustartdatehour >
<#assign dateShowReduced = false >


<#if (entDateStart.ehushowonlyyearmonth)??  >
	<#assign entDateShowReduced = entDateStart.ehushowonlyyearmonth >
</#if>
<#if (entDateShowReduced.getData())??  >
	<#assign dateShowReduced = getterUtil.getBoolean( entDateShowReduced.getData(), false ) >
</#if>
<#if dateShowReduced??  >
	<#if dateShowReduced >
		<#assign dateFormat = genDateFormatMY >
	<#else>
		<#assign dateFormat = genDateFormatDMY >
	</#if>
</#if>

<#setting date_format=dateFormat>
<#setting locale = locale>

<#assign entDateEnd = entGeneralData.ehuenddatehour >
<#if entDateEnd?is_hash >
	<#assign aux = entDateEnd.getData() >
<#else>
	<#assign aux = getterUtil.getString( entDateEnd) >
</#if>
<#if aux?? && aux != "" >
	<#assign dateEndComun = aux>
<#else>
	<#assign dateEndComun = "" >
</#if>

<#assign entDateStart = entGeneralData.ehustartdatehour >
<#if entDateStart?is_hash >
	<#assign aux = entDateStart.getData() >
<#else>
	<#assign aux = getterUtil.getString( entDateStart) >
</#if>
<#if aux?? && aux != "" >
	<#assign dateStartComun = aux >
<#else>
	<#assign dateStartComun = "" >
</#if>

<#-- Hora y minuto de fin -->
<#if entGeneralData.ehuenddatehourhh?? && entGeneralData.ehuenddatehourhh.getData()!= "">
	<#assign dateEndHourStr = entGeneralData.ehuenddatehourhh.getData() >
</#if>
<#if entGeneralData.ehuenddatehourmm?? && entGeneralData.ehuenddatehourmm.getData()!= "">
	<#assign dateEndMinStr = entGeneralData.ehuenddatehourmm.getData() >
</#if>

<#-- Si la hora o el minuto es 04 nos llega solo 4 así que hay que arreglarlo -->
<#if dateEndHourStr??  && (dateEndHourStr?length == 1) >
	<#assign dateEndHourStr = 0 + dateEndHourStr >
</#if>

<#if dateEndMinStr??  && (dateEndMinStr?length == 1) >
	<#assign dateEndMinStr = 0 + dateEndMinStr >
</#if>


<#if dateFormat??  && dateStartComun?? && dateStartComun!= "" && locale??>
	<#assign dateStart = (dateStartComun?datetime("yyyy-MM-dd"))?date>
	<#assign fDate = dateStart?string>
</#if>
<#if fDate??  >
	<#assign dateStartStr = fDate >
	<#-- fecha sin horas -->
	<#assign dateStartReduced = dateStartStr?keep_before(",") >
</#if>
<#if dateShowReduced?? >
	<#if !dateShowReduced >
		<#if entGeneralData.ehustartdatehourhh?? && !(entGeneralData.ehustartdatehourhh.getData() == "") >
		<#-- <#if entGeneralData.ehustartdatehourhh?? && validator.isNotNull( entGeneralData.ehustartdatehourhh.getData() ) > -->
			<#if entGeneralData.ehustartdatehourhh?? >
				<#assign entRaizHourMin = entGeneralData >
			<#else>
				<#assign entRaizHourMin = entDateStart >
			</#if>
		</#if>
		<#if entRaizHourMin??  > 
			<#assign entStartHour = entRaizHourMin.ehustartdatehourhh >
			<#assign entStartMin = entRaizHourMin.ehustartdatehourmm >
		</#if>
		<#if entStartHour??  >
			<#if entStartHour.getData()?? && entStartHour.getData() != "" >
				<#assign dateStartHourStr = entStartHour.getData() >
			<#else>
				<#assign dateStartHourStr = "0" >
			</#if>
		</#if>
		<#if entStartMin??  > 
			<#if entStartMin.getData()?? && entStartMin.getData() != "" >
				<#assign dateStartMinStr = entStartMin.getData() >
			<#else>
				<#assign dateStartMinStr = "0" >
			</#if>
		</#if>
		
		<#-- Si la hora o el minuto es 04 nos llega solo 4 así que hay que arreglarlo -->
		<#if dateStartHourStr??  && (dateStartHourStr?length == 1) >
			<#assign dateStartHourStr = 0 + dateStartHourStr >
		</#if>
		
		<#if dateStartMinStr??  && (dateStartMinStr?length == 1) >
			<#assign dateStartMinStr = 0 + dateStartMinStr >
		</#if>
					
		<#--
		## ============================================================================================
		## OJO: antes no se mostraba la informacion extendida sobre la fecha de inicio si era la hora 0
		## ============================================================================================
		-->
		<#if dateStartHourStr??  >
			<#if dateStartMinStr??  >
				<#assign formatLong = !( ( dateStartHourStr == "0" ) && ( dateStartMinStr == "0" ) ) >		
				<#if formatLong >
					<#assign dateFormatLong = dateFormat + ", HH:mm" >
					<#if dateStartStr?? >
						<#assign dateStartAll = dateStartStr + ", " + dateStartHourStr + ":" + dateStartMinStr >					
						<#-- <#setting date_format= dateFormatLong > -->
						<#if dateFormatLong?? >
							<#assign dateStart = ( dateStartAll?datetime( dateFormatLong ) )?date >
							<#if dateStart?? >			
								<#assign dateStartStr = dateUtil.getDate(dateStart, dateFormatLong, locale) >			
							</#if>
						</#if>
					</#if>
				</#if>
			</#if>
		</#if>
	</#if>
</#if>

<#-- Planner 746. Pintar el día de fin solo con que tenga valor y eliminar el check que lo controlaba -->
<#-- <#if dateShowEnd > -->
<#if dateEndComun?? && dateEndComun != "">
	<#if dateFormat?? && dateEndComun?? && locale??>
		<#assign dateEnd = (dateEndComun?datetime("yyyy-MM-dd"))?date>
		<#assign fEDate = dateEnd?string>
			
	</#if>
	<#if fEDate??  >
		<#assign dateEndStr = fEDate >
		<#-- fecha sin horas -->
		<#assign dateEndReduced = dateEndStr?keep_before(",") >
	</#if>
	<#if !dateShowReduced >
		<#if entGeneralData.ehuenddatehourhh?? && !(entGeneralData.ehuenddatehourhh.getData() == "") >
			<#if entGeneralData.ehuenddatehourhh?? >
				<#assign entRaizHourMin2 = entGeneralData >
			<#else>
				<#assign entRaizHourMin2 = entDateEnd >
			</#if>
		</#if>
		<#if entRaizHourMin2?? >
			<#assign entEndHour = entRaizHourMin2.ehuenddatehourhh >
			<#assign entEndMin = entRaizHourMin2.ehuenddatehourmm >
		</#if>
		<#if entEndHour?? >
			<#if entEndHour.getData()?? && entEndHour.getData() != "" >
				<#assign dateEndHourStr = entEndHour.getData() >
			<#else>
				<#assign dateEndHourStr = "0" >
			</#if>	
		</#if>
		<#if entEndMin?? >
			<#if entEndMin.getData()?? && entEndMin.getData() != "" >
				<#assign dateEndMinStr = entEndMin.getData() >
			<#else>
				<#assign dateEndMinStr = "0" >
			</#if>			
		</#if>
		
		<#-- Si la hora o el minuto es 04 nos llega solo 4 así que hay que arreglarlo -->
		<#if dateEndHourStr??  && (dateEndHourStr?length == 1) >
			<#assign dateEndHourStr = 0 + dateEndHourStr >
		</#if>
		
		<#if dateEndMinStr??  && (dateEndMinStr?length == 1) >
			<#assign dateEndMinStr = 0 + dateEndMinStr >
		</#if>
		
		<#-- Si la hora o el minuto es 00 nos llega solo 0 así que hay que arreglarlo -->
		<#--
		<#if dateEndHourStr?? && (dateEndHourStr == "0") >
			<#assign dateEndHourStr = "00">
		</#if>
		<#if dateEndMinStr?? && (dateEndMinStr == "0") >
			<#assign dateEndMinStr = "00">
		</#if>
		-->
		
		
		<#--
		## ============================================================================================
		## OJO: antes no se mostraba la informacion extendida sobre la fecha de inicio si era la hora 0
		## ============================================================================================
		-->
		<#if dateEndHourStr?? >
			<#if dateEndMinStr?? >
				<#assign formatLong = !( ( ( dateEndHourStr == "0" ) && ( dateEndMinStr == "0" ) ) ||
								 ( ( dateEndHourStr == "23" ) && ( dateEndMinStr == "59" ) ) ) >
				<#if formatLong >
					<#assign dateFormatLong = dateFormat + ", HH:mm" >
					<#if dateEndStr?? && dateEndStr != "">						
						<#assign dateEndAll = dateEndStr + ", " + dateEndHourStr + ":" + dateEndMinStr >
						<#-- <#setting date_format= dateFormatLong > -->
						<#if dateFormatLong?? >
							<#assign dateEnd = ( dateEndAll?datetime( dateFormatLong ) )?date >
							<#if dateEnd?? >
								<#assign dateEndStr = dateUtil.getDate(dateEnd, dateFormatLong, locale) >			
							</#if>
						</#if>
					</#if>
				</#if>
			</#if>
		</#if>
	</#if>
</#if>

<#-- LOCALIZACION -->
<@upvlibs.VocabFormatCategories vocabularyName="Kokalekuak" show=false divClass="location" />
<#assign localization = upvlibs.catString >
<#assign city = "">
<#assign province = "">
<#if localization?? >
	
	<#assign textoIni="<span class=\"city\">" >
	<#assign lengthTextoIni = textoIni?length>
	<#if localization?contains(textoIni)>
		<#assign posTextoIni = localization?index_of(textoIni) + lengthTextoIni>
		<#assign textoFin="</span>" >
		<#assign lengthTextoFin = textoFin?length>
		<#assign posTextoFin = localization?index_of(textoFin, posTextoIni)>
		
		<#if posTextoIni?? && (posTextoIni > 0) && posTextoFin?? && (posTextoFin > 0 )> 
			<#assign city = localization?substring(posTextoIni,posTextoFin) >
		</#if>
	</#if>
	
	<#assign textoIniP="<span class=\"province\">" >
	<#assign lengthTextoIniP = textoIniP?length>
	<#if localization?contains(textoIniP)>
		<#assign posTextoIniP = localization?index_of(textoIniP) + lengthTextoIniP>
		<#assign textoFinP="</span>" >
		<#assign lengthTextoFinP = textoFinP?length>
		<#assign posTextoFinP = localization?index_of(textoFinP, posTextoIniP)>
		<#assign province = "">
		<#if posTextoIniP?? && (posTextoIniP > 0) && posTextoFinP?? && (posTextoFinP > 0 )> 
			<#assign province = localization?substring(posTextoIniP,posTextoFinP) >
		</#if>
	</#if>
</#if> 
<#assign hayCity = city != "" >
<#assign hayProvince = province != "" >

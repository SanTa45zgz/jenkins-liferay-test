<#--
Nombre contenido (ES): Evento
Estructura: global > event.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/evento
Nota: Se usa con global-theme y con ehu-theme
-->

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

<#-- GENERAL-->
<#assign void = ''>
<#assign cTxtAuthors		= languageUtil.get( locale, "ehu.authors" ) >
<#assign cTxtComInfo		= languageUtil.get( locale, "ehu.communication-information" ) >
<#assign cTxtComType		= languageUtil.get( locale, "ehu.communication-type" ) >
<#assign cTxtCycle			= languageUtil.get( locale, "ehu.cycle" ) >
<#assign cTxtDateFrom		= languageUtil.get( locale, "ehu.From" ) >
<#assign cTxtDateTo			= languageUtil.get( locale, "ehu.To" ) >
<#assign cTxtDescription	= languageUtil.get( locale, "ehu.description" ) >
<#assign cTxtInscription	= languageUtil.get( locale, "ehu.registration" ) >
<#assign cTxtMoreInfo		= languageUtil.get( locale, "ehu.more-info" ) >
<#assign cTxtPhoto			= languageUtil.get( locale, "ehu.photo" ) >
<#assign cTxtSpeaker		= languageUtil.get( locale, "ehu.speaker" ) >
<#assign cTxtTitle			= languageUtil.get( locale, "ehu.title" ) >
<#assign cTxtUrl			= languageUtil.get( locale, "ehu.url" ) >
<#assign cTxtNewWindow		= languageUtil.get( locale, "opens-new-window" ) >
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
	<#assign articleClass		= "event" >
	<#assign preTitleClass		= "pretitle" >
	<#assign titleClass			= "event-title" >
	<#assign datesClass			= "event_date" >
	<#assign cycleClass			= "cycle" >
	<#assign descriptionClass	= "description" >
	<#assign registrationClass	= "registration" >
	<#assign comunicationClass	= "communication" >
	<#assign addInfoClass		= "additional-info" >
<#else>
	<#assign articleClass		= "event-detail" >
	<#assign preTitleClass		= "event-detail__pretitle" >
	<#assign titleClass			= "event-detail__title" >
	<#assign datesClass			= "event-detail__featured-information__date" >
	<#assign cycleClass			= "event-detail__featured-information__cycle" >
	<#assign descriptionClass	= "event-detail__body__description" >
	<#assign registrationClass	= "event-detail__registration" >
	<#assign comunicationClass	= "event-detail__communication" >
	<#assign addInfoClass		= "event-detail__additional-info" >
</#if>

<#assign type = "" >
<#assign entItem = entGeneralData.ehutype >
<#if entItem?is_hash >
	<#assign eventType = entItem.getData() >
<#else>
	<#assign eventType = getterUtil.getString( entItem ) >
</#if>
<#if eventType != "" >
	<#if !validator.equals( eventType, "upv-ehu-other" ) && !validator.equals( eventType, "upv-ehu-blank" ) >
		<#assign type = '<span class="type">' + languageUtil.get( locale, eventType ) + '</span>' >
	</#if>
</#if>

<#assign scope = "" >
<#if entGeneralData.upvehuscope?? >
	<#assign entItem = entGeneralData.upvehuscope >
</#if>
<#if entItem?is_hash >
	<#assign eventScope = entItem.getData() >
<#else>
	<#assign eventScope = getterUtil.getString( entItem ) >
</#if>
<#if eventScope != "" >
	<#if !validator.equals( eventScope, "upv-ehu-other" ) && !validator.equals( eventScope, "upv-ehu-blank" ) >
		<#assign scope = '<span class="scope">' + languageUtil.get( locale, eventScope ) + '</span>' >
	</#if>
</#if>

<#if (type?? && type == "") || (scope?? && scope == "")>
	<#assign nexo = "" >
<#else>
	<#assign nexo = " " >
</#if>
<#if locale == "en_GB">
	<#assign typeAndScope = scope + nexo + type >
<#else>
	<#assign typeAndScope = type + nexo + scope  >
</#if>

<#-- HTML-->
<article class="${ articleClass }">
	<#-- PRETITLE, TITLE y POSTTITLE -->
	<header>
	<#assign preTitle = "" >
	<#-- Hasta nuevo aviso no se pinta el "Título de la comunicación"
	<#if !isGlobal >
		<#if hayComTitle >
			<#assign preTitle = '<span class="communication">' + comTitle + '</span>' >
		</#if>
	<#else>
		<#assign preTitle = typeAndScope >
	</#if>
	-->
	<#assign preTitle = typeAndScope >
	
	<#-- Se dejan todos los themes con pretitle y sin (typeAndScope) tras el título -->
	<#if preTitle != "" >
		<div class="${ preTitleClass }">${ preTitle }</div>
	</#if>
	<h1 class="${ titleClass }">
		${ title }
		<#-- 
		<#if !isGlobal >
			<#if typeAndScope != "" >
				<span class="posttitle">(${ typeAndScope })</span>
			</#if>
		</#if>
		 -->
	</h1>   
	</header>

		<#-- CAMPUSA VOCABULARY -->
		<#if !isGlobal >
			<#assign vocabularyName = "Campusa" >
			<#assign tag_init = "<ul></ul>" >
			<#assign categories = tag_init >
			<@upvlibs.formatVocabularyCategoriesProperties vocabularyName=vocabularyName />
			<#assign categories = upvlibs.categoriesListStr >
			<#if !validator.equals( categories, tag_init ) >
				<div class="campusa-category">${ categories }</div>
			</#if>
		</#if>

		<#if isGlobal >
			<#-- clase para la informacion general -->
			<div class="event-detail__featured-information">
		</#if>

		<#-- FECHAS Y LOCALIZACION -->
		<#if !isGlobal >
			<#-- clase y cabecera para la informacion sobre localizacion y fechas -->
			<div class="date-location">
			<h2><@liferay.language key="ehu.when-and-where" /></h2>
		</#if>

		<#-- FECHAS -->
		<#-- clase para la informacion sobre fechas -->
		<div class="${ datesClass }">

			<#if isGlobal >
				<#-- cabecera para la informacion sobre fechas -->
				<h2 class="sr-only"><@liferay.language key="ehu.date" /></h2>
				<i class="icon-calendar-empty"></i>
			</#if>

			<#assign txtDateFrom = "" >
			<#if  dateEnd?? && dateStart??>
				<#assign daysBetween = dateUtil.getDaysBetween( dateStart, dateEnd ) >
				<#if ( daysBetween > 0 ) >
					<#assign txtDateFrom = cTxtDateFrom >
				</#if>					
			<#else>
				<#-- Si no hay fecha de fin pintamos igualmente el texto de "Desde: " ya que sí hay fecha de inicio -->
				<#assign txtDateFrom = cTxtDateFrom >
			</#if>			
		
			<#if txtDateFrom != "">
				<#assign txtDateTo = cTxtDateTo >
			<#else>
				<#assign txtDateTo = "" >
			</#if>

			<#if  txtDateFrom != "" >
				<#if !isGlobal>
					<#assign txtDateFrom = txtDateFrom + ": " >
				<#else>
					<#assign txtDateFrom = "<strong>" + txtDateFrom + "</strong>"> 
				</#if>
			</#if>
			<#if  txtDateTo != "" >
				<#if !isGlobal>
					<#assign txtDateTo = txtDateTo + ": " >
				<#else>
					<#assign txtDateTo = "<strong>" + txtDateTo + "</strong>">
				</#if>	

			</#if>

			<#-- informacion sobre fechas -->
			<#if !isGlobal >
				<#-- Una de las dos variables tiene que tener valor para no pintar un "p" vacío -->
				<#if dateStartStr?? || dateEndStr?? >
					<p>					
						<#-- Si hay fecha de inicio pero no de fin se pinta la fecha de inicio y la hora de fin. Tampoco se pinta el "Desde". -->
						<#if dateStartStr?? && (!dateEndStr?? || dateEndStr == "") >
							<span class="date">${ dateStartStr }</span>
							<#if dateEndHourStr?? && dateEndMinStr?? >
								<span class="date">- ${ dateEndHourStr }:${ dateEndMinStr }</span>
							</#if>
						</#if>
						
						<#-- Si hay fecha de inicio y de fin se pintan -->
						<#if dateStartStr?? && dateEndStr?? && dateEndStr != "" >
							${ txtDateFrom }<span class="date">${ dateStartReduced }</span>
							<#-- Si hay hora de inicio hay que pintar una coma dentro de la fecha para que no meta un espacio en blanco por detrás -->
							<#if dateStartHourStr?? && dateStartMinStr?? >
								${ txtDateTo }<span class="date">${ dateEndReduced + "," }</span>
							<#else>
								${ txtDateTo }<span class="date">${ dateEndReduced }</span>
							</#if>
							<#-- Pintamos las horas -->						
							<#if dateStartHourStr?? && dateStartMinStr?? > 
								<span class="date"> ${ dateStartHourStr }:${ dateStartMinStr } </span>
							</#if>
							<#if dateStartHourStr?? && dateStartMinStr?? && dateEndHourStr?? && dateEndMinStr?? && dateEndHourStr != "" && dateEndMinStr != "">
								<span class="date">- ${ dateEndHourStr }:${ dateEndMinStr }</span>
							</#if>
						</#if>
					</p>
				</#if>
			<#else>
			<#-- Cuando es Global-theme -->
				<#-- Una de las dos variables tiene que tener valor para no pintar un "p" vacío -->
				<#if dateStartStr?? || dateEndStr?? >								
					<p>
						
						<#-- Si hay fecha de inicio pero no de fin se pinta la fecha de inicio y la hora de fin. Tampoco se pinta el "Desde". -->
						<#if dateStartStr?? && (!dateEndStr?? ||  dateEndStr == "") >
							<#-- Si hay hora de inicio hay que pintar una coma dentro de la fecha para que no meta un espacio en blanco por detrás -->
							<#if dateStartHourStr?? && dateStartMinStr?? >
								${ dateStartReduced + "," }
							<#else>
								${ dateStartReduced }
							</#if>
							<#if dateStartHourStr?? && dateStartMinStr?? >
								${ dateStartHourStr }:${ dateStartMinStr }
							</#if>	
							<#if dateStartHourStr?? && dateStartMinStr?? && dateEndHourStr?? && dateEndMinStr?? >
								- ${ dateEndHourStr }:${ dateEndMinStr }
							</#if>
						</#if>
						
						<#-- Si hay fecha de inicio y de fin se pintan -->
						<#if dateStartStr?? && dateEndStr?? && dateEndStr != "" >
							<#-- Si hay fecha de inicio pero no de fin se pinta la fecha de inicio y la hora de fin. Tampoco se pinta el "Desde". -->
							<#if dateStartHourStr?? && dateStartMinStr?? >
								${ txtDateFrom } ${ dateStartReduced } ${ txtDateTo } ${ dateEndReduced + ","}							
							<#else>
								${ txtDateFrom } ${ dateStartReduced } ${ txtDateTo } ${ dateEndReduced }
							</#if>
							<#if dateStartHourStr?? && dateStartMinStr?? >
								${ dateStartHourStr }:${ dateStartMinStr }								
							</#if>	
							<#if dateStartHourStr?? && dateStartMinStr?? && dateEndHourStr?? && dateEndMinStr?? && dateEndHourStr != "" && dateEndMinStr != "">
								- ${ dateEndHourStr }:${ dateEndMinStr }
							</#if>
						</#if>						
					</p>
				</#if>
			</#if>
		</div> <#-- cierra clase para la informacion sobre fechas -->



		<#-- NUEVO EN EVENTO REDUCED -->
		<#-- Horario -->
		<#if entGeneralData.ehudayhours?? && validator.isNotNull (entGeneralData.ehudayhours) >
			<#assign nexoHoraMin = ":" >
			<#assign nexoRangoHoras = ", " >
			<#assign cont = 1>
			<#-- Lista de días -->
			<#list entGeneralData.ehudayhours.getSiblings() as currentehudayhours >
				<#assign ehuday = currentehudayhours.ehuday.getData() >	
				<#assign strehuDay =  "ehu." + ehuday >	
				<#if strehuDay != "ehu.">
					<#-- Lista de horas en un día determinado -->
					<#if cont == 1 >
						<div class="event-detail__featured-information__time">
							<h2 class="sr-only"><@liferay.language key="ehu.horario" /></h2>
							<i class="icon-time"></i>
							<div class="event-detail__featured-information__time--list">
					</#if>	
							<p><strong> <@liferay.language key="${strehuDay}" /> </strong>
							<#assign firstHour = true >	
							<#if entGeneralData.ehudayhours.initendhour?? >
								<#if entGeneralData.ehudayhours.initendhour.inithour.getData()?? &&  entGeneralData.ehudayhours.initendhour.inithour.getData() != "">
								<strong>:</strong>
								</#if>
								<#assign count = 0 >
								<#list currentehudayhours.initendhour.getSiblings() as currentinitendhour >

										<#if ehuday != "" >
											<#if currentinitendhour.inithour?? >
												<#assign inithour = currentinitendhour.inithour.getData() >
											</#if>
											<#if currentinitendhour.endhour?? >
												<#assign endhour = currentinitendhour.endhour.getData() >											
											</#if>
											<#assign txtHoraIni = '' >
											<#assign txtHoraFin = '' >
											
											<#if inithour?has_content && inithour?? && !validator.equals(inithour, "[\"\"]")>
												<#assign txtHoraIni = inithour?substring(0,2) + nexoHoraMin + inithour?substring(2,4) >
											</#if>
											<#-- Si hay varias horas hay que pintar una coma para cada hora menos la última sin dejar espacio -->
											<#if endhour?has_content && endhour?? && !validator.equals(endhour, "[\"\"]")>
												<#assign count = count + 1 >
												<#if (currentehudayhours.initendhour.getSiblings()?size = 1)>
													<#assign txtHoraFin = endhour?substring(0,2) + nexoHoraMin + endhour?substring(2,4) >
												<#elseif (currentehudayhours.initendhour.getSiblings()?size > 1)>													
													<#if count = currentehudayhours.initendhour.getSiblings()?size >
														<#assign txtHoraFin = endhour?substring(0,2) + nexoHoraMin + endhour?substring(2,4) >
													<#else>
														<#assign txtHoraFin = endhour?substring(0,2) + nexoHoraMin + endhour?substring(2,4) + "," >
													</#if>
												</#if>
											</#if>
											<#if firstHour>
												<#assign firstHour = false >	
											</#if>																						
											<#if txtHoraIni?has_content && txtHoraFin?has_content>
												${ txtHoraIni } - ${ txtHoraFin } 
											<#else>
												<#if txtHoraIni?has_content>
													${ txtHoraIni }
												</#if>
												<#if txtHoraFin?has_content>
													${ txtHoraFin } 
												</#if>
											</#if>
										</#if>	
								</#list>	
							</#if>
							</p>
					
					<#assign cont = cont + 1>
				</#if>	
			</#list>
			<#if (cont > 1) >
						</div>
					</div>
			</#if>		
		</#if>
		
			
			
		<#-- LOCALIZACION -->
		<#if localization != "" >
			<#if isGlobal >
				<#-- clase y cabecera para la informacion sobre localizacion -->
				<div class="event-detail__featured-information__location">
					<h2 class="sr-only"><@liferay.language key="ehu.location" /></h2>
					<i class="icon-map-marker"></i>
			</#if>
			${ localization }
			<#if isGlobal >
				</div> <#-- cierra clase para la informacion sobre localizacion -->
			</#if>
		</#if>
		<#if !isGlobal >
			</div> <#-- cierra clase para la informacion sobre localizacion y fechas -->
		</#if>

		<#-- CICLO -->
		<#if entGeneralData.ehucycle?is_hash >
			<#assign eventCycle = entGeneralData.ehucycle.getData() >
		<#else>
			<#assign eventCycle = getterUtil.getString( entGeneralData.ehucycle ) >
		</#if>			
		<#if eventCycle != "" >
			<div class="${ cycleClass }">
				<#if !isGlobal >
					<h2>${ cTxtCycle }</h2>
				<#else>
					<h2 class="sr-only">${ cTxtCycle }</h2>
					<i class="icon-refresh"></i>
				</#if>
				<p>${ eventCycle }</p>
			</div>
		</#if>

		<#-- RECEPTORES -->
		<#if isGlobal >
			<@upvlibs.VocabFormatCategories vocabularyName="Hartzaileak" show=false divClass="receivers" />
			<#assign catString = upvlibs.catString >
			<#if  catString != "" >
				<div class="event-detail__featured-information__receivers">
						<h2 class="sr-only"><@liferay.language key="ehu.receivers" /></h2>
						<i class="icon-user"></i>
						${ catString }
				</div>
			</#if>
		<#else>
			<@upvlibs.VocabFormatCategories vocabularyName="Hartzaileak" show=true divClass="receivers" />
			
				
		</#if>

		<#if isGlobal >
			<#-- clase para la informacion general -->
			</div> <#-- cierra clase para toda la informacion -->
		</#if>

		<#-- REDES SOCIALES -->
		<#if isGlobal >
			<#if ehugeneraldata.ehusocialbookmarks?? >
				<#if entGeneralData.ehusocialbookmarks?is_hash >
					<#assign redesSociales = entGeneralData.ehusocialbookmarks.getData() >
				<#else>
					<#assign redesSociales = getterUtil.getString( entGeneralData.ehusocialbookmarks ) >
				</#if>
				<#assign showRedesSociales = getterUtil.getBoolean(redesSociales, false ) >
				<#assign classRS = "share-social-bar__item" >
				<#if showRedesSociales >
					<#assign urlEnCurso = themeDisplay.getURLPortal() + themeDisplay.getURLCurrent() >
					<div class="event-detail__share">
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
					</div> 
				</#if>
			</#if>
		</#if>

		<#if isGlobal >
			<div class="event-detail__body">
		</#if>

		<#-- IMAGE-->
		
		<#assign entImage = entGeneralData.ehugeneraldataimage >
		<#if entImage?is_hash >
			<#assign imageSrc = entImage.getData() >
		<#else>
			<#assign imageSrc = getterUtil.getString( entImage ) >
		</#if>
		<#if imageSrc != "" >
			<#if isGlobal >
				<div class="event-detail__body__main-image">
			</#if>
			
			<#if entImage.ehuimagedescription?? >
				<#if entImage.ehuimagedescription?is_hash >
					<#assign imageAltTextStr = entImage.ehuimagedescription.getData() >
				<#else>
					<#assign imageAltTextStr = getterUtil.getString( entImage.ehuimagedescription ) >
				</#if>
			</#if>
			<#if !imageAltTextStr?has_content && imageAltTextStr != "">
				<#assign imageAltText = imageAltTextStr>
			<#else>
				<#assign imageAltText = languageUtil.get( locale, "image" )>
			</#if>
			
			<#if entImage.ehuimagefoot?? >
				<#if entImage.ehuimagefoot?is_hash >
					<#assign imageFootTextStr = entImage.ehuimagefoot.getData() >
				<#else>
					<#assign imageFootTextStr = getterUtil.getString( entImage.ehuimagefoot ) >
				</#if>
			</#if>
			<#if imageFootTextStr?has_content && imageFootTextStr != "">
				<#assign imageFootText = imageFootTextStr>				
			<#else>
				<#assign imageFootText = "" >
			</#if>
			
			<#if entImage.ehuimageauthor?? >
				<#if entImage.ehuimageauthor?is_hash >
					<#assign imageAuthorTextStr = entImage.ehuimageauthor.getData() >
				<#else>
					<#assign imageAuthorTextStr = getterUtil.getString( entImage.ehuimageauthor ) >
				</#if>	
			</#if>		
			<#if imageAuthorTextStr?has_content && imageAuthorTextStr != "">
				<#assign imageAuthorText = imageAuthorTextStr>
			<#else>
				<#assign imageAuthorText = "" >
			</#if>
			
			
			<#assign imageAlign = "center" >
			<#assign entImageUrl = "" >
			<#assign imageUrlTitle = "" >
			<#assign imageUrlNewTab = false >
			<#assign imageClass = "img-main" >

			<#-- Pasamos la imagen del evento directamente al og:image para que no haya problemas al compartir
				 el evento en redes sociales (Trello 273 - Trello 637) -->	
			<@liferay_util["html-top"]>
				<meta property="og:image" content="${ portalUtil.getAbsoluteURL( request, imageSrc ) }">
			</@>
			<#if !isGlobal >
				<@upvlibs.imageAuthorSection image=imageSrc altText=imageAltText footText=imageFootText imageAuthor=imageAuthorText
					imageDisposition=imageAlign elemImageUrl=entImageUrl imageUrlTitle=imageUrlTitle imageUrlNewTab=imageUrlNewTab imgClass=imageClass />
			<#else>
			   <img src="${ imageSrc }" alt="${ imageAltText }"/> 
			</#if>

			<#if isGlobal >
				<#if imageFootText != "" || imageAuthorText != "" >
					<div class="main-image__footer">
						<#if imageFootText == "">
							<#assign txtPhoto = "" >
						<#else>
							<#assign txtPhoto = imageFootText >
						</#if>	
						<#if imageAuthorText != "" >
							<#if imageFootText == "">
								<#assign txtPhotoAux = "" >
							<#else>
								<#assign txtPhotoAux =  " | "  >
							</#if>	
							<#assign txtPhoto = txtPhoto + txtPhotoAux + cTxtPhoto + ": " + imageAuthorText >
						</#if>
						<#if txtPhoto != "" >
							<p>${txtPhoto}</p>
						</#if>
				   </div>
				</#if>
			</#if>
			<#if isGlobal >
				</div> <#-- class="event-detail__body__main-image" -->
			</#if>
		<#else>
			<#-- Si el evento no tiene imagen metemos como imagen para redes sociales el logo de la universidad
				 proporcionado por la oficina de comunicación (Trello 565 - Trello 637) -->	
			<@liferay_util["html-top"]>
					<meta property="og:image" content="https://www.ehu.eus/documents/522485/1339603/avatar.jpg">
			</@>
		</#if>
		

		<#-- DESCRIPCION-->
		<#assign description = "">
		<#if  entGeneralData.ehudescription??>
			<#if entGeneralData.ehudescription?is_hash >
				<#assign aux = entGeneralData.ehudescription.getData() >
			<#else>
				<#assign aux = getterUtil.getString( entGeneralData.ehudescription ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign description = aux>
			<#else>
				<#assign description = "">
			</#if>
		</#if>
		<#if description != "" >
			<div class="${ descriptionClass }">
				<#if !isGlobal >
					<h2 class="hide-accessible">${ cTxtDescription }</h2>
				</#if>
				${ description }
			</div>
		</#if>
		<#if isGlobal >
			</div> <#-- class="event-detail__body" -->
		</#if>

		<#-- REGISTRO / INSCRIPCION -->
		<#if ehuregistration?? >
			<#assign entRegistration = ehuregistration >
			<#assign entRegistrationUrl = entRegistration.ehuregistrationlink >
			<#assign registrationUrl = "">
			<#assign description = "">
			<#assign registrationUrlTitle = "">
			<#if entRegistrationUrl??>
				<#if entRegistrationUrl?is_hash >
					<#assign aux = entRegistrationUrl.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entRegistrationUrl ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign registrationUrl = aux>
				<#else>
					<#assign registrationUrl = "">
				</#if>
			</#if>
			
			<#if entGeneralData.ehudescription??>
				<#if entGeneralData.ehudescription?is_hash >
					<#assign aux = entGeneralData.ehudescription.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entGeneralData.ehudescription ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign description = aux>
				<#else>
					<#assign description = "">
				</#if>
			</#if>
			<#if entRegistrationUrl.ehuregistrationlinktitle??>
				<#if entRegistrationUrl.ehuregistrationlinktitle?is_hash >
					<#assign aux = entRegistrationUrl.ehuregistrationlinktitle.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entRegistrationUrl.ehuregistrationlinktitle ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign registrationUrlTitle = aux>
				<#else>
					<#assign registrationUrlTitle = "">
				</#if>
			</#if>
			<#if entRegistration.ehuregistrationdescription??>
				<#if entRegistration.ehuregistrationdescription?is_hash >
					<#assign aux = entRegistration.ehuregistrationdescription.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entRegistration.ehuregistrationdescription ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign registrationDescr = aux>
				<#else>
					<#assign registrationDescr = "">
				</#if>
			</#if>
			
			<#if (registrationUrl?has_content && registrationUrl != "") || registrationDescr != "" >				
				<#if !isGlobal >					
					<div class="registration">
					<h2><@liferay.language key="ehu.registration"/></h2>					
					
						<#-- Descripción -->
						<#if registrationDescr != "" >						
							<#assign regDescription = "<p>" + registrationDescr + "</p>" >							
								<#assign aux = cTxtDescription >
								${ regDescription }			
						</#if>
						
						<#if registrationUrl?has_content && registrationUrl != "" >
							<#-- URL -->
							<#assign url = registrationUrl>
							<#assign formatedURL = "" >
							<#if url?is_hash >
								<#assign aux = url.getData() >
							<#else>
								<#assign aux = getterUtil.getString(url) >
							</#if>
							<#if aux?has_content && aux != "">
								<#assign formatedURL = aux>
							</#if>
							
							<#assign text = "" >
							<#if entRegistrationUrl.ehuregistrationlinktitle?? >
								<#if entRegistrationUrl.ehuregistrationlinktitle?is_hash>
									<#assign text = entRegistrationUrl.ehuregistrationlinktitle.getData() >
								<#else>
									<#assign text = getterUtil.getString(entRegistrationUrl.ehuregistrationlinktitle) >
								</#if>
							</#if>							
																						
							<#assign newTab = getterUtil.getBoolean( "false") >
							<#if entRegistrationUrl.ehuregistrationlinknewtab?is_hash >
								<#assign aux = entRegistrationUrl.ehuregistrationlinknewtab.getData() >
							<#else>
								<#assign aux = getterUtil.getString( entRegistrationUrl.ehuregistrationlinknewtab ) >
							</#if>
							<#if aux?has_content && aux != "">
								<#assign newTab = getterUtil.getBoolean(aux) >
							</#if>
								
							<p>
								<strong>${cTxtUrl}:</strong>								
									
								<#if newTab >
									<#assign target = ' target="_blank"'>									
								<#else>
									<#assign target = "">
								</#if>	
															
								<a href="${ formatedURL }" class="bullet bullet-url"${ target }>
									
								<#if newTab >
									<span class="hide-accessible"><@liferay.language key="opens-new-window"/></span>
								</#if>
									
								<#if text == "">
									${formatedURL}
								<#else>
									${text}
								</#if>
									
								<#if newTab >
									<span class="icon-external-link"></span>
								</#if>
								</a>
							</p>
						</#if>
										
					</div>
						 									
				</#if>	<#-- !isGlobal -->
					
				<#-- Si es tema global  -->
				<#if isGlobal >
					<div class="${ registrationClass }">
						<h2>${ cTxtInscription }</h2>
						
						<#-- Si no hay descripción y hay URL -->
						<#if registrationDescr == "" && registrationUrl?has_content && registrationUrl != "">
							<#assign aux = cTxtUrl >
							<strong>${aux}:</strong>
										
							<#if registrationUrlTitle != "">
								<a href="${ registrationUrl }">${ registrationUrlTitle } <span class="icon-external-link"></span></a>
							<#else>
								<a href="${ registrationUrl }">${ registrationUrl } <span class="icon-external-link"></span></a>
							</#if>
						
						<#-- Si hay descripción y hay URL -->
						<#elseif registrationDescr != "" && registrationUrl?has_content && registrationUrl != "">
							<#assign regDescription = registrationDescr >						
							<p>
								${ regDescription }
							</p>
							<p>
								<strong> ${ cTxtUrl }: </strong>
								<#if registrationUrlTitle != "">
									<a href="${ registrationUrl }">${ registrationUrlTitle } <span class="icon-external-link"></span></a>
								<#else>
									<a href="${ registrationUrl }">${ registrationUrl } <span class="icon-external-link"></span></a>
								</#if>
							</p>
						
						<#-- Si hay descripción pero no hay URL -->
						<#else>
							<#assign regDescription = registrationDescr >	
							<p>
								${ regDescription }
							</p>						
						</#if>										
					</div>
				</#if> <#--  isGlobal -->
				
			</#if> <#--  registrationUrl != ""  -->
		</#if><#--  ehuregistration?? -->

		<#-- INFORMACION DE COMUNICACION -->
		
		<#if ehucommunicationinformation?? >
			<#assign entComInformation = ehucommunicationinformation >
			<#if entComInformation.ehucommunicationauthors??>
				<#if  entComInformation.ehucommunicationauthors?is_hash >					
					<#assign aux = entComInformation.ehucommunicationauthors.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entComInformation.ehucommunicationauthors ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign comunicationAuthors = aux>
				<#else>
					<#assign comunicationAuthors = "">
				</#if>
			</#if>
			<#if entComInformation.ehuspeakers??>
				<#if entComInformation.ehuspeakers?is_hash >
					<#assign aux = entComInformation.ehuspeakers.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entComInformation.ehuspeakers ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign comunicationSpeakers = aux>
				<#else>
					<#assign comunicationSpeakers = "">
				</#if>
			</#if>
			<#if entComInformation.upvehucommunicationtype??>				
				<#if entComInformation.upvehucommunicationtype?is_hash >
					<#assign aux = entComInformation.upvehucommunicationtype.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entComInformation.upvehucommunicationtype ) >
				</#if>				
				<#if aux?has_content && aux != "">
					<#assign comunicationType = aux>
				<#else>
					<#assign comunicationType = "">
				</#if>
			</#if>
			<#if comunicationAuthors?? && (comunicationAuthors != "")>
				<#assign hayComAuthors = getterUtil.getBoolean("true" ) >
			<#else>
				<#assign hayComAuthors = getterUtil.getBoolean("false" ) >
			</#if>
			<#if comunicationSpeakers?? && (comunicationSpeakers != "") >
				<#assign hayComSpeakers = getterUtil.getBoolean("true" ) >
			<#else>
				<#assign hayComSpeakers = getterUtil.getBoolean("false" ) >
			</#if>
			<#if comunicationType?? && (comunicationType != "") && !validator.equals( comunicationType, "upv-ehu-blank" )  >
				<#assign hayComType = getterUtil.getBoolean("true" )>
			<#else>
				<#assign hayComType = getterUtil.getBoolean("false" ) >
			</#if>
			
			<#if hayComTitle?? || hayComAuthors?? ||  hayComSpeakers?? || hayComType??>
				<#assign hayCom = hayComTitle || hayComAuthors || hayComSpeakers || hayComType >
				<#if hayCom >
					<div class="${ comunicationClass }">
						<h2>${ cTxtComInfo }</h2>
						<ul>
							<#if hayComTitle>
								<@upvlibs.writeHtmlForGeneralEvento tipo=0 entInfoElem=entComInformation.ehucommunicationtitle
								cabDefecto=cTxtTitle/>
							</#if>
							<#if hayComAuthors>
							<@upvlibs.writeHtmlForGeneralEvento tipo=0 entInfoElem=entComInformation.ehucommunicationauthors
								cabDefecto=cTxtAuthors/>
							</#if>
							<#if hayComSpeakers >
								<@upvlibs.writeHtmlForGeneralEvento tipo=0 entInfoElem=entComInformation.ehuspeakers
								cabDefecto=cTxtSpeaker/>
							</#if>
							<#if hayComType >
								<li>
									<strong>${cTxtComType}:</strong>
									<@liferay.language key="${ comunicationType }" />
								</li>
							</#if>
						</ul>
					</div>
				</#if>
			</#if>
		</#if>

		<#if !isGlobal >
			<@contactInfo 2/>
			<@aditionalInfo />
			<#if ehuimagegallery?? >
				<#if ehuimagegallery.ehuslide??>
					<@upvlibs.imageGallerySection ehuimagegallery.ehuslide articleId true 4 />
				</#if>
			</#if>		
		<#else>
			<#if ehuimagegallery?? >
				<#if ehuimagegallery.ehuslide?? && ehuimagegallery.ehuslide?has_content && ehuimagegallery.ehuslide.ehuimagegalleryimage.getData() !="" >
				<div class="event-detail__image-gallery">
					<@upvlibs.imageGallerySection ehuimagegallery.ehuslide articleId false 4 />
				</div>
				</#if>
			</#if>			
			<@aditionalInfo />			
            <#if checkH3??>
                <@contactInfo 3/>
            <#else>
                <@contactInfo 2/>
            </#if>
			
		</#if>
				
		
		<#-- LAST MODIFICATION DATE-->
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
						<#assign modifiedDateStr = ""  >
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
		

</article>	

<#--
 # ------------------------------------------------------------------------------
 # A partir de la informacion recibida en el parametro "slides" genera el codigo
 # para visualizar dicha informacion como una galeria de imagenes.
 # Mas informacion en la macro "imageGallerySection".
 # Parametros:
 #	ident			identificador para personalizar el codigo que se genera
 #	slides			estructura con la informacion para la galeria de imagenes
 #	[__showFoot]	indica si se quiere mostrar el pie de las imagenes o no
 #	[__elemsRow]	indica el numero de imagenes a mostrar por linea
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#--
 # ------------------------------------------------------------------------------
 # Genera el codigo html para la informacion adicional presente en el contenido
 # de tipo "Evento".
 # La generacion de codigo es diferente si el tema es el global o no.
 # Parametros:
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro aditionalInfo >
	<#local esGlobal = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
	<#local entAditionalInfo = ehuaditionalinfo >
	<#if entAditionalInfo.ehuaditionaldescription?? >
		<#if entAditionalInfo.ehuaditionaldescription?is_hash >
			<#assign aux = entAditionalInfo.ehuaditionaldescription.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entAditionalInfo.ehuaditionaldescription ) >
		</#if>
	</#if>
	<#if aux?has_content && aux != "">
		<#local aditionalDesc = aux>
	<#else>
		<#local aditionalDesc = "">
	</#if>
	<#local hayAditionalDesc = aditionalDesc != "" >

	<#local entAditionalDocs = entAditionalInfo.ehudocument >
	<#assign hayAditionalDocs = getterUtil.getBoolean("false")>
	<#if entAditionalDocs??>
		<#local hayAditionalDocs = upvlibs.hasElement(entAditionalDocs) >
	</#if>
	<#assign hayAditionalLinks=false />
	
	<#if entAditionalInfo?? >	
		<#if entAditionalInfo.ehuaditionalinfourl?? >		
			<#local entAditionalLinks = entAditionalInfo.ehuaditionalinfourl >	
			<#assign hayAditionalLinks = getterUtil.getBoolean("false")>
			<#local hayAditionalLinks = upvlibs.hasElement(entAditionalLinks) >
		</#if>		
	</#if>
	
    <#assign checkH3=false />

	<#local hayAditionalInfo = hayAditionalDesc || hayAditionalDocs || hayAditionalLinks >
	<#if hayAditionalInfo >	
		<#if !esGlobal || hayAditionalDesc >
			<div class="${ addInfoClass }">
				<h2>${ cTxtMoreInfo }</h2>
                <#if cTxtMoreInfo?has_content>
                    <#assign checkH3=true />
                </#if>

				<#if hayAditionalDesc >
					<p> ${aditionalDesc} </p>
				</#if>
				<#if esGlobal >
			</div>
				</#if>
		</#if>
		<#if hayAditionalDocs>
			<#if esGlobal >
	            <div class="event-detail__documents">	
			</#if>
	        <#if checkH3>
				<#assign macroHack>
	            	<@upvlibs.writeHtmlForDocs entradaInfo=entAditionalDocs nomEntradaTit="ehudocumentname" nomEntradaVal="" nivelHIni=3 />
				</#assign>
	        <#else>
				<#assign macroHack>
					<@upvlibs.writeHtmlForDocs entradaInfo=entAditionalDocs nomEntradaTit="ehudocumentname" nomEntradaVal="" nivelHIni=2 />
				</#assign>
	        </#if>
	
			${macroHack}
			<#if esGlobal >
				</div>
			</#if>
		</#if>
		
		<#if hayAditionalLinks>
			<#if esGlobal >
				<div class="event-detail__links">
			</#if>
	        <#if checkH3>
	        	<#if !esGlobal >
					<#assign auxentLangTitSing = "null" >
				<#else>
					<#assign auxentLangTitSing = "ehu.url">
				</#if>
				<@upvlibs.writeHtmlForLinks entradaInfo=entAditionalLinks nomEntradaTit="ehuaditionalinfourldescription" nomEntradaVal=""
					nivelHIni=3 nomEntrNewTab="ehuaditionalinfourlnewtab" newTab=true />
			<#else> 
				<#-- Si hay descripción de la URL se mete y si no se pinta la URL directamente -->
				<#assign urldescription = "">
				<#if entAditionalInfo?? >	
					<#if entAditionalInfo.ehuaditionalinfourl?? >	
						<#if entAditionalInfo.ehuaditionalinfourl.ehuaditionalinfourldescription?? >	
							<#assign urldescription = entAditionalInfo.ehuaditionalinfourl.ehuaditionalinfourldescription.getData() >
						</#if>
					</#if>
				</#if>
								
				<#if urldescription != "" >
					<#if !esGlobal >
						<#assign auxentLangTitSing = "null" >
					<#else>
						<#assign auxentLangTitSing = "ehu.url">
					</#if>
					<@upvlibs.writeHtmlForLinks entradaInfo=entAditionalLinks nomEntradaTit="ehuaditionalinfourldescription" nomEntradaVal=""
					nivelHIni=2 nomEntrNewTab="ehuaditionalinfourlnewtab" newTab=true/>
				<#else>
					<#if !esGlobal >
						<#assign auxentLangTitSing = "null" >
					<#else>
						<#assign auxentLangTitSing = "ehu.url">
					</#if>
					<@upvlibs.writeHtmlForLinks entradaInfo=entAditionalLinks nomEntradaTit="ehuaditionalinfourl" nomEntradaVal=""
					nivelHIni=2 nomEntrNewTab="ehuaditionalinfourlnewtab" newTab=true />
				</#if>
	       	</#if>
			<#if esGlobal >
				</div>
			</#if>
	    </#if>       	
		
	</#if>
</#macro>


<#--
 # ------------------------------------------------------------------------------
 # Genera el codigo html para la informacion de contacto presente en el contenido
 # de tipo "Evento".
 # La generacion de codigo es diferente si el tema es el global o no.
 # Parametros:
 # Salida:
 # ------------------------------------------------------------------------------
-->
<#macro contactInfo type>
	<#local esGlobal = (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >
	<#if !esGlobal >
		<#local contactClass = "contact" >
		<#local cTxtContacto = languageUtil.get( locale, "ehu.contact-data" ) >
	<#else>
		<#local contactClass = "event-detail__contact" >
		<#local cTxtContacto = languageUtil.get( locale, "ehu.contacto" ) >
	</#if>

	<#local entContact = ehucontactdata >
	<#local entContactResponsible = entContact.ehuresponsible >
	<#local entContactDept = entContact.ehudepartmentservice >
	<#local entContactEmail = entContact.ehucontactemail >
	<#local entContactPhone = entContact.ehucontactphone >
	<#local entContactUrl = entContact.ehucontactdataurl >

	<#local hayContactResponsible = getterUtil.getBoolean("false")>
	<#if entContactResponsible??>
		<#local hayContactResponsible = upvlibs.hasElement(entContactResponsible) >
	</#if>	
	<#local hayContactDept = getterUtil.getBoolean("false")>
	<#if entContactDept??>
		<#local hayContactDept = upvlibs.hasElement(entContactDept) >
	</#if>	
	<#local hayContactEmail = getterUtil.getBoolean("false")>
	<#if entContactEmail??>
		<#local hayContactEmail = upvlibs.hasElement(entContactEmail) >
	</#if>
	<#local hayContactPhone = getterUtil.getBoolean("false")>
	<#if entContactPhone??>
		<#local hayContactPhone = upvlibs.hasElement(entContactPhone) >
	</#if>
	<#local hayContactUrl = getterUtil.getBoolean("false")>
	<#if entContactUrl??>
		<#local hayContactUrl =  upvlibs.hasElement(entContactUrl) >
	</#if>
	<#local hayContact = hayContactResponsible || hayContactDept || hayContactEmail || hayContactPhone || hayContactUrl >
	<#if hayContact >
		<div class="${ contactClass }">
            <#if type?? && type==3>
                <h3>${ cTxtContacto }</h3>
            <#else>
                <h2>${ cTxtContacto }</h2>
            </#if>
			
			<ul>
				<#if hayContactResponsible>
					<@upvlibs.writeHtmlForGeneralEvento tipo=0 entInfoElem=entContactResponsible 
					cabDefecto=languageUtil.get( locale, "ehu.responsible" ) />				
				<#local contactTitle = languageUtil.get(locale, "ehu.departamento" ) + " - " + languageUtil.get( locale, "service" ) >
				</#if>
				<#if hayContactDept>
					<#assign defecto = languageUtil.get(locale, "ehu.departamento" ) + " - " + languageUtil.get( locale, "service" )>
					<@upvlibs.writeHtmlForGeneralEvento tipo=0 entInfoElem=entContactDept 
					cabDefecto=defecto  />
				</#if>
				<#if hayContactEmail>
					<@upvlibs.writeHtmlForGeneralEvento tipo=4 entInfoElem=entContactEmail 
					cabDefecto=languageUtil.get( locale, "ehu.email" ) />
				</#if>
				<#if hayContactPhone>
					<@upvlibs.writeHtmlForGeneralEvento tipo=5 entInfoElem=entContactPhone 
					cabDefecto=languageUtil.get( locale, "ehu.phone" ) />
				</#if>
	
				<#if entContactUrl.ehucontactdataurldescripction?is_hash >
					<#assign aux = entContactUrl.ehucontactdataurldescripction.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entContactUrl.ehucontactdataurldescripction ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#local contactTitle = aux>
				<#else>
					<#local contactTitle = languageUtil.get( locale, "ehu.web-page" )>
				</#if>
				<@upvlibs.writeHtmlForWebPage entWebPage=entContactUrl cab=contactTitle nomEntradaTxt="ehucontactdataurldescripction"
					nomEntradaVal="" nomEntrNewTab="ehucontactdataurlnewtab" newTab=false />
			</ul>
		</div>
	</#if>
</#macro>
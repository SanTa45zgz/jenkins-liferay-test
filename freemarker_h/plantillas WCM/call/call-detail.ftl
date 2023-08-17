<#--  
Nombre contenido (ES): Convocatoria
Estructura: global > call.json
Plantilla:Contenido Completo
https://dev74.ehu.eus/es/web/pruebas/convocatoria
Nota: Se usa con ehu-theme y global-theme
-->
<#assign catLocalService			= serviceLocator.findService( "com.liferay.asset.kernel.service.AssetCategoryLocalService" ) >
<#assign categProperLocalService	= serviceLocator.findService( "com.liferay.asset.kernel.service.AssetCategoryPropertyLocalService" ) >
<#assign vocLocalService			= serviceLocator.findService( "com.liferay.asset.kernel.service.AssetVocabularyLocalService" ) >
<#assign articleService			= serviceLocator.findService( "com.liferay.journal.service.JournalArticleLocalService" ) >
<#assign companyService			= serviceLocator.findService( "com.liferay.portal.kernel.service.CompanyLocalService" ) >

<#assign company= companyService.getCompany(portalUtil.getDefaultCompanyId() ) >
<#assign globalGroupId = getterUtil.getLong(company.getGroup().getGroupId() ) >
<#assign article = articleService.getArticle(getterUtil.getLong(groupId ) , .vars['reserved-article-id'].data) >
<#assign articlePrimKey = article.resourcePrimKey >
<#assign articleCategories = catLocalService.getCategories( "com.liferay.portlet.journal.model.JournalArticle", getterUtil.getLong( articlePrimKey ) ) >
<#--<#assign langId = localeUtil.fromLanguageId( request.locale ) >-->
<#assign langId = themeDisplay.getLocale() >
<#assign langIsEU = langId == "eu_ES"  >
<#assign upvEhuBlank = "upv-ehu-blank" >
<#if langIsEU >
	<#assign genDateFormat = "yyyy-M-d" >
	<#assign firsPubliDateFormat = "yyyy/MM/dd" >
	<#assign procSelStartDateFormat = "yyyy/MM/dd" >
<#else>
	<#assign genDateFormat = "d-M-yyyy" >
	<#assign firsPubliDateFormat = "dd/MM/yyyy" >
	<#assign procSelStartDateFormat = "dd/MM/yyyy" >
</#if>

<article class="call">
	<#assign call_phase_title_literal = languageUtil.get(locale, "ehu.bases" ) >
	<#assign entLangPhaseState = "" >
	<#assign arrPhases = ehuphases.getSiblings() >
	<#assign numPhases = arrPhases?size >

	<#if ((numPhases > 0)?c)?boolean >
		<#assign numCallPhase = numPhases - 1 >
		<#assign call_phase = arrPhases[numCallPhase]>
		<#assign call_phase_title = call_phase.ehuphasetitle.getData() >
		<#if call_phase_title?has_content >
			<#if call_phase_title != upvEhuBlank >
				<#assign entLanguage = "upv-ehu-" + call_phase_title >
				<#assign call_phase_title_literal = languageUtil.get( locale, entLanguage ) >
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
				</#if>
			</#if>
		</#if>
	</#if>

	<header>
		<h1>
			<#assign call_type = ehugeneraldata.ehutype.getData() >
			<#if call_type != upvEhuBlank >
				<#assign call_type_literal = "upv-ehu-" + call_type >
				<@liferay.language key="${call_type_literal}" />:
			</#if>
			${ehugeneraldata.ehugeneraldatatitle.getData()}
		</h1>
		<h2>
			<small>
				${call_phase_title_literal}
				<#if entLangPhaseState?has_content  >
					- <@liferay.language key="${entLangPhaseState}" />
				</#if>
			</small>
		</h2>
		<#assign call_code = ehugeneraldata.ehucode.getData()>
		<#assign call_num = ehugeneraldata.ehunumber.getData() >
		
		<#if call_code?has_content || call_num?has_content >
			<p>
				<small>
					<#if call_code?has_content >
						<span>${call_code}</span>
					</#if>
					<#if call_num?has_content >
						<span>${call_num}</span>
					</#if>
					<#assign convoking_structure = ehugeneraldata.ehuconvokingstructure.getData() >
					<#if convoking_structure?has_content >
						<#if convoking_structure != upvEhuBlank >
							<#assign entLanguage = "upv-ehu-" + convoking_structure >
							<#assign convoking_structure_literal = "(" + languageUtil.get( locale, entLanguage ) + ")" >
							${convoking_structure_literal}
						</#if>
					</#if>
				</small>
			</p>

            <#assign dateFormat = firsPubliDateFormat>
            <#setting date_format=dateFormat>
			<#setting locale = localeUtil.getDefault()>
			<#assign displayDate = .vars['reserved-article-display-date'].data>	
			<#assign displayDate = (displayDate?datetime("EEE, dd MMM yyyy hh:mm:ss"))?date>
		    <#assign displayStr = displayDate?string>

			<p class="date">
				<small><@liferay.language key="ehu.first-publication-date" />: ${displayStr}</small>
			</p>

		</#if>
	</header>
		 
	
	<dl>
		<#assign vocabularyName = "Hartzaileak" >
		<#assign catString = "" >
		<@upvlibs.VocabFormatCategories vocabularyName=vocabularyName show=false divClass="" />
		    <#assign catString = upvlibs.catString >
		<#if catString?has_content >
			${catString}
		</#if>
	    <@upvlibs.getFormatedDate field=ehugeneraldata.ehucalldate dateFormat=genDateFormat llocale=locale />
	        <#assign callDateStr = upvlibs.fDate >
		<dt><@liferay.language key="ehu.convocation-date" />:</dt>
		<dd>${callDateStr}</dd>

		<#assign entBulletinPublicationDate = ehugeneraldata.ehubulletinpublicationdate >											  
														  
		<#if entBulletinPublicationDate?? && entBulletinPublicationDate?has_content && entBulletinPublicationDate.getData() !="">
			<@upvlibs.getFormatedDate field=entBulletinPublicationDate dateFormat=genDateFormat llocale=locale />
		        <#assign bulletinDateStr = upvlibs.fDate >
			<dt><@liferay.language key="ehu.boe-bopv-publication-date" />:</dt>
			<dd>${bulletinDateStr}</dd>
		</#if>

		<#assign requirements = ehugeneraldata.ehurequirements.getData() >
		<#if requirements?has_content >
			<dt class="salto"><@liferay.language key="ehu.requirements" />:</dt>
			<dd><p>${requirements?replace("\n", "</p><p>")}</p></dd>
		</#if>
	</dl>

	<#assign entBasesDocument = ehubases.ehubasesdocument >
	<#assign arrBasesDocuments = entBasesDocument.getSiblings() >
	<#assign numBasesDocuments = getterUtil.getInteger(arrBasesDocuments?size) >
	<#assign existBases = ((numBasesDocuments > 0)?c)?boolean >

	<section id="tab">
		<ul id="list">
			<#if existBases >
				<li role="presentation">
					<a href="#tab1"><@liferay.language key="ehu.bases" /></a>
				</li>
			</#if>
			<#if existBases >
				<#assign cont = 2 >
			<#else>
				<#assign cont = 1 >
			</#if>
			<#list arrPhases as indexPhase >
				<#assign index_phase_title = indexPhase.ehuphasetitle.getData() >
				<#if index_phase_title != upvEhuBlank >
					<#if call_phase_title == index_phase_title >
						<li class="tab-focused active tab-selected" role="presentation">
					<#else>
						<li>
					</#if>
						<#assign tab_id = "#tab" + cont>
						<#assign index_phase_title_literal = "upv-ehu-" + index_phase_title >
						<a href="${tab_id}">${languageUtil.get( locale, index_phase_title_literal )}</a>
						</li>
					<#assign cont = cont + 1 >
				</#if>
			</#list>
		</ul>

		<div class="tab-content">
			<#if existBases >
				<div id="tab1">
					<h2><@liferay.language key="ehu.bases" /></h2>
					<#assign entBasesDate = ehubases.ehubasesdate >
					<#assign baseDateData = entBasesDate.getData() >
					<#if baseDateData?has_content >
						<#-- <#assign showBasesPublicationDate = getterUtil.getBoolean(entBasesDate.ehubasesdateshow.getData() ) >  -->
						<#if entBasesDate?? && entBasesDate?has_content && entBasesDate.getData() !="">
							<@upvlibs.getFormatedDate field=entBasesDate dateFormat=genDateFormat llocale=locale />
						        <#assign baseDateStr = upvlibs.fDate >
							<dl>								
								<dt><small><@liferay.language key="ehu.publication-date"  />:</small></dt>
								<dd><small>${baseDateStr}</small></dd>								
							</dl> 
						</#if>
					</#if>
					<#if ehubases.ehubasesdocument?? && ehubases.ehubasesdocument?has_content && ehubases.ehubasesdocument.getData() != "" >
						<div class="documents">
							<ul>
							    <#list arrBasesDocuments as bases_document_item >
									<#assign bases_document = bases_document_item.getData() >
									<#if bases_document?has_content >
										<#if bases_document?contains( "/" ) >
											<#assign documentTitleField = 'ehubasesdocumentname' >
											<#assign bases_document_format = "" >
											<@upvlibs.formatAttachment documentField=bases_document_item documentTitleField=documentTitleField />
											    <#assign bases_document_format = upvlibs.formatedDocument >
											<li>${bases_document_format}</li>
										</#if>
									</#if>
								</#list>
							</ul>
						</div>
					</#if>	
					<#if ehubases?? && ehubases.ehubasesurls?? >
					    <@HtmlShowUrls entUrls=ehubases.ehubasesurls childName="ehubasesurldescription" />
					</#if>
				</div>
				<#assign tabCont = 2 >
			<#else>
				<#assign tabCont = 1 >
			</#if>
			<#list arrPhases as call_phase >
				<#---------------------------------------------------------------------------------------------------
				## Una fase esta en estado inicial (anuncio) si se muestra la fecha de publicacion o si existen documentos, direcciones web o notas 
				## Por cada fase se reinicializan el numero de notas, documentos y direcciones web -->

				<#assign entInfoState = call_phase.ehuinfostate >
				<#if entInfoState?? >
					<#assign existInfoPublicationDate = getterUtil.getBoolean("false")>
					<#if entInfoState.ehuinfostatedate?? >
    				    <#assign existInfoPublicationDate = upvlibs.hasElement(entInfoState.ehuinfostatedate) && entInfoState.ehuinfostatedate.getData() !="">
    				</#if>
    				<#assign existInfoDocuments = getterUtil.getBoolean("false")>
				    <#if entInfoState.ehuinfostatedocument?? >
    				    <#assign existInfoDocuments = upvlibs.hasElement(entInfoState.ehuinfostatedocument) >
    				</#if>
    				<#assign existInfoUrls = getterUtil.getBoolean("false")>
    				<#if entInfoState.ehuurls?? >
                        <#assign existInfoUrls = upvlibs.hasElement(entInfoState.ehuurls) >				    
    				</#if>
    				<#assign existInfoNotes = getterUtil.getBoolean("false")>
    				<#if entInfoState.ehuinfostatenotes?? >
    				   <#assign existInfoNotes = upvlibs.hasElement(entInfoState.ehuinfostatenotes) >
    				</#if>
    			</#if>

				<#assign existStateInfo = existInfoPublicationDate || existInfoNotes || existInfoDocuments || existInfoUrls >

				<#---------------------------------------------------------------------------------------------------
				## Una fase esta en estado provisional si se muestra la fecha de publicacion o si existen documentos o notas 
				## Por cada fase se reinicializan el numero de notas y documentos-->

				<#assign entProvisionalState = call_phase.ehuprovisionalstate >
				
				<#assign existProvisionalPublicationDate = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatedate)>
				
				<#assign existProvisionalDocuments = getterUtil.getBoolean("false")>
				<#if entProvisionalState.ehuprovisionalstatedocument??>
					<#assign existProvisionalDocuments = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatedocument) >
				</#if>
				<#assign existProvisionalNotes = getterUtil.getBoolean("false")>
				<#if entProvisionalState.ehuprovisionalstatenotes??>
					<#assign existProvisionalNotes = upvlibs.hasElement(entProvisionalState.ehuprovisionalstatenotes) >
				</#if>
				

				<#assign existStateProvisional = existProvisionalPublicationDate || existProvisionalNotes || existProvisionalDocuments >

				<#---------------------------------------------------------------------------------------------------
				## Una fase esta en estado final si se muestra la fecha de publicacion o si existen documentos o notas 
				## Por cada fase se reinicializan el numero de notas y documentos-->

				<#assign entFinalState = call_phase.ehufinalstate >
				
				<#assign existFinalPublicationDate = getterUtil.getBoolean("false")>
				<#if entFinalState.ehufinalstatedocument??>
					<#assign existFinalPublicationDate = upvlibs.hasElement(entFinalState.ehufinalstatedocument) && entFinalState.ehufinalstatedate.getData() !="">
				</#if>
				<#assign existFinalDocuments = getterUtil.getBoolean("false")>
				<#if entFinalState.ehufinalstatedocument??>
					<#assign existFinalDocuments = upvlibs.hasElement(entFinalState.ehufinalstatedocument) >
				</#if>				
				<#assign existFinalNotes = getterUtil.getBoolean("false")>
				<#if entFinalState.ehufinalstatenotes??>
					<#assign existFinalNotes = upvlibs.hasElement(entFinalState.ehufinalstatenotes) >
				</#if>
				
				<#assign existStateFinal = existFinalPublicationDate || existFinalNotes || existFinalDocuments  >

				<#assign call_phase_title = call_phase.ehuphasetitle.getData() >
				<#if call_phase_title?has_content >
					<#if call_phase_title != upvEhuBlank >
						<#assign tab_id = "tab" + tabCont >
						<div id="${tab_id}">
							<#assign entLanguage = "upv-ehu-" + call_phase_title >
							<#assign call_phase_title_literal = languageUtil.get( locale, entLanguage ) >
							<h2>${call_phase_title_literal}</h2>

							<#assign tabStateInfo_id = "tabStateInfo-" + tabCont>
							<#if existStateInfo >
								<div id="${tabStateInfo_id}">
									<h3><@liferay.language key="upv-ehu-advertisement" /></h3>
									<#if existInfoPublicationDate >
									    <@upvlibs.getFormatedDate field=entInfoState.ehuinfostatedate dateFormat=genDateFormat llocale=locale />
									        <#assign infoDateStr = upvlibs.fDate >
										<dl>
											<dt><small><@liferay.language key="ehu.publication-date" />:</small></dt>
											<dd><small>${infoDateStr}</small></dd>
										</dl> 
									</#if>

									<#--
									## Solo en las fase de presentacion de instancias y de meritos existen plazos de reclamacion en el subapartado de informacion 
									##-->
									<#if call_phase_title == "instance-presentation" || call_phase_title == "merits" >
										<#assign entInfoDeadline = entInfoState.ehuinfostatedeadline >
										<#assign entInfoInitDate = entInfoDeadline.ehuinfostatedeadlineinitdate >
										<#assign entInfoEndDate = entInfoDeadline.ehuinfostatedeadlineenddate >
										
										<#if entInfoInitDate?? && entInfoInitDate?has_content && entInfoInitDate.getData() !="" && entInfoEndDate?? && entInfoEndDate?has_content && entInfoEndDate.getData() !="">
										
										    <@upvlibs.getFormatedDate field=entInfoInitDate dateFormat=genDateFormat llocale=locale />
										        <#assign infoDeadlineInitDateStr = upvlibs.fDate >

                                            <@upvlibs.getFormatedDate field=entInfoEndDate dateFormat=genDateFormat llocale=locale />
										        <#assign infoDeadlineEndDateStr = upvlibs.fDate >

											<p class="portlet-msg-info">
													<span><@liferay.language key="ehu.deadline-presentation" />:</span><br>
													<span>${infoDeadlineInitDateStr} - ${infoDeadlineEndDateStr}</span><br>
													<span>(<@liferay.language key="ehu.both-days-included" />)</span>
											</p>
										</#if>
									</#if>

									<#--
									## Solo en las fases relacionadas con procesos selectivos tiene sentido presentar la informacion de localizacion
									##-->
									<@EsProcesoSelectivo fase_title=call_phase_title  />
									  <#assign phaseIsProcSelectivo = eps_is >
									
									<#if phaseIsProcSelectivo >
										<#assign entInfoProcSelectivo = entInfoState.ehuselectiveprocess >
										<#assign phase_info_state_location = entInfoProcSelectivo.ehulocation.getData()>

										<#if phase_info_state_location?has_content >
											<#assign entInfoProcSelStartDate = entInfoProcSelectivo.ehustartdatehour >
											<@upvlibs.getFormatedDate field=entInfoProcSelStartDate dateFormat=procSelStartDateFormat llocale=locale />
											    <#assign infoProcSelStartDateStr = upvlibs.fDate >
											
											<#if infoProcSelStartDateStr?has_content >
												<#assign infoProcSelStartHour = entInfoProcSelStartDate.ehustartdatehourhh.getData() >
												<#assign infoProcSelStartMin = entInfoProcSelStartDate.ehustartdatehourmm.getData() >
												<#-- Si la hora o el minuto es 04 nos llega solo 4 así que hay que arreglarlo -->
												<#if infoProcSelStartHour??  && (infoProcSelStartHour?length == 1) >
													<#assign infoProcSelStartHour = 0 + infoProcSelStartHour >
												</#if>
												<#if infoProcSelStartMin??  && (infoProcSelStartMin?length == 1) >
													<#assign infoProcSelStartMin = 0 + infoProcSelStartMin >
												</#if>
												<#assign infoProcSelStartDateStr = infoProcSelStartDateStr + " " + infoProcSelStartHour + ":" + infoProcSelStartMin >
												<p class="portlet-msg-info">
													<span><@liferay.language key="ehu.init-date-hour" />:</span>
													<span>${infoProcSelStartDateStr}</span><br> 
													<span><@liferay.language key="ehu.location"  />:</span>
													<span>${phase_info_state_location}</span><br>
												</p>
											</#if>
										</#if>
									</#if>

									<#if existInfoNotes >
										<div class="portlet-msg-alert">
											<#assign arrInfoNotes = entInfoState.ehuinfostatenotes.getSiblings() >
											<#list arrInfoNotes as elemNote >
												<#assign note = elemNote.getData() >
												<#if note?has_content >
												    <@upvlibs.getFormatedDate field=elemNote.ehuinfostatenotespublicationdate dateFormat=genDateFormat llocale=locale />
												        <#assign notePublicationDateStr = upvlibs.fDate >
													${note}
													<#if notePublicationDateStr?has_content >
														<small>(${notePublicationDateStr})</small>
													</#if>
												</#if>
											</#list>
										</div>
									</#if>

									<#if existInfoDocuments >
										<div class="documents" >
										  <#if entInfoState?? && entInfoState.ehuinfostatedocument?? && entInfoState.ehuinfostatedocument.getSiblings()?? >
											<ul>
												<#assign arrInfoDocs = entInfoState.ehuinfostatedocument.getSiblings() >
												<#list arrInfoDocs as elemDocument >
													<#assign document = elemDocument.getData() >
													<#if document?has_content >
														<#if document?contains( "/" ) >
															<#assign documentTitleField = 'ehuinfostatedocumentname' >
															<#assign document_format = "" >
															<@upvlibs.formatAttachment documentField=elemDocument documentTitleField=documentTitleField />
															    <#assign document_format = upvlibs.formatedDocument >
															<li>${document_format}</li>
														</#if>
													</#if>
												</#list>
											</ul>
										  </#if>
										</div>
									</#if>

									<@HtmlShowUrls  entUrls=entInfoState.ehuurls childName="ehuurldescription" />
								</div> <#-- id="$tabStateInfo_id"-->
							</#if> <#-- existStateInfo -->

							<#if existStateProvisional >
								<#if call_phase_title != "instance-presentation" >
									<#assign tabStateProvisional_id = "tabStateProvisional-" + tabCont >
									<div id="${tabStateProvisional_id}">
										<h3><@liferay.language key="upv-ehu-provisional-result" /></h3>
										<#if existProvisionalPublicationDate >
										    <@upvlibs.getFormatedDate field=entProvisionalState.ehuprovisionalstatedate dateFormat=genDateFormat llocale=locale />
										        <#assign provisionalDateStr = upvlibs.fDate >
											<dl>
												<dt><small><@liferay.language key="ehu.publication-date" />:</small></dt>
												<dd><small>${provisionalDateStr}</small></dd>												
											</dl> 
										</#if>

										<#assign entProvisionalDeadline = entProvisionalState.ehuprovisionalstatedeadline >
										<#assign entProvisionalInitDate = entProvisionalDeadline.ehuprovisionalstatedeadlineinitdate >
										<#assign entProvisionalEndDate = entProvisionalDeadline.ehuprovisionalstatedeadlineenddate >
										
										<#if entProvisionalInitDate?? && entProvisionalInitDate?has_content && entProvisionalEndDate.getData() !="" && entProvisionalEndDate?? && entProvisionalEndDate?has_content && entProvisionalEndDate.getData() !="">

										    <@upvlibs.getFormatedDate field=entProvisionalInitDate dateFormat=genDateFormat llocale=locale />
										        <#assign provDeadlineInitDateStr = upvlibs.fDate >
										
											<@upvlibs.getFormatedDate field=entProvisionalEndDate dateFormat=genDateFormat llocale=locale />
											    <#assign provDeadlineEndDateStr = upvlibs.fDate >

											<p class="portlet-msg-info">
													<span><@liferay.language key="ehu.claim-deadline" />:</span><br>
													<span>${provDeadlineInitDateStr} - ${provDeadlineEndDateStr}</span><br>
													<span>(<@liferay.language key="ehu.both-days-included" />)</span>
											</p>
										</#if>

										<#if existProvisionalNotes >
											<div class="portlet-msg-alert">
												<#assign arrProvisionalNotes = entProvisionalState.ehuprovisionalstatenotes.getSiblings() >
												<#list arrProvisionalNotes as elemNote >
													<#assign note = elemNote.getData() >
													<#if note?has_content >
													    <@upvlibs.getFormatedDate field=elemNote.ehuprovisionalstatenotespublicationdate dateFormat=genDateFormat llocale=locale />
													        <#assign notePublicationDateStr = upvlibs.fDate >
														${note}
														<#if notePublicationDateStr?has_content >
															<small>(${notePublicationDateStr})</small>
														</#if>
													</#if>
												</#list>
											</div>
										</#if>

										<#if existProvisionalDocuments >
											<div class="documents" >
												<ul>
													<#assign arrProvisionalDocs = entProvisionalState.ehuprovisionalstatedocument.getSiblings() >
													<#list arrProvisionalDocs as elemDocument >
														<#assign document = elemDocument.getData() >
														<#if document?has_content >
															<#if document?contains( "/" ) >
																<#assign documentTitleField = 'ehuprovisionalstatedocumentname' >
																<#assign document_format = "" >
													    		<@upvlibs.formatAttachment documentField=elemDocument documentTitleField=documentTitleField />
													    		    <#assign document_format = upvlibs.formatedDocument >
																<li>${document_format}</li>
															</#if>
														</#if>
													</#list>
												</ul>
											</div>
										</#if>
									</div> <#-- id="$tabStateProvisional_id" -->
								</#if> <#-- !instance-presentation -->
							</#if> <#-- existStateProvisional-->
							<#if existStateFinal >
								<#if call_phase_title != "instance-presentation" >
									<#assign tabStateFinal_id = "tabStateFinal-" + tabCont >
									<div id="${tabStateFinal_id}">
										<h3><@liferay.language key="upv-ehu-final-result" /></h3>
										<#if existFinalPublicationDate >
										    <@upvlibs.getFormatedDate field=entFinalState.ehufinalstatedate dateFormat=genDateFormat llocale=locale />
										        <#assign finalDateStr = upvlibs.fDate >
											<dl>
												<dt><small><@liferay.language key="ehu.publication-date" />:</small></dt>
												<dd><small>${finalDateStr}</small></dd>												
											</dl> 
										</#if>

										<#if existFinalNotes >
											<div class="portlet-msg-alert">
												<#assign arrFinalNotes = entFinalState.ehufinalstatenotes.getSiblings() >
												<#list arrFinalNotes as elemNote >
													<#assign note = elemNote.getData() >
													<#if note?has_content >
													    <@upvlibs.getFormatedDate field=elemNote.ehufinalstatenotespublicationdate dateFormat=genDateFormat llocale=locale />
													        <#assign notePublicationDateStr = upvlibs.fDate >
														${note}
														<#if notePublicationDateStr?has_content >
															<small>(${notePublicationDateStr})</small>
														</#if>
													</#if>
												</#list>
											</div>
										</#if>

										<#if existFinalDocuments >
											<div class="documents" >
												<ul>
													<#assign arrFinalDocs = entFinalState.ehufinalstatedocument.getSiblings() >
													<#list arrFinalDocs as elemDocument >
														<#assign document = elemDocument.getData() >
														<#if document?has_content >
															<#if document?contains( "/" ) >
																<#assign documentTitleField = 'ehufinalstatedocumentname' >
																<#assign document_format = "" >
																<@upvlibs.formatAttachment documentField=elemDocument documentTitleField=documentTitleField />
																    <#assign document_format= upvlibs.formatedDocument >
																<li>${document_format}</li>
															</#if>
														</#if>
													</#list>
												</ul>
											</div>
										</#if>
									</div> <#-- id="$tabStateFinal_id"-->
								</#if> <#-- !instance-presentation -->
							</#if> <#-- existStateFinal-->
						</div> <#-- id="$tab_id"-->
					</#if> <#-- !upvEhuBlank-->
				</#if> <#-- call_phase_title-->
				<#assign tabCont = tabCont + 1 > 
			</#list>
		</div> <#-- id="tab-content" -->
	</section> <#--# id="tab"-->

	<br>

	<button id="lopd-msg" class="btn">
	    <@liferay.language key="ehu.law-of-personal-data-protection" />  
	</button>
	<div id="modal">
		<div id="contentBox">
		</div>
	</div>
</article>

<#-- ==========
## JAVASCRIPT
## ==========-->
<script>
	AUI().use(
		'aui-tabview',
		function( A ) {
			var tabs = new A.TabView(
				{
					srcNode: '#tab'
				}
			);
			tabs.render();
		}
	);

	YUI().use(
		'aui-modal',
		function( Y ) {
			var modal = new Y.Modal(
				{
					contentBox: '#contentBox',
					headerContent: '<h2><@liferay.language key="ehu.law-of-personal-data-protection" /></h2>',
					bodyContent: '<p><@liferay.language key="ehu.warn.call-lopd-msg" /></p>',
					centered: true,
					modal: true,
					render: '#modal',
					visible: false
				}
			).render();

			modal.addToolbar(
				[
					{
						label: '<@liferay.language key="ok" />',
						on: {
							click: function() {
								modal.hide();
							}
						}
					},
					{
						label: '<@liferay.language key="cancel" />',
						on: {
							click: function() {
								modal.hide();
							}
						}
					}
				]
			);

			Y.one( '#lopd-msg' ).on(
				'click',
				function() {
					modal.show();
				}
			);
		}
	);
</script>

<#-- ======
## MACROS
## ======
## -------------------------------------------------------------------------------------
## Dice si "$fase_title" corresponde a una fase relacionada con un proceso selectivo.
## concreto).
## Parametros:
##	$fase_title		texto que identifica una fase de la publicacion
## Salida:
##	$eps_is			true si esta relacionada con un proceso selectivo y false en caso
##					contrario
## ------------------------------------------------------------------------------------->
<#macro EsProcesoSelectivo fase_title >
	<#assign eps_is = fase_title == "theoretical-test" || fase_title == "practice-test" ||
		fase_title == "theoretical-practice-test" || fase_title == "basque-written-test" ||
		fase_title == "basque-oral-test" || fase_title == "english-written-test" ||
		fase_title == "english-oral-test" || fase_title == "language-test" ||
		fase_title == "interview"  >
	<#return>
</#macro>

<#-------------------------------------------------------------------------------------
## Muestra el html correspondiente a las urls contenidas en la entrada "$entUrls", la
## cual es repetible.
## El acceso al subcomponente con la descripcion de cada url lo ofrece "$childName".
## Parametros:
##	$entUrls		entrada repetible con la informacion sobre las urls
##	$childName		nombre del subcomponente para obtener la descripcion de cada url
## Salida:
## ------------------------------------------------------------------------------------->
<#macro HtmlShowUrls entUrls childName >
   	<#assign hsu_existUrls = upvlibs.hasElement(entUrls) >
	<#if hsu_existUrls >
		<div class="links">
			<ul>
				<#assign hsu_arrUrls = entUrls.getSiblings() >
				<#list hsu_arrUrls as hsu_elemUrl >
					<#assign hsu_url = hsu_elemUrl.getData() >
					<#if hsu_url?has_content >
						<#assign hsu_formatedURL = "" >
						<#if hsu_elemUrl?is_hash >
							<#local aux = hsu_elemUrl.getData() >
						<#else>
							<#local aux = getterUtil.getString(hsu_elemUrl) >
						</#if>
						<#if aux?has_content && aux != "">
							<#assign hsu_formatedURL = aux>
						</#if>
						
						
						
						<#if hsu_elemUrl[childName]?? >
							<#assign hsu_urlDescription = hsu_elemUrl[childName].getData() >
							<#if !hsu_urlDescription?has_content >
								<#assign hsu_urlDescription = hsu_url >
							</#if>
							<li>
								<a href="${hsu_formatedURL}" class="bullet bullet-url" target="_blank">
									<span class="hide-accessible"><@liferay.language key="opens-new-window" /></span>
									${hsu_urlDescription}
									<span class="icon-external-link"></span>
								</a>
							</li>
						</#if>
					
					</#if>
				</#list>
			</ul>
		</div>
	</#if>
</#macro>
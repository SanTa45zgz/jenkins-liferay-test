<#--
# ==========
## Constantes
## ==========-->
<#assign cElemTipo_Document		= 1 >
<#assign cElemTipo_Link			= 2 >

<#assign cNomElemApartado		= "ehuinfogeneraldata" >
<#assign cNomElemAdicional		= "ehuinfoattachment" >
<#assign cNomElemDoc			= "document" >
<#assign cNomElemDocTitle		= "documenttitle" >
<#assign cNomElemUrl			= "url" >
<#assign cNomElemUrlNewTab		= "urlnewtab" >
<#assign cNomElemUrlTitle		= "urltitle" >

<#assign cSeccTipo_Apartado		= 1 >
<#assign cSeccTipo_Adicional	= 2 >

<#assign cUrlsRelativas_Pref	= "./" >

<#assign cTxtImage				= languageUtil.get( locale, "image" ) >
<#assign cTxtNewWindow			= languageUtil.get( locale, "opens-new-window" ) >
<#assign cTxtPhoto				= languageUtil.get( locale, "ehu.photo" ) >

<#assign cHtmlTxtIconNewTab		= '<span class="icon-external-link"></span>' >
<#assign cHtmlTxtTagNewTab		= '<span class="hide-accessible">' + cTxtNewWindow + '</span>' >
<#assign cHtmlTxtTargetNewTab	= ' target="_blank" ' >

<#assign isGlobal				= (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") >

<#if !isGlobal >
	<#assign articleClass		= "information" >
	<#assign sectionClass		= "upv-ehu-image-description" >
	<#assign sectionTitleClass	= "info-section" >
	<#assign sectionDescClass	= "main" >
	<#assign footerClass		= "content-footer" >
	<#assign sectionHeaderTag	= "header" >
	<#assign imageFootTag		= "figcaption" >
	<#assign htmlTitleClass		= "" >
	<#assign htmlIndexNavClass	= "" >
	<#assign htmlNavHrefIconTag	= "" >
<#else>
	<#assign articleClass		= "information-detail" >
	<#assign sectionClass		= "information-detail__body__section" >
	<#assign sectionTitleClass	= "information-detail__body__section__title" >
	<#assign sectionDescClass	= "information-detail__body__section__entry" >
	<#assign footerClass		= "information-detail__footer" >
	<#assign sectionHeaderTag	= "h2" >
	<#assign imageFootTag		= "p" >
	<#assign htmlTitleClass		= ' class="information-detail__title"' >
	<#assign htmlIndexNavClass	= ' class="information-detail__body__anchors-nav"' >
	<#assign htmlNavHrefIconTag	= '<i class="icon-double-angle-down"></i>' >
</#if>

<#assign entHeader = ehuheader >
<#if entHeader.ehuinfosubtitle??>		
	<#assign entSections = entHeader.ehuinfosubtitle >
	<#assign arrSections = entSections.getSiblings() >
</#if>


<#assign info_title = "info-title-" + .vars['reserved-article-id'].data>



<#--  macros para las secciones -->
<#macro tratarElemsSeccion tipoElem tipoSeccion section>

	<#assign te_NumElems = 0 >
	<#if ( tipoSeccion != cSeccTipo_Apartado && tipoSeccion != cSeccTipo_Adicional ) >	<#return> </#if>
	<#if ( tipoElem != cElemTipo_Document && tipoElem != cElemTipo_Link ) >				<#return> </#if>
	
	<#if isGlobal >
		<#if  tipoElem == cElemTipo_Document>
			<#local txtBaseSing = "information-detail__document">
		<#else>
			<#local txtBaseSing = "information-detail__link">
		</#if>
	<#else>
		<#if  tipoElem == cElemTipo_Document>
			<#local txtBaseSing = "document">
		<#else>
			<#local txtBaseSing = "link">
		</#if>
	</#if>
	<#local txtBasePlur = txtBaseSing + "s" >
	<#if tipoSeccion == cSeccTipo_Apartado>
		<#local entDatoRaiz = section>
	<#else>
		<#local entDatoRaiz = ehuattachments>
	</#if>
	<#if tipoSeccion == cSeccTipo_Apartado >
		<#local entDatoNomElemPre = cNomElemApartado>
	<#else>
		<#local entDatoNomElemPre = cNomElemAdicional>
	</#if>
	<#if tipoElem == cElemTipo_Document >
		<#local entDatoNomElemPos = cNomElemDoc>
	<#else>
		<#local entDatoNomElemPos = cNomElemUrl>
	</#if>
	<#local entDatoNomElem = entDatoNomElemPre + entDatoNomElemPos >
	<#if entDatoRaiz?? && entDatoNomElem?? && entDatoNomElem != "" && entDatoRaiz.getChild( entDatoNomElem )?? >						
		<#assign entrada = entDatoRaiz.getChild( entDatoNomElem ) >
	</#if>
	<#if !entrada?? >
		<#if section?? >
			<#if section?is_hash >
				<#assign aux = section.getData() >
			<#else>
				<#assign aux = getterUtil.getString( section ) >
			</#if>
			<#if aux?has_content && aux != "">
				<#local txtSection = aux>
			<#else>
				<#local txtSection = "sin entrada">
			</#if>
			<#local txtSection = "hash. " + txtSection >
		</#if>	
		<#return>
	</#if>
	<#local entDato = entrada>
	<#if tipoElem == cElemTipo_Document>
		<#local documentTitleField = entDatoNomElemPre + cNomElemDocTitle>
	<#else>
		<#local documentTitleField = "">
	</#if>
	<#assign te_NumElems = entDato.getSiblings()?size  >
	<#if ( entDato.getSiblings()?size <= 0 ) >			<#return> </#if>

	<#local arrDatos = entDato.getSiblings() >
	<#local classTitle = txtBasePlur + "-title">
	<#local classGenName = txtBasePlur >
	<#if tipoElem == cElemTipo_Document>
		<#local entLangSing = "document">
	<#else>
		<#local entLangSing = "link">
	</#if>
	<#local entLangPlur = entLangSing + "s" >
	<#if ( tipoSeccion == cSeccTipo_Adicional ) >
		<#local classGenName = "additional-" + classGenName >
		<#local entLangSing = "ehu.more-info-" + entLangSing >
		<#local entLangPlur = "ehu.more-info-" + entLangPlur >
	</#if>

	<#local nomElemUrlTitle = entDatoNomElemPre + cNomElemUrlTitle >
	<#local nomElemUrlNewTab = entDatoNomElemPre + cNomElemUrlNewTab >
	<#if entDato.getSiblings()?size == 1>
		<#local entLang =  entLangSing>
	<#else>
		<#local entLang = entLangPlur>
	</#if>
	<div class="${ classGenName }" >
		<#if !isGlobal>
			<@numElemsSeccion tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Apartado section=section />
			<#local numValidDocs = te_NumElems >
			<@numElemsSeccion tipoElem=cElemTipo_Link tipoSeccion=cSeccTipo_Apartado section=section />
			<#local numValidUrls = te_NumElems >
			<#if (numValidDocs > 0) && (tipoElem == cElemTipo_Document)>
				<p class="${ classTitle }"><strong><@liferay.language key=entLang />:</strong></p>
			</#if>
			<#if (numValidUrls > 0) && (tipoElem == cElemTipo_Link)>
				<p class="${ classTitle }"><strong><@liferay.language key=entLang />:</strong></p>
			</#if>
		</#if>
		<ul>
		    <#list arrDatos as entElem >
				<#if entElem??>
					<#if entElem?is_hash >
						<#assign aux = entElem.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entElem ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign dato = aux>
					<#else>
						<#assign dato = "">
					</#if>
				</#if>

				<#if  validator.isNull(dato) || dato == "" >	<#continue> </#if>
				<#if tipoElem == cElemTipo_Document >
					<#if dato?contains( "/" ) >
						<@upvlibs.formatAttachment documentField=entElem documentTitleField=documentTitleField />
						<#local formatedDocument = upvlibs.formatedDocument >
						<li>${ formatedDocument }</li>
					</#if>
				<#else>
					
					<#local formattedURL = "" >
					<#if entElem?is_hash >
						<#local aux = entElem.getData() >
					<#else>
						<#local aux = getterUtil.getString(entElem) >
					</#if>
					<#if aux?has_content && aux != "">
						<#local formattedURL = aux>
					</#if>

					<#if entElem?? && entElem.getChild( nomElemUrlTitle )?? && nomElemUrlTitle != "">					
						<#assign entrada = entElem.getChild( nomElemUrlTitle ) >
					</#if>
					<#local urlTitle = "">
					<#if entrada??>
						<#if  entrada?is_hash >
							<#local aux =  entrada.getData() >
						<#else>
							<#local aux = getterUtil.getString(  entrada ) >
						</#if>
						<#if aux?has_content && aux != "">
							<#local urlTitle = aux>
						<#else>
							<#local urlTitle = "">
						</#if>
					</#if>
					<#if urlTitle!= "">
						<#local urlDesc = urlTitle>
					<#else>
						<#local urlDesc = formattedURL>
					</#if>
					<#local urlNewTab = getterUtil.getBoolean( "false")>
					<#if entElem?? && entElem.getChild( nomElemUrlNewTab )?? && nomElemUrlNewTab != "">						
						<#assign entrada = entElem.getChild( nomElemUrlNewTab ) >
					</#if>
					<#local urlNewTab = getterUtil.getBoolean( "false")>
					<#if entrada??>
						<#if entrada?is_hash >
							<#assign aux = entrada.getData() >
						<#else>
							<#assign aux = getterUtil.getString( entrada ) >
						</#if>
						<#if aux?has_content && aux != "">
							<#local urlNewTab = getterUtil.getBoolean(aux) >
						<#else>
							<#local urlNewTab = getterUtil.getBoolean( "false")>
						</#if>
					</#if>
			
					<#if urlNewTab>
						<#local htmlTxtTargetNewTab = cHtmlTxtTargetNewTab>
					<#else>
						<#local htmlTxtTargetNewTab = "">
					</#if>
					
					<#if urlNewTab>
						<#local htmlTxtTagNewTab = cHtmlTxtTagNewTab>
					<#else>
						<#local htmlTxtTagNewTab = "">
					</#if>					
					
					<#if urlNewTab>
						<#local htmlTxtIconNewTab = cHtmlTxtIconNewTab>
					<#else>
						<#local htmlTxtIconNewTab = "">
					</#if>

					<li>
						<a href="${ formattedURL }" class="bullet bullet-url"${ htmlTxtTargetNewTab }>
							${ htmlTxtTagNewTab }
							${ urlDesc }
							${ htmlTxtIconNewTab }
						</a>
					</li>
				</#if>
			</#list>
		</ul>
	</div>
</#macro>




<#macro  numElemsSeccion tipoElem tipoSeccion section>
	<#assign te_NumElems = 0 >
	<#if ( tipoSeccion != cSeccTipo_Apartado && tipoSeccion != cSeccTipo_Adicional ) >	<#return> </#if>
	<#if ( tipoElem != cElemTipo_Document && tipoElem != cElemTipo_Link ) >				<#return> </#if>
	
	<#if tipoSeccion == cSeccTipo_Apartado>	
		<#assign entDatoRaiz = section>
	<#else>
		<#assign entDatoRaiz = ehuattachments>
	</#if>
	<#if tipoSeccion == cSeccTipo_Apartado >
		<#assign entDatoNomElemPre = cNomElemApartado>
	<#else>
		<#assign entDatoNomElemPre = cNomElemAdicional>
	</#if>
	<#if tipoElem == cElemTipo_Document >
		<#assign entDatoNomElemPos = cNomElemDoc>
	<#else>
		<#assign entDatoNomElemPos = cNomElemUrl>
	</#if>
	<#local entDatoNomElem = entDatoNomElemPre + entDatoNomElemPos >
	<#if entDatoRaiz?? && entDatoNomElem?? && entDatoNomElem != "" && entDatoRaiz.getChild( entDatoNomElem )?? >						
		<#assign entrada = entDatoRaiz.getChild( entDatoNomElem ) >
	
	</#if>
	<#if entrada??>
		<#local entDato = entrada>
			
		<#if entDato?? && entDato.getSiblings()??>
			<#assign te_NumElems = entDato.getSiblings()?size  >
			<#if ( entDato.getSiblings()?size > 0 ) >			
				<#local arrDatos = entDato.getSiblings() >
				<#list arrDatos as entElem >
					<#if entElem??>
						<#if entElem?is_hash >
							<#assign aux = entElem.getData() >
						<#else>
							<#assign aux = getterUtil.getString( entElem ) >
						</#if>
						<#if aux?? && aux == "">
							<#assign te_NumElems = te_NumElems - 1 >
						</#if>
					</#if>
				</#list>
			</#if>
		</#if>
	</#if>
</#macro>

<#--  macros para las secciones -->

<#--  macros para  ehuattachments-->
<#macro tratarElems tipoElem tipoSeccion>

	<#assign te_NumElems = 0 >
	<#if ( tipoSeccion != cSeccTipo_Apartado && tipoSeccion != cSeccTipo_Adicional ) >	<#return> </#if>
	<#if ( tipoElem != cElemTipo_Document && tipoElem != cElemTipo_Link ) >				<#return> </#if>
	
	<#if isGlobal >
		<#if  tipoElem == cElemTipo_Document>
			<#local txtBaseSing = "information-detail__document">
		<#else>
			<#local txtBaseSing = "information-detail__link">
		</#if>
	<#else>
		<#if  tipoElem == cElemTipo_Document>
			<#local txtBaseSing = "document">
		<#else>
			<#local txtBaseSing = "link">
		</#if>
	</#if>
	<#local txtBasePlur = txtBaseSing + "s" >
	
	<#local entDatoRaiz = ehuattachments>

	<#if tipoSeccion == cSeccTipo_Apartado >
		<#local entDatoNomElemPre = cNomElemApartado>
	<#else>
		<#local entDatoNomElemPre = cNomElemAdicional>
	</#if>
	<#if tipoElem == cElemTipo_Document >
		<#local entDatoNomElemPos = cNomElemDoc>
	<#else>
		<#local entDatoNomElemPos = cNomElemUrl>
	</#if>
	<#local entDatoNomElem = entDatoNomElemPre + entDatoNomElemPos >
	<#if entDatoRaiz?? && entDatoNomElem?? && entDatoNomElem != "" && entDatoRaiz.getChild( entDatoNomElem )?? >						
		<#assign entrada = entDatoRaiz.getChild( entDatoNomElem ) >
	</#if>
	<#if !entrada?? >
		
		<#return>
	</#if>
	<#local entDato = entrada>
	<#if tipoElem == cElemTipo_Document>
		<#local documentTitleField = entDatoNomElemPre + cNomElemDocTitle>
	<#else>
		<#local documentTitleField = "">
	</#if>
	<#assign te_NumElems = entDato.getSiblings()?size  >
	<#if ( entDato.getSiblings()?size <= 0 ) >			<#return> </#if>

	<#local arrDatos = entDato.getSiblings() >
	<#local classTitle = txtBasePlur + "-title">
	<#local classGenName = txtBasePlur >
	<#if tipoElem == cElemTipo_Document>
		<#local entLangSing = "document">
	<#else>
		<#local entLangSing = "link">
	</#if>
	<#local entLangPlur = entLangSing + "s" >
	<#if ( tipoSeccion == cSeccTipo_Adicional ) >
		<#local classGenName = "additional-" + classGenName >
		<#local entLangSing = "ehu.more-info-" + entLangSing >
		<#local entLangPlur = "ehu.more-info-" + entLangPlur >
	</#if>

	<#local nomElemUrlTitle = entDatoNomElemPre + cNomElemUrlTitle >
	<#local nomElemUrlNewTab = entDatoNomElemPre + cNomElemUrlNewTab >
	<#if entDato.getSiblings()?size == 1>
		<#local entLang =  entLangSing>
	<#else>
		<#local entLang = entLangPlur>
	</#if>
	<div class="${ classGenName }" >
		<#if !isGlobal>
			<@numElems tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Apartado />
			<#local numValidDocs = te_NumElems >
			<@numElems tipoElem=cElemTipo_Link tipoSeccion=cSeccTipo_Apartado />
			<#local numValidUrls = te_NumElems >
			<#if (numValidDocs > 0) && (tipoElem == cElemTipo_Document)>
				<p class="${ classTitle }"><strong><@liferay.language key=entLang />:</strong></p>
			</#if>
			<#if (numValidUrls > 0) && (tipoElem == cElemTipo_Link)>
				<p class="${ classTitle }"><strong><@liferay.language key=entLang />:</strong></p>
			</#if>
		</#if>
		<ul>
		    <#list arrDatos as entElem >
				<#if entElem??>
					<#if entElem?is_hash >
						<#assign aux = entElem.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entElem ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign dato = aux>
					<#else>
						<#assign dato = "">
					</#if>
				</#if>

				<#if  validator.isNull(dato) || dato == "" >	<#continue> </#if>
				<#if tipoElem == cElemTipo_Document >
					<#if dato?contains( "/" ) >
						<@upvlibs.formatAttachment documentField=entElem documentTitleField=documentTitleField />
						<#local formatedDocument = upvlibs.formatedDocument >
						<li>${ formatedDocument }</li>
					</#if>
				<#else>
					
					<#local formattedURL = "" >
					<#if entElem?is_hash >
						<#local aux = entElem.getData() >
					<#else>
						<#local aux = getterUtil.getString(entElem) >
					</#if>
					<#if aux?has_content && aux != "">
						<#local formattedURL = aux>
					</#if>
					<#local urlTitle = "">
					<#if entElem?? && entElem.getChild( nomElemUrlTitle )?? && nomElemUrlTitle != "">					
						<#assign entrada = entElem.getChild( nomElemUrlTitle ) >
					</#if>
					<#if entrada??>
						<#if  entrada?is_hash >
							<#local aux =  entrada.getData() >
						<#else>
							<#local aux = getterUtil.getString(  entrada ) >
						</#if>
						<#if aux?has_content && aux != "">
							<#local urlTitle = aux>
						<#else>
							<#local urlTitle = "">
						</#if>
					</#if>
					<#if urlTitle!= "">
						<#local urlDesc = urlTitle>
					<#else>
						<#local urlDesc = formattedURL>
					</#if>
					<#local urlNewTab = getterUtil.getBoolean( "false")>
					<#if entElem?? && entElem.getChild( nomElemUrlNewTab )?? && nomElemUrlNewTab != "">						
						<#assign entrada = entElem.getChild( nomElemUrlNewTab ) >
					</#if>
					<#if entrada??>
						<#if entrada?is_hash >
							<#assign aux = entrada.getData() >
						<#else>
							<#assign aux = getterUtil.getString( entrada ) >
						</#if>
						<#if aux?has_content && aux != "">
							<#local urlNewTab = getterUtil.getBoolean(aux) >
						<#else>
							<#local urlNewTab = getterUtil.getBoolean( "false")>
						</#if>
					</#if>
					<#if urlNewTab>
						<#local htmlTxtTargetNewTab = cHtmlTxtTargetNewTab>
					<#else>
						<#local htmlTxtTargetNewTab = "">
					</#if>
					
					<#if urlNewTab>
						<#local htmlTxtTagNewTab = cHtmlTxtTagNewTab>
					<#else>
						<#local htmlTxtTagNewTab = "">
					</#if>					
					
					<#if urlNewTab>
						<#local htmlTxtIconNewTab = cHtmlTxtIconNewTab>
					<#else>
						<#local htmlTxtIconNewTab = "">
					</#if>

					<li>
						<a href="${ formattedURL }" class="bullet bullet-url"${ htmlTxtTargetNewTab }>
							${ htmlTxtTagNewTab }
							${ urlDesc }
							${ htmlTxtIconNewTab }
						</a>
					</li>
				</#if>
			</#list>
		</ul>
	</div>
</#macro>




<#macro  numElems tipoElem tipoSeccion>
	<#assign te_NumElems = 0 >
	<#if ( tipoSeccion != cSeccTipo_Apartado && tipoSeccion != cSeccTipo_Adicional ) >	<#return> </#if>
	<#if ( tipoElem != cElemTipo_Document && tipoElem != cElemTipo_Link ) >				<#return> </#if>
	
	
	<#assign entDatoRaiz = ehuattachments>
	
	<#if tipoSeccion == cSeccTipo_Apartado >
		<#assign entDatoNomElemPre = cNomElemApartado>
	<#else>
		<#assign entDatoNomElemPre = cNomElemAdicional>
	</#if>
	<#if tipoElem == cElemTipo_Document >
		<#assign entDatoNomElemPos = cNomElemDoc>
	<#else>
		<#assign entDatoNomElemPos = cNomElemUrl>
	</#if>
	<#local entDatoNomElem = entDatoNomElemPre + entDatoNomElemPos >
	<#if entDatoRaiz?? && entDatoNomElem?? && entDatoNomElem != "" && entDatoRaiz.getChild( entDatoNomElem )?? >						
		<#assign entrada = entDatoRaiz.getChild( entDatoNomElem ) >
	
	</#if>
	<#if entrada??>
		<#local entDato = entrada>
			
		<#if entDato?? && entDato.getSiblings()??>
			<#assign te_NumElems = entDato.getSiblings()?size  >
			<#if ( entDato.getSiblings()?size > 0 ) >			
				<#local arrDatos = entDato.getSiblings() >
				<#list arrDatos as entElem >
					<#if entElem??>
						<#if entElem?is_hash >
							<#assign aux = entElem.getData() >
						<#else>
							<#assign aux = getterUtil.getString( entElem ) >
						</#if>
						<#if aux?? && aux == "">
							<#assign te_NumElems = te_NumElems - 1 >
						</#if>
					</#if>
				</#list>
			</#if>
		</#if>
	</#if>
</#macro>

<#--  macros para  ehuattachments-->

<#macro soloTitulo textBoxData arrSections>
	
	<#local haytextBoxData = getterUtil.getBoolean( "false")>
	<#if  textBoxData != "" >
		<#local haytextBoxData = getterUtil.getBoolean( "true")>
	</#if>
	<#local haySecciones = getterUtil.getBoolean( "false")>
	<#if arrSections??>
		<#list arrSections as section >
			<#if section??>
				<#if section?is_hash >
					<#local aux = section.getData() >
				<#else>
					<#local aux = getterUtil.getString( section ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#local sectionName = aux >
				<#else>
					<#local sectionName = "" >
				</#if>
			</#if>
			
			<#local description = "">
			<#if section.ehuinfodescription??>	
				<#if section.ehuinfodescription?is_hash >
					<#local aux = section.ehuinfodescription.getData() >
				<#else>
					<#local aux = getterUtil.getString( section.ehuinfodescription ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#local description = aux >
				<#else>
					<#local description = "">
				</#if>
			</#if>
			<#local entImage = section.ehuinfoimage >
			<#local image = "">
			<#if entImage?? >
				<#if entImage?is_hash >
					<#local aux = entImage.getData() >
				<#else>
					<#local aux = getterUtil.getString( entImage ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#local image = aux >
				<#else>
					<#local image = "">
				</#if>
			</#if>
			<#if section??>
				<@numElemsSeccion tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Apartado section=section />
				<#local numValidDocs = te_NumElems >
				<@numElemsSeccion tipoElem=cElemTipo_Link tipoSeccion=cSeccTipo_Apartado section=section />
				<#local numValidUrls = te_NumElems >
				<#if  sectionName != "" || description != "" || image != "" ||  (numValidDocs > 0) || (numValidUrls > 0) >
					<#local haySecciones = getterUtil.getBoolean( "true")>
				</#if>
			</#if>
		</#list>
	</#if>
	<#assign hayalgo = haySecciones || haytextBoxData>
</#macro>


<#-- HTML -->
<article class="${ articleClass }">

	<#-- TITLE -->
	<#if entHeader.ehuinfotitle??>
		<#if entHeader.ehuinfotitle?is_hash >
			<#assign aux = entHeader.ehuinfotitle.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entHeader.ehuinfotitle ) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign title = aux >
		<#else>
			<#assign title = "">
		</#if>
		<#if  title != "" >
			<header id="${info_title}">
				<h1${ htmlTitleClass }>${ title }</h1>
			</header>
		</#if>
	</#if>
	<#assign textBoxClass = "entry" >
	<#if isGlobal >
		<#assign textBoxClass = textBoxClass + " information-detail__subtitle" >
	</#if>
	<#assign textBoxData = "" >
	<#if entHeader.ehuinfointro??>
		<#if entHeader.ehuinfointro?is_hash >
			<#assign aux = entHeader.ehuinfointro.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entHeader.ehuinfointro) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign textBoxData = aux >
		<#else>
			<#assign textBoxData = "" >
		</#if>
	</#if>
	<#assign esHTML = getterUtil.getBoolean("false")>
	<#if textBoxData?matches(r".*</?[a-z]+>.*", "ri")>
		<#assign esHTML = getterUtil.getBoolean("true")>
	</#if>
	<#if textBoxData?? && textBoxData != "">
		<#if esHTML>
			${ textBoxData }
		<#else>	
			<p class="${ textBoxClass }">${ textBoxData }</p>
		</#if>
	</#if>
	<#if arrSections??>
		<@soloTitulo textBoxData arrSections />
	<#else>
		<#assign hayalgo = getterUtil.getBoolean( "false")>
		<#if  textBoxData != "" >
			<#assign hayalgo = getterUtil.getBoolean( "true")>
		</#if>
	</#if>
	
	
	<#assign pintar = hayalgo >
	<#if isGlobal && pintar>
		<div class="information-detail__body">
	</#if>

	<#assign titleIndex = "" >
	<#if entHeader.ehuindex??>
		<#if entHeader.ehuindex?is_hash >
			<#assign aux = entHeader.ehuindex.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entHeader.ehuindex) >
		</#if>
	</#if>
	<#if aux?? && aux?has_content && aux != "">
		<#assign showIndex = getterUtil.getBoolean(aux) >
	<#else>
		<#assign showIndex = getterUtil.getBoolean( "false")>
	</#if>
	<#assign title = "">
	<#if entHeader.ehuinfotitle??>
		<#if entHeader.ehuinfotitle?is_hash >
			<#assign aux = entHeader.ehuinfotitle.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entHeader.ehuinfotitle ) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign title = aux >
		<#else>
			<#assign title = "">
		</#if>
	</#if>
	<#if showIndex && arrSections??>
		<#-- Eliminacion de los espacios del titulo para que se pueda usuar como ancla -->
		<#-- Ademas, se dejan 20 caracteres como maximo -->
		<#assign titleIndexAux = title?replace( " ", "" ) >
		<#if (titleIndexAux?length > 19)>
			<#assign titleIndexAux2 = titleIndexAux?substring(0, 19) >
		<#else>
			<#assign titleIndexAux2 = titleIndexAux>
		</#if>
		
		<#-- Se elimina también el carácter doble comilla para que no interfiera con los enlaces - lagun 698390  -->
		<#assign titleIndex = titleIndexAux2?replace( '"', '' ) >
		<#assign subtitleIndex = 1 >
		<nav role="navigation"${ htmlIndexNavClass }>
			<ul>
			    <#list arrSections as section >
					<#if section?is_hash >
						<#assign aux = section.getData() >
					<#else>
						<#assign aux = getterUtil.getString( section) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign sectionName = aux>
					<#else>
						<#assign sectionName = "">
					</#if>
			
					
					<#-- Solo pintamos la sección en el índice si tiene título -->
					<#if sectionName == "" >
						<#assign image = "">
						<#if section.ehuinfoimage??>
							<#if section.ehuinfoimage?is_hash >
								<#assign aux = section.ehuinfoimage.getData() >
							<#else>
								<#assign aux = getterUtil.getString( section.ehuinfoimage) >
							</#if>
							<#if aux?has_content && aux != "">
								<#assign image = aux>
							<#else>
								<#assign image = "">
							</#if>
						</#if>
						<#if image == "" >
							<#assign description = "">
							<#if section.ehuinfodescription??>
								<#if section.ehuinfodescription?is_hash >
									<#assign aux = section.ehuinfodescription.getData() >
								<#else>
									<#assign aux = getterUtil.getString( section.ehuinfodescription) >
								</#if>
								<#if aux?has_content && aux != "">
									<#assign description = aux>
								<#else>
									<#assign description = "">
								</#if>
							</#if>
							<#if description == "">
								<@numElemsSeccion cElemTipo_Document cSeccTipo_Apartado section />
								<#assign numValidDocs = te_NumElems >
								<@numElemsSeccion cElemTipo_Link cSeccTipo_Apartado section />
								<#assign numValidUrls = te_NumElems >
								<#if ( numValidDocs <= 0 && numValidUrls <= 0 ) > <#continue> </#if>
							</#if>
						</#if>
						<#assign sectionIndex = section?index + 1 >
						<#if  languageUtil.getLanguageId(locale) == "eu" >
							<#assign sectionIndex = sectionIndex + "." >
						</#if>
						<#assign sectionName = languageUtil.format( locale, "ehu.section-x", sectionIndex ) >
					<#else>			
						<li>
							<a href="#${ titleIndex }${ subtitleIndex }">${ htmlNavHrefIconTag }
								<#if !isGlobal >
									${ sectionName }
								<#else>
									<span>${ sectionName }</span>
								</#if>
							</a>
						</li>
					</#if>
					<#assign subtitleIndex = subtitleIndex + 1 >
				</#list>
			</ul>
		</nav>
	</#if>

	<#assign subtitleIndex = 1 >
	<#if arrSections??>
		<#list arrSections as section >
			<#assign haySectionInfo = false >
			<#if !showIndex >
				<#assign htmlSectionId = "" >
			<#else>
				<#assign htmlSectionId = ' id="' + titleIndex + subtitleIndex?string + '"'>
				<#assign subtitleIndex = subtitleIndex + 1 >
			</#if>
			
			<#assign sectionName = "" >
			<#if section??>
				<#if section?is_hash >
					<#assign aux = section.getData() >
				<#else>
					<#assign aux = getterUtil.getString( section ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign sectionName = aux >
				<#else>
					<#assign sectionName = "" >
				</#if>
			</#if>
			
			<#-- Comprobamos si la sección tiene título porque si no lo tiene no hay que pintar la sección de "Atrás" -->
			<#assign haySectionTitle = false >
			<#if sectionName?? && sectionName?has_content && sectionName != "">
				<#assign haySectionTitle = true >
			</#if>			
			
			<#assign description = "">
			<#if section.ehuinfodescription??>	
				<#if section.ehuinfodescription?is_hash >
					<#assign aux = section.ehuinfodescription.getData() >
				<#else>
					<#assign aux = getterUtil.getString( section.ehuinfodescription ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign description = aux >
				<#else>
					<#assign description = "">
				</#if>
			</#if>
			<#assign entImage = section.ehuinfoimage >
			<#assign image = "">
			<#if entImage?? >
				<#if entImage?is_hash >
					<#assign aux = entImage.getData() >
				<#else>
					<#assign aux = getterUtil.getString( entImage ) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign image = aux >
				<#else>
					<#assign image = "">
				</#if>
			</#if>
			<#assign numValidDocs = 0 >
			<#assign numValidUrls = 0 >
			<@numElemsSeccion tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Apartado section=section />
			<#assign numValidDocs = te_NumElems >
			<@numElemsSeccion tipoElem=cElemTipo_Link tipoSeccion=cSeccTipo_Apartado section=section />
			<#assign numValidUrls = te_NumElems >
	
			<#if  sectionName != "" || description != "" || image != "" ||  (numValidDocs > 0) || (numValidUrls > 0) >
				<section class="${ sectionClass }"${ htmlSectionId }>
			</#if>
			
			<#if sectionName != "" >
				<#assign haySectionInfo = true >
				<${ sectionHeaderTag } class="${ sectionTitleClass }">
				<#if !isGlobal >
					<h2>${ sectionName }</h2>
				<#else>
					${ sectionName }
				</#if>
				</${ sectionHeaderTag }>
			</#if>
			

			<#if  image != "" >
			
				<#assign haySectionInfo = true >
				<#assign image_src = htmlUtil.escape( image ) >
				<#assign imageAltText = cTxtImage>
				<#if entImage.ehuinfoimagealt??>
					<#if entImage.ehuinfoimagealt?is_hash >
						<#assign aux = entImage.ehuinfoimagealt.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImage.ehuinfoimagealt ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign imageAltText = aux >
					<#else>
						<#assign imageAltText = cTxtImage>
					</#if>
				</#if>
				<#assign imageFootText = "" >
				<#if entImage.ehuimagefoot??>
					<#if entImage.ehuimagefoot?is_hash >
						<#assign aux = entImage.ehuimagefoot.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImage.ehuimagefoot ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign imageFootText = aux >
					<#else>
						<#assign imageFootText = "">
					</#if>
				</#if>
				<#assign imageAuthorText = "">
				<#if entImage.ehuimageauthor??>
					<#if entImage.ehuimageauthor?is_hash >
						<#assign aux = entImage.ehuimageauthor.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImage.ehuimageauthor ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign imageAuthorText = aux >
					<#else>
						<#assign imageAuthorText = "">
					</#if>
				</#if>
				<#assign image_align = "">
				<#if entImage.ehuinfoimagedisposition??>
					<#if entImage.ehuinfoimagedisposition?is_hash >
						<#assign aux = entImage.ehuinfoimagedisposition.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImage.ehuinfoimagedisposition ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign image_align = aux >
					<#else>
						<#assign image_align = "">
					</#if>
				</#if>
				<#assign entImageUrl = entImage.ehuinfoimageurl >
				<#assign image_url = "">
				<#if entImageUrl?? >
					<#if entImageUrl?is_hash >
						<#assign aux = entImageUrl.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImageUrl ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign image_url = aux >
					<#else>
						<#assign image_url = "">
					</#if>
				</#if>
				<#assign image_url_title = "">
				<#if entImageUrl.ehuinfoimageurltitle?? >
					<#if entImageUrl.ehuinfoimageurltitle?is_hash >
						<#assign aux = entImageUrl.ehuinfoimageurltitle.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImageUrl.ehuinfoimageurltitle ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign image_url_title = aux >
					<#else>
						<#assign image_url_title = "">
					</#if>
				</#if>
				<#assign image_url_new_tab = getterUtil.getBoolean( "false")>
				<#if entImageUrl.ehuinfoimageurlnewtab?? >
					<#if entImageUrl.ehuinfoimageurlnewtab?is_hash >
						<#assign aux = entImageUrl.ehuinfoimageurlnewtab.getData() >
					<#else>
						<#assign aux = getterUtil.getString( entImageUrl.ehuinfoimageurlnewtab ) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign image_url_new_tab = getterUtil.getBoolean(aux) >
					<#else>
						<#assign image_url_new_tab = getterUtil.getBoolean( "false")>
					</#if>
				</#if>
				
				<#assign formattedURL = "" >
				<#assign classFigure = "" >
				<#assign divFigure = false >
	
				<#if image_align == "top" || image_align == "bottom" >
					<#assign classFigure = "center" >
					<#if image_align == "bottom" >
						<#if description != "" >
							<div class="${ sectionDescClass }">
								${ description }
							</div>
						</#if>
					</#if>
				<#else>
					<#if !isGlobal >
						<#if image_align == "right" >
							<#assign classAlign = image_align >
						<#else>
							<#assign classAlign =  "left"  >
						</#if>
						<div class="figure ${ classAlign } span4">
						<#assign divFigure = true >
					</#if>
				</#if>
				<#assign aFigureLink = false >
				
				<#if  image_url != "" >						
						<#assign formattedURL = "" >
						<#if entImageUrl?is_hash >
							<#assign aux = entImageUrl.getData() >
						<#else>
							<#assign aux = getterUtil.getString(entImageUrl) >
						</#if>
						<#if aux?has_content && aux != "">
							<#assign formattedURL = aux>
						</#if>
						
						<#assign urlTitle = image_url_title >
						<#if image_url_new_tab >
							<#assign htmlUrlTarget = ' target="_blank" ' >
						<#else>
							<#assign htmlUrlTarget = "" >
						</#if>
						<#if urlTitle != "" && image_url_new_tab >
							<#assign urlTitle = urlTitle + " _ " + cTxtNewWindow >
						</#if>
						<#if urlTitle != "" >
							<#assign htmlUrlTitle =  ' title="' + urlTitle + '" ' >
						<#else>
							<#assign htmlUrlTitle = "" >
						</#if>						
					</#if>
					
				<#if isGlobal >
					<#if image_align == "right" || image_align == "left">
						<#assign classAlign = " " + image_align + " " >
					<#else>
						<#assign classAlign =  ""  >
					</#if>
					
					<#if  image_url != "" >
						<a class="figure-link center" href="${ formattedURL }"${ htmlUrlTitle }${ htmlUrlTarget }>
					</#if>
					
					<div class="information-detail__body__section__main-image${ classAlign }">
					<#assign divFigure = true >
				</#if>
	
									
				<#if isGlobal ||  classFigure == "">
					<#assign htmlFigureClass = "" >
				<#else>
					<#assign htmlFigureClass = ' class="' + classFigure + '"' >
				</#if>
				
							
				<#if !isGlobal &&  image_url != "" >
					<a class="figure-link center" href="${ formattedURL }"${ htmlUrlTitle }${ htmlUrlTarget }>
				</#if>
				
				<figure${ htmlFigureClass }>
				<img src="${ image_src }" alt="${ imageAltText }" />
				
			
				<#if imageFootText != "" || imageAuthorText != "" >
					<#if isGlobal >
						<div class="main-image__footer">
					</#if>
					<#if imageFootText == "" >
						<#assign txtPhoto = "">
					<#else>	
						<#assign txtPhoto = imageFootText >
					</#if>

					<#if imageAuthorText != "" >
						<#if imageFootText == "" >
							<#assign aux = "">
						<#else>	
							<#assign aux = " | "  >
						</#if>
						<#assign txtPhoto = txtPhoto + aux + cTxtPhoto + ": " + imageAuthorText >
					</#if>
					<${ imageFootTag }>${ txtPhoto }</${ imageFootTag }>
					<#if isGlobal >
						</div> <#-- class="main-image__footer" -->
						</figure>
					<#else>
					
						</figure>
					</#if>
				<#else>
					 </figure>
					 <#--
					<#if !isGlobal >
						</figure>
					</#if>
					 -->
				</#if>
	
				<#if !isGlobal >
					<#if image_url != "" >
						</a>
					</#if>
				</#if>
				<#if divFigure >
					</div>
				</#if>
				<#if isGlobal >
					<#if image_url != "" >
						</a>
					</#if>
				</#if>
	
				<#if image_align != "bottom" >
					<#if description != "" >
						<div class="${ sectionDescClass }">
							${ description }
						</div>
					</#if>
				</#if>
	
				<#-- photo -->
				<#-- image & description -->
			<#else>	
				<#if  description != "" >
					<#assign haySectionInfo = true >
					<div class="${ sectionDescClass }">
						${ description }
					</div>
				</#if>
				<#-- description -->
			</#if>
		
			<#if ( numValidDocs > 0 || numValidUrls > 0 ) >
				<#assign haySectionInfo = true >
				<@tratarElemsSeccion tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Apartado section=section />
				<@tratarElemsSeccion tipoElem=cElemTipo_Link tipoSeccion=cSeccTipo_Apartado section=section />
			</#if>
	
			<#if isGlobal >
				<#if  sectionName != "" || description != "" || image != "" ||  (numValidDocs > 0) || (numValidUrls > 0) >
					</section> <#-- class="information-detail__body__section" -->
				</#if>
			</#if>
	
			<#if showIndex && haySectionInfo && haySectionTitle >
				<div class="backtop">
					<a href="#${info_title}">
						<#if !isGlobal >
							<@liferay.language key="up" />
							<span class="icon-chevron-up"></span>
						<#else>
							<i class="icon-double-angle-up"></i> 
							<span><@liferay.language key="ehu.back" />
								<span><@liferay.language key="up" /></span>
							</span> 
						</#if>
					</a>
				</div>				
			</#if>
			
			<#if !isGlobal >
				<#if  sectionName != "" || description != "" || image != "" ||  (numValidDocs > 0) || (numValidUrls > 0) >
					</section> <#-- class="information-detail__body__section" -->
				</#if>
			</#if>
			
		</#list>
	</#if>
	
	<#if isGlobal && pintar>
		</div> <#-- class="information-detail__body" -->
	</#if>


	<@numElems tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Adicional />
	<#assign numValidDocs = te_NumElems >
	<@numElems tipoElem=cElemTipo_Link  tipoSeccion=cSeccTipo_Adicional />
	<#assign numValidUrls = te_NumElems >

	<#if ( numValidDocs > 0 || numValidUrls > 0 ) >
		<#if isGlobal >
            <div class="informacion-adicional__title">
			    <h3><@liferay.language key="ehu.informacionAdicional" /></h3>
            </div> 
		</#if>
		<#if ( numValidDocs > 0 ) >
			<#if !isGlobal >
			    <@tratarElems tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Adicional />
			<#else>
				<div class="information-detail__documents">
				    <@tratarElems tipoElem=cElemTipo_Document tipoSeccion=cSeccTipo_Adicional />
				</div>
			</#if>
		</#if>
		<#if ( numValidUrls > 0 ) >
			<#if !isGlobal >
			    <@tratarElems cElemTipo_Link cSeccTipo_Adicional />
			<#else>
				<div class="information-detail__links">
				    <@tratarElems cElemTipo_Link cSeccTipo_Adicional />
				</div>
			</#if>
		</#if>
	</#if>

	<#-- LAST MODIFICATION DATE -->
	<#assign showDate = getterUtil.getBoolean( "false")>
	<#if entHeader.ehudateshow??>
		<#if entHeader.ehudateshow?is_hash >
			<#assign aux = entHeader.ehudateshow.getData() >
		<#else>
			<#assign aux = getterUtil.getString( entHeader.ehudateshow ) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign showDate = getterUtil.getBoolean(aux) >
		<#else>
			<#assign showDate = getterUtil.getBoolean( "false")>
		</#if>
	</#if>
	<#if showDate >
		<div class="${ footerClass }">
			
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
					<#assign modifiedDateStr = "" >
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

</article>
<script>
    if($(".information-detail__body h2").length==0){
        var element=$(".informacion-adicional__title h3").html();
        $(".informacion-adicional__title h3").remove();
        $(".informacion-adicional__title").prepend("<h2>"+element+"</h2>");
    }
</script>

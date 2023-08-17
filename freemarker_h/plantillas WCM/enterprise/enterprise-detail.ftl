<#--
Nombre contenido (ES): Empresa
Estructura: kontratazioa > enterprise.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/kontratazioa/enpresa
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign entGeneralData = ehucompanygeneraldata >
<article class="enterprise">
	<header class="company-title">
		<h1>${entGeneralData.ehucompanyname.getData()}</h1>
	</header>

	<#assign companyLogoSrc = htmlUtil.escape(entGeneralData.ehucompanylogo.getData() )>
	<#if companyLogoSrc?has_content >
		<div class="upv-ehu-company-logo">
			<img alt="" src="${companyLogoSrc}" />
		</div>
	</#if>

	<#-- Datos de contacto-->
	<#assign entContacto = ehucompanycontactdata >
	<#assign entPhones = entContacto.ehucompanyphonetext >
	<#assign entMails = entContacto.ehucompanyemailtext >
	<#assign entWebs = entContacto.ehucompanyurltext >
	
	<#assign hayPhones = getterUtil.getBoolean("false")>
	<#if entPhones.ehucompanyphone??>
		<#assign hayPhones = upvlibs.hasElement(entPhones.ehucompanyphone) >
	</#if>
	<#assign hayMails = getterUtil.getBoolean("false")>
	<#if entMails.ehucompanyemail??>
		<#assign hayMails = upvlibs.hasElement(entMails.ehucompanyemail) >
	</#if>
	<#assign hayWebs = getterUtil.getBoolean("false")>
	<#if entWebs.ehucompanyurl??>
		<#assign hayWebs = upvlibs.hasElement(entWebs.ehucompanyurl) >
	</#if>	 
	<#if hayPhones || hayMails || hayWebs >
		<header>
			<h2><@liferay.language key="ehu.contact-data" /></h2>
		</header>
	</#if> 
    <#if hayPhones>
        <@upvlibs.writeHtmlForPhones entradaInfo=entPhones nomEntradaTit="" nomEntradaVal="ehucompanyphone" nivelHIni=3/>
    </#if>
    <#if hayMails >
	    <@upvlibs.writeHtmlForMails entradaInfo=entMails nomEntradaTit="" nomEntradaVal="ehucompanyemail" nivelHIni=3/>
	</#if>
	<#if hayWebs >				
	
		<div class="webs">			
			<#assign titulo =languageUtil.get(locale, "ehu.web-page")>
	 		<h3>${titulo}</h3>
			 <ul>
			<#assign arrWebs = entWebs.getSiblings() >
			<#list arrWebs as entElem >
				<#if entElem??>
					<#assign text = "" >
					<#assign url = "" >
					<#assign target = ' target="_blank"'>
					
					<#if entElem?has_content >
						<#assign text = entElem.getData() >		
					</#if>			
			
					<#if entElem.ehucompanyurl?has_content >
						<#assign url = entElem.ehucompanyurl.getData() >
					</#if>
					
					<#if url?has_content && url != "" >													
						<#if text == "">
							<#assign text = url>
						</#if>
						<li>	
							<a href="${ url }" class="bullet bullet-url"${ target }>
								<span class="hide-accessible"><@liferay.language key="opens-new-window"/></span>
								${ text }
								<span class="icon-external-link"></span>						
							</a>
						</li>		
					</#if>
				</#if>
			</#list>
			</ul>
		</div>	
	</#if>

	<#-- Datos de localizacion -->
	<#assign entLocation = ehucompanylocationdata >
	<#assign entLocationStreet = entLocation.ehucompanyaddressstreet >
	<#assign entLocationPD = entLocation.ehucompanyaddresspostcode >
	<#assign entLocationCity = entLocation.ehucompanyaddresscity >
	<#assign entLocationProvince = entLocation.ehucompanyaddressprovince >

	<#assign hayStreet = getterUtil.getBoolean("false")>
	<#if entLocationStreet??>
		<#assign hayStreet = upvlibs.hasElement(entLocationStreet) >
	</#if>
	<#assign hayPD = getterUtil.getBoolean("false")>
	<#if entLocationPD??>
		<#assign hayPD = upvlibs.hasElement(entLocationPD) >
	</#if>
	<#assign hayCity = getterUtil.getBoolean("false")>
	<#if entLocationCity??>
		<#assign hayCity = upvlibs.hasElement(entLocationCity) >
	</#if>
	<#assign hayProvince = getterUtil.getBoolean("false")>
	<#if entLocationProvince??>
		<#assign hayProvince = upvlibs.hasElement(entLocationProvince) >
	</#if>
	
	<#assign hayLocation = hayStreet || hayPD || hayCity || hayProvince >
	<#if hayLocation >
		<header>
			<h2><@liferay.language key="ehu.location" />:</h2>
		</header>
		<div class="upv-ehu-company-location">
			<address>
				<#assign linLocation = "" >
				<#if hayStreet >
					<#assign linLocation = '<span class="address">' + entLocationStreet.getData() + '</span>' >
				</#if>
				<#if hayPD >
					<#if linLocation != "" >
						<#assign linLocation = linLocation + ' - ' >
					</#if>
					<#assign linLocation = linLocation + '<span class="postalCode">' + entLocationPD.getData() + '</span>' >
				</#if>
				<#if hayCity >
					<#if linLocation != "" >
						<#assign linLocation = linLocation + ', ' >
					</#if>
					<#assign linLocation = linLocation + '<span class="city">' + entLocationCity.getData() + '</span>' >
				</#if>
				<#if hayProvince >
					<#if linLocation != "" >
						<#assign linLocation = linLocation + ' ' >
					</#if>
					<#assign linLocation = linLocation + '<span class="province">(' + entLocationProvince.getData() + ')</span>' >
				</#if>
				${linLocation}
			</address>
		</div>
	</#if>

	<#-- Informacion extra: documentos, enlaces... -->
	<#assign entExtraInf = ehucompanyextrainformationdata >
	<#assign entExtraInfDocs = entExtraInf.ehucompanydocument >
	<#assign entExtraInfLinks = entExtraInf.ehucompanylinks >
	 
	<#assign hayDocs = getterUtil.getBoolean("false")>
	<#if entExtraInfDocs??>    
   		<#assign hayDocs = upvlibs.hasElement(entExtraInfDocs) > 
   	</#if>	
   	<#assign hayLinks = getterUtil.getBoolean("false")>
	<#if entExtraInfLinks??>
    	<#assign hayLinks = upvlibs.hasElement(entExtraInfLinks) >
    </#if>
	<#if hayDocs || hayLinks >
		<header>
			<h2><@liferay.language key="ehu.more-info" /></h2>
		</header>
	</#if> 
	<#if hayDocs >
    	<@upvlibs.writeHtmlForDocs entradaInfo=entExtraInfDocs nomEntradaTit="ehucompanydocumenttitle" nomEntradaVal=""  nivelHIni=3 />
    </#if>
    <#if hayLinks >
    	<@upvlibs.writeHtmlForLinks entradaInfo=entExtraInfLinks nomEntradaTit="ehucompanylinkstitle" nomEntradaVal="" nivelHIni=3 nomEntrNewTab="ehucompanylinkstitle" newTab=true />
    </#if>
</article>
<#assign formatedURL="">
<#assign fifty=getterUtil.getInteger("50")>
<#assign forty_nine=getterUtil.getInteger("49")>
<#assign zero=getterUtil.getInteger("0")>

<#assign titleLength=getterUtil.getInteger(ehubannertext.getData())?length>
<#assign formattedTittle=getterUtil.getString(ehubannertext.getData())>
<#assign alttext = "">					
<#if ehubannerimage.ehubannerimagealttext??>
	<#if ehubannerimage.ehubannerimagealttext?is_hash >
		<#assign aux = ehubannerimage.ehubannerimagealttext.getData() >
	<#else>
		<#assign aux = getterUtil.getString( ehubannerimage.ehubannerimagealttext) >
	</#if>
	<#if aux?has_content && aux != "">
		<#assign alttext = aux>
	</#if>
</#if>


<#if ehubannerurl?is_hash >
	<#assign aux = ehubannerurl.getData() >
<#else>
	<#assign aux = getterUtil.getString(ehubannerurl) >
</#if>
<#if aux?has_content && aux != "">
	<#assign formatedURL = aux>
</#if>

<#if themeDisplay.getTheme().getContextPath() == "/o/ehu-theme">
	<aside>
		<div class="banner">            
		
		<#if ehubannertitle?? && ehubannertitle.getData()?has_content >
			<#if ehubannerurl?? && ehubannerurl.ehubannerurlnewtab?? && ehubannerurl.ehubannerurlnewtab.getData()?? &&  getterUtil.getBoolean(ehubannerurl.ehubannerurlnewtab.getData())>
				<a href="${formatedURL}" title="${ehubannertitle.getData()}" target="_blank">				
			<#else>
				<a href="${formatedURL}" title="${ehubannertitle.getData()}">
			</#if>						
		<#elseif ehubannerurl?? && ehubannerurl.ehubannerurlnewtab?? && ehubannerurl.ehubannerurlnewtab.getData()?? &&  getterUtil.getBoolean(ehubannerurl.ehubannerurlnewtab.getData())>
			<a href="${formatedURL}" target="_blank">			
		<#else>
			<a href="${formatedURL}">
		</#if>
		    
			<figure>
				<img src="${htmlUtil.escape(ehubannerimage.getData())}" alt="${alttext}" />
					
				<figcaption>
					<#if ((titleLength > fifty)?c)?boolean >
						<#assign formattedTittle=formattedTittle?substring(zero,forty_nine)>
					</#if>
				    <#assign ehubannerlangData = ehubannerlang.getData()>
					<#if ehubannerlangData?has_content && ehubannerlangData!="default" && ehubannerlangData!="upv-ehu-blank">
					    <span lang="${ehubannerlangData}">
							${formattedTittle} 
						</span>
					<#else>
						${formattedTittle}
					</#if>
				</figcaption>                
	        </figure>
			</a>
		</div>
	</aside>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

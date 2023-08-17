<#assign formatedURL = "" >
<#if ehuoutstandinglink?is_hash >
	<#assign aux = ehuoutstandinglink.getData() >
<#else>
	<#assign aux = getterUtil.getString(ehuoutstandinglink) >
</#if>
<#if aux?has_content && aux != "">
	<#assign formatedURL = aux>
</#if>
<#assign titulo = ehuoutstandingtitle.getData() >
<#assign link_title = ehuoutstandinglink.ehuoutstandinglinktitle.getData() >
<#assign link_in_new_tab = getterUtil.getBoolean(ehuoutstandinglink.ehuoutstandingurlnewtab.getData() ) >
<#assign href_title = "" >
<#assign href_target = "" >

<@upvlibs.hrefOptions new_tab=link_in_new_tab link_title=link_title href_title=href_title href_target=href_target />
<#assign href_title = upvlibs.href_title >
<#assign href_target = upvlibs.href_target >

<#if titulo?has_content>
    <#assign className = "outstanding-summary" >
    <#assign txtHRef = titulo >
<#else>
    <#assign className = "alert alert-error" >
    <#assign txtHRef = languageUtil.get(locale, "ehu.error.title-not-filled" )>
</#if>
<#if link_in_new_tab || link_title?has_content>
    <#assign titleHRef = href_title>
<#else>
    <#assign titleHRef = "" >
</#if>

<#if themeDisplay.getTheme().getContextPath() == "/o/ehu-theme">
	<div class=${className} >
		<a href="${formatedURL}" title="${titleHRef}" target="${href_target}">
			<span class="outstanding" >${txtHRef}</span>
		</a>
	</div>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
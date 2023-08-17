<#-- TITLE -->

<#if  ehuheader?? &&  ehuheader.ehuinfotitle?? &&  ehuheader.ehuinfotitle.getData()??>
	<#assign title = ehuheader.ehuinfotitle.getData()/>
</#if>

<#if title?has_content>
    <span class="information">
        ${title}                
    </span>
<#else>
    <div class="alert alert-error">
        <@liferay.language key="ehu.error.title-not-filled" />
    </div>
</#if>

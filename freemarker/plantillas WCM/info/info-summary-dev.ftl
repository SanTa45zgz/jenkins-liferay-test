<#-- TITLE-->

<#if  ehuheader?? &&  ehuheader.ehuinfotitle?? &&  ehuheader.ehuinfotitle.getData()??>
	<#assign title = ehuheader.ehuinfotitle.getData()/>
<#else>
	<#assign title = ""/>
</#if>

<div class="information">
    <h2>${title}</h2>
</div>
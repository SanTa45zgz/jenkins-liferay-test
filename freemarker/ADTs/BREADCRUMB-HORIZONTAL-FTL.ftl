<#-- Evita que se muestren las páginas ocultas ni las de tipo contenedoras -->

<#-- Se obtiene la friendlyURL del site -->
<#assign urlSite = (themeDisplay.getSiteGroup().getDisplayURL(themeDisplay))?replace(themeDisplay.getPortalURL(),'')>


<#if entries?has_content>
	<ol class="breadcrumb">
		<#list entries as entry>
			<#if !entry.getBaseModel()?? || (!entry.getBaseModel().isHidden() && entry.getBaseModel().getType()!="node") || entry?is_last>
			 <#-- Se controla que no se pinta el site en la miga de pan -->
			    <#if entry?? && entry.getURL()??>
				    <#assign entryURL = entry.getURL()>
    			    <#if entryURL?has_content && entryURL!=urlSite>
        				<li class="breadcrumb-item">
        					<#if entry?has_next>
        						    <a class="breadcrumb-link" href="${entry.getURL()!""}" title="${htmlUtil.escape(entry.getTitle())}">
        							    <span class="breadcrumb-text-truncate">${htmlUtil.escape(entry.getTitle())}</span>
        						    </a>
        					<#else>
        						<span class="active breadcrumb-text-truncate">${htmlUtil.escape(entry.getTitle())}</span>
        					</#if>
        				</li>
    				</#if>
    			<#else>
    			    <li class="breadcrumb-item">
        					<#if entry?has_next>
        						    <a class="breadcrumb-link" href="${entry.getURL()!""}" title="${htmlUtil.escape(entry.getTitle())}">
        							    <span class="breadcrumb-text-truncate">${htmlUtil.escape(entry.getTitle())}</span>
        						    </a>
        					<#else>
        						<span class="active breadcrumb-text-truncate">${htmlUtil.escape(entry.getTitle())}</span>
        					</#if>
        				</li>
    			</#if>
			</#if>
		</#list>
	</ol>
</#if>
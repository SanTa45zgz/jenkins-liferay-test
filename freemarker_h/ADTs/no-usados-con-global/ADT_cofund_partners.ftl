<#if entries?has_content>
    <div class="host-group-adt">
        <h2 class="title">Partners</h2>
	
        <ul class="host-groups-list">
            <#list entries as entry>				
                <#assign assetRenderer = entry.getAssetRenderer() 
                         journalArticle = assetRenderer.getArticle()
                         document = saxReaderUtil.read(journalArticle.getContent())
                         <#-- rootElement = document.getRootElement()
                         xPathSelector = saxReaderUtil.createXPath("dynamic-element[@name='partnerLogo']")
                         image = xPathSelector.selectNodes(rootElement).getStringValue() -->
                />

                <#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale))/>
                <#assign title = docXml.valueOf("//dynamic-element[@name='tituloPartner']/dynamic-content/text()") />
                <#assign img = docXml.valueOf("//dynamic-element[@name='partnerLogo']/dynamic-content/text()") />
                <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
                <#assign clase = ""/>
                <li>
                    <a href="${viewURL} "
                        <#list entry.getCategoryIds() as catId>
                            <#if catId == 24717050 >
                                <#assign clase = "upv-ehu"/>
                            <#elseif catId == 24717051>
                                <#assign clase = "bordeaux"/>
                            </#if>
    						data-catId-${catId}="${catId}"
    					</#list>
    				    class="host-group ${clase}" >
    				    <#assign clase = ""/>
                        <div class="project-name">${title}</div>
                        <div class="investigator-name"></div>
                    </a>
                </li>
            </#list>
        </div>
    </div>
</#if>
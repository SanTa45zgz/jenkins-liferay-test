<#assign groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")>
<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService")>
<#assign assetVocabularyLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService")>
<#assign assetCategoryLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")>

<div class="filters">
    <#assign voc = assetVocabularyLocalService.getGroupVocabulary(groupId, "Area")
    		 cats = assetCategoryLocalService.getVocabularyRootCategories(voc.getVocabularyId(), -1, -1, null)>
    <div class="filter">
        <label for="${randomNamespace}voc1">${voc.getTitle(locale)}</label>
        <select id="${randomNamespace}voc1">
            <option value=""></option>
            <#list cats as cat>
                <option value="${cat.getCategoryId()}">${cat.getTitle(locale)}</option>
            </#list>
        </select>
    </div>
    <#assign voc = assetVocabularyLocalService.getGroupVocabulary(groupId, "Institution")
    		 cats = assetCategoryLocalService.getVocabularyRootCategories(voc.getVocabularyId(), -1, -1, null)>
    <div class="filter">
        <label for="${randomNamespace}voc2">${voc.getTitle(locale)}</label>
        <select id="${randomNamespace}voc2">
            <option value=""></option>
            <#list cats as cat>
                <option value="${cat.getCategoryId()}">${cat.getTitle(locale)}</option>
            </#list>
        </select>
    </div>
</div>

<#if entries?has_content>
    <div class="host-group-adt">
        <h2 class="title">Host groups </h2>
		
		<div class="alert alert-info text-center sin-resultados hide">
			<@liferay.language key="no-results-were-found" />
		</div>
	
	
        <ul class="host-groups-list">
            <#list entries as entry>				
                <#assign assetRenderer = entry.getAssetRenderer() />

                <#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale))/>
                <#assign proyecto = docXml.valueOf("//dynamic-element[@name='GroupName']/dynamic-content/text()") />
                <#assign investigador = docXml.valueOf("//dynamic-element[@name='PrincipalInvestigator']/dynamic-content/text()") />
                <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
                
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
                    <div class="project-name">${proyecto}</div>
                    <div class="investigator-name">${investigador}</div>
                </a>
                </li>
            </#list>
        </div>
    </div>
	
	
	<script type="text/javascript">
	$(document).ready(function() {
	    console.log(".");
		$('#${randomNamespace}voc1, #${randomNamespace}voc2').change(function() {
			var cat1 = $('#${randomNamespace}voc1').val();
			var cat2 = $('#${randomNamespace}voc2').val();
			
			var resultadosWrapper = $('ul.host-groups-list');
			var sinResultadosWrapper = $('div.sin-resultados');
			
			var todos = resultadosWrapper.find('a.host-group');
			if (cat1 || cat2) {
				var filtrados = todos;
				if (cat1) {
					filtrados = filtrados.filter('[data-catId-'+cat1+']');
				}
				if (cat2) {
					filtrados = filtrados.filter('[data-catId-'+cat2+']');
				}
				
				todos.addClass('hide');
				filtrados.removeClass('hide');
				
				sinResultadosWrapper.toggleClass('hide', filtrados.length>0);
				resultadosWrapper.toggleClass('hide', filtrados.length==0);
			} else {
				todos.removeClass('hide');
				sinResultadosWrapper.addClass('hide');
				resultadosWrapper.removeClass('hide');
			}

		});
	});
	</script>
</#if>
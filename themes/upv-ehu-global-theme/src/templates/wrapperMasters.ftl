<#if masterRootPage??>
	<#assign masterName = masterRootPage.getName( locale ) />
	<#assign masterHtmlTitle = masterRootPage.getHTMLTitle( locale ) />
<#else>
	<#assign masterName = languageUtil.get( locale, "unknown" ) />
	<#assign masterHtmlTitle = "" />
</#if>


<#if facebookMasterURL?has_content || twitterMasterURL?has_content || linkedinMasterURL?has_content || instagramMasterURL?has_content || flickrMasterURL?has_content ||  blogMasterURL?has_content>
	<#assign socials=true/>
<#else>
	<#assign socials=false/>
</#if>


<#include "${full_templates_path}/header_masters.ftl" />

<section id="content" class="section section-padded" aria-label="<@liferay.language key='ehu.main-content'/>">
	<#if selectable>
		 <@liferay_util["include"] page=content_include /> 
	<#else>
		${portletDisplay.recycle()}

		${portletDisplay.setTitle(the_title)}

		<@liferay_theme["wrap-portlet"] page="portlet.ftl">
			<@liferay_util["include"] page=content_include />
		</@>
	
	</#if>
</section>


<div class="pre-footer" role="contentinfo">
    <div class="container d-flex"> 
        
	    <p class="ehu-sans">${masterHtmlTitle}</p>

	    <p id="footerContact"></p>  
	</div>
</div>


<#include "${full_templates_path}/footer.ftl" />

<header id="masthead" class="header header--featured">
	<div class="navbar">
		<div class="navbar-inner d-flex">
			<div class="container">
				<div class="brand">
					<a href="${themeDisplay.getCDNBaseURL()}${urlNavigationLanguage}">
				    	<img class="d-none d-md-block" src="${images_folder}/custom/ehu-upv-logotipo-completo-sin-fondo-branding-black.svg" alt="<@liferay.language key='ehu.university-of-the-basque-country' />">
				    	<img class="d-md-none d-block" src="${images_folder}/custom/ehu-upv-logotipo-completo-sin-fondo-branding-mobile-black.svg" alt="<@liferay.language key='ehu.university-of-the-basque-country' />">
				    </a>
				</div>	
				<#if  themeDisplay.getColorSchemeId()!="08"> <#-- Si no tiene el color scheme centros se carga el menu -->
					<#include "${full_templates_path}/header_menu.ftl" />
				</#if>
				<#include "${full_templates_path}/top_menu.ftl" />
			</div>
		</div>
	</div>
	<#include "${full_templates_path}/header_content.ftl" />
	<div class="header-rss-refresh container">
		<#include "${full_templates_path}/header_rrss.ftl" />
	</div>
</header>
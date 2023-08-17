<header id="headerMasters" class="header header--featured header--featured--masters ${hierarchyMasters}">
	<div class="navbar">
		<div class="navbar-inner d-flex">
			<div class="container">
				<div class="brand">
					<a href="${themeDisplay.getCDNBaseURL()}${urlNavigationLanguage}" class="logoMasters">
				    	<img class="d-none d-md-block" src="${images_folder}/custom/ehu-upv-logotipo-completo-sin-fondo-branding-black.svg" alt="<@liferay.language key='ehu.university-of-the-basque-country' />">
				    	<img class="d-md-none d-block" src="${images_folder}/custom/ehu-upv-logotipo-completo-sin-fondo-branding-mobile-black.svg" alt="<@liferay.language key='ehu.university-of-the-basque-country' />">
				    </a>
				</div>
				
				<#include "${full_templates_path}/header_menu.ftl" />
				<#include "${full_templates_path}/top_menu.ftl" />
				<#include "${full_templates_path}/header_rrss_masters.ftl" />
			</div>
		</div>
	</div>

	<#if imageMasterURL?? && imageMasterURL?has_content>
		<#assign cadenaVacia=false/>
	<#else>
		<#assign cadenaVacia=true/>
	</#if>

	<section aria-label="<@liferay.language key='header' />">
		<div class="header-content">
			<#if  !cadenaVacia>
				<div class="header-image">
				   	<img alt=" " src="${imageMasterURL}">
				</div>
			<#else>
				<div class="header-no-image"></div>	    		   					
			</#if>

			<#assign entTitMasterDef = "upv-ehu.masters.master" />
			<#assign entTitMaster = entTitMasterDef />
			<#assign titMasterInfo = "ok" />


			<#if validator?? && validator?has_content>

				<#assign tipo = getterUtil.getString(typeMaster, "") />
				<#if tipo == "Especializacion">
					<#assign entTitMaster = "upv-ehu.masters.masterSpecialization" />
				<#elseif tipo == "Propio" >
					<#assign entTitMaster = "upv-ehu.masters.masterOwn" />
				<#elseif tipo == "Experta" >
					<#assign entTitMaster = "upv-ehu.masters.masterExpert" />
				<#elseif tipo == "Diploma" >
					<#assign entTitMaster = "upv-ehu.masters.masterDiploma" />
				<#elseif tipo == "Universitario" >
					<#assign entTitMaster = "upv-ehu.masters.master" />
				<#else>
					<#assign titMasterInfo = tipo />
				</#if>

			<#elseif typeMaster?size lte 0 >
				<#assign titMasterInfo = "size0" />
			<#else>
				<#assign titMasterInfo = "null" />
			</#if>
			<div class="container">
				<div class="header-content__bgtitle">
					<p><@liferay.language key='${entTitMaster}'/></p>
			        <h1>${masterName}</h1>
	       		</div>
	       	</div>
		</div>
	</section>
</header>
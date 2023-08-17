<nav id="top-menu" class="navbar header__top-menu" role="navigation">
	<div class="nav" aria-label="<@liferay.language key='ehu.utility-menu'/>" role="menubar" >
		<#--## Si el usuario no esta identificado -->
		<#if !is_signed_in>
			<div class="header__top-menu__sign-in"> 
				<a data-redirect="${is_login_redirect_required?c}" href="${sign_in_url}" rel="nofollow" role="menuitem" tabindex="0">
					<img src="${images_folder}/icons/user-nireEHU.svg" alt="<@liferay.language key='ehu.nireEHU'/>">
					<span class="hide-accessible"><@liferay.language key='ehu.login'/></span>
				</a>
			</div>
		</#if>
		<div class="top-menu-search header__top-menu__search">
			
			<#assign searchPreferences = freeMarkerPortletPreferences.getPreferences({
			 "portletSetupPortletDecoratorId": "borderless",
			 "searchScope": "let-the-user-choose",
			 "com.liferay.portal.search.web.internal.facet.UserSearchFacet": "false",
			 "com.liferay.portal.search.web.internal.facet.FolderSearchFacet": "false",
			 "searchConfiguration": "{&#34;facets&#34;:[{&#34;fieldName&#34;:&#34;entryClassName&#34;,&#34;static&#34;:false,&#34;data&#34;:{&#34;frequencyThreshold&#34;:1,&#34;values&#34;:[&#34;com.liferay.journal.model.JournalArticle&#34;]},&#34;weight&#34;:1.5,&#34;className&#34;:&#34;entryClassName&#34;,&#34;id&#34;:&#34;com.liferay.portal.search.web.internal.facet.AssetEntriesSearchFacet&#34;,&#34;label&#34;:&#34;any-asset&#34;,&#34;order&#34;:&#34;OrderHitsDesc&#34;}]}"
			}) />

			<@liferay_portlet["runtime"]
				defaultPreferences=searchPreferences
				portletProviderAction=portletProviderAction.VIEW
				portletProviderClassName="com.liferay.admin.kernel.util.PortalSearchApplicationType$Search"
			/>
		</div>
		<#if themeDisplay.getColorSchemeId()=="08">
			<div class="language-portlet-7 header__top-menu__languages">
				<ul role="menu">
					<@liferay_ui["language"]
						ddmTemplateKey="ADT_MENU_IDIOMA_INGLES"
						ddmTemplateGroupId=themeDisplay.getCompanyGroupId()
						displayCurrentLocale=false
					/>
				</ul>
			</div>
		<#else>
			<div class="language-portlet-7 header__top-menu__languages">
				<ul role="menu">
					<@liferay_ui["language"]
						ddmTemplateKey="ADT_MENU_IDIOMA"
						ddmTemplateGroupId=themeDisplay.getCompanyGroupId()
						displayCurrentLocale=false
					/>
				</ul>
			</div>
		</#if>
		<#if  themeDisplay.getColorSchemeId()!="08">
			<button class=" hamburguer-icon collapsed d-flex d-lg-none" type="button" data-toggle="collapse" data-target="#myNavbar" aria-expanded="false" aria-controls="myNavbar" aria-label="Abrir menú">
				<span class="hamburguer-icon-animated"></span>
				<span class="hamburguer-icon-animated"></span>
				<span class="hamburguer-icon-animated"></span>
				<span class="hamburguer-icon-animated"></span>
			</button>
		</#if>
	</div>
</nav>

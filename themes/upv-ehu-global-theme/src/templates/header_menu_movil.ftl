<div class="header__menu-mobile  collapse" id="myNavbar">
	<div class="header__menu-mobile__title">
		
		<p>Universidad del País Vasco <br>
			Euskal Herriko Unibertsitatea
		</p>
		<button class=" hamburguer-icon collapsed" type="button" data-toggle="collapse" data-target="#myNavbar" aria-expanded="false" aria-controls="myNavbar" aria-label="Abrir menú">
			<span class="hamburguer-icon-animated"></span>
			<span class="hamburguer-icon-animated"></span>
			<span class="hamburguer-icon-animated"></span>
			<span class="hamburguer-icon-animated"></span>
		</button>
		
	</div>
	<div class="header__menu-mobile__nav">
		
		<#if !is_signed_in>
			<a data-redirect="${is_login_redirect_required?c}" href="${sign_in_url}" rel="nofollow" role="menuitem" tabindex="0">
				<img src="${images_folder}/icons/user-nireEHU.svg" alt="<@liferay.language key='ehu.nireEHU'/>">
				<@liferay.language key='ehu.nireEHU'/>
				<span class="hide-accessible"><@liferay.language key='ehu.login'/></span>
			</a>
		</#if>
		<#assign preferences = freeMarkerPortletPreferences.getPreferences("portletSetupPortletDecoratorId", "borderless") /> <@liferay_portlet["runtime"] defaultPreferences="${preferences}" portletName="com_liferay_site_navigation_menu_web_portlet_SiteNavigationMenuPortlet"  instanceId="UPV-EHU-headerMenu-Mobile"/>
		
	</div>
</div>
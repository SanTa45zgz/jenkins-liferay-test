<div class="header__menu d-none d-lg-flex">

	<#assign preferences = freeMarkerPortletPreferences.getPreferences("portletSetupPortletDecoratorId", "borderless") /> <@liferay_portlet["runtime"] defaultPreferences="${preferences}" portletName="com_liferay_site_navigation_menu_web_portlet_SiteNavigationMenuPortlet"  instanceId="UPV-EHU-headerMenu"/>

</div>
<#include "${full_templates_path}/header_menu_movil.ftl" />
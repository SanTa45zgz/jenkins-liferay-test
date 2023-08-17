
<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService") />


<#-- 
###############
## CompanyId ##
###############
-->
<#assign companyId = themeDisplay.getCompanyId() />

<#-- 
###################
## Guest Website ##
###################
 -->
<#assign isGuestSite = layout.getGroup().isGuest() />

<#-- 
###########
## Scope ##
###########
Por defecto el ambito de la pagina es publico 
-->

<#assign pageScope = "/web" />
<#assign isPublicPage = layout.isPublicLayout() />
<#assign isPrivatePage = layout.isPrivateLayout() />

<#if isPrivatePage >
	<#assign pageScope = "/group" />
</#if>


<#--
##########################
## Content Display Page ##
##########################
Pagina para presentar los contenidos completos de los publicadores de contenidos. 
No tiene cambio de idioma 
-->
<#assign isContentDisplayPage = layout.isContentDisplayPage() />


<#-- 
####################
## Theme Settings ##
####################
-->
<#assign headerContentSetting = getterUtil.getString(theme_settings["carousel-web-content-article-id"]) />
<#assign headerMenuRootPageFriendlyUrlSetting = getterUtil.getString(theme_settings["header-menu-root-page-friendly-url"]) />
<#assign showSpecificMenuSetting = getterUtil.getBoolean(layout.getTypeSettingsProperty("lfr-theme:regular:show-specific-menu")) />
<#assign specificMenuRootPageFriendlyUrlSetting = getterUtil.getString(theme_settings["specific-menu-root-page-friendly-url"]) />
<#assign showFeaturedHeader = getterUtil.getBoolean(theme_settings["show-featured-header"])>



<#-- se obtiene el valor del campo personalizado que configura la página específica de la home en inglés -->
<#assign sitio = themeDisplay.getSiteGroup()/>										
<#assign specificPageHomeEN = (sitio.getExpandoBridge().getAttribute("FriendlyPageHomeEnglish"))!""> 

<#--
############
## Layout ##
############
Nivel de profundidad de la pagina actual - Pagina/es inicial/es de sitio (RootLayout) = nivel 0)
-->

<#assign pageLevel = layout.getAncestors()?size />

<#-- Disposicion de pagina de la pagina actual -->

<#assign pageTpl = layout.getTypeSettingsProperty("layout-template-id") />

<#--
##############
## Language ##
##############
-->
<#assign navigationLanguage = w3c_language_id />
<#-- ## Idioma en la URL -->
<#assign urlNavigationLanguage = "/" + w3c_language_id?substring(0,2) />

<#-- ## Mapa de nombres de la pagina (en los idiomas en los que la pagina tiene nombre) -->
<#assign pageNameMap = layout.getNameMap() />

<#-- ## Mapa de Friendly URLS de la pagina (en los idiomas en los que la pagina tiene URL)  -->
<#assign pageFriendlyURLMap = layout.getFriendlyURLMap() />


<#-- 
#############################
## Root Title Custom Field ##
#############################
-->
<#assign isRootPage = false />
<#if themeDisplay.getColorSchemeId()=="06" || themeDisplay.getColorSchemeId()=="02" || themeDisplay.getColorSchemeId()=="08" || themeDisplay.getColorSchemeId()=="001" || themeDisplay.getColorSchemeId()=="002" || themeDisplay.getColorSchemeId()=="003" || themeDisplay.getColorSchemeId()=="004" || themeDisplay.getColorSchemeId()=="005">
	<#if layout.getExpandoBridge().getAttribute("is-root-master")>
		<#assign specificMenuRootPage = layout />
		<#assign isRootPage = true />
	<#else>	
		<#if layout.getParentLayoutId() gt 0>
			<#assign layoutParent = layoutLocalService.getParentLayout(layout) />

			<#if getterUtil.getBoolean(layoutParent.getExpandoBridge().getAttribute("is-root-master")) >
				<#assign specificMenuRootPage = layoutParent />
				<#assign isRootPage = false />
			<#else>
				
				<#if layoutParent.getParentLayoutId() gt 0>
					<#assign layoutParent = layoutLocalService.getParentLayout(layoutParent) />

					<#if layoutParent.getExpandoBridge().getAttribute("is-root-master") >
						<#assign specificMenuRootPage = layoutParent />
						<#assign isRootPage = false />
					<#else>
						<#assign layoutParent = layout["parentLayoutId"] />
					</#if>

				<#else>
					<#assign specificMenuRootPage = layout />
					<#assign isRootPage = true />

				</#if>
				
			</#if>
		<#else>
			<#assign specificMenuRootPage = layout />
			<#assign isRootPage = true />
		</#if>
	</#if>
</#if>


<#-- 
###############
##  Masters  ##
###############
-->
<#if themeDisplay.getColorSchemeId()=="06" || themeDisplay.getColorSchemeId()=="08" || themeDisplay.getColorSchemeId()=="001" || themeDisplay.getColorSchemeId()=="002" || themeDisplay.getColorSchemeId()=="003" || themeDisplay.getColorSchemeId()=="004" || themeDisplay.getColorSchemeId()=="005">
	<#if specificMenuRootPage??>
		<#--<#assign typeMaster = getterUtil.getString("")  />
		<#assign typeMasterArray = specificMenuRootPage.getExpandoBridge().getAttribute("type-master") />
		  <#list typeMasterArray as item>
			<#assign typeMaster = item />
		</#list>  -->
		<#assign typeMaster = specificMenuRootPage.getExpandoBridge().getAttribute("type-master") />
		<#assign facebookMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("facebook-master-url") />
		<#assign twitterMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("twitter-master-url") />
		<#assign linkedinMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("linkedin-master-url") />
		<#assign instagramMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("instagram-master-url") />
		<#assign flickrMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("flickr-master-url") />
		<#assign blogMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("rrss-blog-master-url") />
		<#assign youtubegMasterURL = "" />
		<#if specificMenuRootPage?? && specificMenuRootPage.getExpandoBridge()?? && specificMenuRootPage.getExpandoBridge().getAttribute("youtube-master-url")?? > 
			<#assign youtubegMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("youtube-master-url") />
		</#if>
		<#assign imageMasterURL = specificMenuRootPage.getExpandoBridge().getAttribute("image-master-url") />
		
		<#if imageMasterURL?contains("?")>
			<#assign imageMasterURL = imageMasterURL?substring(0, imageMasterURL?indexOf('?')) />
		</#if>

		<#assign masterRootPage = specificMenuRootPage />

	</#if>
	

	<#if isRootPage>
		<#assign hierarchyMasters = "isHomeMasters" />
	<#else>
		<#assign hierarchyMasters = "isChildMasters" />
	</#if>

</#if>



<#--
###############
## Main Menu ##
###############
## Menu de cabecera, se construye a partir de la propiedad de configuracion (ehu.header-menu-root-page-friendly-url) 
## en la cual se indica la friendlyUrl de la pagina inicial del menu de cabecera.
## - Primer nivel del menu: Paginas hijas NO ocultas asociadas al Menu de cabecera seleccionado indicando si es la pagina actual o si una de sus hijas lo es 	
## - Segundo nivel de menu: Paginas hijas NO ocultas del primer nivel de menu indicando si es la pagina actual

## Si se indica la propiedad de configuracion (ehu.header-menu-root-page-friendly-url)
-->


<#--
<#if headerMenuRootPageFriendlyUrlSetting != '' >

	<#if isPrivatePage>
		<#assign headerMenuRootPage = layoutLocalService.getFriendlyURLLayout(themeDisplay.getSiteGroupId(),true,headerMenuRootPageFriendlyUrlSetting) />
	<#else>
		<#assign headerMenuRootPage = layoutLocalService.getFriendlyURLLayout(themeDisplay.getSiteGroupId(),false,headerMenuRootPageFriendlyUrlSetting) />
	</#if>

	<#assign headerMenuFirstLevelPages = headerMenuRootPage.getChildren() />

</#if>
-->



<#if headerMenuRootPageFriendlyUrlSetting != '' >

	<#if isPrivatePage>

			<#attempt>
			  <#assign headerMenuRootPage = layoutLocalService.getFriendlyURLLayout(themeDisplay.getSiteGroupId(),true,headerMenuRootPageFriendlyUrlSetting) />
			<#recover>
			<#assign  headerMenuRootPageFriendlyUrlSetting ="" />
			 
			</#attempt>
			
		
	<#else>

		<#attempt>
			<#assign headerMenuRootPage = layoutLocalService.getFriendlyURLLayout(themeDisplay.getSiteGroupId(),false,headerMenuRootPageFriendlyUrlSetting) />
		<#recover>
			<#assign  headerMenuRootPageFriendlyUrlSetting ="" />
			 
		</#attempt>

	
	</#if>
	<#attempt>

		<#if headerMenuRootPage.getChildren()??>
			<#assign headerMenuFirstLevelPages = headerMenuRootPage.getChildren() />
		</#if>
	<#recover>
		<#assign  headerMenuRootPageFriendlyUrlSetting ="" />
			
	</#attempt>
</#if>



<#-- ## Sitio GUEST: se aplica el color definido a los elementos de primer nivel de menu. IMPORTANTE respetar el orden -->

<#assign firstLevelGuestClasses = [' university',' study',' research',' collaborate',' live'] />
<#assign firstLevelGuestClassIndex = 0  />

<#--  
ADT_MENU_IDIOMA_INGLES
https://dev74.ehu.eus/es/web/vitoria-gasteizko-ingeniaritza-eskola
Nota: centros
-->
<#assign groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")>
<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService")>

<#-- Se recupera la página de visualización del campo personalizado correspondiente del site -->										
	<#assign groupId = themeDisplay.getScopeGroupId()/>
	<#assign sitio = groupLocalService.fetchGroup(groupId)/>
	<#assign FriendlyPageHomeEnglish = (sitio.getExpandoBridge().getAttribute("FriendlyPageHomeEnglish"))!"">
	<#assign friendlyURL = "" />

<#if entries?has_content>

	<#assign w3c_language_id = localeUtil.toW3cLanguageId(themeDisplay.getLanguageId())>

	<#if entries?size == 1>
		<li class="dropdown language" role="menuitem">
			<span class="hide-text">${languageUtil.get(themeDisplay.getLocale(), 'ehu.language-selected')}</span>
			<span>
				<#if w3c_language_id?contains("fr-FR")>
					<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.french')}">
				<#elseif w3c_language_id?contains("en-GB")>
					<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.english')}">
				<#elseif w3c_language_id?contains("es-ES")>
					<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.spanish')}">
				<#else>
					<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.basque')}">
				</#if>
					${w3c_language_id?substring(0,2)}
				</abbr>
			</span>
		</li>
	<#else>
		<li class="dropdown language hover" role="menuitem">
			<a href="#" class="dropdown-toggle" data-toggle="dropdown"  tabindex="0">
				<span class="hide-text">${languageUtil.get(themeDisplay.getLocale(), 'ehu.language-selected')}</span>
				<span>
					<#if w3c_language_id?contains("fr-FR")>
						<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.french')}">
					<#elseif w3c_language_id?contains("en-GB")>
						<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.english')}">
					<#elseif w3c_language_id?contains("es-ES")>
						<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.spanish')}">
					<#else>
						<abbr title="${languageUtil.get(themeDisplay.getLocale(), 'ehu.basque')}">
					</#if>
						${w3c_language_id?substring(0,2)}
					</abbr>
				</span>
				<i class="icon-chevron-down"></i>
			</a>
			
			
			<ul aria-label="${languageUtil.get(themeDisplay.getLocale(), 'ehu.language-selector')}" class="dropdown-menu child-menu language-selection" role="menu">				
				<#list entries as curEntry>
					<#assign friendlyURL = "" />			
					<#if !curEntry.isDisabled()>

						<li role="menuitem">
							<#-- URL de cambio de idioma en funcion de configuracion, ya que para ingles hay arbol de paginas especifico -->
							<#assign urlCambioIdioma = "" />
							<#if w3c_language_id?contains("en-GB")>
								<#if FriendlyPageHomeEnglish?has_content>								
    								<#--<#if layoutLocalService.fetchLayout(groupId, layout.isPrivateLayout(), 1)?? >
    									<#assign homeGroupLayout = layoutLocalService.getLayout(groupId, layout.isPrivateLayout(), 1) />-->
    								<#if layoutLocalService.fetchLayout(groupId, layout.isPrivateLayout(), layout.layoutId)?? >
    									<#assign homeGroupLayout = layoutLocalService.getLayout(groupId, layout.isPrivateLayout(), layout.layoutId) />
    									<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + homeGroupLayout.getPlid() + "&languageId=" + curEntry.getLanguageId() />
    								</#if>
    							<#else>
    							    <#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + layout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />
    							</#if>
							<#else>		
								<#if curEntry.getW3cLanguageId()?contains("en-GB")>						
									<#-- Se recupera la página de visualización del campo personalizado correspondiente del site -->																			
										<#if FriendlyPageHomeEnglish?has_content>											
											<#assign friendlyURL = FriendlyPageHomeEnglish?string />
										</#if>
										<#if friendlyURL?has_content >
											<#if layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)??>
												<#assign homeInglesLayout = layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)/>																						
												<#if homeInglesLayout?? >
													<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + homeInglesLayout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />											 											 
												<#else>
													<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + layout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />
												</#if>	
											<#else>
												<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + layout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />
											</#if>								
										<#else>
												<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + layout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />
										</#if>	
								<#else>
									<#assign urlCambioIdioma = "/c/portal/update_language?p_l_id=" + layout.getPlid() + "&redirect=" + htmlUtil.escapeURL(themeDisplay.getURLCurrent()) + "&languageId=" + curEntry.getLanguageId() />
								</#if>
							</#if>

						<#if friendlyURL?? && friendlyURL!="oculto">
							<a  href='${urlCambioIdioma}' hreflang="${curEntry.getW3cLanguageId()}">
								<#if curEntry.getW3cLanguageId()?contains("fr-FR")>
									${languageUtil.get(themeDisplay.getLocale(), 'ehu.french')}
								<#elseif curEntry.getW3cLanguageId()?contains("en-GB")>
									${languageUtil.get(themeDisplay.getLocale(), 'ehu.english')}
								<#elseif curEntry.getW3cLanguageId()?contains("es-ES")>
									${languageUtil.get(themeDisplay.getLocale(), 'ehu.spanish')}
								<#elseif curEntry.getW3cLanguageId()?contains("eu-ES")>
									${languageUtil.get(themeDisplay.getLocale(), 'ehu.basque')}
								<#else>
									${curEntry.getLongDisplayName()}
								</#if>
							</a>
						</#if>
						</li>
							
					</#if>
				</#list>
			</ul>
		</li>
	</#if>

</#if>
<#if entries?has_content>

	<#assign w3c_language_id = localeUtil.toW3cLanguageId(themeDisplay.getLanguageId())>

	<#if entries?size == 1>
		<li class="dropdown language">
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
			<a href="#" class="dropdown-toggle" data-toggle="dropdown">
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
			<#-- Se obtienen los idiomas disponibles de la página y se convierte a un string separado por comas, además de formatear el laguage a la manera correcta -->
			<#assign layout = themeDisplay.getLayout()/>						
			<#assign pageAvailableLanguageIds = (layout.getAvailableLanguageIds()?join(", "))?replace('_','-')/>			
			
			<ul aria-label="${languageUtil.get(themeDisplay.getLocale(), 'ehu.language-selector')}" class="dropdown-menu child-menu language-selection" role="menu">
				<#list entries as curEntry>
					<#if !curEntry.isDisabled()>
						<#-- Si el idioma del curEntry existe como idioma disponible en la página, se pinta -->
						<#if pageAvailableLanguageIds?contains(curEntry.getW3cLanguageId()) >												
							<li role="menuitem">							
								<a  href='/c/portal/update_language?p_l_id=${layout.getPlid()}&redirect=${htmlUtil.escapeURL(themeDisplay.getURLCurrent())}&languageId=${curEntry.getLanguageId()}' hreflang="${curEntry.getW3cLanguageId()}">								
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
							</li>
						</#if>
					</#if>
				</#list>
			</ul>
		</li>
	</#if>

</#if>
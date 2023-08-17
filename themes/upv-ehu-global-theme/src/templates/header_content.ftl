<#-- ## Si la pagina tiene asociado un contenido de cabecera (propiedad del tema)  -->


<#if  themeDisplay.getColorSchemeId()=="08" >
	<div class="container">
		<section aria-label="<@liferay.language key='header' />">
				<div class="header-content">
					<@liferay_portlet["runtime"]
					    portletName="com_liferay_journal_content_web_portlet_JournalContentPortlet"
					/>
					<div class="header-content__bgtitle">
						<a class="title" href="${site_default_url}">
                            <h1>${site_name}</h1>
                        </a>
                    </div>
				</div>
		</section>
	</div>	 	
<#--## Si la pagina NO tiene asociado un contenido  -->
<#else>
	<div class="container">
		<section aria-label="<@liferay.language key='header' />">
				<div class="header-content">

					<@liferay_portlet["runtime"]
					portletProviderAction=portletProviderAction.VIEW
					instanceId="${layout.getPlid()}"
					portletName="com_liferay_journal_content_web_portlet_JournalContentPortlet" />
				
					<div class="header-content__bgtitle">
						<div class="title">
                        	<h1 class="page-header">${layout.getNameCurrentValue()}</h1>
                        </div>
                    </div>
				</div>
		</section>
	</div>	 
</#if>

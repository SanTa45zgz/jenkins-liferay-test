<footer id="footer" class="footer">
    <div class="container d-flex">
        <div class="footer__logo">
            <img src="${images_folder}/custom/ehu-upv-logotipo-completo-sin-fondo-branding.svg" alt="<@liferay.language key='ehu.university-of-the-basque-country'/>">
        </div>

        <div class="footer__navigations">
            <ul class=" footer__menu">
                <li><a href="<@liferay.language key='ehu.url.electronic-office'/>"><@liferay.language key='ehu.electronic-office'/></a></li>
                <li><a href="<@liferay.language key='ehu-theme.url.accessibility'/>"><@liferay.language key='ehu.accessibility'/></a></li>
                <li><a href="<@liferay.language key='ehu-theme.url.legal-information'/>"><@liferay.language key='ehu.legal-information'/></a></li>

                <#-- Si estamos en un centro, es decir, el esquema de color es el 08, entonces el map web del footer, debe enlazar con el mapa web de propio centro -->
                <#assign urlSiteMap = languageUtil.get( locale, "ehu-theme.url.sitemap" ) />
                <#if themeDisplay.getColorSchemeId()=="08" || themeDisplay.getColorSchemeId()=="002">
                <#assign groupId = themeDisplay.getScopeGroupId()/>
                <#assign groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")>
                <#assign sitio = groupLocalService.fetchGroup(groupId)/>
                <#if sitio?? >
                <#assign urlSiteMap = sitio.getDisplayURL(themeDisplay) + "/sitemap" />
                </#if>
                </#if>
                <li><a href="${urlSiteMap}"><@liferay.language key='ehu.sitemap'/></a></li>
                <li><a href="<@liferay.language key='ehu-theme.url.help'/>"><@liferay.language key='help'/></a></li> 
                <li><a href="<@liferay.language key='ehu-theme.url.contact'/>"><@liferay.language key='contact'/></a></li>
            </ul>
            <ul class=" footer__rrss">
                <li>
                    <a href="<@liferay.language key='ehu.url.facebook'/>" target="_blank" title="<@liferay.language key='ehu.title.facebook'/> - (Abre una nueva ventana)">
                        <svg><use xlink:href="${images_folder}/icons/fontawesome-brands.svg#facebook-f" /></svg><span class="sr-only"><@liferay.language key='ehu.title.facebook'/></span>
                    </a>
                </li>

                <li>
                    <a href="<@liferay.language key='ehu.url.twitter'/>" target="_blank" title="<@liferay.language key='ehu.title.twitter'/> - (Abre una nueva ventana)"> 
                        <svg><use xlink:href="${images_folder}/icons/fontawesome-brands.svg#twitter" /></svg><span class="sr-only"><@liferay.language key='ehu.title.twitter'/></span>
                    </a> 
                </li>

                <li>
                    <a href="<@liferay.language key='ehu.url.linkedin'/>" target="_blank" title="<@liferay.language key='ehu.title.linkedin'/> - (Abre una nueva ventana)">
                        <svg><use xlink:href="${images_folder}/icons/fontawesome-brands.svg#linkedin-in" /></svg> <span class="sr-only"><@liferay.language key='ehu.title.linkedin'/></span>
                    </a>
                </li>

                <li>
                    <a href="<@liferay.language key='ehu.url.instagram'/>" target="_blank" title="<@liferay.language key='ehu.title.instagram'/> - (Abre una nueva ventana)">
                        <svg><use xlink:href="${images_folder}/icons/fontawesome-brands.svg#instagram" /></svg><span class="sr-only"><@liferay.language key='ehu.title.instagram'/></span>
                    </a>
                </li>

                <li>
                    <a href="<@liferay.language key='ehu.url.youtube'/>" target="_blank" title="<@liferay.language key='ehu.title.youtube'/> - (Abre una nueva ventana)">
                        <i class="icon-youtube"></i><span class="sr-only"><@liferay.language key='ehu.title.youtube'/></span>
                    </a>
                </li>  

                <li>
                    <a href="<@liferay.language key='ehu.url.vimeo'/>" target="_blank" title="<@liferay.language key='ehu.title.vimeo'/> - (Abre una nueva ventana)">
                        <svg><use xlink:href="${images_folder}/icons/fontawesome-brands.svg#vimeo-v" /></svg><span class="sr-only"><@liferay.language key='ehu.title.vimeo'/></span>
                    </a>
                </li>      
            </ul>
        </div>
    </div>
</footer>

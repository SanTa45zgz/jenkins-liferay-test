<#--
Nombre contenido (ES): Tratamiento de datos personales
Estructura: secretaria-general > data-processing.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/pruebas/tratamiento
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign title = ehudata_processingname.getData()>

<#if title?has_content >
    <#assign titleLang = ehudata_processingname.ehutitlelangname.getData()>
        <#if titleLang == "" || titleLang = "upv-ehu-blank">
            <#assign articleTitle = .vars['reserved-article-title'].data >
            <span class="information">${articleTitle} - ${title}</span>
        <#else>
            <#assign articleTitle = .vars['reserved-article-title'].data >
            <span class="information">${articleTitle} - <span class="lang" lang="${titleLang}">${title}</span></span>                         
        </#if>
</#if>
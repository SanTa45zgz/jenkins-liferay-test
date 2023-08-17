<#--
Nombre contenido (ES): Empresa
Estructura: kontratazioa > enterprise.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/kontratazioa/enpresa
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign url_title = languageUtil.get(locale, 'upv-ehu-extended-information') + ": " + ehucompanygeneraldata.ehucompanyname.getData()>
<span class="enterprise">${ehucompanygeneraldata.ehucompanyname.getData()}</span>
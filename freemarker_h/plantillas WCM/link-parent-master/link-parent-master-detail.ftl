<#--
Nombre contenido (ES): Enlace a Máster padre
Estructura: graduondokoak > link-parent-master.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/graduondokoak/especializacion-universitaria-gestion-entidades-deportivas-en-direccion-gerencia
Nota: Solo se usa con global-theme > master
-->

<div class="bg-white p-20 ehu-sans">
    <div class="bg-dark">
        <div class="p-20">
        <#assign label = "upv-ehu.master.presentation.template.title."+Tipo_de_Master_Padre.getData()> 
        <#assign label = languageUtil.get(locale, label) >
        <p>${label?replace("{0}", nombre_master.getData())}</p>
        
        <#assign keyLanguage = "upv-ehu.master.own.button.text."+ Tipo_de_Master_Padre.getData()>
        <#assign texto = languageUtil.get(locale, keyLanguage)>
        <a class="btn btn-upv btn-primary btn-fill" href="${enlace_master.getFriendlyUrl()}" title="${nombre_master.getData()}"> ${texto} </a></div>
    </div>
</div>
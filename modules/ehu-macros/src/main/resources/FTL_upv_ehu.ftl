<#-- ========================================================================================
 #-- Devuelve, en una variable, el title y el target para un tag de enlace <a>, dependiendo
 #-- de si se va a abrir una nueva ventana (newTab) y teniendo en cuenta que el title puede
 #-- tener ya un valor.
 #-- Parametros:
 #--    newTab          especifica si se quiere que el enlace abra una nueva ventana
 #--    linkTitle       texto con el title para el enlace
 #-- Salida:
 #--    variable hash con los campos:
 #--    hrefTitle       el title completo (se crea en la funcion)
 #--    hrefTarget      el target para el enlace
========================================================================================= -->
<#function hrefOptions newTab linkTitle >
        <#if newTab >
                <#assign hrefTarget = "_blank" />
                <#assign txtLink = languageUtil.get( locale, "opens-new-window" ) />
        <#else>
                <#assign hrefTarget = "_self" />
                <#assign txtLink = "" />
        </#if>

        <#if validator.isNotNull( linkTitle ) && !validator.isBlank( linkTitle ) >
                <#assign hrefTitle = linkTitle + " " + txtLink />
        <#else>
                <#assign hrefTitle = txtLink />
        </#if>
        <#return {"hrefTitle":hrefTitle, "hrefTarget":hrefTarget} >
</#function>

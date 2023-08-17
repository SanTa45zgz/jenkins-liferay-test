<#--
Nombre contenido (ES): Tesis doctoral
Estructura: global > thesis.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/pruebas/tesis
Nota: Se usa con global-theme y con ehu-theme
-->

<#-- nuevo código para gestionar el año -->

<#assign txtYearUnknown = "unknown" >

<#assign thesisYear = "" >
<#if ehuthesisyearseparator??>
	<#if ehuthesisyearseparator.ehuthesisyear?? >
		<#assign thesisYear = ehuthesisyearseparator.ehuthesisyear.getData() >
	</#if>
</#if>

<#if thesisYear == txtYearUnknown >
	<#assign txtThesisYear = languageUtil.get(  locale , "unknown" )?lower_case>
<#else>
	<#assign txtThesisYear = thesisYear >
</#if>
	
<#assign showYear =  thesisYear != "" && thesisYear != txtYearUnknown >


<span class="thesis">
    <#if ehuthesisphd?? && ehuthesisphd.getData()?has_content >
        <span class="phd">${ehuthesisphd.getData()} </span> 
    </#if>
    <#if ehuthesistitle?? && ehuthesistitle.ehutitlelang?? && ehuthesistitle.ehutitlelang.getData()??>
        <#assign titleLang = ehuthesistitle.ehutitlelang.getData()>
    </#if>
    
    <#-- Solo pintamos el span del lang="XX" si se ha seleccionado un idioma en el desplegable (Trello 579)-->
	<#-- También controlamos que el contenido no tenga seleccionado upv-ehu-blank (opción antigua "Selecciona una opción") 
				para que no aparezca el lang con eso ya que da error de validación web (Trello 579)-->
    <#if titleLang?has_content && titleLang!="default" && titleLang!="upv-ehu-blank">
        <span lang="${titleLang}">
            <#if ehuthesistitle?? && ehuthesistitle.getData()??>
                <span class="template-title"><strong>"${ehuthesistitle.getData()}"</strong></span>
            </#if>
        </span>
    <#else>
     <#if ehuthesistitle?? && ehuthesistitle.getData()??>
        <span class="template-title"><strong>"${ehuthesistitle.getData()}"</strong></span>            
     </#if>
    </#if>
        
    <#if ehuthesisuniversity?? && ehuthesisuniversity.getData()?has_content >
        <span class="place"> <em>${ehuthesisuniversity.getData()}</em>. </span> 
    </#if>    
    
    
    <#if showYear >
		<span class="thesis-year">${txtThesisYear}</span>	  
	</#if>
</span>
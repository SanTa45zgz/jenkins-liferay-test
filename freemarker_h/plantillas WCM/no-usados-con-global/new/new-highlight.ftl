<#-- TITLE, SUBTITLE, IMAGE -->
<#if ehuimages?has_content >
	<#if ehuimages.ehuhighlighttitle?? && ehuimages.ehuhighlighttitle.getData()?? >
        <#assign title = ehuimages.ehuhighlighttitle.getData()>
    </#if>
    <#if ehuimages.ehuhighlightsubtitle?? && ehuimages.ehuhighlightsubtitle.getData()?? >
        <#assign subtitle = ehuimages.ehuhighlightsubtitle.getData()>
    </#if>
    <#if ehuimages.ehuhighlightimage?? && ehuimages.ehuhighlightimage.getData()?? >
        <#assign image = ehuimages.ehuhighlightimage.getData()>
    </#if>
    <#if ehuimages.ehuhighlightimage.ehuhighlightimagealttext?? && ehuimages.ehuhighlightimage.ehuhighlightimagealttext.getData()?? >
    	<#assign altText = ehuimages.ehuhighlightimage.ehuhighlightimagealttext.getData()>
    <#else>     	
     	<#assign altText = "" >
    </#if>    
<#else>
    <#assign title = "" >
    <#assign subtitle = "" >
    <#assign image = "" >
    <#assign altText = "" >
</#if>

<#if !title?has_content>
    <#if ehugeneraldata?has_content >
        <#assign title =  ehugeneraldata.ehunewtitle.getData()>
    <#else>
        <#assign title = "" >
    </#if>
</#if>

<#if !subtitle?has_content >
    <#if ehugeneraldata?has_content >
	    <#assign  subtitle =  ehugeneraldata.ehunewsubtitle.getData()>
	<#else>
	    <#assign  subtitle = "" >
	</#if>
</#if>


<#assign tottitle =  subtitle?length + title?length>
<#assign maxtitle =  title?length < 246>

<#assign theme_image_path = (themeDisplay.getPathThemeImages())!"">



<#-- Para diferenciar campusa se mira unicamente si el tema es el de campusa-->
<#if theme_image_path?has_content && theme_image_path?contains('/upv-ehu-campusa-theme/images')>
    <#-- CAMPUSA-->

    <div class='new'>
        <#if image?has_content >
          <figure>
            <img alt='${altText}' src='${image}'> 
            <figcaption>
				<#-- Para poner la categoria antes del titulo quitamos lo que pintaba la categoria con el ADT y lo ponemos aqui-->
                <#-- CAMPUSA VOCABULARY-->
                <#assign vocabularyCampusaName = 'Campusa'>
                <#assign tag_campusa = '<ul></ul>'>
                <#assign tag_init = '<ul></ul>'>
                <#-- Macro de la biblioteca de macros: upvlibs-->
				<@upvlibs.formatVocabularyCategoriesProperties vocabularyName="${vocabularyCampusaName}" />   
				<#assign tag_campusa = upvlibs.categoriesListStr >
				
                <#if !validator.equals(tag_campusa,tag_init)>
                    <div class="campusa-category">
                        ${tag_campusa}
                    </div>
                </#if>
                
                <p class="card-title"><strong>${title}</strong></p> 
                <#if subtitle?has_content > 
					<#if (tottitle &gt; 250) && maxtitle  >
						<#assign  subtitle = subtitle?substring(0, 246 - title?length) >
						<#assign  subtitle += '...' >
					</#if>						
					<p class="subtitle">${subtitle}</p>
					
                </#if>
            </figcaption>
        </figure>
   <#else>
       <p class="card-title"><strong>${title}</strong></p> 
         <#if subtitle?has_content >   
			<#if (tottitle &gt; 250) && maxtitle  >
				<#assign  subtitle = subtitle?substring(0, 246 - title?length) >
				<#assign  subtitle += '...' >
			</#if>
            <p class="subtitle">${subtitle}</p>
          </#if>
    </#if>
</div>

<#-- CAMPUSA -->     
<#else>
<#-- NO CAMPUSA-->

<div class='new'>
 <#if image?has_content >
        <figure class="row">
            <img class="col-4" alt='${altText}' src='${image}'> 
            <figcaption class="col-8">
                <p class="card-title"><strong>${title}</strong></p> 
                <#if subtitle?has_content >
					<#if (tottitle &gt; 250) && maxtitle >
						<#assign  subtitle = subtitle?substring(0, 246 - title?length) >
						<#assign  subtitle += '...' >
					</#if>
                    <p class="subtitle">${subtitle}</p>
                </#if>
            </figcaption>
        </figure>
   <#else>
       <p class="card-title"><strong>${title}</strong></p> 
         <#if subtitle?has_content > 
			<#if (tottitle &gt; 250) && maxtitle  >
				<#assign  subtitle = subtitle?substring(0, 246 - title?length) >
				<#assign  subtitle += '...' >
			</#if>
            <p class="subtitle">${subtitle}</p>
          </#if>
    </#if>
</div>

<#-- NO CAMPUSA-->
</#if>
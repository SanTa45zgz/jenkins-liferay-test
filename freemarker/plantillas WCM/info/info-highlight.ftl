<#-- TITLE -->
<#if  ehuheader?? &&  ehuheader.ehuinfotitle?? &&  ehuheader.ehuinfotitle.getData()??>
    <#assign main_title = ehuheader.ehuinfotitle.getData()>
</#if>

<#-- HIGHLIGHT TITLE-->
<#if ehuimages?? && ehuimages.ehuhighlighttitle?? && ehuimages.ehuhighlighttitle.getData()?? >
    <#assign title = ehuimages.ehuhighlighttitle.getData()>
</#if>

<#if !title?has_content && main_title?has_content>

     <#assign title = main_title>
</#if>

<#-- SUBTITLE-->
<#if ehuimages?? && ehuimages.ehuhighlightsubtitle?? && ehuimages.ehuhighlightsubtitle.getData()??>
    <#assign subtitle = ehuimages.ehuhighlightsubtitle.getData()>
</#if>


<#-- IMAGE-->
<#if ehuimages?? && ehuimages.ehuhighlightimage?? && ehuimages.ehuhighlightimage.getData()??>
    <#assign image = ehuimages.ehuhighlightimage.getData()>
</#if>


<div class='information'>
   <#if image?has_content >
        <figure class="row">
             <img class="col-4" alt=' ' src='${image}'> 
                <figcaption class="col-8">
                    <#if title?has_content >
                        <p class="card-title"><strong>${title}</strong></p> 
                    </#if>
                    
                    <#if subtitle?has_content >     
                        <p class="subtitle">${subtitle}</p>
                    </#if>
                </figcaption>
        </figure>
    <#else>
        <#if title?has_content >
            <p class="card-title"><strong>${title}</strong></p> 
        </#if>
        <#if subtitle?has_content >    
            <p class="subtitle">${subtitle}</p>
        </#if> 
   </#if>
</div>

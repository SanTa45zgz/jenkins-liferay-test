<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") && (colorSchemeId?has_content && colorSchemeId == "08")) ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>
    
        <div class="summary_data-wrapper">
            <#if Titulo.getData()?? && Titulo.getData() != "">
                <h2>${Titulo.getData()}</h2>
            </#if>
            <#if Dato.getSiblings()?has_content>
        		<#assign elements = Dato.getSiblings()?size/>
                <div class="summary_data-content">
        		    <#list Dato.getSiblings() as cur_Dato>
        			<!-- Se visualizan 3 datos independientemente de los que se metan -->
        			<#if cur_Dato?index lt 3>
                        <div class="summary_data-item">
                            <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content> 
                                <a href="${cur_Dato.Enlace.getData()}">                            
                            </#if>
                            <#if cur_Dato?? && cur_Dato.Cantidad?? && cur_Dato.Cantidad.getData()?has_content> 
                                <p class="text-number">
                                    ${cur_Dato.Cantidad.getData()}
                                </p>
                                <p class="text-data">
                                    ${cur_Dato.getData()}
                                </p>
                            </#if>
                           <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content> 
                                </a>
                            </#if>
                        </div>
        			</#if>
        		    </#list>		
                </div>
            </#if>
        </div>
        
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

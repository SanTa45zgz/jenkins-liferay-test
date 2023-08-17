<div class="partners">

	<#if tituloPartner.getData()?? && tituloPartner.getData()?has_content>
	    <h2 class="partner-title">  
	        ${tituloPartner.getData()}
	    </h2>
	</#if>

	<#if (partnerLogo.getData()?? && partnerLogo.getData()?has_content) || 
		(partnerDescription.getData()?? && partnerDescription.getData()?has_content) || 
		(linkWeb.getData()?? && linkWeb.getData()?has_content)>
	    <div class="partner-info">
	        <div class="partner-description">  
	        	<#if partnerLogo.getData()?? && partnerLogo.getData()?has_content>
	            	<div class="partner-logo">      	
	                	<img alt="${partnerLogo.getAttribute("alt")}" data-fileentryid="${partnerLogo.getAttribute("fileEntryId")}" src="${partnerLogo.getData()}" />
	                </div>
	            </#if>
	            
	            <#if partnerDescription.getData()?? && partnerDescription.getData()?has_content>
	            	${partnerDescription.getData()}
	            </#if>
	            
	            <#if linkWeb.getData()?? && linkWeb.getData()?has_content>
		            <div class="partner-web">
		                <p><span>
		                    <b>Link Web:</b>
		                    <a href="${linkWeb.getData()}">${linkWeb.getData()}</a>
		                </span></p>
		            </div>
		        </#if>
	        </div>
	    </div>
    </#if>
    
    <#if getterUtil.getBoolean(ResearchLines.researchLines_am.getData()) ||
        getterUtil.getBoolean(ResearchLines.researchLines_ifeps.getData()) ||
        getterUtil.getBoolean(ResearchLines.researchLines_dcf.getData()) ||
        getterUtil.getBoolean(ResearchLines.researchLines_ee.getData()) ||
        getterUtil.getBoolean(ResearchLines.researchLines_sm.getData()) >
    
    	<#if tituloPartner.getData()?? && tituloPartner.getData()?has_content>
        	<h3>Research Lines</h3>
        <#else>
        	<h2>Research Lines</h2>
        </#if>
    
        <div class="toggle research-line-amp">
            <#if getterUtil.getBoolean(ResearchLines.researchLines_am.getData())>
            		<#if tituloPartner.getData()?? && tituloPartner.getData()?has_content>
	            	    <h4 tabindex="0" class="research-line-section toggled">
	            	        ADVANCED MATERIALS AND PROCESSES
	            	    </h4>
	            	<#else>
	            		<h3 tabindex="0" class="research-line-section toggled">
	            	        ADVANCED MATERIALS AND PROCESSES
	            	    </h3>
	            	
	            	</#if>
            	    <div class="research-line-info" style="display: none">
                    	<#if ResearchLines.researchLines_am.researchLines_amp_title.getSiblings()?has_content>
                        	<#list ResearchLines.researchLines_am.researchLines_amp_title.getSiblings() as cur_ResearchLines_am>
                        	    <div class="research-line">
                        	        <ul>
                            	        <li class="research-line-title">
                            		        <p>${cur_ResearchLines_am.getData()}</p>
                                        
                                            <#if cur_ResearchLines_am.researchLines_amp_desc.getData()?has_content && cur_ResearchLines_am.researchLines_amp_desc.getData()??>
                                                <ul>
                                                    <li class="research-line-description">
                                                        ${cur_ResearchLines_am.researchLines_amp_desc.getData()}
                                                    </li>
                                                
                                                    <#if cur_ResearchLines_am.researchLines_amp_author.getData()?has_content && cur_ResearchLines_am.researchLines_amp_author.getData()??>
                                                        <li class="research-line-author">
                                                            <p>${cur_ResearchLines_am.researchLines_amp_author.getData()}</p>
                                                        </li>
                                                    </#if>
                                                </ul>
                                            </#if>
                                        </li>
                                    </ul>
                        	    </div>
                        	</#list>
                        </#if>
                    </div>
            </#if>
        </div>
               
        <div class="toggle research-line-ifeps">     
            <#if getterUtil.getBoolean(ResearchLines.researchLines_ifeps.getData())>
                
            	    <div tabindex="0" class="research-line-section toggled">
            	        INTELLIGENT, FLEXIBLE & EFFICIENT PRODUCTION SYSTEMS
            	    </div>
            	    <div class="research-line-info" style="display: none">
                    	<#if ResearchLines.researchLines_ifeps.researchLines_ifeps_title.getSiblings()?has_content>
                        	<#list ResearchLines.researchLines_ifeps.researchLines_ifeps_title.getSiblings() as cur_ResearchLines_ifeps>
                        	    <div class="research-line">
                        	        <ul>
                            	        <li class="research-line-title">
                            		        <p>${cur_ResearchLines_ifeps.getData()}</p>
                                        
                                            <#if cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()?has_content && cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()??>
                                                <ul>
                                                    <li class="research-line-description">
                                                        ${cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()}
                                                    </li>
                                                
                                                    <#if cur_ResearchLines_ifeps.researchLines_ifeps_author.getData()?has_content && cur_ResearchLines_ifeps.researchLines_ifeps_author.getData()??>
                                                        <li class="research-line-author">
                                                            <p>${cur_ResearchLines_ifeps.researchLines_ifeps_author.getData()}</p>
                                                        </li>
                                                    </#if>
                                                </ul>
                                            </#if>
                                        </li>
                                    </ul>
                        	    </div>
                        	</#list>
                        </#if>
            	    </div>
            </#if>
        </div>
                
        <div class="toggle research-line-dcf">        
            <#if getterUtil.getBoolean(ResearchLines.researchLines_dcf.getData())>
                
            	    <div tabindex="0" class="research-line-section toggled">
            	        DIGITAL AND CONNECTED FACTORY
            	    </div>
            	    <div class="research-line-info" style="display: none">
                    	<#if ResearchLines.researchLines_dcf.researchLines_dcf_title.getSiblings()?has_content>
                        	<#list ResearchLines.researchLines_dcf.researchLines_dcf_title.getSiblings() as cur_ResearchLines_dcf>
                        	    <div class="research-line">
                        	        <ul>
                            	        <li class="research-line-title">
                            		        <p>${cur_ResearchLines_dcf.getData()}</p>
                                        
                                            <#if cur_ResearchLines_dcf.researchLines_dcf_desc.getData()?has_content && cur_ResearchLines_dcf.researchLines_dcf_desc.getData()??>
                                                <ul>
                                                    <li class="research-line-description">
                                                        ${cur_ResearchLines_dcf.researchLines_dcf_desc.getData()}
                                                    </li>
                                                
                                                    <#if cur_ResearchLines_dcf.researchLines_dcf_author.getData()?has_content && cur_ResearchLines_dcf.researchLines_dcf_author.getData()??>
                                                        <li class="research-line-author">
                                                            <p>${cur_ResearchLines_dcf.researchLines_dcf_author.getData()}</p>
                                                        </li>
                                                    </#if>
                                                </ul>
                                            </#if>
                                        </li>
                                    </ul>
                        	    </div>
                        	</#list>
                        </#if>
            	    </div>
            </#if>
        </div>        
        
        <div class="toggle research-line-ee">        
            <#if getterUtil.getBoolean(ResearchLines.researchLines_ee.getData())>
                
            	    <div tabindex="0" class="research-line-section toggled">
            	        ENERGY EFFICIENCY
            	    </div>
            	    <div class="research-line-info" style="display: none">
                    	<#if ResearchLines.researchLines_ee.researchLines_ee_title.getSiblings()?has_content>
                        	<#list ResearchLines.researchLines_ee.researchLines_ee_title.getSiblings() as cur_ResearchLines_ee>
                        	    <div class="research-line">
                        	        <ul>
                            	        <li class="research-line-title">
                            		        <p>${cur_ResearchLines_ee.getData()}</p>
                                        
                                            <#if cur_ResearchLines_ee.researchLines_ee_desc.getData()?has_content && cur_ResearchLines_ee.researchLines_ee_desc.getData()??>
                                                <ul>
                                                    <li class="research-line-description">
                                                        ${cur_ResearchLines_ee.researchLines_ee_desc.getData()}
                                                    </li>
                                                
                                                    <#if cur_ResearchLines_ee.researchLines_ee_author.getData()?has_content && cur_ResearchLines_ee.researchLines_ee_author.getData()??>
                                                        <li class="research-line-author">
                                                            <p>${cur_ResearchLines_ee.researchLines_ee_author.getData()}</p>
                                                        </li>
                                                    </#if>
                                                </ul>
                                            </#if>
                                        </li>
                                    </ul>
                        	    </div>
                        	</#list>
                        </#if>
            	    </div>
            </#if>
        </div>        
        
        <div class="toggle research-line-sm">        
            <#if getterUtil.getBoolean(ResearchLines.researchLines_sm.getData())>
                
            	    <div tabindex="0" class="research-line-section toggled">
            	        SUSTAINABLE MANUFACTURING
            	    </div>
            	    <div class="research-line-info" style="display: none">
                    	<#if ResearchLines.researchLines_sm.researchLines_sm_title.getSiblings()?has_content>
                        	<#list ResearchLines.researchLines_sm.researchLines_sm_title.getSiblings() as cur_ResearchLines_sm>
                        	    <div class="research-line">
                        	        <ul>
                            	        <li class="research-line-title">
                            		        <p>${cur_ResearchLines_sm.getData()}</p>
                                        
                                            <#if cur_ResearchLines_sm.researchLines_sm_desc.getData()?has_content && cur_ResearchLines_sm.researchLines_sm_desc.getData()??>
                                                <ul>
                                                    <li class="research-line-description">
                                                        ${cur_ResearchLines_sm.researchLines_sm_desc.getData()}
                                                    </li>
                                                
                                                    <#if cur_ResearchLines_sm.researchLines_sm_author.getData()?has_content && cur_ResearchLines_sm.researchLines_sm_author.getData()??>
                                                        <li class="research-line-author">
                                                            <p>${cur_ResearchLines_sm.researchLines_sm_author.getData()}</p>
                                                        </li>
                                                    </#if>
                                                </ul>
                                            </#if>
                                        </li>
                                    </ul>
                        	    </div>
                        	</#list>
                        </#if>
            	    </div>
            </#if>
        </div>
    </#if>
    
</div>

<script>

    $(".research-line-section").click(function(){
        var toggle = false;
        
        if (!$(this).hasClass("toggled")){
            var toggle = true;
        }
    
        $('.research-line-section').each(function(i, item) {
            var $item = $(item);
        
                $item.addClass('toggled');
        });
        
        if (!toggle){
            $(this).removeClass("toggled");
        }
    });
    
    $(".research-line-section").keypress(function (e) {
        var key = e.which;
        if(key == 13)  // the enter key code
        {
        this.click();
            return false;  
        }
    });
    
</script>

<style>
.research-line-section.toggled + .research-line-info {
    display: none !important;
}

.research-line-section:not(.toggled) + .research-line-info {
    display: block !important;
}
</style>
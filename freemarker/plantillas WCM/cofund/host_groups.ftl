<div class="host-group">

    <div class="toggle host-research-group">
        <div tabindex="0" class="toggle-title">
            <h2>Host Research Group</h2>
        </div>
        <div class="toggle-content">
        	<#if hostResearchGroup??>
	        	<#if hostResearchGroup.GroupName??>
		        	<#if hostResearchGroup.GroupName.getData()?? && hostResearchGroup.GroupName.getData()?has_content>
		           		<h1 class="host-research-group-name">${hostResearchGroup.GroupName.getData()}</h1>
		           	</#if>
		        </#if>
		        <#if hostResearchGroup.IkertuCodeHR??>
		           	<#if hostResearchGroup.IkertuCodeHRG.getData()?? && hostResearchGroup.IkertuCodeHRG.getData()?has_content>
		            	<div class="host-research-group-code"><p>${hostResearchGroup.IkertuCodeHRG.getData()}</div>
		            </#if>
		        </#if>
	            <#if hostResearchGroup.PrincipalInvestigator??>
		            <#if hostResearchGroup.PrincipalInvestigator.getData()?? && hostResearchGroup.PrincipalInvestigator.getData()?has_content>
		            	<div class="host-research-group-investigator"><p>${hostResearchGroup.PrincipalInvestigator.getData()}</div>
		            </#if>
		        </#if>
	            <#if hostResearchGroup.ContactNumber??>
		            <#if hostResearchGroup.ContactNumber.getData()?? && hostResearchGroup.ContactNumber.getData()?has_content>
		            	<div class="host-research-group-contact"><p><i>${hostResearchGroup.ContactNumber.getData()}</i></div>
		            </#if>
		        </#if>
		        <#if hostResearchGroup.ContactEmail??>
		            <#if hostResearchGroup.ContactEmail.getData()?? && hostResearchGroup.ContactEmail.getData()?has_content>
		            	<p><a class="host-research-group-mail" href="mailto:${hostResearchGroup.ContactEmail.getData()}">${hostResearchGroup.ContactEmail.getData()}</a>
		            </#if>
		        </#if>
		        <#if hostResearchGroup.GroupWebsite??>
		            <#if hostResearchGroup.GroupWebsite.getData()?? && hostResearchGroup.GroupWebsite.getData()?has_content>
		            	<p><a class="host-research-group-web" href="${hostResearchGroup.GroupWebsite.getData()}">${hostResearchGroup.GroupWebsite.getData()}</a>
		            </#if>
		        </#if>
	            <div class="host-group-description">
	                <h2 class="description-title">
	                    Group description
	                </h2>
	                <#if hostResearchGroup.GroupDescription.getData()?? && hostResearchGroup.GroupDescription.getData()?has_content>
	                	${hostResearchGroup.GroupDescription.getData()}
	                </#if>
	            </div>
	            
	            <#assign existKeyword = getterUtil.getBoolean("false")>
			 	<#if hostResearchGroup.Keyword?? >
			   		<#assign arrElems = hostResearchGroup.Keyword.getSiblings() >	
					<#if ((arrElems?size >= 1)?c)?boolean>
						<#if arrElems[0].getData()?? && arrElems[0].getData()!= "">
							<#assign existKeyword = getterUtil.getBoolean("true")>
						</#if>
						
					</#if>
				</#if>
	            <#if existKeyword>
		            <#if hostResearchGroup.Keyword.getSiblings()?has_content>
			            <h2 class="keywords-title">Keywords</h2>
			            <ul class="keywords">
			            	<#list hostResearchGroup.Keyword.getSiblings() as cur_hostResearchGroup_Keyword>
			            		<#if cur_hostResearchGroup_Keyword.getData()?? && cur_hostResearchGroup_Keyword.getData()?has_content>
				                	<li class="keyword">
				                    	${cur_hostResearchGroup_Keyword.getData()}
				                    </li>
				                </#if>
			                </#list>
			            </ul>
			        </#if>
			     </#if>
			 </#if>
        </div>
    </div>
    
    <#assign existDescription = getterUtil.getBoolean("false")>
 	<#if TeamDescription.TeamMember?? >
   		<#assign arrElems = TeamDescription.TeamMember.getSiblings() >	
		<#if arrElems??>
			<#if ((arrElems?size >= 1)?c)?boolean>
				<#if arrElems[0].Name??>
					<#if arrElems[0].Name.getData()?? && arrElems[0].Name.getData()!= "">
						<#assign existDescription = getterUtil.getBoolean("true")>
					</#if>
				</#if>
				<#if arrElems[0].Orcid??>
					<#if arrElems[0].Orcid.getData()?? && arrElems[0].Orcid.getData()!= "">
						<#assign existDescription = getterUtil.getBoolean("true")>
					</#if>
				</#if>
			</#if>
		</#if>
	</#if>
	
    <#if existDescription>
	    <div class="toggle team-description">
	        <div tabindex="0" class="toggle-title">
	            <h2>Team Description</h2>
	        </div>
	        <div class="toggle-content">
	            <#if TeamDescription.TeamMember.getSiblings()?has_content>
	                <ul class="team-member-list">
	                    <#list TeamDescription.TeamMember.getSiblings() as cur_teamMember>
	                        <li class="team-member">
	                        	<#if cur_teamMember.Name.getData()?? && cur_teamMember.Name.getData()?has_content>
	                            	<h3 class="member-name"><b>${cur_teamMember.Name.getData()}</b> (${cur_teamMember.Category.getData()})</h3>
	                            </#if>
	                            <#if cur_teamMember.Orcid.getData()?has_content && cur_teamMember.Orcid.getData()??>
	                                <p class="member-code">ORCID: ${cur_teamMember.Orcid.getData()}</p>
	                            </#if>
	                        </li>
	                    </#list>
	                </ul>
	            </#if>
	        </div>
	    </div>
	</#if>
	
	<#assign existProjects = getterUtil.getBoolean("false")>
 	<#if Projects.Project?? >
   		<#assign arrElems = Projects.Project.getSiblings() >	
		<#if ((arrElems?size >= 1)?c)?boolean>
			<#if arrElems[0].projectTitle??>
				<#if arrElems[0].projectTitle.getData()?? && arrElems[0].projectTitle.getData()!= "">
					<#assign existDescription = getterUtil.getBoolean("true")>
				</#if>
			</#if>
			<#if arrElems[0].Pi??>
				<#if arrElems[0].Pi.getData()?? && arrElems[0].Pi.getData()!= "">
					<#assign existDescription = getterUtil.getBoolean("true")>
				</#if>
			</#if>
			<#if arrElems[0].FundingAgency??>
				<#if arrElems[0].FundingAgency.getData()?? && arrElems[0].FundingAgency.getData()!= "">
					<#assign existDescription = getterUtil.getBoolean("true")>
				</#if>
			</#if>
			<#if arrElems[0].Ongoing??>
				<#if arrElems[0].Ongoing.getData()?? && arrElems[0].Ongoing.getData()!= "">
					<#assign existDescription = getterUtil.getBoolean("true")>
				</#if>
			</#if>
			<#if arrElems[0].IkertuCode??>
				<#if arrElems[0].IkertuCode.getData()?? && arrElems[0].IkertuCode.getData()!= "">
					<#assign existDescription = getterUtil.getBoolean("true")>
				</#if>
			</#if>
		</#if>
	</#if>
	
    <#if existProjects>
	    <div class="toggle projects">
	        <div tabindex="0" class="toggle-title">
	            <h2>Projects</h2>
	        </div>
	        <div class="toggle-content">
	            <#if Projects.Project.getSiblings()?has_content>
	                <ul class="team-member-list">
	                <#list Projects.Project.getSiblings() as cur_project>
	                    <li class="project">
	                    	<#if cur_project.projectTitle.getData()?? && cur_project.projectTitle.getData()?has_content>
	                        	<h3><b>${cur_project.projectTitle.getData()}</b></h3>
	                        </#if>
	                        
	                       <#if (cur_project.Pi.getData()?? && cur_project.Pi.getData()?has_content) ||
	                       (cur_project.FundingAgency.getData()?? && cur_project.FundingAgency.getData()?has_content) ||
	                       (cur_project.Ongoing.getData()?? && cur_project.Ongoing.getData()?has_content) ||
	                       (cur_project.IkertuCode.getData()?? && cur_project.IkertuCode.getData()?has_content)>
		                        <div class="project-data">
		                        	<#if cur_project.Pi.getData()?? && cur_project.Pi.getData()?has_content>
			                            <p>
			                                <span><b>Pl: </b>${cur_project.Pi.getData()}</span>
			                            </p>
			                        </#if>
			                        <#if cur_project.FundingAgency.getData()?? && cur_project.FundingAgency.getData()?has_content>
			                            <p>
			                                <span><b>Funding Agency*: </b>${cur_project.FundingAgency.getData()}</span>
			                            </p>
			                        </#if>
			                        <#if cur_project.Ongoing.getData()?? && cur_project.Ongoing.getData()?has_content>
			                            <p>
			                                <span><b>Ongoing: </b>${cur_project.Ongoing.getData()}</span>
			                            </p>
			                        </#if>
			                        <#if cur_project.IkertuCode.getData()?? && cur_project.IkertuCode.getData()?has_content>
			                            <p>
			                                <span><b>Project reference: </b>${cur_project.IkertuCode.getData()}</span>
			                            </p>
			                        </#if>
		                        </div>
	                        </#if>
	                    </li>
	                </#list>
	                </ul>
	            </#if>
	            <div class="legend" style="font-size: 14px">
	            <span style="margin-left: 1em">* <b>INT -</b> International</span> 
	            <span style="margin-left: 1em"><b>EU -</b> European</span>
	            <span style="margin-left: 1em"><b>NAT -</b> National</span>
	            <span style="margin-left: 1em"><b>RE -</b> Regional</span>
	            </div>
	        </div>
	    </div>
	</#if>
	
	
	<#assign existPublications = getterUtil.getBoolean("false")>
 	<#if Publications.Publication?? >
   		<#assign arrElems = Publications.Publication.getSiblings() >	
		<#if ((arrElems?size >= 1)?c)?boolean>
			<#if arrElems[0].Authors.getData()?? && arrElems[0].Authors.getData()!= "">
				<#assign existDescription = getterUtil.getBoolean("true")>
			</#if>
			<#if arrElems[0].Title.getData()?? && arrElems[0].Title.getData()!= "">
				<#assign existDescription = getterUtil.getBoolean("true")>
			</#if>
			<#if arrElems[0].Journal.getData()?? && arrElems[0].Journal.getData()!= "">
				<#assign existDescription = getterUtil.getBoolean("true")>
			</#if>
			<#if arrElems[0].Year.getData()?? && arrElems[0].Year.getData()!= "">
				<#assign existDescription = getterUtil.getBoolean("true")>
			</#if>
			
		</#if>
	</#if>

    <#if existPublications>
	    <div class="toggle publications">
	        <div tabindex="0" class="toggle-title">
	            <h2>Publications</h2>
	        </div>
	        <div class="toggle-content">
	            <#if Publications.Publication.getSiblings()?has_content>
	                <ul>
	                    <#list Publications.Publication.getSiblings() as cur_publication>
	                        <#if (cur_publication.Authors.getData()?? && cur_publication.Authors.getData()?has_content) ||
	                        (cur_publication.Title.getData()?? && cur_publication.Title.getData()?has_content) ||
	                        (cur_publication.Journal.getData()?? && cur_publication.Journal.getData()?has_content) ||
	                        (cur_publication.Year.getData()?? && cur_publication.Year.getData()?has_content)>
		                        <li>
		                            <p>
		                            <#if cur_publication.Authors.getData()?? && cur_publication.Authors.getData()?has_content>
		                            	<b>${cur_publication.Authors.getData()}, </b>=
		                            </#if>
		                            <#if cur_publication.Title.getData()?? && cur_publication.Title.getData()?has_content>
		                            	${cur_publication.Title.getData()}, 
		                           	</#if>
		                           	<#if cur_publication.Journal.getData()?? && cur_publication.Journal.getData()?has_content>
		                            	${cur_publication.Journal.getData()},
		                           	</#if>
		                           	<#if cur_publication.Year.getData()?? && cur_publication.Year.getData()?has_content>
		                           		<b>${cur_publication.Year.getData()}</b>
		                           	</#if>
		                            <br>
		                            <#if cur_publication.Doi.getData()?? && cur_publication.Doi.getData()?has_content>
		                            	<a href="${cur_publication.Doi.getData()}">${cur_publication.Doi.getData()}</a>
		                            </#if>	
		                            </p>
		                        </li>
		                     </#if>
	                    </#list>
	                </ul>
	            </#if>
	        </div>
	    </div>
    </#if>
    
    
    <#assign am = getterUtil.getBoolean("false")>
    <#assign ifeps = getterUtil.getBoolean("false")>
    <#assign dcf = getterUtil.getBoolean("false")>
    <#assign ee = getterUtil.getBoolean("false")>
    <#assign sm = getterUtil.getBoolean("false")>
	<#if ResearchLines??>
		<#if ResearchLines.researchLines_am??>
			<#assign am = getterUtil.getBoolean(ResearchLines.researchLines_am.getData()) >
		</#if>
		<#if ResearchLines.researchLines_ifeps??>
	   		<#assign ifeps = getterUtil.getBoolean(ResearchLines.researchLines_ifeps.getData())>
	    </#if>
	    <#if ResearchLines.researchLines_dcf??>
	    	<#assign dcf = getterUtil.getBoolean(ResearchLines.researchLines_dcf.getData())>
	    </#if>
	    <#if ResearchLines.researchLines_ee??>	
	    	<#assign ee = getterUtil.getBoolean(ResearchLines.researchLines_ee.getData())>
	    </#if>	
	    <#if ResearchLines.researchLines_sm??>
	    	<#assign sm = getterUtil.getBoolean(ResearchLines.researchLines_sm.getData())>
	    </#if>	
	</#if>
    <#if am || ifeps || dcf || ee || sm>
	    <div class="toggle research-lines">
	        <div tabindex="0" class="toggle-title">
	            <h2>Research Lines</h2>
	        </div>
	        <div class="toggle-content">
	        
	            <#if am>
	                <div class="research-line-amp">
	                    <h3 class="research-line-section">
	                        ADVANCED MATERIALS AND PROCESSES
	                    </h3>
	                    <#if ResearchLines.researchLines_am.researchLines_amp_title.getSiblings()?has_content>
	                        <#list ResearchLines.researchLines_am.researchLines_amp_title.getSiblings() as cur_ResearchLines_am>
	                            <div class="research-line">
	                            	<#if cur_ResearchLines_am.getData()?? && cur_ResearchLines_am.getData()?has_content>
		                                <h4 class="research-line-title">
		                                    ${cur_ResearchLines_am.getData()}
		                                </h4>
		                            </#if>
		                            <#if cur_ResearchLines_am.researchLines_amp_desc.getData()?? && cur_ResearchLines_am.researchLines_amp_desc.getData()?has_content>
		                                <div class="research-line-description">
		                                    ${cur_ResearchLines_am.researchLines_amp_desc.getData()}
		                                </div>
		                            </#if>
	                                <#if cur_ResearchLines_am.researchLines_amp_author?has_content && cur_ResearchLines_am.researchLines_amp_author??>
	                                    <p class="research-line-author">
	                                        ${cur_ResearchLines_am.researchLines_amp_author.getData()}
	                                    </p>
	                                </#if>
	                            </div>
	                        </#list>
	                    </#if>
	                </div>
	            </#if>
	            
	            
	            <#if ifeps>
	                <div class="research-line-amp">
	                    <h3 class="research-line-section">
	                        INTELLIGENT, FLEXIBLE & EFFICIENT PRODUCTION SYSTEMS
	                    </h3>
	                    <#if ResearchLines.researchLines_ifeps.researchLines_ifeps_title.getSiblings()?has_content>
	                        <#list ResearchLines.researchLines_ifeps.researchLines_ifeps_title.getSiblings() as cur_ResearchLines_ifeps>
	                            <div class="research-line">
	                            	<#if cur_ResearchLines_ifeps.getData()?? && cur_ResearchLines_ifeps.getData()?has_content>
		                                <h4 class="research-line-title">
		                                    ${cur_ResearchLines_ifeps.getData()}
		                                </h4>
		                            </#if>
		                            <#if cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()?? && cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()?has_content>
		                                <div class="research-line-description">
		                                    ${cur_ResearchLines_ifeps.researchLines_ifeps_desc.getData()}
		                                </div>
		                            </#if>
	                                <#if cur_ResearchLines_ifeps.researchLines_ifeps_author?has_content && cur_ResearchLines_ifeps.researchLines_ifeps_author??>
	                                    <p class="research-line-author">
	                                        ${cur_ResearchLines_ifeps.researchLines_ifeps_author.getData()}
	                                    </p>
	                                </#if>
	                            </div>
	                        </#list>
	                    </#if>
	                </div>
	            </#if>
	            
	            
	            <#if dcf>
	                <div class="research-line-amp">
	                    <h3 class="research-line-section">
	                        DIGITAL AND CONNECTED FACTORY
	                    </h3>
	                    <#if ResearchLines.researchLines_dcf.researchLines_dcf__title.getSiblings()?has_content>
	                        <#list ResearchLines.researchLines_dcf.researchLines_dcf__title.getSiblings() as cur_ResearchLines_dcf>
	                            <div class="research-line">
	                            	<#if cur_ResearchLines_dcf.getData()?? && cur_ResearchLines_dcf.getData()?has_content>
		                                <h4 class="research-line-title">
		                                    ${cur_ResearchLines_dcf.getData()}
		                                </h4>
		                            </#if>
		                            <#if cur_ResearchLines_dcf.researchLines_dcf_desc.getData()?? && cur_ResearchLines_dcf.researchLines_dcf_desc.getData()?has_content>
		                                <div class="research-line-description">
		                                    ${cur_ResearchLines_dcf.researchLines_dcf_desc.getData()}
		                                </div>
		                            </#if>
	                                <#if cur_ResearchLines_dcf.researchLines_dcf_author?has_content && cur_ResearchLines_dcf.researchLines_dcf_author??>
	                                    <p class="research-line-author">
	                                        ${cur_ResearchLines_dcf.researchLines_dcf_author.getData()}
	                                    </p>
	                                </#if>
	                            </div>
	                        </#list>
	                    </#if>
	                </div>
	            </#if>
	            
	            
	            <#if ee>
	                <div class="research-line-amp">
	                    <h3 class="research-line-section">
	                        ENERGY EFFICIENCY
	                    </h3>
	                    <#if ResearchLines.researchLines_ee.researchLines_ee_title.getSiblings()?has_content>
	                        <#list ResearchLines.researchLines_ee.researchLines_ee_title.getSiblings() as cur_ResearchLines_ee>
	                            <div class="research-line">
	                            	<#if cur_ResearchLines_ee.getData()?? && cur_ResearchLines_ee.getData()?has_content>
		                                <h4 class="research-line-title">
		                                    ${cur_ResearchLines_ee.getData()}
		                                </h4>
		                            </#if>
		                            <#if cur_ResearchLines_ee.researchLines_ee_desc.getData()?? && cur_ResearchLines_ee.researchLines_ee_desc.getData()?has_content>
		                                <div class="research-line-description">
		                                    ${cur_ResearchLines_ee.researchLines_ee_desc.getData()}
		                                </div>
		                            </#if>
	                                <#if cur_ResearchLines_ee.researchLines_ee_author?has_content && cur_ResearchLines_ee.researchLines_ee_author??>
	                                    <p class="research-line-author">
	                                        ${cur_ResearchLines_ee.researchLines_ee_author.getData()}
	                                    </p>
	                                </#if>
	                            </div>
	                        </#list>
	                    </#if>
	                </div>
	            </#if>
	            
	            
	            <#if sm>
	                <div class="research-line-amp">
	                    <h3 class="research-line-section">
	                        SUSTAINABLE MANUFACTURING
	                    </h3>
	                    <#if ResearchLines.researchLines_sm.researchLines_sm_title.getSiblings()?has_content>
	                        <#list ResearchLines.researchLines_sm.researchLines_sm_title.getSiblings() as cur_ResearchLines_sm>
	                            <div class="research-line">
	                            	<#if cur_ResearchLines_sm.getData()?? && cur_ResearchLines_sm.getData()?has_content>
		                                <h4 class="research-line-title">
		                                    ${cur_ResearchLines_sm.getData()}
		                                </h4>
		                            </#if>
		                            <#if cur_ResearchLines_sm.researchLines_sm_desc.getData()?? && cur_ResearchLines_sm.researchLines_sm_desc.getData()?has_content>
		                                <div class="research-line-description">
		                                    ${cur_ResearchLines_sm.researchLines_sm_desc.getData()}
		                                </div>
		                            </#if>
	                                <#if cur_ResearchLines_sm.researchLines_sm_author?has_content && cur_ResearchLines_sm.researchLines_sm_author??>
	                                    <p class="research-line-author">
	                                        ${cur_ResearchLines_sm.researchLines_sm_author.getData()}
	                                    </p>
	                                </#if>
	                            </div>
	                        </#list>
	                    </#if>
	                </div>        
	              </#if>    
	        </div>
	    </div>
    </#if>
	<#if CrossborderCollaboration??>
	    <#if CrossborderCollaboration.Collaboration??>
		    <#if CrossborderCollaboration.Collaboration.getData()?has_content && CrossborderCollaboration.Collaboration.getData()??>
		        <div class="toggle crossborder-collaboration">
		            <div tabindex="0" class="toggle-title">
		                Cross-border Collaboration (if any)
		            </div>
		        
		            <div class="toggle-content">
		                ${CrossborderCollaboration.Collaboration.getData()}
		            </div>
		        </div>
			</#if>
		</#if>
	</#if>
    

</div>


<script>
    $(".toggle-title").click(function(){
        $(this).next().toggle();
        if ($(this).hasClass("toggled")) {
            $(this).removeClass("toggled");   
        }
        else {
            $(this).addClass("toggled");
        }
    });
    
    $(".toggle-title").keypress(function (e) {
        var key = e.which;
        if(key == 13)  // the enter key code
        {
        this.click();
            return false;  
        }
    });
</script>
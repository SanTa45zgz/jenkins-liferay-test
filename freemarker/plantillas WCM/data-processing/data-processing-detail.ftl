<article class="data-processing">

<#--TITLE -->
    <header id="data-processing-title">
    <#assign title = ehudata_processingname.getData()>
    <#if title?has_content >
        <#assign titleLang = ehudata_processingname.ehutitlelangname.getData()>
			<#-- Solo pintamos el span del lang si hay seleccionado un idioma -->
			<#-- Tampoco pintamos el lang si el contenido tiene seleccionado la opción antigua de "Selecciona un idioma" (upv-ehu-blank). Trello  -->
			<#if titleLang == "" || titleLang = "upv-ehu-blank">			
                <#assign articleTitle = .vars['reserved-article-title'].data >
                <h1>${articleTitle} - ${title}</h1>                               
            <#else>
                <#assign articleTitle = .vars['reserved-article-title'].data >
                <h1>${articleTitle} - <span lang="${titleLang}">${title}</span></h1>           
            </#if>
    </#if>
    </header>
    
<#-- MENU -->

    <nav>
    	<ul>
    		<li><a href="#responsible"><@liferay.language key="ehu.responsible" /></a></li>
    		<li><a href="#purpose"><@liferay.language key="ehu.purpose" /></a></li>
    		<li><a href="#legitimation"><@liferay.language key="ehu.legitimation" /></a></li>
    		<li><a href="#receivers"><@liferay.language key="ehu.receivers" /></a></li>
    		<li><a href="#personal-data"><@liferay.language key="ehu.personal-data" /></a></li>
    		<li><a href="#rights"><@liferay.language key="ehu.rights" /></a></li>
    		<li><a href="#more-info"><@liferay.language key="ehu.more-info" /></a></li>
    	</ul>
    </nav>

<#--SECTIONS -->

<#--RESPONSIBLE -->

    <section id="responsible">
        <h2><@liferay.language key="ehu.responsible" /></h2>
        <@liferay.language key="ehu.data_processing-responsible" />
        
        <div class="backtop">
			<a href="#data-processing-title">
			<@liferay.language key="up" />
			 <span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>
    
<#--PURPOSE -->
    
    <section id="purpose">
        <h2><@liferay.language key="ehu.purpose" /></h2>
        
        <h3><@liferay.language key="ehu.data_processing-purpose-title" /></h3>
        
        <#assign purpose_text_box_data = ehudata_processingpurpose.getData()>
        <#if purpose_text_box_data?has_content >
            <#assign titleLang = ehudata_processingpurpose.ehutitlelangpurpose.getData()>
            <#if "upv-ehu-blank" == titleLang >
               <p>${purpose_text_box_data?replace("\\r?\\n", "</p><p>")}</p>
            <#else>
                <div lang="${titleLang}"><p>${purpose_text_box_data?replace("\\r?\\n", "</p><p>")}</p></div>
            </#if>
        </#if>
        
        <h3><@liferay.language key="ehu.data_processing-time-title" /></h3>
        
        <p><@liferay.language key="ehu.data_processing-time-description" /></p>
        

        <div class="backtop">
			<a href="#data-processing-title">
			<@liferay.language key="up" /> <span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>

<#-- LEGITIMATION-->

    <section id="legitimation">
        <h2><@liferay.language key="ehu.legitimation" /></h2>
        
        <h3><@liferay.language key="ehu.data_processing-legitimation-title" /></h3>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation1.getData())>
            <p><@liferay.language key="ehu.data_processing-legitimation1" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation2.getData())>
            <p><@liferay.language key="ehu.data_processing-legitimation2" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation3.getData())>
            <p><@liferay.language key="ehu.data_processing-legitimation3" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation4.getData())>
            <p><@liferay.language key="ehu.data_processing-legitimation4" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation5.getData())>
            <p><@liferay.language key="ehu.data_processing-legitimation5" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processinglegitimation.ehudata_processinglegitimation6.getData())>
            <#if ehudata_processinglegitimation.ehudata_processinglegitimation6.ehudata_processinglegitimation6other.getData()?has_content >
            <p><@liferay.language key="ehu.data_processing-legitimation6" />: ${ehudata_processinglegitimation.ehudata_processinglegitimation6.ehudata_processinglegitimation6other.getData()}</p>
            <#else>
                <p><@liferay.language key="ehu.data_processing-legitimation6" />.</p>
            </#if>
        </#if>
        
        <#list ehudata_processinglegitimation.ehudata_processinglegitimationother.getSiblings() as legitimation >
            <#if legitimation.getData()?has_content >
                <p>${legitimation.getData()}</p>
            </#if>
        </#list>
        
		<#if ehudata_processinglegitimation.ehudata_processinglegislation.getData()?has_content >
			<h4><@liferay.language key="ehu.data_processing-regulation" /></h4>
			<#list ehudata_processinglegitimation.ehudata_processinglegislation.getSiblings() as legislation >
				<#if legislation.getData()?has_content >
					<p>${legislation.getData()}</p>
				</#if>
			</#list>
		</#if>
        
        <div class="backtop">
			<a href="#data-processing-title">
			    <@liferay.language key="up" /> <span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>
    
<#-- RECEIVERS -->

    <section id="receivers">
        <h2><@liferay.language key="ehu.receivers" /></h2>
        
        <h3><@liferay.language key="ehu.data_processing-receivers-title" /></h3>
        
        <#if getterUtil.getBoolean(ehudata_processingtransfer.ehudata_processingtransferno.getData())>
            <p><@liferay.language key="ehu.data_processing-transfer_no" /></p>
        </#if>
        
        <#if getterUtil.getBoolean(ehudata_processingtransfer.ehudata_processingtransfernointernational.getData())>
            <p><@liferay.language key="ehu.data_processing-transfer_no_international" /></p>
        </#if>
        
        <#assign receivers_text_box_data = ehudata_processingtransfer.ehudata_processingtransferother.getData()>
        <#if receivers_text_box_data?has_content >
            <p>${receivers_text_box_data?replace("\\r?\\n", "</p><p>")}</p>
        </#if>
        
        <div class="backtop">
			<a href="#data-processing-title">
			    <@liferay.language key="up" />	<span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>

<#-- PERSONAL DATA -->

    <section id="personal-data">
        <h2><@liferay.language key="ehu.personal-data" /></h2>
        
        <h3><@liferay.language key="ehu.data_processing-categories-title" /></h3>
        
        <p><@liferay.language key="ehu.data_processing-categories-description" />:</p>
        
        <ul>
		
        <#assign special_data = ehudata_processingdata.ehudata_processingspecial>
        <#if special_data?? && (getterUtil.getBoolean(special_data.ehudata_processingspecialhealth.getData()) || 
             getterUtil.getBoolean(special_data.ehudata_processingspecialbiometric.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialgenetic.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialsexual.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialsexual.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialpolitics.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialunions.getData())|| 
             getterUtil.getBoolean(special_data.ehudata_processingspecialreligion.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialphilosophy.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialrace.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialgenderviolence.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialcrimes.getData())||
             getterUtil.getBoolean(special_data.ehudata_processingspecialadministrativeinfractions.getData())
             || (special_data.ehudata_processingspecialother?? && special_data.ehudata_processingspecialother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-special" />:
            <ul>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialhealth.getData())>
                    <li><@liferay.language key="ehu.data_processing-health" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialbiometric.getData())>
                    <li><@liferay.language key="ehu.data_processing-biometric" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialgenetic.getData())>
                    <li><@liferay.language key="ehu.data_processing-genetic" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialsexual.getData())>
                    <li><@liferay.language key="ehu.data_processing-sexual" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialpolitics.getData())>
                    <li><@liferay.language key="ehu.data_processing-politics" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialunions.getData())>
                    <li><@liferay.language key="ehu.data_processing-unions" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialreligion.getData())>
                    <li><@liferay.language key="ehu.data_processing-religion" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialphilosophy.getData())>
                    <li><@liferay.language key="ehu.data_processing-philosophy" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialrace.getData())>
                    <li><@liferay.language key="ehu.data_processing-race" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialgenderviolence.getData())>
                    <li><@liferay.language key="ehu.data_processing-gender_violence" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialcrimes.getData())>
                    <li><@liferay.language key="ehu.data_processing-crimes" /></li>
                </#if>
                <#if getterUtil.getBoolean(special_data.ehudata_processingspecialadministrativeinfractions.getData())>
                    <li><@liferay.language key="ehu.data_processing-administrative_infractions" /></li>
                </#if>
                <#list special_data.ehudata_processingspecialother.getSiblings() as special_data > 
                    <#if special_data.getData()?has_content >
                        <li>${special_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign id_data = ehudata_processingdata.ehudata_processingidentification >
        <#if id_data?? && (getterUtil.getBoolean(id_data.ehudata_processingidentificationid.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationss.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationregistry.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationname.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationaddress.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationphone.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationsign.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationelectronicsign.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationimage.getData())||
            getterUtil.getBoolean(id_data.ehudata_processingidentificationbody.getData())|| (id_data.ehudata_processingidentificationother?? && id_data.ehudata_processingidentificationother.getData()?has_content)) >
		
         <li><@liferay.language key="ehu.data_processing-identification"/>:
            <ul>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationid.getData())>
                    <li><@liferay.language key="ehu.data_processing-id"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationss.getData())>
                    <li><@liferay.language key="ehu.data_processing-ss"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationregistry.getData())>
                    <li><@liferay.language key="ehu.data_processing-registry"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationname.getData())>
                    <li><@liferay.language key="ehu.data_processing-name"/></li>
                </#if>
               <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationaddress.getData())>
                    <li><@liferay.language key="ehu.data_processing-address"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationphone.getData())>
                    <li><@liferay.language key="ehu.phones"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationsign.getData())>
                    <li><@liferay.language key="ehu.data_processing-sign"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationelectronicsign.getData())>
                    <li><@liferay.language key="ehu.data_processing-electronic-sign"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationimage.getData())>
                    <li><@liferay.language key="ehu.data_processing-image"/></li>
                </#if>
                <#if getterUtil.getBoolean(id_data.ehudata_processingidentificationbody.getData())>
                    <li><@liferay.language key="ehu.data_processing-body"/></li>
                </#if>
                <#list id_data.ehudata_processingidentificationother.getSiblings()as id_data >
                    <#if id_data.getData()?has_content >
                        <li>${id_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign personal_data = ehudata_processingdata.ehudata_processingpersonal >
       <#if personal_data?? && (getterUtil.getBoolean(personal_data.ehudata_processingpersonalmaritalstatus.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalfamily.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalbirthdate.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalbirthplace.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalage.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalsex.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalnationality.getData())||
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalmothertongue.getData())|| 
            getterUtil.getBoolean(personal_data.ehudata_processingpersonalphysical.getData())|| (personal_data.ehudata_processingpersonalother?? && personal_data.ehudata_processingpersonalother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-personal_characteristics"/>:
            <ul>
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalmaritalstatus.getData())>
                    <li><@liferay.language key="ehu.data_processing-marital_status"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalfamily.getData())>
                    <li><@liferay.language key="ehu.data_processing-family"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalbirthdate.getData())>
                    <li><@liferay.language key="ehu.data_processing-birthdate"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalbirthplace.getData())>
                    <li><@liferay.language key="ehu.data_processing-birthplace"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalage.getData())>
                    <li><@liferay.language key="ehu.data_processing-age"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalsex.getData())>
                    <li><@liferay.language key="ehu.data_processing-sex"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalnationality.getData())>
                    <li><@liferay.language key="ehu.data_processing-nationality"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalmothertongue.getData())>
                    <li><@liferay.language key="ehu.data_processingmother-tongue"/></li>
                </#if >
               <#if getterUtil.getBoolean(personal_data.ehudata_processingpersonalphysical.getData())>
                    <li><@liferay.language key="ehu.data_processing-physical"/></li>
                </#if >
                <#list personal_data.ehudata_processingpersonalother.getSiblings() as personal_data >
                    <#if personal_data.getData()?has_content >
                        <li>${personal_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign social_data = ehudata_processingdata.ehudata_processingsocial >
       <#if social_data?? && (getterUtil.getBoolean(social_data.ehudata_processingsociallivingplace.getData())||
             getterUtil.getBoolean(social_data.ehudata_processingsocialmilitary.getData())||
             getterUtil.getBoolean(social_data.ehudata_processingsocialpossessions.getData())||
             getterUtil.getBoolean(social_data.ehudata_processingsociallifestyle.getData())||
             getterUtil.getBoolean(social_data.ehudata_processingsocialassociation.getData())||
             getterUtil.getBoolean(social_data.ehudata_processingsocialpermissions.getData())|| (social_data.ehu_data_processingsocialother?? && social_data.ehu_data_processingsocialother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-social_circumstances"/>:
            <ul>
               <#if getterUtil.getBoolean(social_data.ehudata_processingsociallivingplace.getData())>
                    <li><@liferay.language key="ehu.data_processing-living_place"/></li>
                </#if >
               <#if getterUtil.getBoolean(social_data.ehudata_processingsocialmilitary.getData())>
                    <li><@liferay.language key="ehu.data_processing-military"/></li>
                </#if >
               <#if getterUtil.getBoolean(social_data.ehudata_processingsocialpossessions.getData())>
                    <li><@liferay.language key="ehu.data_processing-possessions"/></li>
                </#if >
               <#if getterUtil.getBoolean(social_data.ehudata_processingsociallifestyle.getData())>
                    <li><@liferay.language key="ehu.data_processing-lifestyle"/></li>
                </#if >
               <#if getterUtil.getBoolean(social_data.ehudata_processingsocialassociation.getData())>
                    <li><@liferay.language key="ehu.data_processing-association"/></li>
                </#if >
				<#if getterUtil.getBoolean(social_data.ehudata_processingsocialpermissions.getData())>
                    <li><@liferay.language key="ehu.data_processing-permissions"/></li>
                </#if >
                <#list social_data.ehudata_processingsocialother.getSiblings() as social_data >
                    <#if social_data.getData()?has_content >
                        <li>${social_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign economy_data = ehudata_processingdata.ehudata_processingeconomy >
       <#if economy_data?? && ( getterUtil.getBoolean(economy_data.ehudata_processingeconomyincome.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomyinvest.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomycredit.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomybank.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomypension.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomytax.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomyinsurance.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomymortgage.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomysubsidy.getData())||
             getterUtil.getBoolean(economy_data.ehudata_processingeconomycredithistory.getData())|| 
             getterUtil.getBoolean(economy_data.ehudata_processingeconomycreditcards.getData())|| (economy_data.ehudata_processingeconomyother?? && economy_data.ehudata_processingeconomyother.getData()?has_content)) >
             
        <li><@liferay.language key="ehu.data_processing-economic_data"/>:
            <ul>
               <#if getterUtil.getBoolean(economy_data.ehudata_processingeconomyincome.getData())>
                    <li><@liferay.language key="ehu.data_processing-income"/></li>
                </#if>
               <#if getterUtil.getBoolean(economy_data.ehudata_processingeconomyinvest.getData())>
                    <li><@liferay.language key="ehu.data_processing-invest"/></li>
                </#if>
               <#if getterUtil.getBoolean(economy_data.ehudata_processingeconomycredit.getData())>
                    <li><@liferay.language key="ehu.data_processing-credit"/></li>
                </#if>
               <#if getterUtil.getBoolean(economy_data.ehudata_processingeconomybank.getData())>
                    <li><@liferay.language key="ehu.data_processing-bank"/></li>
                </#if>
               <#if getterUtil.getBoolean(economy_data.ehudata_processingeconomypension.getData())>
                    <li><@liferay.language key="ehu.data_processing-pension"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomytax.getData())>
                    <li><@liferay.language key="ehu.data_processing-tax"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomyinsurance.getData())>
                    <li><@liferay.language key="ehu.data_processing-insurance"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomymortgage.getData())>
                    <li><@liferay.language key="ehu.data_processing-mortgage"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomysubsidy.getData())>
                    <li><@liferay.language key="ehu.data_processing-subsidy"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomycredithistory.getData())>
                    <li><@liferay.language key="ehu.data_processing-credit-history"/></li>
                </#if>
				<#if getterUtil.getBoolean(economy_data.ehudata_processingeconomycreditcards.getData())>
                    <li><@liferay.language key="ehu.data_processing-cards"/></li>
                </#if>
                <#list economy_data.ehudata_processingeconomyother.getSiblings() as economy_data >
                    <#if economy_data.getData()?has_content >
                        <li>${economy_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign  study_data = ehudata_processingdata.ehudata_processingstudies>
        <#if study_data?? && (getterUtil.getBoolean(study_data.ehudata_processingstudiestraining.getData())||
              getterUtil.getBoolean(study_data.ehudata_processingstudieshistory.getData())||
              getterUtil.getBoolean(study_data.ehudata_processingstudiesprofessionalexperience.getData())||
              getterUtil.getBoolean(study_data.ehudata_processingstudiescollege.getData())|| (study_data.ehudata_processingstudiesother?? && study_data.ehudata_processingstudiesother.getData()?has_content)) > 
        <li><@liferay.language key="ehu.data_processing-academic_professional"/>:
            <ul>
                <#if getterUtil.getBoolean(study_data.ehudata_processingstudiestraining.getData())>
                    <li><@liferay.language key="ehu.data_processing-training"/></li>
                </#if>
                <#if getterUtil.getBoolean(study_data.ehudata_processingstudieshistory.getData())>
                    <li><@liferay.language key="ehu.data_processing-studies_history"/></li>
                </#if>
                <#if getterUtil.getBoolean(study_data.ehudata_processingstudiesprofessionalexperience.getData())>
                    <li><@liferay.language key="ehu.data_processing-professional-experience"/></li>
                </#if>
                <#if getterUtil.getBoolean(study_data.ehudata_processingstudiescollege.getData())>
                    <li><@liferay.language key="ehu.data_processing-college"/></li>
                </#if>
                <#list study_data.ehudata_processingstudiesother.getSiblings() as study_data >
                    <#if study_data.getData()?has_content >
                        <li>${study_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
        <#assign  job_data = ehudata_processingdata.ehudata_processingjob >
       <#if job_data?? && ( getterUtil.getBoolean(job_data.ehudata_processingjobscale.getData())||
             getterUtil.getBoolean(job_data.ehudata_processingjobcategory.getData())||
             getterUtil.getBoolean(job_data.ehudata_processingjobpositions.getData())||
             getterUtil.getBoolean(job_data.ehudata_processingjobnoneconomicpayroll.getData())||
             getterUtil.getBoolean(job_data.ehudata_processingjobhistory.getData())|| (job_data.ehudata_processingjobother?? && job_data.ehudata_processingjobother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-job_detail"/>:
            <ul>
               <#if getterUtil.getBoolean(job_data.ehudata_processingjobscale.getData())>
                    <li><@liferay.language key="ehu.data_processing-job_scale"/></li>
                </#if>
               <#if getterUtil.getBoolean(job_data.ehudata_processingjobcategory.getData())>
                    <li><@liferay.language key="ehu.data_processing-job_category"/></li>
                </#if>
               <#if getterUtil.getBoolean(job_data.ehudata_processingjobpositions.getData())>
                    <li><@liferay.language key="ehu.data_processing-job_positions"/></li>
                </#if>
               <#if getterUtil.getBoolean(job_data.ehudata_processingjobnoneconomicpayroll.getData())>
                    <li><@liferay.language key="ehu.data_processing-non_economic_payroll"/></li>
                </#if>
				<#if getterUtil.getBoolean(job_data.ehudata_processingjobhistory.getData())>
                    <li><@liferay.language key="ehu.data_processing-job_history"/></li>
                </#if>
                <#list job_data.ehudata_processingjobother.getSiblings() as job_data >
                    <#if job_data.getData()?has_content >
                        <li>${job_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign  commercial_data = ehudata_processingdata.ehudata_processingcommercial>
        <#if commercial_data?? && ( getterUtil.getBoolean(commercial_data.ehudata_processingcommercialbusiness.getData())||        
              getterUtil.getBoolean(commercial_data.ehudata_processingcommerciallicenses.getData())||
              getterUtil.getBoolean(commercial_data.ehudata_processingcommercialsubscriptions.getData())||
              getterUtil.getBoolean(commercial_data.ehudata_processingcommercialcreations.getData()) || (commercial_data.ehudata_processingcommercialother?? && commercial_data.ehudata_processingcommercialother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-commercial"/>:
            <ul>
                <#if getterUtil.getBoolean(commercial_data.ehudata_processingcommercialbusiness.getData())>
                    <li><@liferay.language key="ehu.data_processing-business"/></li>
                </#if >
                <#if getterUtil.getBoolean(commercial_data.ehudata_processingcommerciallicenses.getData())>
                    <li><@liferay.language key="ehu.data_processing-commercial-licenses"/></li>
                </#if >
                <#if getterUtil.getBoolean(commercial_data.ehudata_processingcommercialsubscriptions.getData())>
                    <li><@liferay.language key="ehu.data_processing-subscriptions"/></li>
                </#if >
                <#if getterUtil.getBoolean(commercial_data.ehudata_processingcommercialcreations.getData())>
                    <li><@liferay.language key="ehu.data_processing-creations"/></li>
                </#if >
                <#list commercial_data.ehudata_processingcommercialother.getSiblings() as commercial_data >
                    <#if commercial_data.getData()?has_content >
                        <li>${commercial_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
		
		<#assign  transactions_data = ehudata_processingdata.ehudata_processingtransactions >
        <#if transactions_data?? && (getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsprovidedservices.getData())|| getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsreceivedservices.getData())|| getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsfinancial.getData())|| getterUtil.getBoolean(transactions_data.ehudata_processingtransactionscompensation.getData())|| (transactions_data.ehudata_processingtransactionsother?? && transactions_data.ehudata_processingtransactionsother.getData()?has_content)) >
        <li><@liferay.language key="ehu.data_processing-transactions"/>:
            <ul>
                <#if getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsprovidedservices.getData())>
                    <li><@liferay.language key="ehu.data_processing-provided-services"/></li>
                </#if>
                <#if getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsreceivedservices.getData())>
                    <li><@liferay.language key="ehu.data_processing-received-services"/></li>
                </#if>
                <#if getterUtil.getBoolean(transactions_data.ehudata_processingtransactionsfinancial.getData())>
                    <li><@liferay.language key="ehu.data_processing-financial"/></li>
                </#if>
                <#if getterUtil.getBoolean(transactions_data.ehudata_processingtransactionscompensation.getData())>
                    <li><@liferay.language key="ehu.data_processing-compensation"/></li>
                </#if>
                <#list transactions_data.ehudata_processingtransactionsother.getSiblings() as transactions_data >
                    <#if transactions_data.getData()?has_content >
                        <li>${transactions_data.getData()}</li>
                    </#if>
                </#list>
            </ul>
        </li>
        </#if>
        
        </ul>
        
        <div class="backtop">
			<a href="#data-processing-title">
			    <@liferay.language key="up" />	<span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>
    
<#-- RIGHTS-->

    <section id="rights">
        <h2><@liferay.language key="ehu.rights" /></h2>
        
        <h3><@liferay.language key="ehu.data_processing-rights-title" /></h3>
        
        <@liferay.language key="ehu.data_processing-rights-description" />
        
        <div class="backtop">
			<a href="#data-processing-title">
			    <@liferay.language key="up" />	<span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>
    
<#-- MORE INFO-->

    <section id="more-info">
        <h2><@liferay.language key="ehu.more-info" /></h2>
        
        <p><a href="https://www.ehu.eus/babestu">www.ehu.eus/babestu</a></p>
        
        <div class="backtop">
			<a href="#data-processing-title">
			    <@liferay.language key="up" />	<span class="icon-chevron-up"></span>
			</a>
		</div>
    </section>

</article>

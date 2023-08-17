<#--
Nombre contenido (ES): Oferta tecnológica
Estructura: enpresa > technological-offer.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/enpresa/oferta-tecnologica
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign one = getterUtil.getInteger("1")>
<#assign zero = getterUtil.getInteger("0")>
<article class="technology-offer">

    <header id="info-title">
        <h1>${ehumaindata.ehugrouptitle.getData()}</h1>
    </header>
    
    <#-- Índice. Comprobamos si existen datos de cada sección antes de pintar el enlace -->
	<nav role="navigation">
	<ul>
        <li>
            <a href="#main-data"><@liferay.language key="ehu.general-data" /></a>
        </li>
        
        <#if ehumembers.ehumembername.getData()?has_content >
            <li>
                <a href="#members"><@liferay.language key="ehu.persons" /></a>
            </li>
        </#if>
        
        <#if ehuresearchlines.ehuresearchlinesdescription.getData()?has_content >
            <li>
                <a href="#research-lines"><@liferay.language key="ehu.research-guidelines" /></a>
            </li>
        </#if>
        
        <#if ehutechnologyoffer.ehutechnologyofferdescription.getData()?has_content >
            <li>
                <a href="#technology-offer"><@liferay.language key="ehu.technologic-offer" /></a>
            </li>
        </#if>
        
        <#if ehuequipment.ehuequipmentname.getData()?has_content >
            <li>
                <a href="#equipment"><@liferay.language key="ehu.equipment" /></a>
            </li>
        </#if>
        
        <#if ehuprojects.ehuprojectsdescription.getData()?has_content >
            <li>
                <a href="#projects"><@liferay.language key="ehu.main-projects" /></a>
            </li>
        </#if>
        
    </ul>
    </nav>
                
	
	<#assign url = ehumaindata.ehuwebpageurl>

    <section id="main-data">
        <h2><@liferay.language key="ehu.general-data" /></h2>
		<dl>

			<#assign scopeId = groupId>
			<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
            <#assign articlePrimKey = journalLocalService.getArticle(scopeId, .vars['reserved-article-id'].data).resourcePrimKey >
            <#assign catLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")>
			<#assign vocabularyLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService")>    
			<#assign articleCategories = catLocalService.getCategories("com.liferay.journal.model.JournalArticle", getterUtil.getLong(articlePrimKey))>
			
			
			<#assign cont = zero>
			<#assign catString = "">
			<#list articleCategories as category >
				<#assign titulo = category.getTitle(locale)>
                <#assign vocabulary = vocabularyLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
                <#--  No es el vocabulario de global, es uno propio del sitio web -->		
                <#if vocabulary.getName() == "Kokapena" >
                    <#if cont == zero >
                        <#assign catString= catString + "<dt>" + languageUtil.get(locale, "ehu.ubication")+ " </dt>">
                    </#if>
                    <#assign catString= catString + "<dd>">
					<#assign catString= catString +  category.getTitle(locale)>
                    <#assign catString= catString + "</dd>" >
                    <#assign cont = cont + one>
                </#if> <#-- if vocabularyname=category vocabulary -->
                        
            </#list>
			
			${catString}
			
            <dt><@liferay.language key="ehu.main-researcher" /></dt>
            <dd>${ehumaindata.ehumainresearcher.getData()}</dd>
            
            <#if ehumaindata.ehuphdnumber.getData()?has_content >
                <dt><@liferay.language key="ehu.number-of-doctors" /></dt>
                <dd>${ehumaindata.ehuphdnumber.getData()}</dd>
            </#if>
            
            <#if ehumaindata.ehumembernumber.getData()?has_content >
                <dt><@liferay.language key="ehu.number-of-persons" /></dt>
                <dd>${ehumaindata.ehumembernumber.getData()}</dd>
            </#if>
            
            <#if ehumaindata.ehucontactemail.getData()?has_content >
                <dt><@liferay.language key="ehu.email" /></dt>
                <dd><a href="mailto:${ehumaindata.ehucontactemail.getData()}">${ehumaindata.ehucontactemail.getData()}</a></dd>
            </#if>
            
            <#if ehumaindata.ehuwebpageurl.getData()?has_content >
               
                <#assign formatedURL = "">
                <#if url?is_hash >
					<#assign aux = url.getData() >
				<#else>
					<#assign aux = getterUtil.getString(url) >
				</#if>
				<#if aux?has_content && aux != "">
					<#assign formatedURL = aux>
				</#if>

			    <#assign urlText = formatedURL>
                <dt><@liferay.language key="ehu.web-page" /></dt>
                <dd><a href="${formatedURL}" target="_blank"><span class="hide-accessible"><@liferay.language key="opens-new-window" /></span>
					${urlText}
				<span class="icon-external-link"></span></a></dd>
            </#if>
        </dl>
        
        <#--UP-->
        <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
   </section>
    
    <#if ehumembers.ehumembername.getData()?has_content >
        <section id="members">
            <h2><@liferay.language key="ehu.persons" /></h2>
            <ul>
                <#list ehumembers.ehumembername.getSiblings() as member >
    				<li>
    					${member.getData()}
    				</li>
				</#list>
			</ul>
			
			<#--UP-->
            <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
       </section>
    </#if>
    
    <#assign description = ehuresearchlines.ehuresearchlinesdescription.getData()>
    <#if description?has_content >
        <section id="research-lines">
            <h2><@liferay.language key="ehu.research-guidelines" /></h2>
            
            <div class="description">
                
                ${description}
               
    		</div>
    		<#--UP-->
            <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
       </section>
    </#if>
    
    <#assign description = ehutechnologyoffer.ehutechnologyofferdescription.getData()>
    <#if description?has_content >
        <section id="technology-offer">
            <h2><@liferay.language key="ehu.technologic-offer" /></h2>
        
            <div class="description">
                 ${description}
	    	</div>
	    	<#--UP-->
            <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
       </section>
    </#if>

    <#if ehuequipment.ehuequipmentname.getData()?has_content >
        <section id="equipment">
            <h2><@liferay.language key="ehu.equipment" /></h2>
            <ul>
                <#list ehuequipment.ehuequipmentname.getSiblings() as equipment >
        			<li>
        				${equipment.getData()}
        			</li>
    			</#list>
    		</ul>
    		<#--UP-->
            <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
            
        </section>
    </#if>
    
    <#assign description = ehuprojects.ehuprojectsdescription.getData()>
    <#if description?has_content >
        <section id="projects">
            <h2><@liferay.language key="ehu.main-projects" /></h2>
        
            <div class="description">
                 ${description}
    		</div>
    	<#--UP-->
        <div class="backtop"><a href="#info-title"> <@liferay.language key="up" /> <span class="icon-chevron-up"></span></a></div>
       </section>
    </#if>
    
</article>
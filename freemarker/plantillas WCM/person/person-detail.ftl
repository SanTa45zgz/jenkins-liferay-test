<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#assign scopeId = themeDisplay.scopeGroupId >

<#if journalLocalService.fetchArticle(scopeId, .vars['reserved-article-id'].data)??>
    <#assign articlePrimKey = journalLocalService.getArticle(scopeId, .vars['reserved-article-id'].data).resourcePrimKey >
</#if>

<#assign catLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")>
<#assign articleCategories = catLocalService.getCategories("com.liferay.journal.model.JournalArticle", getterUtil.getLong(articlePrimKey))>
<#assign vocLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService")>
<#assign globalGroupId = company.getGroupId()>
<#assign one = getterUtil.getInteger("1")>

<#assign existHartzaileak = getterUtil.getBoolean("false")>
<#list articleCategories as category >
	<#assign vocabulary = vocLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
	<#if vocabulary.getName() == "Hartzaileak" && vocabulary.getGroupId() == globalGroupId >
		<#assign existHartzaileak = getterUtil.getBoolean("true")>
		<#break>
	</#if>
</#list>
<#assign existH2 = existHartzaileak || ehucontactdata.ehuotherinformation.getData()?has_content>
<#assign titleHO = "<h2>">
<#assign titleHC = "</h2>">
<#if existH2>
	<#assign titleHO = "<h3>">
	<#assign titleHC = "</h3>">
</#if>
<article class="person">
    <header>
        <h1>${ehucontactdata.ehuname.getData()}</h1>
        <#if existH2>
	        <h2>
	            <#list articleCategories as category >
	                <#assign vocabulary = vocLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
	                <#if vocabulary.getName() == "Hartzaileak" && vocabulary.getGroupId() == globalGroupId >
	                    <span>${category.getTitle(locale)}</span>
	                </#if>
	            </#list> 
	            <#if ehucontactdata.ehuotherinformation.getData()?has_content >
	                <span>(${ehucontactdata.ehuotherinformation.getData()})</span>
	            </#if>
	        </h2>
	     </#if>
    </header>
    <#-- title -->
        
    <#assign personImage= ehucontactdata.ehuimage.getData() >
    <#if !personImage?has_content >
        <#assign personImage="/image/user_male_portrait">
    </#if>
        
    <img class="person_photo" src="${personImage}" alt="">

    <#-- contact data / name-image -->
        
    <#if ehucontactdata.ehuphone.getData()?has_content || ehucontactdata.ehumail.getData()?has_content >      
        <div>
            <#if ehucontactdata.ehuphone.getData()?has_content >
                <#if (ehucontactdata.ehuphone.getSiblings()?size == one) >
                    ${titleHO}<@liferay.language key="ehu.phone" />${titleHC}
                <#elseif (ehucontactdata.ehuphone.getSiblings()?size > one) >
                    ${titleHO}<@liferay.language key="ehu.phones" />${titleHC}
                </#if>
                <ul>
                    <#list ehucontactdata.ehuphone.getSiblings() as phone >
                    	<#assign valor = phone.getData()>
						<#assign valor = valor?replace(' ', '', 'i')>
						<#assign valor = valor?replace('  ', '', 'i')>
						<#assign valor = valor?replace('.', '', 'i')>
						<#assign valor = valor?replace('-', '', 'i')>
						<#assign valor = valor?replace('/', '', 'i')>
		
                        <li>
                            <#if phone.ehuphonetext.getData()?has_content >                                     
                            	<strong>${phone.ehuphonetext.getData()}:</strong>
                            </#if>
                            <a href="tel:${valor}">${phone.getData()}</a>
                        </li>
                    </#list>
                </ul>
            </#if><#-- if phones -->
                    
                    
            <#if ehucontactdata.ehumail.getData()?has_content >
                <#if (ehucontactdata.ehumail.getSiblings()?size == one) >
                    ${titleHO}<@liferay.language key="ehu.email" />${titleHC}
                <#elseif (ehucontactdata.ehumail.getSiblings()?size > one)>
                    ${titleHO}<@liferay.language key="ehu.emails" />${titleHC}
                </#if>
                <ul>
                    <#list ehucontactdata.ehumail.getSiblings() as mail >
                        <li>
                            <#if mail.ehumailtext.getData()?has_content >
                                <strong>${mail.ehumailtext.getData()}:</strong>
                            </#if>
                            <a href="mailto:${mail.getData()}">${mail.getData()}</a>
                        </li>
                    </#list> <#-- foreach -->
                </ul>                   
            </#if> <#-- if mail -->
            <#-- contact data / job-phone-email -->
        </div>
    </#if>    
        
    <#if ehuaditionalinfo.ehudocument.getData()?has_content >
        <div class="documents">
            <#if ((ehuaditionalinfo.ehudocument.getSiblings()?size == one)?c)?boolean >
                ${titleHO}<@liferay.language key="document" />${titleHC}
            <#elseif ((ehuaditionalinfo.ehudocument.getSiblings()?size > one)?c)?boolean >
                ${titleHO}<@liferay.language key="documents" />${titleHC}
            </#if>
            <ul>
                <#list ehuaditionalinfo.ehudocument.getSiblings() as document >                   
                    <#if document.getData()?has_content >
                        <#assign formatedDocument="">
                        <#if document.getData()?contains("/") >
                            <#assign documentTitleField = 'ehudocumentdescription' >
                            <@upvlibs.formatAttachment documentField=document documentTitleField=documentTitleField />
                                <#assign formatedDocument = upvlibs.formatedDocument >
                            <li>${formatedDocument}</li>
                        </#if>
                    </#if>
                </#list>
            </ul>
        </div>  
    </#if> <#-- if documents -->
                
    <#if ehuaditionalinfo.ehuurl.getData()?has_content >
        <div class="links">
            <#if ((ehuaditionalinfo.ehuurl.getSiblings()?size == one)?c)?boolean  >
                ${titleHO}<@liferay.language key="ehu.url" />${titleHC}
            <#elseif ((ehuaditionalinfo.ehuurl.getSiblings()?size> one)?c)?boolean >
                ${titleHO}<@liferay.language key="ehu.urls" />${titleHC}
            </#if>
            <ul>
                <#list ehuaditionalinfo.ehuurl.getSiblings() as url >
                    <#assign formatedURL="">
                    <#if url?is_hash >
						<#assign aux = url.getData() >
					<#else>
						<#assign aux = getterUtil.getString(url) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign formatedURL = aux>
					</#if>
                    
                    <#assign urlDesc = formatedURL >
                    <#if url.ehuurldescription.getData()?has_content >
                       <#assign urlDesc = url.ehuurldescription.getData() >
                    </#if>
                    <li>
                        <a href="${formatedURL}" class="bullet bullet-url" target="_blank">
                           <span class="hide-accessible"><@liferay.language key="opens-new-window" /></span>
                             ${urlDesc}
                             <span class="icon-external-link"></span>
                         </a>
                     </li>
                    
                </#list>
            </ul>
        </div>  
    </#if> <#-- if urls -->
        
        
    <#-- se añaden las nuevas pestañas -->
    
    <#-- Se valida que la asignación no sea nula (Trello 686) -->
    <#if ehuaditionalinfo?? >
    	<#if ehuaditionalinfo.ehutitle?? >
    		<#if (ehuaditionalinfo.ehutitle.getSiblings()?has_content) >
    			<#assign aditionInfoSize = ehuaditionalinfo.ehutitle.getSiblings()?size >
			</#if>	
		</#if>
	</#if>
	<#assign aditionalInfoFirstTitle = '' >
	<#assign aditionalInfoFirstContent = '' >
	<#-- si la primera pestaña existe en un idioma pero en otro no, se evita que aparezca una pestaña vacía en el idioma que no exista -->
	<#if aditionInfoSize?? >
		<#if ((aditionInfoSize >= 1)?c)?boolean >
			<#assign aditionalInfoFirst = ehuaditionalinfo.ehutitle.getSiblings()[0]>
			<#assign aditionalInfoFirstTitle = aditionalInfoFirst.getData()>
			<#assign aditionalInfoFirstContent = aditionalInfoFirst.ehudescription.getData()>
			<#assign isAditionalInfoFirstContent = getterUtil.getBoolean("false")>
			<#if aditionalInfoFirstContent != '' >
				<#assign isAditionalInfoFirstContent =  getterUtil.getBoolean("true")>
			</#if>
		</#if>
	</#if>
    <#if aditionalInfoFirstContent?has_content >
    	<section id="tab">
	        <#assign cont = one >
	        <#assign aditional_info_tab = ehuaditionalinfo.ehutitle.getSiblings()?size >
	        <ul class="nav nav-tabs" role="tablist" aria-label='<@liferay.language key="ehu.content-sections-menu" />'>  
		        <#list ehuaditionalinfo.ehutitle.getSiblings() as tab >
	        		<#assign title = tab.getData()>
					<#if !title?has_content >
	        			<#assign title = languageUtil.get(locale, "ehu.informacionAdicional")>
	        		</#if>
	        		<#-- Eliminamos los espacios del nombre de la persona para poder usuarlo como ancla -->
					<#assign personName = ehucontactdata.ehuname.getData()>
					<#assign personName = personName?replace(" ", "")>
		            <#assign tabHref = "#" + personName + cont >
		            <li role="presentation">
	                   <a href="${tabHref}">${title}</a>
	                </li>
		            <#assign cont= cont + one >
		        </#list> 
		        </ul>         
		        <#assign cont = one >
				<div class="tab-content">
				    <#list ehuaditionalinfo.ehutitle.getSiblings() as tab_content >
		        	    <#assign text_box_data = tab_content.ehudescription.getData()>
		                <#assign tabId = "#" + personName + cont >
                       
                        <#assign title = tab_content.getData() >
		        	    <#if !title?has_content >
		        		    <#assign title = languageUtil.get(locale, "ehu.informacionAdicional")>
		        	    </#if>
		                <div id="${tabId}">
		             	    <h3 class="hide-accessible">${title}</h3 >
		             	    <#if text_box_data?has_content>
		             	    	<p>${(text_box_data?js_string)?replace("\\n", "</p><p>")}</p>
		             	    </#if>
		                </div>
		                <#assign cont = cont + one >
		            </#list> 
		        </div>
	      	</section>
	     </#if> 
</article>

<#-- la definición de la función javascript tb depende de la existencia de pestañas, sino da errores -->
<script>
        AUI().use(
        'aui-tabview',
        function(A) {
        	<#if aditionInfoSize?? >
				var aditionInfoSize = "${aditionInfoSize}";
				var isAditionalInfoFirstContent = ${isAditionalInfoFirstContent?string};
				
				
				if(aditionInfoSize >= 1 && isAditionalInfoFirstContent){
					 var tabs = new A.TabView({
						srcNode: '#tab'
					 });
					 tabs.render();
				}
			</#if>
        }
    );

</script>

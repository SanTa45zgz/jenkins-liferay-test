<#-- Mostrar las rrss de un site -->
	<#-- las urls de las redes sociales, serán la misma que las configuradas en la home -->
		<#assign rootPage = layoutLocalService.fetchFirstLayout(themeDisplay.getSiteGroupId(),false, 0)/>					
		
	<#if rootPage?? && rootPage.getExpandoBridge()?? && rootPage.getExpandoBridge().getAttribute("is-root-master")?? > 	
		<#assign facebookMasterURL = rootPage.getExpandoBridge().getAttribute("facebook-master-url") />						
		<#assign twitterMasterURL = rootPage.getExpandoBridge().getAttribute("twitter-master-url") />						
		<#assign linkedinMasterURL = rootPage.getExpandoBridge().getAttribute("linkedin-master-url") />
		<#assign instagramMasterURL = rootPage.getExpandoBridge().getAttribute("instagram-master-url") />
		<#assign flickrMasterURL = rootPage.getExpandoBridge().getAttribute("flickr-master-url") />
		<#assign blogMasterURL = rootPage.getExpandoBridge().getAttribute("rrss-blog-master-url") />
		<#assign youtubegMasterURL = "" />
		<#if rootPage.getExpandoBridge().getAttribute("youtube-master-url")?? > 
			<#assign youtubegMasterURL = rootPage.getExpandoBridge().getAttribute("youtube-master-url") />							
		</#if>
	</#if>
	
	<#if facebookMasterURL?has_content || twitterMasterURL?has_content || linkedinMasterURL?has_content || instagramMasterURL?has_content || flickrMasterURL?has_content ||  blogMasterURL?has_content || youtubegMasterURL?has_content >
		<div class="header__rrss">
				
			<#if facebookMasterURL?? && facebookMasterURL?has_content >								
				<a href="${facebookMasterURL}" target="_blank"><i class="icon-facebook"></i>
					<span class="sr-only">Facebook - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>
	
			<#if flickrMasterURL?? && flickrMasterURL?has_content >
				<a href="${flickrMasterURL}"  target="_blank"><i class="icon-flickr"></i>
					<span class="sr-only">Flickr - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>

			<#if instagramMasterURL?? && instagramMasterURL?has_content >
				<a href="${instagramMasterURL}" target="_blank"><i class="icon-instagram"></i>
					<span class="sr-only">Instagram - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>

			<#if linkedinMasterURL?? && linkedinMasterURL?has_content>
				<a href="${linkedinMasterURL}" target="_blank"> <i class="icon-linkedin"></i>
					<span class="sr-only">Linkedin - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>

			<#if blogMasterURL?? && blogMasterURL?has_content>
			
				<a class="header__rrss__img-icon" href="${blogMasterURL}" target="_blank">
					<span class="sr-only">Blog - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>
			
			<#if youtubegMasterURL?? && youtubegMasterURL?has_content>
				<a href="${youtubegMasterURL}" target="_blank"><i class="icon-youtube"></i>
					<span class="sr-only">Youtube - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>

			<#if twitterMasterURL?? && twitterMasterURL?has_content>
				<a href="${twitterMasterURL}"  target="_blank"><i class="icon-twitter"></i>
					<span class="sr-only">Twitter - <@liferay.language key="opens-new-window" /></span>
				</a>
			</#if>
		</div>
	</#if>
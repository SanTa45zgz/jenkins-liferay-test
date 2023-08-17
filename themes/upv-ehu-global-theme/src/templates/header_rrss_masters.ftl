<#if socials>
    <div class="header__rrss">
		<#if facebookMasterURL?? && facebookMasterURL?has_content >
			<a href="${facebookMasterURL}" target="_blank"><i class="icon-facebook"></i><span class="sr-only">Facebook - ${masterName}</span>
			</a> 
		</#if>
		
		<#if twitterMasterURL?? && twitterMasterURL?has_content>
			<a href="${twitterMasterURL}" target="_blank"><i class="icon-twitter"></i><span class="sr-only">Twitter - ${masterName}</span>
			</a> 
		</#if>

		<#if linkedinMasterURL?? && linkedinMasterURL?has_content>
			<a href="${linkedinMasterURL}" target="_blank"><i class="icon-linkedin"></i><span class="sr-only">Linkedin - ${masterName}</span> </a> 
		</#if>


		<#if instagramMasterURL?? && instagramMasterURL?has_content >
			 <a href="${instagramMasterURL}" target="_blank"><i class="icon-instagram"></i><span class="sr-only">Instagram - ${masterName}</span></a>
		</#if>


		<#if flickrMasterURL?? && flickrMasterURL?has_content >
			<a href="${flickrMasterURL}" target="_blank"> <i class="icon-flickr"></i><span class="sr-only">Flickr - ${masterName}</span></a>
		</#if>

		<#if blogMasterURL?? && blogMasterURL?has_content>
			<a class="header__rrss__img-icon" href="${blogMasterURL}" target="_blank">
				<span class="sr-only">Blog - ${masterName}</span>
			</a>
		</#if>
    </div> 
</#if>

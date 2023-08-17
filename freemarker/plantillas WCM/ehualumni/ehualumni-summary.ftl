<#assign description = ehubody.getData()>
<#assign image_src = ehuimage.getData()>
<#assign title = ehutitle.getData()>
<#assign userLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.UserLocalService")>
<#assign user = userLocalService.getUserById(themeDisplay.getUserId())>

<article class="alumni">
	<header id="alumni-title">
		<h1>${title}</h1>
	</header>

	<div id="acreditacion">
		<div class="photo">
			<div>
                <img alt="" src="${image_src}" >
            </div>			
		</div>
		<div class="description">  
			<p>${user.getFullName()}</p>			
			<div class="main">
				<p>${description}</p>
			</div>                                                                  
		</div>
	</div>
</article>
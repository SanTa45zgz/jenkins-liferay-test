<#assign description = ehubody.getData()>
<#assign image_src = ehuimage.getData()>
<#assign title = ehutitle.getData()>
<#assign userLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.UserLocalService")>
<#assign user = userLocalService.getUserById(themeDisplay.getUserId())>

<article class="alumni">
	<header id="alumni-title">
		<h1>${title}</h1>
	</header>

	<div id="acreditacion1" class="acd_div_bq">
		<div class="photo">
			<div class="acd_div_tx">
				<p>ehu<span>alumni</span></p>
			</div>
			
		</div>
		<div class="description">  
			<p>${user.getFirstName()}</p>
			<p>${user.getLastName()}</p>
			<div class="main">
				<p><@liferay.language key="ehu.nationalID" /></p>
			</div>                                                                  
		</div>
	</div>

	<div id="acreditacion2" class="acd_div_bq">
		<div class="photo">
			<img src="https://www.ehu.eus/documents/4615962/5480001/logo_ehualumni/a65c7226-9117-006b-057b-a0cc97e7d07e?t=1524754323083">
		</div>
		<div class="description">  
			<div class="main">
				<p>www.ehu.eus/ehualumni</p>
				<p>946017150</p>
				<p>ehualumni@ehu.eus</p>
			</div>                                                                  
		</div>
	</div>
	
	<a id="descarga" target="_blank" href="https://ehu.eus/alumniregistration/acreditacionEHUalumni?user=${user.getScreenName()}"><@liferay.language key="download" /></a>
</article>
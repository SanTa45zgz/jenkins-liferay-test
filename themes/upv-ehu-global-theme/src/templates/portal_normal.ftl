<!DOCTYPE html>

<#include init />

<html class="${root_css_class} aui" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">

<head>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-PF5W7J2G9S"></script>
<script>
	window.dataLayer = window.dataLayer || [];
	function gtag(){dataLayer.push(arguments);}
	gtag('js', new Date());
	gtag('config', 'G-PF5W7J2G9S');
</script>

<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-K7VPXV4');</script>
<!-- End Google Tag Manager -->


	<#if isRootPage && specificMenuRootPage.get??>
		<#attempt>
			<title>${the_title} - ${specificMenuRootPage.getName(locale)} - ${company_name}</title>
			<meta property="og:title" content="${the_title} - ${specificMenuRootPage.getName(locale)} - ${company_name}" />
		<#recover>
			<title>${the_title} - ${company_name}</title>
			<meta property="og:title" content="${the_title} - ${company_name}" />
		</#attempt>
	<#else>
		<title>${the_title} - ${company_name}</title>
		<meta property="og:title" content="${the_title} - ${company_name}" />
	</#if>

	<meta name="google" content="notranslate">
	<meta property="og:type" content="website" />
	<meta property="og:url" content="${portal.getCurrentCompleteURL(request)}" />
	<meta property="og:site_name" content="${site_name}" />
	<meta property="og:locale" content="${locale}" />

	<meta content="initial-scale=1.0, width=device-width" name="viewport" />

	<link href="${images_folder}/apple-touch-icon-precomposed.png" rel="apple-touch-icon-precomposed">

	<@liferay_util["include"] page=top_head_include />
</head>

<body class="${css_class} ${w3c_language_id}">
<input type="hidden" id="theme-name" value="upv-ehu-global-theme" />

<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-K7VPXV4"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

<@liferay_ui["quick-access"] contentId="#main-content" />

<@liferay_util["include"] page=body_top_include />

<@liferay.control_menu />

<#if is_signed_in>	
	<div class="user-logged">
		<@liferay.user_personal_bar />
	</div>
</#if>

<script type="text/javascript" src="${javascript_folder}/owl-carousel.js"></script>


<div class="container-fluid" id="wrapper">
 	<#if themeDisplay.getColorSchemeId()=="06" >

       <#include "${full_templates_path}/wrapperMasters.ftl" />
       <script src="${javascript_folder}/masters.js"></script>

    <#else>
        <#if showFeaturedHeader || themeDisplay.getColorSchemeId()=="08">
            <#include "${full_templates_path}/header_featured.ftl" />
        <#else>
             <#include "${full_templates_path}/header.ftl" />
        </#if>

 		<#include "${full_templates_path}/content.ftl" />
 		<#include "${full_templates_path}/footer.ftl" />
    </#if>
</div>

<#--  <div class="container-fluid position-relative" id="wrapper">
	<header id="banner" role="banner">
		<div id="heading">
			<div aria-level="1" class="site-title" role="heading">
				<a class="${logo_css_class}" href="${site_default_url}" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
					<img alt="${logo_description}" height="${site_logo_height}" src="${site_logo}" width="${site_logo_width}" />
				</a>

				<#if show_site_name>
					<span class="site-name" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
						${site_name}
					</span>
				</#if>
			</div>
		</div>

		<#if !is_signed_in>
			<a data-redirect="${is_login_redirect_required?string}" href="${sign_in_url}" id="sign-in" rel="nofollow">${sign_in_text}</a>
		</#if>

		<#if has_navigation && is_setup_complete>
			<#include "${full_templates_path}/navigation.ftl" />
		</#if>
	</header>

	<section id="content">
		<h2 class="hide-accessible sr-only" role="heading" aria-level="1">${htmlUtil.escape(the_title)}</h2>

		<#if selectable>
			<@liferay_util["include"] page=content_include />
		<#else>
			${portletDisplay.recycle()}

			${portletDisplay.setTitle(the_title)}

			<@liferay_theme["wrap-portlet"] page="portlet.ftl">
				<@liferay_util["include"] page=content_include />
			</@>
		</#if>
	</section>

	<footer id="footer" role="contentinfo">
		<p class="powered-by">
			<@liferay.language_format
				arguments='<a href="http://www.liferay.com" rel="external">Liferay</a>'
				key="powered-by-x"
			/>
		</p>
	</footer>
</div>  -->

<@liferay_util["include"] page=body_bottom_include />

<@liferay_util["include"] page=bottom_include />

<#--  <script src="${javascript_folder}/jquery.js"></script>  -->

<#if showSideMenuSetting??>
	
	<#--  <script src="${javascript_folder}/main.js"></script>  -->
	<script>
	$(function () {
	  var ot = $('#side-menu').offset().top;
	  var mt = $('#side-menu').css('margin-top'); 	
	  console.log('OFFSET TOP: ' + ot);
      console.log('MARGIN TOP: ' + mt);
      $(window).scroll(function (event) {
	  	var y = $(this).scrollTop();	
	  	console.log('Y: ' + y);	
	  });
	    
	});
	</script>	
</#if>
<script>
	$(".toggler-header" ).click(function() {
		if($(this).hasClass("toggler-header-collapsed")){
			$(this).removeClass("toggler-header-collapsed")
			$(this).addClass("toggler-header-expanded")
			$(this).next().removeClass("toggler-content-collapsed")
			$(this).next().addClass("toggler-content-expanded")

		}else{
			$(this).removeClass("toggler-header-expanded")
			$(this).addClass("toggler-header-collapsed")
			$(this).next().removeClass("toggler-content-expanded")
			$(this).next().addClass("toggler-content-collapsed")
		}
	});

	$(".accordion-heading" ).click(function() {
		if($(this).next().hasClass("collapse")){
			$(this).next().removeClass("collapse")
			$(this).next().css("height","auto");
			$(this).children().removeClass("collapsed");
		}else{
			$(this).next().addClass("collapse")
			$(this).next().css("height","0px");
			$(this).children().addClass("collapsed");
		}
	});
</script>

</body>

</html>
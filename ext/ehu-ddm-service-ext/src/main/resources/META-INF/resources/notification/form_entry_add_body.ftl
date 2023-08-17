<!DOCTYPE html>
<html class="ltr" dir="ltr">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>${emailTitle}</title>
		<style type="text/css">
			body {
				color: #54595f;
				font: 400 13px EHUSans, Verdana;
				font-weight: normal;
				font-style: normal;				
			}
			
			h1 {
				font-size: 1.35em;
			}
			
			h2{
				font-size:1.05em;
			}
			
			#container {
				margin: 25px 50px;
				line-height: 19px;
			}
			
			article {
				padding: 20px 0px;
			}
			
			a {
				color: #0d719a;
			}

			dl dt {
				font-weight: bold;
			}

			footer p{
				color: #444;
				text-align: right;
				padding-right: 20px;
			}
		</style>
	</head>
	<body>
	
		<#list localizedDatas as localizedData>
			<#assign rb = localizedData.getRb()/>
			<#assign locale = localizedData.getLocale()/>
			<#assign formName = localizedData.getFormName()/>
			<#assign pages = localizedData.getPages()/>
			<#assign siteName = localizedData.getSiteName()/>
			<#assign userName = localizedData.getUserName()/>
			
			
			<div id="container" style="border-bottom: 1px dotted #ccc;" lang="${locale.getLanguage()}">
				
				<header>
					<img src="${logoUrl}" width="200" height="92" alt="${languageUtil.get(rb, "upv-ehu.webform.university.basque-country.oficial-languages")}" />
				</header>
			
				<article>
					<h1>${languageUtil.get(rb, "upv-ehu.webform.send.email.title")}: <a href="${viewFormURL}" style="font-size:0.9em;text-decoration:none;">${formName}</a></h1>
			
					<h2>${languageUtil.get(rb, "upv-ehu.webform.information.sent.is.as-follows")}:</h2>
			
					
					<#foreach page in pages>
						<div style="background-color: #fff; border-radius: 4px; margin: 0 auto 24px auto; padding: 40px;">
							<h4 style="color: #9aa2a6; font-size: 21px; font-weight: 500; margin: 0;">${page.title}</h4>
							<dl>
							<#foreach field in page.fields>
								<#if field??>
										<#-- si no tiene valor no hay que introducir el campo -->
										<#if field.value?? && field.value != "">
											<dt>${field.label}</dt>										
											<dd>${field.value}</dd>

										</#if>
								</#if>
							</#foreach>
						</dl>
						</div>
					</#foreach>
					
				</article>
			
				<footer>
					<p>
						<span lang="es">Universidad del País Vasco</span> / <span lang="eu">Euskal Herriko Unibertsitatea</span>
					</p>
				</footer>
			</div>
		</#list>
	</body>
</html>	
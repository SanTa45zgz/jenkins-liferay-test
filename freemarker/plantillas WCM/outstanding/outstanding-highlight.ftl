<#assign puntos_txt = "..." >

<#assign formatedURL = "" >
<#if ehuoutstandinglink?is_hash >
	<#assign aux = ehuoutstandinglink.getData() >
<#else>
	<#assign aux = getterUtil.getString(ehuoutstandinglink) >
</#if>
<#if aux?has_content && aux != "">
	<#assign formatedURL = aux>
</#if>

<#assign len_max_subtitulo = 125 >

<#assign titulo = ehuoutstandingtitle.getData() >
<#assign subtitulo = ehuoutstandingsubtitle.getData() >
<#assign image = ehuoutstandingimage.getData() >
<#assign image_alt = ehuoutstandingimage.ehuoutstandingimagealttext.getData()>
<#assign link_title = ehuoutstandinglink.ehuoutstandinglinktitle.getData() >
<#assign link_in_new_tab = getterUtil.getBoolean(ehuoutstandinglink.ehuoutstandingurlnewtab.getData() ) >

<#assign subtitulo_txt = getterUtil.getString(subtitulo ) >
<#assign subtitulo_len = subtitulo_txt?length>

<#assign href_title = "" >
<#assign href_target = "" >
<@upvlibs.hrefOptions new_tab=link_in_new_tab link_title=link_title href_title=href_title href_target=href_target />
<#assign href_title = upvlibs.href_title >
<#assign href_target = upvlibs.href_target >

<#if image_alt?has_content>
	<#assign image_alt_text = getterUtil.getString(image_alt ) >
<#else>
	<#assign image_alt_text = "" >
</#if>

<#if themeDisplay.getTheme().getContextPath() == "/o/ehu-theme">
	<#if image?has_content>
		<figure class="row">
	        <img class="col-4" src="${htmlUtil.escape(image)}" alt="${image_alt_text}" />    
			<figcaption class="col-8">
				<p class="card-title"><strong>
					${titulo}
				</strong></p>
				<#if subtitulo_txt?has_content>
					<p>${subtitulo_txt}</p>
				</#if>
			</figcaption>
		</figure>
	<#else>
		<p class="card-title"><strong>
			${titulo}
		</strong></p>
		<#if subtitulo_txt?has_content>
			<p>${subtitulo_txt}</p>
		</#if>
	</#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

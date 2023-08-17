<section id="content" class="section section-padded" aria-label="<@liferay.language key='ehu.main-content'/>">

	<#if pageTpl?contains("upv_ehu_1_col")>
		<div class="columns-1" id="main-content__principal" role="main">
	<#elseif pageTpl?contains("upv_ehu_2_cols")>
		<div class="columns-2" id="main-content__principal" role="main">
	<#elseif pageTpl?contains("upv_ehu_3_cols")>
		<div class="columns-3" id="main-content__principal" role="main">
	</#if>



		<div class="portlet-layout container">
			<#if !pageTpl?contains("upv_ehu_centers")>
				<div class="row">
			</#if>

			<#if selectable>
				 <@liferay_util["include"] page=content_include /> 
			<#else>
				${portletDisplay.recycle()}

				${portletDisplay.setTitle(the_title)}

				<@liferay_theme["wrap-portlet"] page="portlet.ftl">
					<@liferay_util["include"] page=content_include />
				</@>
			
			</#if>

			<#if !pageTpl?contains("upv_ehu_centers")>
				</div>
			</#if>
		</div>			  
	</div>	

</section>
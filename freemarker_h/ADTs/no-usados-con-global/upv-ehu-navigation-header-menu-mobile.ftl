<!--
Template Name: UPV Header Menu Mobile
Description: Displays header menu navigation - Mobile
-->

<#if !entries?has_content>
	<#if themeDisplay.isSignedIn()>
		<div class="alert alert-info">
			<@liferay.language key="there-are-no-menu-items-to-display" />
		</div>
	</#if>
<#else>

	<#assign indicatorId = stringUtil.randomString() /> 
	<ul class="accordion" id="header__menu-mobile__nav__accordion_${indicatorId}">
		<#assign navItems = entries />

		<#list navItems as navItem>
			<#assign showChildren = (displayDepth != 1) && navItem.hasBrowsableChildren() />

			<#if navItem.isBrowsable() || showChildren>
				<#assign
					nav_item_caret = ""
					nav_item_css_class = ""
					nav_item_href_link = ""
				/>

				<#if navItem.isSelected()>
					<#assign nav_item_css_class = "active" />
				</#if>
				<#assign indicatorIdItem = stringUtil.randomString() /> 
				<#if showChildren>
					<#assign toggle_text>
						<@liferay.language key="toggle" />
					</#assign>

					<#assign nav_item_caret = "<button class='btn' type='button' data-toggle='collapse' data-target='#collapse_${indicatorIdItem}' aria-expanded='false' aria-controls='collapse_${indicatorIdItem}'>
				  	<i class='icon-angle-down'></i><span class='sr-only'>${toggle_text}</span>
    			</button>" />
				</#if>

				<#if navItem.isBrowsable()>
					<#assign nav_item_href_link = "href='${navItem.getURL()}' ${navItem.getTarget()}" />
				</#if>


				<li>
					<div id="heading_${indicatorIdItem}">
					${nav_item_caret}<a aria-labelledby="layout_${portletDisplay.getId()}_${navItem.getLayoutId()}" class="${nav_item_css_class}" ${nav_item_href_link}><span>${navItem.getName()}</span></a>
					</div>

					<#if showChildren>
						<ul id="collapse_${indicatorIdItem}" class="collapse" aria-labelledby="heading_${indicatorIdItem}" data-parent="#header__menu-mobile__nav__accordion_${indicatorId}" role="menu">
							<#list navItem.getBrowsableChildren() as childNavigationItem>
								<#assign
									nav_child_css_class = ""
								/>

								<#if childNavigationItem.isSelected()>
									<#assign
										nav_child_css_class = "active"
									/>
								</#if>

								<li class="${nav_child_css_class}" id="layout_${portletDisplay.getId()}_${childNavigationItem.getLayoutId()}" role="presentation">
									<a aria-labelledby="layout_${portletDisplay.getId()}_${childNavigationItem.getLayoutId()}" href="${childNavigationItem.getURL()}" ${childNavigationItem.getTarget()} role="menuitem">${childNavigationItem.getName()}</a>
								</li>
							</#list>
						</ul>
					</#if>
				</li>
			</#if>
		</#list>
	</ul>
</#if>
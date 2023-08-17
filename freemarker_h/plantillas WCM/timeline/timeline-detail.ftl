<#--
Nombre contenido (ES): Timeline
Estructura: global > timeline.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/timeline
Nota: Solo se usa con global-theme
-->

<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
	<article id="timeline" class="timeline-detail timeline-container">
	    <#assign titulo = ehutimelinetitle.getData() >
	    <#if titulo != "" >
	        <h1 class="timeline-detail__title">${ titulo }</h1>
	    </#if>
	
	    <#assign descr = ehutimelinedescription.getData() >
	    <#if descr != "" >
	        <div class="timeline-detail__description">${ descr }</div>
	    </#if>
	  
	
	  
	    <#assign txtExtend = languageUtil.get( locale, "ehu.extend-deploy" ) >
	    <#assign txtClose = languageUtil.get( locale, "ehu.shrink-close" ) >
	    <button class="timeline-toggle">${ txtExtend }</button>
	
	    <#if ehutimelineyear.getSiblings()?has_content >
	        <#list ehutimelineyear.getSiblings() as entActualYear >
	            <div class="timeline-wrapper">
	                <h2 tabindex="0" class="timeline-time">${ entActualYear.getData() }</h2>
	                <#if entActualYear.ehutimelineitemtitle.getSiblings()?has_content >
	                    <div class="timeline-series">
	                        <#list entActualYear.ehutimelineitemtitle.getSiblings() as entItemTitle >
	                            <#assign idTitleYear = "${ entItemTitle?index }_${ entActualYear?index }" >
	                            <dl>
	                                <#assign keepOpen = getterUtil.getBoolean( entItemTitle.ehutimelinekeepopenonstart.getData() ) >
	                                <#assign classDt = "timeline-event" >
	                                <#assign classDtA = "closed" >
	                                <#if keepOpen >
	                                    <#assign classDt = classDt + " start-open" >
	                                    <#assign classDtA = "" >
	                                </#if>
	
	                                <dt id="time${ idTitleYear }" class="${ classDt }">
	                                    <a tabindex="0" class="${ classDtA }">
	                                        <#if entItemTitle.ehutimelinehighlight?? && getterUtil.getBoolean(entItemTitle.ehutimelinehighlight.getData())>
	                                            <span class="timeline-event-content-flex">    
	                                            	<span class="timeline-event__destacado">
	                                                    <span class="hide-accesible">
	                                                       <@liferay.language key="ehu.timeline.item-destacado" />
	                                                    </span>
	                                            	</span>
	                                                <span class="timeline-event__title">	
	                                            	    ${ entItemTitle.getData() }
	                                                </span>
	                                            </span>
	                                        <#else>
	                                        <span class="timeline-event__title">${ entItemTitle.getData() }</span>
	                                        </#if>   
	                                        
	                                        <#if entItemTitle.ehutimelinethumbnailimage?? >
	                                            <#assign thumbnailImage = entItemTitle.ehutimelinethumbnailimage.getData() >
	                                            <#if thumbnailImage != "" >
	                                           
	                                            <span class="timeline-event__title-picture visibility-transition" style="display:none;">
	                   
	                                            
	                                                <span class="timeline-event__title-picture__line"><span></span></span>
	                                                <span class="timeline-event__title-picture__image">
	                                                    <img src="${ thumbnailImage }"
	                                                     alt="${ entItemTitle.ehutimelinethumbnailimage.ehutimelinethumbnailalt.getData() }"/>
	                                                     </span>
	                                            </span>
	                                            </#if>
	                                        </#if>
	                                    
	                                    </a>
	                                </dt>
	
	                                <dd id="time${ idTitleYear }EX" class="timeline-event-content">
	                                
	                                    <#assign itemText = entItemTitle.ehutimelinetext.getData() >
	                                    <#if  itemText != "" >
	                                        <div class="timeline-text-section">${ itemText }</div>
	                                    </#if>
	
	                                    <#assign entItemImage = entItemTitle.ehutimelineimage >
	                                    <#assign arrItemImage = entItemImage.getSiblings() >
	                                    <#if arrItemImage?has_content >
	                                        <div class="images-section">
	                                            <#assign activeClass = "active" >
	                                            <#if arrItemImage?size gt 1 >
	                                                <div id="carousel${ idTitleYear }" class="carousel slide">
	                                                    <input type="hidden" class="showing-image" value="<@liferay.language key="showing" /> <@liferay.language key="image" />" />
	                                                    <ol class="carousel-indicators">
	                                                        <#assign activeSlide = "active" >
	                                                        <#list arrItemImage as elemItemImage >
	                                                            <#if elemItemImage.getData()?has_content >
	                                                                <li tabindex="0" data-target="#carousel${ idTitleYear }"
	                                                                    data-slide-to="${ elemItemImage?index }" data-item="item-${ elemItemImage?index }" class="${ activeSlide }">
	                                                                    <span><span class="img-showing"></span>${elemItemImage.ehutimelineimagealt.getData()}</span>
	                                                                </li>
	                                                                <#assign activeSlide="" />
	                                                            </#if>
	                                                        </#list>
	                                                    </ol>
	                                                    <div class="carousel-inner">
	                                                        <#list arrItemImage as elemItemImage >
	                                                            <#assign itemImage = elemItemImage.getData() >
	                                                            <#if itemImage != "" >
	                                                                <div data-item="item-${ elemItemImage?index + 1 }"
	                                                                    class="item-${ elemItemImage?index + 1 } carousel-item ${ activeClass}">
	                                                                    <span class="container_image">
	                                                                        <img tabindex="0" src="${ itemImage }" alt="${ elemItemImage.ehutimelineimagealt.getData() }"/>
	                                                                        <span tabindex="0" class="image-gallery-ico">
	                                                                            <span class="gallery-text"><@liferay.language key="centros.accesibilidad.galeria.imagenes" /></span>
	                                                                        </span>
	                                                                    </span>
	                                                                    <p>${ elemItemImage.ehutimelinecaption.getData() }</p>
	                                                                    <a href="${ itemImage }" download>
	                                                                        <span class="hide">
	                                                                            <#if elemItemImage.ehutimelineimagealt.getData()?has_content>
	                                                                                ${elemItemImage.ehutimelineimagealt.getData()}
	                                                                            <#else>
	                                                                                Image
	                                                                            </#if>
	                                                                        </span> 
	                                                                    </a>
	                                                                </div>
	                                                                <#assign activeClass = "" >
	                                                            </#if>
	                                                        </#list>
	                                                    </div>
	                                                </div>
	                                            <#else>
	                                                <#assign itemImage = entItemImage.getData() >
	                                                <#if itemImage != "" >
	                                                    <div class="image-item">
	                                                        <div class="imagen-item__container">
	                                                            <span class="container_image">
	                                                                <img tabindex="0" src="${ itemImage }" alt="${ entItemImage.ehutimelineimagealt.getData() }"/>
	                                                                <span tabindex="0" class="image-gallery-ico">
	                                                                    <span class="gallery-text"><@liferay.language key="centros.accesibilidad.galeria.imagenes" /></span>
	                                                                </span> 
	                                                            </span>
	                                                            <p>${ entItemImage.ehutimelinecaption.getData() }</p>
	                                                        </div>
	                                                    </div>
	                                                </#if>
	                                            </#if>
	                                        </div>
	                                    </#if>
	                                    
	                                    <#if entItemTitle.ehutimelinevideo?? >
	                                        <#assign itemVideo = entItemTitle.ehutimelinevideo.getData() >
	                                        <#if itemVideo != "" >
	                                            <#assign iframeTitle = languageUtil.get( locale, "video" ) >
	                                            <div class="video-center-content">
	                                                <div class="col-12 col-md-12 feature_article-video p-0">
	                                                    <iframe title="${ iframeTitle }" src="${ itemVideo }" allowfullscreen="">
	                                                    </iframe>
	                                                </div>
	                                            </div>
	                                        </#if>
	                                    </#if>
	
	                                    <#if entItemTitle.ehutimelineaudio?? >
	                                        <#assign itemAudio = entItemTitle.ehutimelineaudio.getData() >
	                                        <#if itemAudio != "" >
	                                            <div class="feature_article-audio">
	                                                <audio controls>
	                                                    <source src="${ itemAudio }" type="audio/mpeg">
	                                                    <#-- <@liferay.language key="ehu.browser-not-support-audio-element" /> -->
	                                                    <#-- Your browser does not support the audio element. -->
	                                                </audio>
	                                            </div>
	                                        </#if>
	                                    </#if>
	
	                                    <#if entItemTitle.ehutimelinelink?? >
	                                        <#assign entItemLink = entItemTitle.ehutimelinelink >
	                                        <#assign hayLink = getterUtil.getBoolean("false")>				
	                                        <#assign hayLink = upvlibs.hasElement(entItemLink) >
	                                        <#if hayLink >
	                                            <@upvlibs.writeHtmlForLinks entradaInfo=entItemLink nomEntradaTit="ehutimelinelinktext"
	                                                nomEntradaVal="" nivelHIni=2 nomEntrNewTab="ehutimelinelinknewtab" newTab=true />
	                                        </#if>
	                                    </#if>
	                                </dd>
	                            </dl>
	                        </#list>
	                    </div>
	                </#if>
	            </div>
	        </#list>
	    </#if>
	    <div class="last-item-timeline"></div>
	    <button class="timeline-toggle">${ txtExtend }</button>
	</article>
	
	<script type="text/javascript" src="/o/upv-ehu-global-theme/js/timeliner.js"></script>
	
	<script type="text/javascript">
	    $(document).ready(function () {
	        setTimeout(function(){
	            $(".timeline-event__title-picture").show();
	            
	        }, 100);
	       
	
	        $.timeliner({
	            timelineContainer: '#timeline',
	            timelineSectionMarker: '.timeline-wrapper',
	            timelineSectionMarker: '.timeline-time',
	            oneOpen: false,
	            expandAllText: '<strong>+</strong> ${ txtExtend }',
	            collapseAllText: '<strong>-</strong> ${ txtClose }'
	        });
	
	        $("#timeline .images-section .image-item").click(function () {
	
	            var element = $(this).parent();
	            element = element.html();
	            var texto = $(this).find(".imagen-item__container p").text();
	            var imageUrl = $(this).find("img").attr("src");
	            var imageTitle = $(this).find("img").attr("alt");
	
	            $( "<div class='image-viewer-base image-viewer image-viewer-timeline only-one-image'>" +
	                    "<div class='navigation-controller'>" +
	                        "<div class='download-item'>" +
	                            "<a tabindex='0' title='<@liferay.language key="download" /> <@liferay.language key="image" /> : "+imageTitle+"' href='" + imageUrl + "' download><span class='hide'><@liferay.language key="download" /> <@liferay.language key="image" /></span></a>" +
	                        "</div>" +
	                    "</div>" +
	                    "<div class='image-viewer-timeline-content'>" +
	                        "<div class='iv-timeline-carousel'>" + element + "</div>" +
	                        "<p class='iv-timeline-carousel-title image-viewer-caption'>" + texto + "</p>" +
	                        "<p class='image-viewer-info' style='user-select: text;''>Image " +
	                            "<span class='actual'>1</span> of <span id='total'>1</span>" +
	                        "</p>" +
	                        "<div class='iv-timeline-navigator'>" + element + "</div>" +
	                    "</div>" +
	                    "<div tabindex='0' class='close-popup'>"+
	                        "<span><@liferay.language key="centros.accesibilidad.cerrar.galeria.imagenes" /></span>"+
	                    "</div>"+
	                "</div>" ).appendTo( "body" );
	
	            $("body").addClass("timeline-popup");
	            setTimeout(function(){$(".image-viewer-base .download-item a").focus(); }, 100);
	            $(this).addClass("accesible-position");
	
	        });
	
	        $("#timeline .carousel-inner").click(function () {
	
	            var element = $(this);
	            var totalElements = element.find(".carousel-item").length;
	            var actualElement = element.find(".active").data("item");
	            actualElement = actualElement.replace("item-", "");
	            element = element.html();
	            var texto = $(this).find(".active p").text();
	            var imageUrl = $(this).find(".active img").attr("src");
	            var imageTitle = $(this).find(".active img").attr("alt");
	
	            $( "<div class='image-viewer-base image-viewer image-viewer-timeline'>" +
	                    "<div class='navigation-controller'>" +
	                        "<div class='download-item'>" +
	                            "<a tabindex='0' title='<@liferay.language key="download" /> <@liferay.language key="image" /> : "+imageTitle+"' href='" + imageUrl + "' download> <span class='hide'><@liferay.language key="download" /> <@liferay.language key="image" /></span> </a>" +
	                        "</div>" +
	                    "</div>" +
	                    "<div class='image-viewer-timeline-content'>" +
	                        "<div class='iv-timeline-carousel'>" +
	                            "<div tabindex='0' class='arrow-prev'><span><@liferay.language key="centros.accesibilidad.anterior.galeria.imagenes" /></span></div>" +
	                            "<div tabindex='0' class='arrow-next'><span><@liferay.language key="centros.accesibilidad.siguiente.galeria.imagenes" /></span></div>" + element +
	                        "</div>" +
	                        "<div class='content-carousel-flex'>"+
	                            "<p class='iv-timeline-carousel-title image-viewer-caption'>" + texto + "</p>" +
	                            "<p class='image-viewer-info' style='user-select: text;''>Image <span class='actual'>" +
	                            actualElement + "</span> of <span id='total'>" + totalElements + "</span>" +
	                                "<span tabindex='0' class='glyphicon glyphicon-pause' style='display:none'><span><@liferay.language key="centros.accesibilidad.detener.galeria.imagenes" /></span></span>" +
	                                "<span tabindex='0' class='glyphicon glyphicon-play'><span><@liferay.language key="centros.accesibilidad.continuar.galeria.imagenes" /></span></span>" +
	                            "</p>" +
	                            "<div class='iv-timeline-navigator'>" + element + "</div>" +
	                        "</div>"+
	                    "</div>" +
	                    "<div tabindex='0' class='close-popup'>"+
	                        "<span><@liferay.language key="centros.accesibilidad.cerrar.galeria.imagenes" /></span>"+
	                    "</div>"+
	                "</div>" ).appendTo( "body" );
	
	            $("body").addClass("timeline-popup");
	            setTimeout(function(){$(".image-viewer-base .download-item a").focus(); }, 100);
	            $(this).addClass("accesible-position");
	
	        });
	    });
	
	</script>
	<script type="text/javascript" src="/o/upv-ehu-global-theme/js/timeliner-main.js"></script>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

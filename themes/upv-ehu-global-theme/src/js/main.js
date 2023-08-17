/* 
 * UPV/EHU - Menu lateral izquierdo
 * 	Para des/plegarlo al pulsar sobre el icono de des/plegar
 *  Para mantener desplegada la opción que tenga una pagina hija seleccionada  
 */  
 
AUI().use(
		'anim',
		'transition',
		function(A) {
			
			var toggleClass = function(event) {
				event.stopPropagation();

				var currentTargetNode = event.currentTarget;

				var baseClassName = 'class-toggle-';

				var targetClass = currentTargetNode.attr('data-target-class');
				
				if (targetClass) {
					var className = baseClassName + targetClass;						
				}
				else {
					var className = baseClassName + 'active';					
				}

				var nodes = currentTargetNode.attr('data-target-node');

				if (nodes) {
					nodes = A.all(nodes);
				}
				else {
					nodes = A.NodeList.create();

					nodes.push(currentTargetNode);
				}

				nodes.each(
					function(node) {
						node.toggleClass(className);
						
						// Al clickar el icono para plegar/desplegar paginas hijos, varia su los estilos del icono asociado  
						if (node.hasClass("has-sub-nav")){
							var nodeChildren = node.attr('children');
							nodeChildren.each(
								function(nodeChild) {
									if (nodeChild.hasClass("children-marker")){
										if (nodeChild.hasClass("icon-chevron-down")){
											nodeChild.replaceClass("icon-chevron-down","icon-chevron-up");
										} else {
											nodeChild.replaceClass("icon-chevron-up","icon-chevron-down");
										}										
									} 
								}		
							);
						}

						if (!currentTargetNode.hasAttribute('data-transition-property')) {
							return;
						}

						var transitionProperty = currentTargetNode.getAttribute('data-transition-property');

						var transitionDuration = parseInt(currentTargetNode.getAttribute('data-transition-duration'));

						if (!transitionDuration) {
							transitionDuration = 0.5;
						}

						var transitionStart = currentTargetNode.getAttribute('data-transition-start');

						if (!transitionStart) {
							var transitionStart = 0;
						}

						var transitionEnd = currentTargetNode.getAttribute('data-transition-end');

						if (!transitionEnd) {
							transitionEnd = parseInt(node.one('.' + baseClassName + 'content').get('clientHeight'));
						}

						var config = [];

						if (node.hasClass(className)) {
							config[transitionProperty] = transitionEnd;
						}
						else {
							config[transitionProperty] = transitionStart;
						}

						config["duration"] = transitionDuration;

						node.transition(config);

						node.setStyle(transitionProperty, config[transitionProperty]);
					}
				);
			};

			A.all('.class-toggle').on('click', toggleClass);
			A.all('.class-toggle').on('keypress', toggleClass);			
		}
	);

/*-- UPV/EHU --*/

AUI().ready(
		
	/*
	This function gets loaded when all the HTML, not including the portlets, is
	loaded.
	*/	
		
	'aui-carousel', 'liferay-navigation-interaction', 'aui-toggler',
	function(A) {
		
		/*---------------*/
		/*-- Carrusel  --*/
		/*---------------*/
		/*-- Si existe el carrusel, el primer nodo del menu del carrusel es siempre el nodo de Play/Pause,
		 * el cual cambia de icono asociado al pulsar sobre él teniendo en cuenta el estado anterior 
		 */
		
		var carousel = A.one('#carousel');
		
		if (carousel) {
		
			var menuItems = A.all("#carousel menu li a");
			var playPauseItem = menuItems.first(); 
			
			playPauseItem.on(
					'click',
					function(event){
						if (playPauseItem.hasClass("carousel-menu-play")){
							playPauseItem.replaceClass("icon-play","icon-pause");						
						} else {
							playPauseItem.replaceClass("icon-pause","icon-play");
						}					
					}
			);		
		}	
		
		/*--------------------*/
		/*-- Menu Principal --*/
		/*--------------------*/
		
		/*-- Si existe menu principal se carga el scrit liferay-navigation-interaction.js asociado al mismo, 
		 * lo cual posibilita la navegacion por teclado de dicho menu --*/ 
		/*var mainMenu = A.one('html:not(.mobile) #main-menu');
		
		if (mainMenu) {
			mainMenu.plug(Liferay.NavigationInteraction);			
		} */
		
		/*----------------------------------------------------------*/
		/*-- Menu superior (Sign-in, Language, Search, Sitemap) --*/
		/*----------------------------------------------------------*/
		
		/*-- Si existe menu superior se carga el scrit liferay-navigation-interaction.js asociado al mismo, 
		 * lo cual posibilita la navegacion por teclado de dicho menu--*/ 
		/*var topMenu = A.one('html:not(.mobile) #top-menu');
		
		if (topMenu) {
			topMenu.plug(Liferay.NavigationInteraction);			
		} */
		
		/*-------------------------------*/
		/*-- Menu Responsive Principal --*/
		/*-------------------------------*/
		
		/*-- Al clickar el boton del menu responsivo se pliega/despliega el menu responsivo si existe --*/
		var menuResponsive = A.one('#menu-responsive');
		var btnResponsive = A.one('#btn-responsive');
		if ((menuResponsive) && (btnResponsive)) {
			btnResponsive.on(
					'click', 
					function(event){
						btnResponsive.toggleClass('open');
						menuResponsive.toggleClass('open');						
					}
			);
		}
		
		/*--------------------------------*/
		/*-- Menu Responsive del sitio  --*/
		/*--------------------------------*/
		
		/*-- Al clickar el boton (#side-btn) del menu de navegacion del sitio en responsivo (por defecto plegado class="icon-chevron-down"),
		 *  se muestra/oculta el menu de navegacion del sitio (#side-menu)  --*/
		var menuSite = A.one('#side-menu');
		var btnSite = A.one('#side-menu #side-btn');
		var iconSite = A.one('#side-menu #side-btn #icon-chevron');
		if ((menuSite) && (btnSite) && (iconSite)) {
			btnSite.on(
				'click',
				function(event){
					btnSite.toggleClass('class-toggle-active');
					menuSite.toggleClass('open');
					A.one("body").toggleClass("menu-opened");
					if (iconSite.hasClass("icon-chevron-down")){
						iconSite.replaceClass("icon-chevron-down","icon-chevron-up");						
					} else {
						iconSite.replaceClass("icon-chevron-up","icon-chevron-down");						
					}					
				}
			);
		}	
		
		/*--------------------------------*/
		/*--  TogglerAui: Acordeon   --*/
		/*--------------------------------*/
	
		if(document.getElementById("myToggler") != null){
			
			new A.TogglerDelegate({
		        animated: true,
		        closeAllOnExpand: true,
		        container: '#myToggler',
		        content: '.content',
		        expanded: false,
		        header: '.header',
		        transition: {
		        	duration: 0.2,
		        	easing: 'cubic-bezier(0, 0.1, 0, 1)'
		        }
			});
			
		}
		
		/*-- Hay que usar el marcado de manera que facilite la accesibilidad y en elementos no estándar de HTML 
		 * (acordeones, ventanas modales, carruseles, desplegables…) hay que usar WAI-ARIA.  --*/
		var menuItems = document.querySelectorAll("#myToggler .header.toggler-header");
		for (i = 0; i < menuItems.length; i++) {
			menuItems[i].addEventListener("click",
				function(event){
					for (j = 0; j < menuItems.length; j++) {
						menuItems[j].removeAttribute('aria-disabled');
						menuItems[j].setAttribute("aria-expanded","false");
					}
					if (this.classList.contains("toggler-header-collapsed")){
						this.setAttribute("aria-disabled","true");
						this.setAttribute("aria-expanded","true");
					}
				}
			);
		}
	}
);

Liferay.Portlet.ready(

	/*
	This function gets loaded after each and every portlet on the page.

	portletId: the current portlet's id
	node: the Alloy Node object of the current portlet
	*/

	function(portletId, node) {
	}
);

Liferay.on(
	'allPortletsReady',

	/*
	This function gets loaded when everything, including the portlets, is on
	the page.
	*/

	function() {
		
		//		Para grados y doctorados en los nuevos colapsables
		/*-- Hay que usar el marcado de manera que facilite la accesibilidad y en elementos no estándar de HTML 
		 * (acordeones, ventanas modales, carruseles, desplegables…) hay que usar WAI-ARIA.  --*/
		if(document.getElementsByTagName("body")[0].classList.contains("red-color-scheme")) {
			var newAcordeonMenuItems = document.querySelectorAll(".new-upv-acordeon .accordion-toggle");
			for (i = 0; i < newAcordeonMenuItems.length; i++) {
				newAcordeonMenuItems[i].addEventListener("click",
					function(event){
						if (this.classList.contains("collapsed")){
							this.setAttribute("aria-disabled","true");
							this.setAttribute("aria-expanded","true");
						} else {
							this.removeAttribute('aria-disabled');
							this.setAttribute("aria-expanded","false");
						}
					}
				);
			}
		}
		
		if(document.getElementsByTagName("body")[0].classList.contains("masters")) {
			$( ".first-level.vermas" ).next().wrapAll( "<div class='auxiliar' />");
			$( ".level2.vermas" ).first().next().wrapAll( "<div class='auxiliar' />");
			$( ".level2.vermas" ).last().next().wrapAll( "<div class='auxiliar' />");
			$( ".vermas" ).click(function() {
			    if($(this).next().children().hasClass("show")){
					$(this).next().slideUp();
				}
				else {
					$(this).next().slideDown();
				}
			});
		}

		if(document.getElementsByTagName("body")[0].classList.contains("centers2")) {
			$( "#side-menu" ).click(function() {
			    if($(this).hasClass("open")){
					$("#column-1 .list-group.list-group-flush").css({
						display: 'inline-flex'					
					});
					$("#column-1 #side-menu + .portlet-column-content").css({
						display: 'block'					
					});
					$("#column-1 .menu-lateral-logos").css({
						display: 'block'					
					});
				}
				else {
					$("#column-1 .list-group.list-group-flush").css({
						display: 'none'					
					});
					$("#column-1 #side-menu + .portlet-column-content").css({
						display: 'none'					
					});
					$("#column-1 .menu-lateral-logos").css({
						display: 'none'					
					});
				}
			});

			$( ".yui3-widget-mask" ).bind("DOMSubtreeModified",function() {
				if ($(this).hasClass('hide')) {
				  	$("body").removeClass("image-gallery");
				}
				else {
					$("body").addClass("image-gallery");
				}
			});

			$( document ).on( 'keydown', function ( e ) {
    			if ( e.keyCode === 27 ) {
			        $(".dropdown.open a:focus").removeClass("open");
			        $("a:focus .hide-accessible").css({
			       		display: 'none'
			        });
			        $("a:hover .hide-accessible").css({
			       		display: 'none'
			        });
				}
			});

			$(".portlet-search button.btn").focus(function(){
			    $("li.dropdown.language > a").attr("tabindex","0");
			});

			$("a").bind("focus blur",function() {
			    $(this).children(".hide-accessible").css({display: 'block'});
			});

			$("a").mouseout(function() {
			    $(this).children(".hide-accessible").css({display: 'block'});
			});

			$("a").bind("DOMSubtreeModified",function() {
			    if ($(this).is("#top-menu li a") && $(this).hasClass('active')) {
			        $(this).removeClass('active');
			    }
			});

			$("a:hover").bind("change",function() {
				$(this).children(".hide-accessible").css({display: 'block'});
			});

			$(".dropdown.language > a").change(function() {
				$(this).attr({tabindex: '0'});
			});

			/* */

			$("li.sign-in a").change(function() {
				$(this).attr({tabindex: '0'});
			});

			$(".btn-home").change(function() {
				$(this).attr({tabindex: '0'});
			});

			$('li.sign-in a').on('classChange', function() {
			    $(this).removeClass('active');
			});

			$('.btn-home').on('classChange', function() {
			    $(this).removeClass('active');
			});

			$('li.dropdown.language a').on('classChange', function() {
			    $(this).removeClass('active');
			});

			
			$(".btn-home").attr({
				tabindex: '0'
			});
			$("li.sign-in a").attr({
				tabindex: '0'
			});
			$("li.dropdown.language > a").attr({
				tabindex: '0'
			});
			
			// $("li.sign-in a").bind("DOMSubtreeModified",function() {
			// 	$(this).attr({
			// 		tabindex: '0'
			// 	});
			// });

			$(".centers2 .top-menu-search .input-container button, .centers2 .top-menu-search .search-input").focus(function() {
				$("#top-menu").addClass('opened-search-bar');
			});

			$(".centers2 .top-menu-search .input-container button, .centers2 .top-menu-search .search-input").focusout(function() {
				$("#top-menu").removeClass('opened-search-bar');
			});

			$(".yui3-calendar-day").click(function() {
				$("body").addClass("calendar-modal");
				// console.log(".");
			});

			$('body').on('DOMSubtreeModified', '.yui3-widget-mask', function(){
		        if ($("body").hasClass("calendar-modal")) {
		            $("body").css("overflow", "auto");
		        }
		    });
		}

		//$(".ddm-radio .custom-control-input").click(function() {
		//   $(this).addClass("input-checked");
		//    setTimeout(function(){
		//    	$(".input-checked").prop("checked", true);
		//    	$(".input-checked").removeClass("input-checked")
		//    }, 50);
		//});
		
		//Nuevo acordeon
		var acc = document.getElementsByClassName("own-accordion");
		
		for (var i = 0; i < acc.length; i++) {
		  acc[i].addEventListener("click", function() {
		    this.classList.toggle("active");
		    var panel = $(this).parent().next()[0];
		    if (panel.style.maxHeight) {
		      panel.style.maxHeight = null;
		    } else {
		      panel.style.maxHeight = panel.scrollHeight + "px";
		    } 
		  });
		}		
	}
);

$(document).ready(function() {

	mobileMenuLateral();
	accessibility();

	$("body").on("click", ".yui3-calendar-pane table tbody tr td.evento a", function(){
		$(this).closest('.column-right-calendar').find('.listadoCal > ul > li:first-child a').focus();
	});

	$('.filterCal .form-check input').change(function() {
        $('.tbodyAux a:first-child').focus();        
    });
});

$( document ).ready(function() {
    $(".yui3-widget-mask").one("DOMSubtreeModified",function() {
		if ($(this).hasClass('hide')) {
		  	$("body").removeClass("image-gallery");
		}
		else {
			$("body").addClass("image-gallery");
		}
	});
});


$(document).ready(function() {
	
    $(".image-gallery-carousel .carousel-inner").on("click", function(){
        changeOverflow();
    });
    $(".image-gallery .image-thumbnail").on("click", function(){
        changeOverflow();
    });
    function changeOverflow(){
        $("body").css("overflow", "hidden");
         $("button.close.image-viewer-base-control.image-viewer-close").on("click", function(){
             $("body").css("overflow", "auto");
        });
    }
});
	
$('.featured_article-image .owl-carousel').owlCarousel({
    loop:false,
	nav:false,
	items:1,
	dots:false,
	autoplay:true,
	autoplayTimeout: 6000
})


function mobileMenuLateral(){

	/*$(".mobile_open_menu").click(function(){

		if($(this).closest("#side-menu").hasClass("open")){
		    $("body").removeClass("menu-opened");
		    $(this).closest("#side-menu").removeClass("open");
		}else{
		    $(this).closest("#side-menu").addClass("open");
		    $("body").addClass("menu-opened");
		}

	});*/
}

function accessibility(){

	//Liferay search btn text
	if($("form#_com_liferay_portal_search_web_portlet_SearchPortlet_fm").length>0){
		var getName=$("form#_com_liferay_portal_search_web_portlet_SearchPortlet_fm .input-container > legend").html();
		$("form#_com_liferay_portal_search_web_portlet_SearchPortlet_fm button.btn.btn-light.btn-unstyled").append('<span class="sr-only">'+getName+'</span>');
	}
	//Liferay input hide
	if($("#hrefFm input").length>0) {
		$("#hrefFm input").val("hide accesible");
	}
	//owl dotted accesibility
	if($(".owl-carousel").length>0) {
		var cont=0;
		$(".owl-carousel .owl-dots button").each(function(){
		    $(this).find("span").html(""+cont);
		    cont++;
		});
	}

	if($("button.close.image-viewer-base-control.image-viewer-close.hide").length>0) {
		$('<span class="sr-only">close</span>').appendTo($("button.close.image-viewer-base-control.image-viewer-close.hide"));
	}

	if($("a.carousel-control.right.image-viewer-base-control.image-viewer-base-control-right").length>0) {
		$('<span class="sr-only">right</span>').appendTo($("a.carousel-control.right.image-viewer-base-control.image-viewer-base-control-right"));
	}

	if($("a.carousel-control.left.image-viewer-base-control.image-viewer-base-control-left").length>0) {
	   $('<span class="sr-only">left</span>').appendTo($("a.carousel-control.left.image-viewer-base-control.image-viewer-base-control-left"));
	}

	if($("section#portlet_com_liferay_portal_search_web_portlet_SearchPortlet .form-group.form-group-inline.input-text-wrapper").length>0){

		var getTitle=$("#_com_liferay_portal_search_web_portlet_SearchPortlet_keywords").attr("title");
		$("<a style='display:none' role='button' href='javascript:void(0)' class='search-find' tabindex='0'><p class='sr-only'>"+getTitle+"</p></a><span style='display:none' class='search-find-close'></span><div class='search-out' tabindex='0'></div>").appendTo("section#portlet_com_liferay_portal_search_web_portlet_SearchPortlet .form-group.form-group-inline.input-text-wrapper");

		$(".search-find").on("click",function(){
			if( $("#_com_liferay_portal_search_web_portlet_SearchPortlet_keywords").val().length>0){
				$("form#_com_liferay_portal_search_web_portlet_SearchPortlet_fm .lfr-ddm-field-group.lfr-ddm-field-group-inline.field-wrapper button").trigger("click");
			}
		});	

		$("span.search-find-close").on("click",function(){
		    $(this).closest("form").removeClass("focusin");
		});
	}
	
	$("button.btn.btn-light.btn-unstyled").focus(function(){
	    $(this).closest("form").addClass("focusin");
		setTimeout(function(){ $("input#_com_liferay_portal_search_web_portlet_SearchPortlet_keywords").focus();}, 100);
	});

	$(".nav-link,li.dropdown.language a").focus(function(){
	    $(".focusin").removeClass("focusin");
	});


	$(".header__top-menu__sign-in > a").focus(function(){
		$(".focusin").removeClass("focusin");
	});

	$(".search-out").focus(function(){
	    $(".focusin").removeClass("focusin");
	    $("li.dropdown.language > a").focus();
	});
}

	/* Hamburguer icon */

$(document).ready(function(){

	$('.hamburguer-icon').on('click', function () {

		$('.hamburguer-icon-animated').toggleClass('open');
	});

});
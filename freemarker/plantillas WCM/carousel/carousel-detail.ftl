<#assign zero = getterUtil.getInteger("0")>
<#assign slide_index = zero>
<#-- Si existe al menos una diapositiva en el carrusel-->
<#if ehucarouselslide.getSiblings()[zero].getData()?has_content >
    <div id="carousel2" class="owl-carousel owl-theme animated">
        <#-- Por cada diapositiva -->
        <#list ehucarouselslide.getSiblings() as slide >
            <#assign slide_image = htmlUtil.escape(slide.getData())>
            <#assign slide_header = slide.ehucarouselslideheader.getData()>
            <#assign slide_url = slide.ehucarouselslideurl.getData()>
            <#-- La imagen, su cabecera y  enlace asociados son obligatorios (existen y no son nulos) -->
            <#if slide_image?has_content && slide_header?has_content && slide_url?has_content >
                <#assign slide_text = slide.ehucarouselslidetext.getData()>
                <div class="aui-carousel-item aui-carousel-item-${slide_index} item">
                    <figure>
                        <img alt=" " src="${slide_image}">
                            <figcaption>
                                    <div class="container title-text">
                                        <div class="row">
                                            <div class="blank span2"></div>
                                            <div class="controller-back"></div>
                                            <div class="blank title span2">
                                                <a href="${slide_url}">
                                                    <h1 class="slide-title super">${slide_header}</h1>
                                                <#if slide_text?has_content >
                                                    <div class="subtitle span2">
                                                        <h2>${slide_text}</h2>
                                                    </div>
                                                <#else>
                                                    <div class="subtitle span2">
                                                    </div>
                                                </#if>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </figcaption>
                            </figure>
                        </div>
                </#if>
                <#assign slide_index = slide_index + 1>
        </#list>
        </div>
</#if>
<script>
var $owl=$('.owl-carousel').owlCarousel({
    autoplay:true,
    autoplayTimeout:4000,
    loop:true,
    margin:0,
    nav:true,
    items:1,
    tanimateIn: 'fadeIn', // add this
  animateOut: 'fadeOut' // and this
})
setTimeout(function(){ $owl.trigger('refresh.owl.carousel'); }, 500);


$(".owl-nav").prepend("<div class='pausevideo' tabindex='1'><span class='hide-accessible'>${languageUtil.get(locale,'pause')}</span><div class='carousel-menu-item icon-play carousel-menu-play'><span class='hide-accessible'>${languageUtil.get(locale,'play')}</span></div><div class='carousel-menu-item icon-pause carousel-menu-pause'></div></div>");
$(".owl-prev").prepend("<span class='hide-accessible'>${languageUtil.get(locale,'previous')}</span>");
$(".owl-next").prepend("<span class='hide-accessible'>${languageUtil.get(locale,'previous')}</span>");
$(".owl-nav").append("<span class='controller1' tabindex='1'></span>");
$(".owl-nav").prepend("<span class='controller0' tabindex='0'></span>");

$(".owl-nav button").attr("tabindex","1");

$('.carousel-menu-pause').on('click', function () {
    $('.owl-carousel').trigger('stop.owl.autoplay');
    //simple one (EDIT: not enough to make it work after testing it):
    //$('.owl-carousel').trigger('changeOption.owl.carousel', { autoplay: false });
    //or more complicated (will work for one carousel only, or else use 'each'):
    //EDIT: this one seems to work
    var carousel = $('.owl-carousel').data('owl.carousel');
    carousel.settings.autoplay = false; //don't know if both are necessary
    carousel.options.autoplay = false;
    $('.owl-carousel').trigger('refresh.owl.carousel');
    $(".pausevideo").addClass("pause");
});
$('.carousel-menu-play').on('click', function () {
    $('.owl-carousel').trigger('stop.owl.autoplay');
    //simple one (EDIT: not enough to make it work after testing it):
    //$('.owl-carousel').trigger('changeOption.owl.carousel', { autoplay: false });
    //or more complicated (will work for one carousel only, or else use 'each'):
    //EDIT: this one seems to work
    var carousel = $('.owl-carousel').data('owl.carousel');
    carousel.settings.autoplay = true; //don't know if both are necessary
    carousel.options.autoplay = true;
    $('.owl-carousel').trigger('refresh.owl.carousel');
    $(".pausevideo").removeClass("pause");
});

$("body").on("keyup",".aui-carousel-item .row .title.span2",function(e){

    var elemento=$(this);

     if(e.keyCode==9 && !elemento.closest(".owl-item").hasClass("active")){
     
  
        $('.owl-carousel').trigger('refresh.owl.carousel');
        
        
        var carousel = $('.owl-carousel').data('owl.carousel');
        carousel.settings.autoplay = false; //don't know if both are necessary
        carousel.options.autoplay = false;
        $('.owl-carousel').trigger('stop.owl.autoplay');
        
        $(".active .row .title.span2 a").addClass("stop-c");
        $(".active .stop-c").focus();
    
     }
});

$("body").on("focusout",".active .stop-c",function(e){

    $(".active .row .title.span2 a.stop-c").removeClass("stop-c");
    $(".owl-nav .pausevideo").focus();
});

$("body").on("focusin",".controller1",function(e){
    
    if($(".controller2").length==0){
        $(".section.section-gray a").parent().prepend("<span class='controller2' tabindex='0'></span>");
    }

    $(".section.section-gray a").focus();
   
   
});

$("body").on("focusin",".controller2",function(e){
    $(".owl-next").focus();
});

$("body").on("focusin",".controller0",function(e){
    $(".controller0").attr("tabindex","0");
    //$(".active .row .title.span2 a").focus();
    $("h1.brand a").focus();
});

$("body").on("focusin",".pausevideo",function(e){
    $(".controller0").attr("tabindex","1");
});
$("body").on("focusin",".blank.title.span2",function(e){
    $(".active .controller-back").attr("tabindex","1");
    
});

$("body").on("focusin",".controller-back",function(e){

    $(".controller-back").attr("tabindex","-1");
    //$("nav#main-menu .nav > li:first-child").focus();
    $("h1.brand a").focus();
});

</script>
<style>
a.stop-c {
    border: 2px solid #333333 !important;
    display: inline-block;
}
#content .container #carousel2 .owl-nav .pausevideo:focus {
    color: #898989;
    outline: 2px solid #3c3c3c !important;
}

.owl-nav button:focus {
    border:  2px solid #3c3c3c !important;
}
</style>
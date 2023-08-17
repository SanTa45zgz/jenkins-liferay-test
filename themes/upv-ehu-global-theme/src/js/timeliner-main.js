$(document).ready(function() {

    $("body").on("click",".iv-timeline-navigator .carousel-item",function(){

        var element=$(this);
        element.parent().find(".active").removeClass("active");
        element.addClass("active");
        var cssClass=element.data("item");
        $(".iv-timeline-carousel .active").removeClass("active");
        $(".iv-timeline-carousel ."+cssClass).addClass("active");
        var url = $(".iv-timeline-carousel ."+cssClass).find("img").attr("src");
        var alt = $(".iv-timeline-carousel ."+cssClass).find("img").attr("alt");

        $("h4.iv-timeline-carousel-title.image-viewer-caption").text($(".iv-timeline-carousel ."+cssClass+" p").text()); 
        $(".download-item a").attr("href",url);
        $(".download-item a").attr("title","Descargar image:"+alt);

    });


    $("body").on("click",".iv-timeline-carousel .arrow-next",function(){
    
        var element=$(".iv-timeline-navigator .active");
        if(element.next().length>0) {
            element.next().trigger("click");
        }else{
            $(".iv-timeline-navigator .item-1").trigger("click");
        }

    });


    $("body").on("click",".iv-timeline-carousel .arrow-prev",function(){

        var element=$(".iv-timeline-navigator .active");
        if(element.prev().length>0) {
            element.prev().trigger("click");
        }else{
            $(".iv-timeline-navigator > div:last-child").trigger("click");
        }

    });


    $("body").on("click",".close-popup",function(){

        $(".image-viewer-base.image-viewer.image-viewer-timeline").remove();
        $("body").removeClass("timeline-popup");

    });

    var intervalId;
    $("body").on("click",".image-viewer-info .glyphicon.glyphicon-play",function(){
    
        $(".image-viewer-info .glyphicon.glyphicon-play").hide();
        $(".image-viewer-info .glyphicon.glyphicon-pause").show();
        intervalId = window.setInterval(function(){
            $(".iv-timeline-carousel .arrow-next").trigger("click");
        }, 4000);

    });

    $("body").on("click",".image-viewer-info .glyphicon.glyphicon-pause",function(){
    
        clearInterval(intervalId);
        $(".image-viewer-info .glyphicon.glyphicon-play").show();
        $(".image-viewer-info .glyphicon.glyphicon-pause").hide();

    });

    $(".timeline-event a,.timeline-time").on("keydown",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
        }
    });

    $(".image-gallery-ico").click(function(){

        $(this).prev().find("img").trigger("click");

    });

    $(".image-gallery-ico,.container_image img,.download-item a").on("keydown",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
        }
    });

    $("body").on("keydown",".iv-timeline-navigator .carousel-item img,.iv-timeline-carousel .arrow-prev,.iv-timeline-carousel .arrow-next",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
            $(".accesible-position img").focus();
        }
    });

    $("body").on("keydown",".close-popup",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
            $(".accesible-position img").focus();
            $("div.accesible-position").removeClass("accesible-position");
        }
    });

    $("body").on("keydown","span.glyphicon.glyphicon-play",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
            $("span.glyphicon.glyphicon-pause").focus();
        }
    });

    $("body").on("keydown","span.glyphicon.glyphicon-pause",function( ev ) {
        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            $(this).trigger("click");
            $("span.glyphicon.glyphicon-play").focus();
        }
    });

    $("body").on("keydown",".carousel-indicators li",function( ev ) {

        var keyCode = ev.keyCode || ev.which;
        // enter
        if( keyCode === 13 ) {
            var slidePosition=$(this).data("slideTo");
            $(this).parent().find(".active").removeClass("active");
            $(this).parent().parent().find(".carousel-inner .carousel-item").removeClass("active");
            
            $(this).parent().find("li").eq(slidePosition).addClass("active");
            $(this).parent().parent().find(".carousel-inner .carousel-item").eq(slidePosition).addClass("active");
        }

    });

    function carouselArias(){
    
        $(".images-section .carousel .carousel-item,.images-section .carousel .carousel-indicators li,.iv-timeline-navigator .carousel-item").each(function(){

            var item = $(this);
            
            if(item.hasClass('active')) {
                if(item.hasClass("carousel-item")){
                    var element=$(this).data("item");
                    element=element.replace("item-","");
                    item.closest(".content-carousel-flex").find(".image-viewer-info .actual").html(element);
                }
                item.attr({ 'aria-selected': 'true' });
                if(item.parent().hasClass("carousel-indicators")){
                    if(item.find(".img-showing").html()!=$(".showing-image").val()){
                        item.find(".img-showing").html($(".showing-image").val());
                    }
                }
            }else{
                item.attr({ 'aria-selected': 'false' });
                if(item.parent().hasClass("carousel-indicators")){
                    item.find(".img-showing").html("");
                }
            }
            
        });
    
        $(".image-viewer-timeline .container_image .image-gallery-ico").attr("tabindex","-1");
    }

    carouselArias();
    setInterval(carouselArias, 500);

     
});
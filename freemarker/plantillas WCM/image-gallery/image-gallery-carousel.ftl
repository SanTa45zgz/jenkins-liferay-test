<#assign scopeId = themeDisplay.scopeGroupId>
<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#if .vars['reserved-article-id']?has_content>
	<#assign articleId = .vars['reserved-article-id'] > 
<#else>
	<#assign articleId = ""> 
</#if>
   
<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>
        <div class="image-gallery-carousel">
            <h2>${ehuimagegallerytitle.getData()}</h2>

            <@upvlibs.imageGallerySectionCarousel ehuslide articleId true 4 />
        </div>
    </#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>


<script>

$(document).ready(function(){
        
    carouselArias();
    setInterval(carouselArias, 500);
    carouselSwipe();
    
    $("body").on("keydown",".carousel-indicators li",function( ev ) {

        var keyCode = ev.keyCode || ev.which;
        if( keyCode === 13 ) {
            $(this).parent().find(".active").removeClass("active");
            $(this).addClass("active");
            $(this).parent().next().find(".carousel-item").removeClass("active");
            var pos=$(this).data("slideTo");
            $(this).parent().next().find(".carousel-item").eq(pos).addClass("active");
        }
    });

})

function carouselSwipe(){
    $("ol.carousel-indicators .active").trigger("click");
}

function carouselArias(){

    $(".carousel li").each(function(){

        var item = $(this);
        
        if(item.hasClass('active')) {
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

}
</script>
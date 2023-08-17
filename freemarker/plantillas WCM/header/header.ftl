<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">

<#if Imagen.getSiblings()?has_content>
  <#assign startItem = rand(1, Imagen.getSiblings()?size)-1 />
  
  <#assign path_cabeceras = ""/>
  <#assign _dlFolderLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFolderLocalService")/>
  <#assign _groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")/>
  <#assign siteGlobal = _groupLocalService.fetchCompanyGroup(themeDisplay.companyId)/>
  <#if siteGlobal?? >
    <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" )?? >
      <#assign folderRecursos = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" ) >
      <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Cabeceras" )?? >
         <#assign folderCabeceras = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Cabeceras" ) >
         
         <#if folderCabeceras?has_content >
          <#assign path_cabeceras = "/documents/"+siteGlobal.groupId+"/"+folderCabeceras.folderId+"/"/>
         </#if>
       </#if>
    </#if>
  </#if>
  <#assign indicatorId = stringUtil.randomString() /> 
  <div id="carouselIndicators_${indicatorId}" class="header__carousel carousel slide" data-touch="true">
    <#assign carouselSize = Imagen.getSiblings()?size /> 
    <#if carouselSize gt 1>
    <input type="hidden" class="showing-image" value="<@liferay.language key="showing" /> <@liferay.language key="image" />" />
      <ol class="carousel-indicators">
        <#list Imagen.getSiblings() as cur_Imagen>
          <#assign carouselClass = "" />
          <#if startItem == cur_Imagen?index>
            <#assign carouselClass = "active" />
          </#if>
          <#-- <li data-target="#carouselIndicators_${indicatorId}" data-slide-to="${cur_Imagen?index}" class="${carouselClass}"></li> -->
          <li tabindex="0" data-target="#carouselIndicators_${indicatorId}" data-slide-to="${cur_Imagen?index}" class="${carouselClass}">
                <span class="hide-accesible">
                
                <#assign altImage="" />
                    <#list cur_Imagen.getOptionsMap() as value, label>
                        <#if value == cur_Imagen.getData()>
                             <#assign altImage = label />
                        </#if>
                    </#list>

                   <span class="img-showing"></span>
                   ${altImage}
            </span>    
          </li>
        </#list>
      </ol>
    </#if>
    
    
    <div class="carousel-inner">
      <#list Imagen.getSiblings() as cur_Imagen>
      <#assign altImage="" />
      <#list cur_Imagen.getOptionsMap() as value, label>
        <#if value == cur_Imagen.getData()>
             <#assign altImage = label />
             
        </#if>
      </#list>
      
      
        <#assign carouselClass = "" />
        <#if startItem == cur_Imagen?index>
          <#assign carouselClass = "active" />
        </#if>
        <div class="carousel-item ${carouselClass}">
      
          <img src="${path_cabeceras}${cur_Imagen.getData()}.jpg" class="d-block w-100" alt="${altImage}">
        </div>
      </#list>
    </div>
  </div>
</#if>

<#function rand min max>
  <#assign _rand = 0.36 />
  <#local now = .now?long?c />
  <#local randomNum = _rand + ("0." + now?substring(now?length-1) + now?substring(now?length-2))?number />
  <#if (randomNum > 1)>
    <#assign _rand = randomNum % 1 />
  <#else>
    <#assign _rand = randomNum />
  </#if>
  <#return (min + ((max - min) * _rand))?round />
</#function>

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

    $(".header__carousel li").each(function(){

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

    $(".image-viewer-timeline .container_image .image-gallery-ico").attr("tabindex","-1");
}
</script>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

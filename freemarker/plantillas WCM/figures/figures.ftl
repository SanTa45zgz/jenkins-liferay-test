<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>

        <#if Imagen.getData()?? && Imagen.getData() != "">
            <div class="numbers numbers--bgimage d-block d-lg-none" style="background-image: url(${Imagen.getData()});">
        <#else>
            <div class="numbers numbers--bgcolor d-block d-lg-none" >
        </#if>

            <#if Titulo.getData()?? && Titulo.getData() != "">
                <h2>${Titulo.getData()}</h2>
            </#if>
            <#assign indicatorId = stringUtil.randomString() /> 
            <div id="numbers-individual_${indicatorId}" class="carousel slide" data-ride="carousel" data-touch="true" data-interval="false">
                <#if Dato.getSiblings()?has_content>
                    <#assign elements = Dato.getSiblings()?size/> 
                    <#if elements &gt; 1>
                        <ol class="carousel-indicators">
                            <#list 0..(elements-1) as i>
                                <#assign activeIndicator = "" />
                                <#if i?is_first>
                                    <#assign activeIndicator = "active" />
                                </#if>
                                    <li tabindex="0"  data-target="#numbers-individual_${indicatorId}" data-slide-to="${i}"  class="${activeIndicator}">  <span class="hide-accesible"> <@liferay.language_format arguments="${i + 1}" key="ehu.cifras.texto-accesibilidad" /> </span></li>
                            </#list>
                        </ol>
                        <div class="carousel-inner numbers__list">
                    <#else>
                        <div class="carousel-inner numbers__list numbers__list--noindicators">
                    </#if>
                        <#list Dato.getSiblings() as cur_Dato>
                            <#assign activeItem = "" />
                            <#if cur_Dato?is_first>
                                <#assign activeItem = "active" />
                            </#if>
                            <div class="carousel-item ${activeItem}">
                                <div class="numbers__list__item  text-center">
                                    <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content> 
                                        <a href="${cur_Dato.Enlace.getData()}">
                                    </#if>
                                    <#if cur_Dato?? && cur_Dato.Cantidad?? && cur_Dato.Cantidad.getData()?has_content> 
                                        <p class="numbers__list__item__number">
                                            ${cur_Dato.Cantidad.getData()}
                                        </p>
                                        <p class="numbers__list__item__info u-text-truncate u-text-truncate--3">
                                            ${cur_Dato.getData()}
                                        </p>
                                        
                                        </#if>
                                    <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content>
                                        </a>
                                    </#if>
                                </div>
                            </div>
                        </#list>        
                    </div>
                </#if>
            </div>
        </div>

        <!-- html para la vista desktop -->
        <#if Imagen.getData()?? && Imagen.getData() != "">
            <div class="numbers numbers--bgimage d-none d-lg-block" style="background-image: url(${Imagen.getData()});" >
        <#else>
            <div class="numbers numbers--bgcolor d-none d-lg-block">
        </#if>
            <#if Titulo.getData()?? && Titulo.getData() != "">
                <h2>${Titulo.getData()}</h2>
           </#if>
            <#assign indicatorId = stringUtil.randomString() /> 
            <div id="numbers-multiple_${indicatorId}" class="carousel slide" data-ride="carousel" data-touch="true" data-interval="false">
                <#if Dato.getSiblings()?has_content>
                    <#assign elements = Dato.getSiblings()?size/>
                    <#assign slideElements = (elements/3)/>
                    <#if elements%3 = 0>
                        <#assign slideElements--/>
                    </#if>
                    <#if slideElements?number &gt;= 1>
                        <ol class="carousel-indicators">
                            <#list 0..(slideElements) as i>
                                <#assign activeIndicator = ""/>
                                <#if i?is_first>
                                    <#assign activeIndicator = "active"/>
                                </#if>
                                <li tabindex="0" data-target="#numbers-multiple_${indicatorId}" data-slide-to="${i}" class="${activeIndicator}" > <span class="hide-accesible"> <@liferay.language_format arguments="${i + 1}" key="ehu.cifras.texto-accesibilidad" />  </span></li>
                            </#list>
                        </ol>

                        <div class="carousel-inner numbers__list">
                    <#else>
                        <div class="carousel-inner numbers__list numbers__list--noindicators">
                    </#if>
                        <#assign counter = 0/>
                        <#list Dato.getSiblings() as cur_Dato>
                            <#assign activeItem = "" />
                                <#if cur_Dato?is_first>
                                    <#assign activeItem = "active" />
                                </#if>
                            <#if cur_Dato?is_first || counter%3==0>
                                <div class="carousel-item ${activeItem}">
                            </#if>
                                    <!-- Se visualizan 3 datos independientemente de los que se metan -->
                                    <div class="numbers__list__item text-center carousel-item-column">
                                        <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content> 
                                            <a href="${cur_Dato.Enlace.getData()}">
                                        </#if>
                                        <#if cur_Dato?? && cur_Dato.Cantidad?? && cur_Dato.Cantidad.getData()?has_content> 
                                            <p class="numbers__list__item__number ">
                                                ${cur_Dato.Cantidad.getData()}
                                            </p>
                                            <p class="numbers__list__item__info u-text-truncate u-text-truncate--3">
                                                ${cur_Dato.getData()}
                                            </p>
                                        </#if>
                                       <#if cur_Dato?? && cur_Dato.Enlace?? && cur_Dato.Enlace.getData()?has_content> 
                                            </a>
                                        </#if>
                                    </div>
                            <#assign counter++/>
                            <#if !cur_Dato?is_first && counter%3==0>
                                </div>
                            </#if>
                        </#list>        
                    </div>
                </#if>
            </div>
        </div>
    </#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

<script>

$(document).ready(function(){
        
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
    $("ul.carousel-indicators .active").trigger("click");
}

</script>

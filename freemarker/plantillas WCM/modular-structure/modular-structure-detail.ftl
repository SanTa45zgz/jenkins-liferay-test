<#assign imagePath = themeDisplay.getPathThemeImages()>
<script src="${imagePath}/../js/jquery.js" type="text/javascript"></script>
<#assign imgMinus = imagePath + "/custom/ico-estructura-modular-minus.png">
<#assign imgPlus = imagePath + "/custom/ico-estructura-modular-plus.png">

<#if ((title2.getSiblings()?size > 1)?c)?boolean >
<div class="row m-b-30">
  <div class="col-12 bg-white p-20 estructura-modular acordeon">
    <div >
      <div class="bloque col-12">
        <div class="bloque-tipo"><h2>${title1.getChild("type1").getData()}</h2></div>
        <p class="bloque-nombre text-uppercase">${title1.getData()}</p>
        <div class="bloque-creditos"><span>${title1.getChild("credit1").getData()}</span><abbr title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS
        </abbr></div>
      </div>
    </div>
    <div class="${randomNamespace} first-level vermas"><a data-toggle="collapse" href=".bloque-0" aria-controls="bloque0" id="accordion01id" aria-expanded="true" class="">
        <img class="imgMore hide" src="${imgPlus}" alt="" />
        <img class="imgMinus" src="${imgMinus}" alt="" />
    </a></div>
    
    <div id="bloque0" class="${randomNamespace} text-center collapse bloque-0 show" aria-labelledby="accordion01id" style="height: auto;">
      <div class="row row-eq-height mgt-56">
      
      <#if ((title2.getSiblings()?size > 0)?c)?boolean >
      
        <#assign thirdLevelArray1 = []>
        <#assign thirdLevelArray2 = []>
        <#assign thirdLevelArray3 = []>
        <#assign thirdLevelArray4 = []>

        <#-- SET third level positions --> 
        <#if ((title3.getSiblings()?size > 0)?c)?boolean >
            <#list title3.getSiblings() as cur_title3 >
                <#assign boxArray = cur_title3.getChild("parentsBox").options>
                <#list boxArray as parentPos >
                    <#if parentPos?has_content && parentPos?number == 1 >
                        <#assign thirdLevelArray1 = thirdLevelArray1 + [cur_title3] >
                    <#elseif parentPos?has_content && parentPos?number == 2 >
                        <#assign thirdLevelArray2 = thirdLevelArray2 + [cur_title3] >
                    <#elseif parentPos?has_content && parentPos?number == 3 >
                        <#assign thirdLevelArray3 = thirdLevelArray3 + [cur_title3] >
                    <#elseif parentPos?has_content && parentPos?number == 4 >
                        <#assign thirdLevelArray4 = thirdLevelArray4 + [cur_title3] >
                    </#if>
                </#list>
            </#list>
        </#if>     
      
        <#assign countNode2 = 1>
        <#list title2.getSiblings() as cur_title2 >
            <div class="${randomNamespace} level2 col">

                <#assign style =  cur_title2.getChild("style").data>
                <#assign styleLenght = style?length - 2 >
                <#assign styleValue= style[2..styleLenght]>
                <#if styleValue?has_content >
                     <#assign styleValue = "especializacion">
                </#if>

              <div class='${randomNamespace} bloque-level2 bloque ${styleValue}'>
                <div class="bloque-tipo"><h3>${cur_title2.getChild("type2").getData()}</h3></div>

                <p class="bloque-nombre">               	 
                        
                    <#if cur_title2.getChild('link2').getFriendlyUrl()?has_content > 
                        <a target="_blank" href="${cur_title2.getChild('link2').getFriendlyUrl()}">${cur_title2.getData()}</a>
                    <#else>
                    	${cur_title2.getData()}
                    </#if>
                        
                </p>
                <div class="bloque-creditos"><span>${cur_title2.getChild("credit2").getData()}</span><abbr 
                    title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS</abbr></div>
              </div>
                <#assign thirdLevelArray = []>
                <#if countNode2 == 1 >
                    <#assign thirdLevelArray = thirdLevelArray1 >
                <#elseif countNode2 == 2 >
                    <#assign thirdLevelArray = thirdLevelArray2 >
                <#elseif countNode2 == 3 >
                    <#assign thirdLevelArray = thirdLevelArray3 >
                <#elseif countNode2 == 4 >
                    <#assign thirdLevelArray = thirdLevelArray4 >
                </#if>
                
                
                <#if thirdLevelArray?? && getterUtil.getBoolean(thirdLevelArray?size > 0, false) && Tercer_Nivel?? &&  Tercer_Nivel.getChild("showThirdLevel")?? && Tercer_Nivel.getChild("showThirdLevel").getData()?? &&  getterUtil.getBoolean(Tercer_Nivel.getChild("showThirdLevel").getData(), false)>
                    <div class="${randomNamespace} level2 vermas mgb-15">
                        <a data-toggle="collapse" href=".sbloque-0${countNode2}" id="accordion0${countNode2}" aria-controls="sbloque-0${countNode2}" aria-expanded="true">
                        <img class="imgMinus" src="${imgMinus}" alt="" />
                         <img class="imgMore hide" src="${imgPlus}" alt=""/></a></div>
                     <div class="over collapse sbloque-0${countNode2} show" aria-labelledby="accordion0${countNode2}" id="sbloque-0${countNode2}">
                        <#list thirdLevelArray as itemThirdLevel >
                            <div class="${randomNamespace} bloque-level3 ">
                                <div class="row row-eq-height">
                                  <div class="${randomNamespace} level3 bloque col-12 experto">
                                    <div class="bloque-tipo"><h4>${itemThirdLevel.getChild("type3").getData()}</h4></div>
                                    <p class="bloque-nombre">
                                    	
                                        <#if itemThirdLevel.getChild('link3').getFriendlyUrl()?has_content >
                                            <a target="_blank" href="${itemThirdLevel.getChild('link3').getFriendlyUrl()}">${itemThirdLevel.getData()}</a>
                                        <#else>
                                        	${itemThirdLevel.getData()}
                                        </#if>
                                  
                                    <div class="bloque-creditos"><span>${itemThirdLevel.getChild("credit3").getData()}</span><abbr 
                                        title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS</abbr></div>
                                  </div>
                              </div>
                            </div> 
                        </#list>
                    </div>
                    
                </#if> 
            </div> 
            <#assign countNode2 = countNode2 + 1>
        </#list> <#-- End foreach 2º level -->
      </#if>
      </div>
    </div> <#-- End 2º level -->
    
    
  </div> <!-- End 1º level -->
</div>

<script type="text/javascript">

    $( document ).ready(function() {
        drawLines();
    });
    
    $( window ).resize(function() {
        $(".${randomNamespace}" + ".orgLine").remove();
        drawLines();
    });
    
    function isIE() {
        var ua = window.navigator.userAgent; //Check the userAgent property of the window.navigator object
        var msie = ua.indexOf('MSIE '); // IE 10 or older
        var trident = ua.indexOf('Trident/'); //IE 11

        return (msie > 0 || trident > 0);
    }
    
    function drawLines() {

        var heightLine = 18;
        var secondLevelHeight = 40;
        var withVerticalLine = 5;

        var firstViewMore = $(".${randomNamespace}" + ".bloque-0");
        var imgViewMore = $(".${randomNamespace}" + ".first-level.vermas img");

        if (isIE()){
            var style = "position: relative; height: "+ heightLine + "px; width: 1px; left: " + firstViewMore.outerWidth() / 2 + "px;";
        } else {
            var style = "position: absolute; height: "+ heightLine + "px; width: "+ withVerticalLine +"px;";
        }
        firstViewMore.prepend('<svg class="${randomNamespace} orgLine second-level" style="'+ style +'"><line x1="0" y1="0" x2="0" y2="'+heightLine
            +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
        var firstLineLeft = firstViewMore.find(".${randomNamespace}" + ".orgLine").offset().left;
        
        $(".${randomNamespace}" + ".bloque-level2").each(function( index ) {
            
            if (isIE()){
                style = "position: absolute; height: " + secondLevelHeight + "px; width: "+ withVerticalLine 
                +"px; top: " +  (-secondLevelHeight) +"px; left: " + $(this).outerWidth() / 2 + "px;";
            } else {
                style = "position: absolute; height: " + secondLevelHeight + "px; width: "+ withVerticalLine 
                +"px; top: " +  (-secondLevelHeight) +"px;";
            }  
            $(this).append('<svg class="${randomNamespace} orgLine second-level" style="'
                + style +'"><line x1="0" y1="0" x2="0" y2="'
                + secondLevelHeight +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
                
            
            var posLeft = $(this).find(".${randomNamespace}" + ".orgLine").offset().left;
            
            if (posLeft != firstLineLeft) {
                var horizontalWidth = firstLineLeft - posLeft;
                
                if (isIE()){
                    style = "position: absolute; height: 5px; width: " +horizontalWidth+ "px; top:" + (-secondLevelHeight) + "px; left: " + $(this).outerWidth() / 2 + "px";
                } else {
                    style = "position: absolute; height: 5px; width: " +horizontalWidth+ "px; top:" + (-secondLevelHeight) + "px;";
                }  
                if (posLeft > firstLineLeft) {
                    horizontalWidth = posLeft - firstLineLeft;
                    style = "position: absolute; height: 5px; width: " +horizontalWidth+ "px; top:" + (-secondLevelHeight) + "px; left: -" + ($(this).offset().left - firstLineLeft) + "px";
                }
                $(this).append('<svg class="${randomNamespace} orgLine second-level" style="'+ style +'"><line x1="0" y1="0" x2="'
                 +horizontalWidth+'" y2="0" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
            }
        });
        
        drawThirdLevelLines(" .sbloque-01 ");
        drawThirdLevelLines(" .sbloque-02 ");
        drawThirdLevelLines(" .sbloque-03 ");
        drawThirdLevelLines(" .sbloque-04 ");
    }

    function drawThirdLevelLines(block) {
        var lastTop = 0;
        var thirdLevelHeight = 15;
        var withVerticalLine = 5;

        $(".${randomNamespace}" + block + ".bloque-level3").each(function( index ) {
            
            var top = lastTop - thirdLevelHeight;
            lastTop += $(this).height();
            
            if (isIE()){
                style = "position: absolute; height: "+ thirdLevelHeight + "px; width: "+ withVerticalLine 
                +"px; top: " + top +"px; left: " + $(this).outerWidth() / 2 + "px;";
            } else {
                style = "position: absolute; height: "+ thirdLevelHeight + "px; width: "+ withVerticalLine 
                +"px; top: " + top +"px;";
            }  
            
                
            $(this).append('<svg class="${randomNamespace} orgLine" style="'+ style +'"><line x1="0" y1="0" x2="0" y2="'
            +thirdLevelHeight +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
        });
    }
</script>







<#else>

    <div class="row m-b-30">
      <div class="col-12 bg-white p-20 estructura-modular modo-simple acordeon">
        <div class="row">
          <div class="bloque col-12">
            <div class="bloque-tipo"><h2>${title1.getChild("type1").getData()}</h2></div>
	            <p class="bloque-nombre text-uppercase">${title1.getData()}</p>
	            <div class="bloque-creditos">
	            	<span>${title1.getChild("credit1").getData()}</span>
	            	<abbr title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS</abbr>
            	</div>
          </div>
        </div>
        <div class="${randomNamespace} first-level vermas"><a data-toggle="collapse" href=".bloque-0" aria-controls="bloque0" id="accordion01id" aria-expanded="true" class="">
            <img class="imgMore hide" src="${imgPlus}" alt="" />
            <img class="imgMinus" src="${imgMinus}" alt="" />
        </a></div>
        
        <div id="bloque0" class="${randomNamespace} text-center collapse bloque-0 show pruebaa" aria-labelledby="accordion01id" style="height: auto;">
          <div class="row row-eq-height mgt-30">
          
          <#if ((title2.getSiblings()?size > 0)?c)?boolean >
            <#assign countNode2 = 1>
            <#list title2.getSiblings() as cur_title2 >
                <#if countNode2 == 1 >
                    <div class="${randomNamespace} level2 col-12">

                        <#assign style =  cur_title2.getChild("style").data >
                        <#assign styleLenght = style?length - 2 >
                        <#assign styleValue= style[2..styleLenght]>
                        <#if styleValue?has_content >
                             <#assign styleValue = "especializacion">
                        </#if>

                      <div class='${randomNamespace} bloque-level2 bloque simple ${styleValue} col-md-6 mx-auto'>
                        <div class="bloque-tipo">
                        	<h3>${cur_title2.getChild("type2").getData()}</h3> 
                        </div>
                        <p class="bloque-nombre">                        
	                        <#if cur_title2.getChild('link2').getFriendlyUrl()?has_content >
	                            <a target="_blank" href="${cur_title2.getChild('link2').getFriendlyUrl()}">${cur_title2.getData()}</a>
	                        <#else>
	                        	${cur_title2.getData()}
	                        </#if>               
                        </p>
                        <div class="bloque-creditos"><span>${cur_title2.getChild("credit2").getData()}</span><abbr 
                            title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS</abbr></div>
                      </div>
                                    
                        <#-- Third Level -->
                        <#if title3?? && title3.getSiblings()?? && getterUtil.getBoolean((title3.getSiblings()?size > 0), false) && Tercer_Nivel?? && Tercer_Nivel.getChild("showThirdLevel")?? && Tercer_Nivel.getChild("showThirdLevel").getData()?? &&  getterUtil.getBoolean((Tercer_Nivel.getChild("showThirdLevel").getData()), false)>
                                    <#assign mgSpecialClass = "mg-15-horizontal" >
                                    <#assign mgExceedClass = "">
                                    <#assign spanSizeDefault = "offset-md-3 col-md-6">
                                    <#assign spanSizeSpecific = "">
                                    <#assign mgt_30 = "mgt-30">
                                   
                            <div class="span-12" style="margin-left: 0;">
                                <div class="${randomNamespace} level2 vermas">
                                    <a data-toggle="collapse" href=".sbloque-0${countNode2}" id="accordion0${countNode2}" aria-controls="sbloque-0${countNode2}" aria-expanded="true">
                                    	<img class="imgMinus" src="${imgMinus}" alt="" />
                                     	<img class="imgMore hide" src="${imgPlus}" alt=""/>
                                     </a>
                                </div>
                                     
                                <div class="over ${mgSpecialClass} collapse sbloque-0${countNode2} show" aria-labelledby="accordion0${countNode2}" id="sbloque-0${countNode2}">
                            	    <#list title3.getSiblings() as itemThirdLevel >
                                    	<div class="${randomNamespace} bloque-level3 ${spanSizeSpecific} ${mgt_30}">
                                	    	<div class="${mgExceedClass} ${randomNamespace} level3 bloque simple experto ${spanSizeDefault}">
                                            	<div class="bloque-tipo">
                                            		<h4>${itemThirdLevel.getChild("type3").getData()}</h4>
                                            	</div>
                                            	<p class="bloque-nombre">                                                    	
                                                	<#if itemThirdLevel.getChild('link3').getFriendlyUrl()?has_content >
                                                    	<a target="_blank" href="${itemThirdLevel.getChild('link3').getFriendlyUrl()}">${itemThirdLevel.getData()}</a>                                                           
                                                    <#else>
                                                    	${itemThirdLevel.getData()}
                                                    </#if>
                                                </p>
                                               	<div class="bloque-creditos">
                                               		<span>${itemThirdLevel.getChild("credit3").getData()}</span>
                                               		<abbr title="${languageUtil.get(locale, 'ehu.title.ects')}">ECTS</abbr>
                                               	</div>
                                           	</div>
                                        </div> 
                                    </#list>                                    
                                </div>
                            </div>
                            
                        </#if> <#-- End if 3ยบ level -->
                    </div> 
                    </#if>
                <#assign countNode2 = countNode2 + 1>
            </#list> <#-- End foreach 2ยบ level -->
          </#if>
          </div>
        </div> <!-- End 2ยบ level -->
        
        
      </div> <!-- End 1ยบ level -->
    </div>

    <script type="text/javascript">

        $( document ).ready(function() {
            drawLines();
        });
        
        $( window ).resize(function() {
            $(".${randomNamespace}" + ".orgLine").remove();
            drawLines();
        });
        
        function isIE() {
            var ua = window.navigator.userAgent; //Check the userAgent property of the window.navigator object
            var msie = ua.indexOf('MSIE '); // IE 10 or older
            var trident = ua.indexOf('Trident/'); //IE 11
            return (msie > 0 || trident > 0);
        }
        
        function drawLines() {
            
            // First Line
            var heightLine = 30;
            var withLine = 5;
            var topLine = -30;
            var firstViewMore = $(".${randomNamespace}" + ".bloque-0");

            var style = "position: absolute; height: "+ heightLine + "px; width: "+ withLine +"px; left: " + firstViewMore.outerWidth() / 2 + "px; top:"+topLine+ "px;";
            firstViewMore.prepend('<svg class="${randomNamespace} orgLine second-level" style="'+ style +'"><line x1="0" y1="0" x2="0" y2="'+heightLine
                +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
            var firstLineLeft = firstViewMore.find(".${randomNamespace}" + ".orgLine").offset().left;
                    
            drawThirdLevelLines();
        }

        function drawThirdLevelLines() {
            
            // Preparation
            var heightLine = 15;
            var withVerticalLine = 5;
            var minusMarginTop = -15;
            var heightBlockLine = 30; 
            var firstViewMore = $(".${randomNamespace}" + ".sbloque-01");
            var elementCount = $(".${randomNamespace}" + ".bloque-level3").size();
            var isSameLine = true;
            var lastTop = 0;
            
            if (isIE()){
                var style = "position: absolute; height: "+ heightLine + "px; width: "+ withVerticalLine +"px; left: " + firstViewMore.outerWidth() / 2 + "px; top: " + minusMarginTop + "px;";
            } else {
                var style = "position: absolute; height: "+ heightLine + "px; width: "+ withVerticalLine +"px; top: " + minusMarginTop + "px;";
            }
            
            // Check and print the Second Vertical Line
             $(".${randomNamespace}" + ".bloque-level3").each(function( index ) {
                if (lastTop != 0 && lastTop != $(this).offset().top){
                    isSameLine = false;
                }
                lastTop = $(this).offset().top;
             });
            if (elementCount > 1 && elementCount < 5 && isSameLine){    
                firstViewMore.prepend('<svg class="${randomNamespace} orgLine orgLineSelect2 second-level" style="'+ style +'"><line x1="0" y1="0" x2="0" y2="'+heightLine
                    +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
                var firstLineLeft = firstViewMore.find(".${randomNamespace}" + ".orgLineSelect2").offset().left;
            }
            
            lastTop = 0;
            var leftIE = 0;
            $(".${randomNamespace}" + ".bloque-level3").each(function( index ) {
                var svgTop = -30;
                if (index > 0 && !isSameLine) {
                    lastTop += $(this).outerHeight() + heightBlockLine;
                    svgTop += lastTop;
                } else if (index > 0 && elementCount >= 5) {
                    lastTop += $(this).find("div").outerHeight() + heightBlockLine;
                    svgTop += lastTop;
                }
                
                // Print vertical line for each third block
                var left = "";
                if (isIE()){
                    // IE 11 FixPack
                    if (index == 0){
                        leftIE = $(this).offset().left;
                    }
                    left = ($(this).offset().left + ( $(this).outerWidth() / 2) ) -  leftIE;
                // Modern nagiators
                } else if (!isSameLine || elementCount == 1 || elementCount >= 5){
                    left = $(this).outerWidth(true) / 2;
                } 
            
                style = "position: absolute; height: " + heightBlockLine + "px; width: "+ withVerticalLine +"px; top: "+svgTop+"px; left: " + left + "px;border:0";
                $(this).append('<svg class="${randomNamespace} orgLine second-level" style="' + style +'"><line x1="0" y1="0" x2="0" y2="'
                    + heightBlockLine +'" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
                
                // Print Horizontal line in first and last third block      
                if (elementCount > 1 && elementCount < 5 && isSameLine){    
                    var posLeft = $(this).offset().left;
                    
                    if (posLeft != firstLineLeft && index == 0 || elementCount == index +1) {
                        var horizontalWidth = firstLineLeft - posLeft;

                        style = "position: absolute; height: 5px; width: " +horizontalWidth+ "px; top: 0; left: " + $(this).outerWidth() / 2 + "px;border:1";
        
                        if (posLeft > firstLineLeft) {
                            horizontalWidth = (posLeft + $(this).outerWidth() / 2) - firstLineLeft;
                            var startLeftPos = $(".${randomNamespace}" + ".level2.vermas").width() / 2;
                            style = "position: absolute; height: 5px; width: " +horizontalWidth+ "px; top: 0; left: " + startLeftPos + "px;border:2";
                        }
                        $(this).append('<svg class="${randomNamespace} orgLine third-horizontal" style="'+ style +'"><line x1="0" y1="0" x2="'
                         +horizontalWidth+'" y2="0" style="stroke:rgb(0,0,0);stroke-width:2" /></svg>');
                    }
                }
            });
        }
    </script>
</#if>

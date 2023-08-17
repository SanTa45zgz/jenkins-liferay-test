$(document).ready(function(){
	
	
});

function processHtml(){	
	const form = document.querySelector('form[name="form-search"]');
	var nav = form.elements['p_nav'].value;
	var search = form.elements['p_search'].value.toLowerCase();
	var elements = $('.elements__list');
	if(search !== ''){
		if(nav == '' || nav == 'A' || nav == 'M'){
			showAll(nav, elements.children('li'));
			elements.children('li').each(function(){
				var elementText = $(this).text().toLowerCase();
				if(!elementText.includes(search) && !accent_fold(elementText).includes(search) && !accent_fold(elementText).includes(accent_fold(search))){

					$(this).hide();
				}
			});			
		}else{			
			showAll(nav, elements.children('div.panel'));
			//iterate over elements
			elements.children('div.panel').each(function(){
				var showSubElementsCount = 0;
				//iterate over subElements
				$(this).find('li').each(function(){
					var subElement = $(this).text().toLowerCase();
					if(!subElement.includes(search) && !accent_fold(subElement).includes(search) && !accent_fold(subElement).includes(accent_fold(search))){

						$(this).hide();						
					}else{
						showSubElementsCount++;
					}					
				});
				if(showSubElementsCount == 0){
					$(this).hide();
					$(this).find('li').each(function(){
						$(this).find('a').each(function(){
							$(this).attr("tabindex", -1);
						});
					});
				}else{
					$(this).find('a.own-accordion').addClass('active');
					var panel = $(this).find('a.own-accordion').parent().next()[0];
				    panel.style.maxHeight = panel.scrollHeight + "px"; 
				    $(this).find('li').each(function(){
						$(this).find('a').each(function(){
							$(this).attr("tabindex", 0);
						});
					});
				}
			});
		}		
	}else{
		if(nav == '' || nav == 'A' || nav == 'M' ){
			showAll(nav,elements.children('li'));
		}else{
			showAll(nav,elements.children('div.panel'));
		}
	}	
}


function processHtmlMaster(){	
	const form = document.querySelector('form[name="form-search"]');
	var nav = form.elements['navegacion'].value;
	var search = form.elements['search'].value.toLowerCase();
	var elements = $('.elements__list');
	if(search !== ''){
		if(nav == '' || nav == 'A' || nav == 'M'){
			showAllMaster(nav, elements.children('li'));
			elements.children('li').each(function(){
				var elementText = $(this).text().toLowerCase();
				if(!elementText.includes(search) && !accent_fold(elementText).includes(search) && !accent_fold(elementText).includes(accent_fold(search))){

					$(this).hide();
				}
			});			
		}else{			
			showAllMaster(nav, elements.children('div.panel'));
			//iterate over elements
			elements.children('div.panel').each(function(){
				var showSubElementsCount = 0;
				//iterate over subElements
				$(this).find('li').each(function(){
					var subElement = $(this).text().toLowerCase();
					if(!subElement.includes(search) && !accent_fold(subElement).includes(search) && !accent_fold(subElement).includes(accent_fold(search))){

						$(this).hide();						
					}else{
						showSubElementsCount++;
					}					
				});
				if(showSubElementsCount == 0){
					$(this).hide();
					$(this).find('li').each(function(){
						$(this).find('a').each(function(){
							$(this).attr("tabindex", -1);
						});
					});
				}else{
					$(this).find('a.own-accordion').addClass('active');
					var panel = $(this).find('a.own-accordion').parent().next()[0];
				    panel.style.maxHeight = panel.scrollHeight + "px"; 
				    $(this).find('li').each(function(){
						$(this).find('a').each(function(){
							$(this).attr("tabindex", 0);
						});
					});
				}
			});
		}		
	}else{
		if(nav == '' || nav == 'A' || nav == 'M' ){
			showAllMaster(nav,elements.children('li'));
		}else{
			showAllMaster(nav,elements.children('div.panel'));
		}
	}	
}



function processHtmlGrades(){	
	const form = document.querySelector('form[name="form-search"]');
	var nav = form.elements['navegacion'].value;
	var search = form.elements['search'].value.toLowerCase();
	var elements = $('.elements__list');
	if(search !== ''){			
		showAllGrades(nav, elements.children('div.panel'));
		//iterate over elements
		elements.children('div.panel').each(function(){
			var showSubElementsCount = 0;
			//iterate over subElements
			$(this).find('li').each(function(){
				var subElement = $(this).text().toLowerCase();
				if(!subElement.includes(search) && !accent_fold(subElement).includes(search) && !accent_fold(subElement).includes(accent_fold(search))){
					$(this).hide();						
				}else{
					showSubElementsCount++;
				}					
			});
			if(showSubElementsCount == 0){
				$(this).hide();
				$(this).find('li').each(function(){
					$(this).find('a').each(function(){
						$(this).attr("tabindex", -1);
					});
				});
			}else{
				$(this).find('a.own-accordion').addClass('active');
				var panel = $(this).find('a.own-accordion').parent().next()[0];
				if(panel !== undefined){
					panel.style.maxHeight = panel.scrollHeight + "px";
				} 
			    $(this).find('li').each(function(){
					$(this).find('a').each(function(){
						$(this).attr("tabindex", 0);
					});
				});
			}
		});				
	}else{
		showAllGrades(nav,elements.children('div.panel'));
	}	
}


function showAll(nav,elements){
	if(nav == '' || nav == 'A' || nav == 'M'){
		elements.each(function(){
			$(this).show();
		});
	}else{
		elements.each(function(){
			$(this).show();
			$(this).find('a.own-accordion').removeClass('active');
			var panel = $(this).find('a.own-accordion').parent().next()[0];
		    panel.style.maxHeight = null;
			$(this).find('li').each(function(){
				$(this).show();
				$(this).find('a').each(function(){
					$(this).attr("tabindex", -1);
				});
			});
		});
	}
}


function showAllGrades(nav,elements){
	if(nav == '' || nav == 'A' || nav == 'B'){
		elements.each(function(){
			$(this).show();
			$(this).find('li').each(function(){
				$(this).show();
			});
		});
	}else{
		elements.each(function(){
			$(this).show();
			$(this).find('a.own-accordion').removeClass('active');
			var panel = $(this).find('a.own-accordion').parent().next()[0];
		    panel.style.maxHeight = null;
			$(this).find('li').each(function(){
				$(this).show();
				$(this).find('a').each(function(){
					$(this).attr("tabindex", -1);
				});
			});
		});
	}
}

function showAllMaster(nav,elements){
	if(nav == '' || nav == 'A' || nav == 'B'){
		elements.each(function(){
			$(this).show();
			$(this).find('li').each(function(){
				$(this).show();
			});
		});
	}else{
		elements.each(function(){
			$(this).show();
			$(this).find('a.own-accordion').removeClass('active');
			var panel = $(this).find('a.own-accordion').parent().next()[0];
		    panel.style.maxHeight = null;
			$(this).find('li').each(function(){
				$(this).show();
				$(this).find('a').each(function(){
					$(this).attr("tabindex", -1);
				});
			});
		});
	}
}


function handleCommand(elm,event) {
	var panel = $(elm).parent().next()[0];
    if (event instanceof KeyboardEvent && event.key == 'Enter') {
    	if(panel.style.maxHeight == 0){
    		$(elm).addClass('active');
    		panel.style.maxHeight = panel.scrollHeight + "px";
    		$(elm).parent().parent().find('li').each(function(){
				$(this).find('a').each(function(){
					$(this).attr("tabindex", 0);
				});
			});
    	}else{
    		$(elm).removeClass('active');
    		panel.style.maxHeight = null;
    		$(elm).parent().parent().find('li').each(function(){
				$(this).find('a').each(function(){
					$(this).attr("tabindex", -1);
				});
			});
    	}
    }
}

function handleCommandClick(elm,event) {
	var panel = $(elm).parent().next()[0];
    if(panel.style.maxHeight == 0){
		$(elm).parent().parent().find('li').each(function(){
			$(this).find('a').each(function(){
				$(this).attr("tabindex", 0);
			});
		});
	}else{
		$(elm).parent().parent().find('li').each(function(){
			$(this).find('a').each(function(){
				$(this).attr("tabindex", -1);
			});
		});
	}
}


function accent_fold(s) {
	var accent_map = {'á':'a', 'é':'e', 'è':'e', 'í':'i','ó':'o','ú':'u','Á':'a', 'É':'e', 'è':'e', 'Í':'i','Ó':'o','Ú':'u'};
	if (!s) { return ''; }
	var ret = '';
	for (var i = 0; i < s.length; i++) {
		ret += accent_map[s.charAt(i)] || s.charAt(i);
	}
	return ret;
}
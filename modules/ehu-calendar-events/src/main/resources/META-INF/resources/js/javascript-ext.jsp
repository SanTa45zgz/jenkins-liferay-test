<aui:script>
var namespace = "<portlet:namespace />";
var calendarHeaderId = "calendaryui___18_1_1_1525951310844_62_header";
var calendarPanelId = "calendaryui_patched_v3_18_1_1_1525951310844_4510_pane_0";
var mesAMostrar = namespace + "mesAux";
var anioAMostrar = namespace + "anioAux";
var defMonth = "defMonth";
var defYear = "defYear";

function <portlet:namespace />addClickEvent() {
	var $dias = $('#p_p_id<portlet:namespace /> .tbodyAux .yui3-calendar-day');

    $dias.click(function(event) {
    	var _this = $(this);
		if (!_this.hasClass('selected')) {
			$dias.filter(".selected").removeClass('selected');
			_this.addClass('selected');
		}
	});
}

AUI().ready('aui-base','node', 'event', 'aui-module',  function (A) {
	A.one("#yui___18_1_1_1525951310844158 .yui3-calendarnav-prevmonth").on('click', function (ev) {
		YUI().use('aui-aria', 'aui-dialog', 'aui-overlay-manager', 'dd-constrain','aui-io-request','aui-base',
	  		  function(Y) {	  
				Y.io.request("<%=changeMonthCalURL.toString()%>",
					      {
					      method:'POST',
					      data: {
					     	 p_r_p_calmes: $( "#" + mesAMostrar ).val(),
					     	 p_r_p_calanio: $( "#" + anioAMostrar ).val(),
					     	 <portlet:namespace />monthPrevNext: "prevMonth",
					     	 <portlet:namespace />typesSelected:  $("#typesSeleted").val(),
					     	 <portlet:namespace />catgsSelected:  $("#catgsSeleted").val()
					      },
					          on:{
					           success:function(data) {
					              			var responseJSON = JSON.parse(data.details[1].response);
		              						var calendario = responseJSON[0][0];
		              						$(".tbodyAux").empty();
		              						$(calendario).appendTo($(".tbodyAux"));
		              						var mesPrev = responseJSON[1][0];
		              						var mesName = responseJSON[1][1];
		              						var anioPrev = responseJSON[2][0];
		              						$( "#" + mesAMostrar ).val( mesPrev );
		              						$( "#" + anioAMostrar ).val( anioPrev );
		              						var labelPrev = mesName + " " + anioPrev;
		              						$( "#" + calendarHeaderId ).text( labelPrev );
		              						$( "#" + calendarPanelId ).attr( "aria-label", labelPrev );
		              						
		              						<portlet:namespace />addClickEvent();
		              					}
		              			}
					      });
			      });
					
	});
	
	A.one("#yui___18_1_1_1525951310844158 .yui3-calendarnav-nextmonth").on('click', function (ev) {
		YUI().use('aui-aria', 'aui-dialog', 'aui-overlay-manager', 'dd-constrain','aui-io-request','aui-base',
	  		  function(Y) {	  
				Y.io.request("<%=changeMonthCalURL.toString()%>",
					      {
					      method:'POST',
					      data: {
					     	 p_r_p_calmes: $( "#" + mesAMostrar ).val(),
					     	 p_r_p_calanio: $( "#" + anioAMostrar ).val(),
					     	 <portlet:namespace />monthPrevNext: "nextMonth",
					     	 <portlet:namespace />typesSelected:  $("#typesSeleted").val(),
					     	 <portlet:namespace />catgsSelected:  $("#catgsSeleted").val()
					      },
					          on:{
					           success:function(data) {
					              			var responseJSON = JSON.parse(data.details[1].response);
		              						var calendario = responseJSON[0][0];
		              						$(".tbodyAux").empty();
		              						$(calendario).appendTo($(".tbodyAux"));
		              						var mesNext = responseJSON[1][0];
		              						var mesName = responseJSON[1][1];
		              						var anioNext = responseJSON[2][0];
		              						$( "#" + mesAMostrar ).val( mesNext );
		              						$( "#" + anioAMostrar ).val( anioNext );
		              						var labelNext = mesName + " " + anioNext;
		              						$( "#" + calendarHeaderId ).text( labelNext );
		              						$( "#" + calendarPanelId ).attr( "aria-label", labelNext );
		              						<portlet:namespace />addClickEvent();
		              					}
		              			}
					      });
			      });
	});
});

	
$(function() {
	var $portletWrapper = $('#p_p_id<portlet:namespace />');
	var $tipoEventsCheckbox = $portletWrapper.find(".tipoEvents:checkbox");
	var $typesSeleted = $portletWrapper.find("#typesSeleted");
	var $catgsSeleted = $portletWrapper.find("#catgsSeleted");
	var newMes = $portletWrapper.find( "#" + defMonth ).val();
	var newYear = $portletWrapper.find( "#" + defYear ).val();
	$portletWrapper.find( "#" + mesAMostrar ).val( newMes );
	$portletWrapper.find( "#" + anioAMostrar ).val( newYear );
	
      $tipoEventsCheckbox.click(function() {
          var checkBoxStatus = $tipoEventsCheckbox.filter(":checked");
            if(this.checked == true) {
           		if(this.value == ""){
           			$tipoEventsCheckbox.prop("checked",true);
           			$catgsSeleted.val("");
           		} else {
	           		$catgsSeleted.val(checkBoxStatus.map(function(){
				    	return $(this).val();
				    }).get().join());
           		}
            }
            else { 
            	if(this.value == ""){
           			$tipoEventsCheckbox.prop("checked",false);
           			$catgsSeleted.val("");
           		} else {
           			if(checkBoxStatus.length != 0) {
           				$tipoEventsCheckbox.filter('[value=""]').prop("checked", false);
	           			$catgsSeleted.val(checkBoxStatus.map(function(){
					    	return $(this).val();
					    }).get().join());
	           		} else { 
           				$catgsSeleted.val("");
           			}
           		}
            }
            
           YUI().use('aui-aria', 'aui-dialog', 'aui-overlay-manager', 'dd-constrain','aui-io-request','aui-base',
	  		  function(Y) {	  
				Y.io.request("<%=showEventsByTypeURL.toString()%>",
			      {
			      method:'POST',
			      data: {
			       	 p_r_p_calmes: $portletWrapper.find( "#" + mesAMostrar ).val(),
			     	 p_r_p_calanio: $portletWrapper.find( "#" + anioAMostrar ).val(),
			     	 <portlet:namespace />typesSelected:  $typesSeleted.val(),
			     	 <portlet:namespace />catgsSelected:  $catgsSeleted.val()
			      },
			          on:{
			           success:function(data) {
			              			var responseJSON = JSON.parse(data.details[1].response);
              						var calendario = responseJSON[0][0];
              						$portletWrapper.find(".tbodyAux").empty();
              						$(calendario).appendTo($portletWrapper.find(".tbodyAux"));
              						var listadoCal = responseJSON[1][0];
              						$portletWrapper.find(".listadoCal").empty();
              						$(listadoCal).appendTo($portletWrapper.find(".listadoCal"));
              						<portlet:namespace />addClickEvent();
              					}
              			}
			      });
	      });
      });


	<portlet:namespace />addClickEvent();
});

function showEventsByDay(dia,mes,anyo,tipoVista){
	YUI().use('aui-aria', 'aui-dialog', 'aui-overlay-manager', 'dd-constrain','aui-io-request','aui-base',
	  		  function(Y) {	  
				Y.io.request("<%=showEventsByDayURL.toString()%>",
					      {
					      method:'POST',
					      data: {
					     	 <portlet:namespace />dia: dia,
					     	 <portlet:namespace />mes: mes,
					     	 <portlet:namespace />anyo: anyo,
					     	 <portlet:namespace />typesSelected: $("#typesSeleted").val(),
					     	 <portlet:namespace />catgsSelected: $("#catgsSeleted").val(),
					     	 <portlet:namespace />tipoVista: tipoVista
					      },
					          on:{
					           success:function(data) {
					              			var responseJSON = JSON.parse(data.details[1].response);					              			
					              			
		              						
		              						var listadoDia = responseJSON[0][0];
		              						$(".listadoCal").empty();
		              						
		              						if(tipoVista==1){
		              							 var header = responseJSON[1][0];		   		              							
		              							 var headerEventsDay = "<liferay-ui:message key='calendar.popup.header'/> "+header;		              							
		              							         					
		              							 popUpEvents(headerEventsDay, listadoDia);	
		              						}
		              						else{		              						
		              							$(listadoDia).appendTo($(".listadoCal"));
		              						}
		              						
		              						<portlet:namespace />addClickEvent();
		              					}
		              			}
					      });
			      });
}


function popUpEvents(headerEventsDay,listadoEventos){
	YUI().use('aui-modal', function(Y) {
	    var modal = new Y.Modal({
	        bodyContent: listadoEventos,
	        draggable: true,
	        resizable: true,
	        centered: true,
	        modal: true,
	        render: '#modalEvents',
	        headerContent: '<h2>'+headerEventsDay+'</h2>',
	        height: 350,
			width: 500,
			destroyOnHide: true,
			toolbars: {
				header: [{
	              	labelHTML: '<span class="hide-accesible"><liferay-ui:message key="calendar.popup.cerrar" /></span>',
	              	on: {
                  		click: function(event) {
                    		modal.hide();
                    		event.domEvent.stopPropagation();
						}
					}
				}]
	        }
		});
		
		<%-- la capa de fondo solo se ocultaba y se creaba una nueva al volverla a abrir --%>
		modal.on('destroy', function(){
        	jQuery('#modalEvents').empty();
        	jQuery('#p_p_id<portlet:namespace /> .yui3-calendar-day.selected').removeClass('selected');
	    });
		
		<%-- cierra la popup al pulsar fuera de ella --%>
		modal.on('render', function(){
	    	jQuery('#modalEvents > .yui3-widget-mask').click(function(){
	    		modal.hide();
	    	});
	    });

		modal.render();
	});
        
}



</aui:script>
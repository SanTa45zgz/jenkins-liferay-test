<#assign idCourse = "" >
<#assign idTeacher = "" >
<#assign idStudent = "" >
<#assign hash = "" >
<#if request.getParameter("idCourse")??>
    <#assign idCourse = request.getParameter("idCourse") >
</#if>


<#if request.getParameter("idTeacher")??>
    <#assign idTeacher = request.getParameter("idTeacher") >
</#if>


<#if request.getParameter("idStudent")??>
    <#assign idStudent = request.getParameter("idStudent") >
</#if>

<#if request.getParameter("hash")??>
    <#assign hash = request.getParameter("hash") >
</#if>



<p class="portlet-msg-info" id="oharra"><strong>
<a href="https://frontmooddesa.lgp.ehu.es/" target="_blank" title="eGela">${oharra.getData()}</a>
</strong></p>



<script>
	
    function egelaActualizarForm() {

    
        var idCourse = "${idCourse}";
        var idTeacher = "${idTeacher}";
		var idStudent = "${idStudent}";
		var hash = "${hash}";
        var mensaje = document.getElementById("oharra");
  
       
        var divformulario = document.getElementById("p_p_id_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_")
		var idCourseInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_ddm$$idCourse$"]');
        var idTeacherInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_ddm$$idTeacher$"]');
        var idStudentInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_ddm$$idStudent$"]');
        var hashInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_ddm$$hash$"]');
        var comentariosInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_ddm$$Comentarios$"]')

      
		if ((idCourse != '') && (idStudent != '') && (idTeacher != '') && (hash != '')) {
      
            //Si disponemos de los 4 datos requeridos
			
            idCourseInput.setAttribute('value',idCourse);
            idTeacherInput.setAttribute('value',idTeacher);
            idStudentInput.setAttribute('value',idStudent);
            hashInput.setAttribute('value',hash);
          
            // Actualizamos el objeto global que representa la instancia del formulario y que Liferay utiliza por detrás para mantener actualizados los valores
            var formObject = window._com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_LSDbk30Q0M4v_form;
            formObject.pages[0].rows[0].columns[0].fields[0].value = idStudent;
            formObject.pages[0].rows[0].columns[1].fields[0].value = idCourse;
            formObject.pages[0].rows[0].columns[2].fields[0].value = idTeacher;
            formObject.pages[0].rows[0].columns[3].fields[0].value = hash;
   
            mensaje.style.display = "none";
            divformulario.style.display = "block";

        }//En caso de no disponer de los datos.
        else{
         
       
           mensaje.style.display = "block";
			
		

        }

   }
   
   
 window.onload = function(){
    
        setTimeout(egelaActualizarForm, 1000);
}
   
   
	
</script>
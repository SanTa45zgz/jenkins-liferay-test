<#assign texto = texto.getData() >
<#assign ldap = user.getScreenName() >
<#assign correo = user.getEmailAddress() >
<#assign nombre = user.getFirstName() >
<#assign apellidos = user.getLastName() >



<script>
	
    function updateForm() {

    
        var ldap = "${ldap}";
        var correo = "${correo}";
		var nombre = "${nombre}";
		var apellidos = "${apellidos}";
        var mensaje = document.getElementById("info-texto");
  
       
        var divformulario = document.getElementById("p_p_id_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_")
		var ldapInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_ddm$$ldap$"]');
        var correoInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_ddm$$correo$"]');
        var nombreInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_ddm$$nombre$"]');
        var apellidosInput = document.querySelector('[name^="_com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_ddm$$apellidos$"]');
       
      
       
		if ((ldap == '') || (correo == '')|| (nombre == '')|| (apellidos == '')) {
      
          // todo

        }
        else{

			
            ldapInput.setAttribute('value',ldap);
            correoInput.setAttribute('value',correo);
            nombreInput.setAttribute('value',nombre);
            apellidosInput.setAttribute('value',apellidos);
        
            var formObject = window._com_liferay_dynamic_data_mapping_form_web_portlet_DDMFormPortlet_INSTANCE_nPnxb85NsOpg_form;
            formObject.pages[0].rows[0].columns[0].fields[0].value = ldap;
            formObject.pages[0].rows[0].columns[1].fields[0].value = correo;
            formObject.pages[0].rows[1].columns[0].fields[0].value = nombre;
            formObject.pages[0].rows[1].columns[1].fields[0].value = apellidos;
   

           
			ldapInput.readOnly  = true;
            correoInput.readOnly  = true;
            nombreInput.readOnly  =true;
            apellidosInput.readOnly =true;
		

        }

   }
   
   
 window.onload = function(){
    
        setTimeout(updateForm, 1000);
}
   
   
	
</script>
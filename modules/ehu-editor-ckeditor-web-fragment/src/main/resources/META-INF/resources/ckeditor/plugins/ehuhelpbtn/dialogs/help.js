CKEDITOR.dialog.add( 'helpDialog',
	function( editor ) {
		var lang = editor.lang.ehuhelpbtn;
		
		return {
			title: lang.dlgTitle,
			minWidth: 400,
			minHeight: 200,

			contents: [
			    {
					id: 'tab-help-accesibilidad',
					label: lang.tabAccesibility,
					elements: [
					    {
						type:'html',
						html:'<style type="text/css">.cke_about_container{padding-left:2em;} .cke_about_container ol {padding-left:0.5em;}</style>' +
							'<div class="cke_about_container cke_help_accesibility">' + lang.infoAccesibility + '</div>'
					    },
					]
			    },
			    {
					id: 'tab-help-comandos',
					label: lang.tabCommands,
					elements: [
					    {
						type:'html',
						html:'<div class="cke_about_container cke_help_commands">' + lang.infoCommands + '</div>'
					    },
					]
			    }
			],

			buttons: [CKEDITOR.dialog.cancelButton]
		};
});

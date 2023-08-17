(function() {
	var pluginName = 'ehuhelpbtn';
	
	CKEDITOR.plugins.add(
		pluginName,
		{
			lang: "es,eu,en,fr",

			init: function( editor ) {
				var lang = editor.lang.ehuhelpbtn;
				if( editor.ui.addButton ) {
					editor.ui.addButton(
						'HelpBtn',
						{
							command: 'ehuHelp',
							label: lang.label,
							icon: CKEDITOR.plugins.basePath + 'icons.png'
						}
					);
				}
				editor.addCommand( 'ehuHelp', new CKEDITOR.dialogCommand( 'helpDialog' ) );

				CKEDITOR.dialog.add( 'helpDialog', this.path + 'dialogs/help.js' );
				editor.on(
					'uiSpace',
					function(event) {

						var toolbarHTML = event.data.html;

						var helpbtnIndex = toolbarHTML.indexOf('cke_button__helpbtn');

						if (helpbtnIndex !== -1) {
							var helpToolbarIndex = toolbarHTML.lastIndexOf('class="cke_toolbar"', helpbtnIndex);

							var toolbarText = toolbarHTML.substr(helpToolbarIndex).replace('class="cke_toolbar"', 'class="cke_toolbar cke_toolbar__ehuhelpbtn"');

							event.data.html = toolbarHTML.substr(0, helpToolbarIndex) + toolbarText;
						}
					}
				);
			}
		}
	);
})();

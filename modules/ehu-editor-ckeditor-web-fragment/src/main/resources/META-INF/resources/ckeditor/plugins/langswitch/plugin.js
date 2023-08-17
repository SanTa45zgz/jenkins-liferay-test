CKEDITOR.plugins.add( 'langswitch', {
	requires: "richcombo",
	lang: "es,eu,en,fr",

	init: function( editor )
	{
		var comboName = "Langswitch";
		var lang = editor.lang.langswitch;
		var config = editor.config;
		var entries = config.language_names;
		var styleType = "language";
		var styleDefinition = config.language_style;
		var defaultLabel = config.language_defaultLabel;
		
		var names = entries.split( ';' );
		var codes = [];
		var styles = {};

		for( var i=0; i<names.length; i++ )
		{
			var parLang = names[ i ];
			if( parLang )
			{
				var arrLang = parLang.split( '/' );
				var vars = {};
				var langName = names[ i ] = arrLang[ 0 ];
				var langCode = arrLang[ 1 ];
				codes[ i ] = langCode;
				vars[ styleType ] = codes[ i ];
				styles[ langName ] = new CKEDITOR.style( styleDefinition, vars );
				styles[ langName ]._.definition.name = langName;
			} else {
				names.splice( i--, 1 );
			}
		}

		editor.ui.addRichCombo( comboName,
		{
			label : lang.label,
			title : lang.panelTitle,
			multiSelect : false,
			className : 'cke_' + 'langswitch',

			//use the same style as the font/style dropdowns
			panel :
			{
				css: [ CKEDITOR.skin.getPath( 'editor' ) ].concat( config.contentsCss ),
				attributes : { 'aria-label' : 'lang.panelTitle' }
			},
      
			init : function()
			{
				this.startGroup( lang.panelTitle );
				for( var i=0; i<names.length; i++ )
				{
					var langName = names[ i ];
					// Add the tag entry to the panel list.
					this.add( langName, styles[ langName ].buildPreview(), langName );
				}
			},
				
			onClick : function( value )
			{
				editor.focus();
				editor.fire( 'saveSnapshot' );
				
				var style = styles[ value ];
				if( this.getValue() == value )
					style.remove( editor.document );
				else
					style.apply( editor.document );

				editor.fire( 'saveSnapshot' );
			},

			onRender : function()
			{
				editor.on( 'selectionChange', function( ev )
					{
						var currentValue = this.getValue();
						var elementPath = ev.data.path;
						var elements = elementPath.elements;

						// For each element into the elements path.
						for( var i=0, element; i<elements.length; i++ )
						{
							element = elements[ i ];

							// Check if the element is removable by any of
							// the styles.
							for( var value in styles )
							{
								if( styles[ value ].checkElementRemovable( element, true ) )
								{
									if( value != currentValue )
										this.setValue( value );
									return;
								}
							}
						}

						// If no styles match, just empty it.
						this.setValue( '', defaultLabel );
					},
					this );
			}
		});
	}
});

/**
 * The list of language ids to be displayed in the Language combo in the toolbar.
 * Entries are separated by semi-colons (;)
 * @type String
 * @example
 * config.language_names = 'es;en;eu';
 */

CKEDITOR.config.language_names = 'euskara/eu;español/es;english/en;française/fr;;deutsch/de;italiano/it;;portugues/pt;català/ca;galego/gl;';

/**
 * The text to be displayed in the Language combo is none of the available values
 * matches the current cursor position or text selection.
 * @type String
 * @example
 * config.language_defaultLabel = 'es';
 */
CKEDITOR.config.language_defaultLabel = '';

/**
 * The style definition to be used to apply the font in the text.
 * @type Object
 * @example
 * // This is actually the default value for it.
 * config.language_style =
 *     {
 *         element		: 'span',
 *         styles		: { 'lang' : '#(language)', 'style' : 'background-color: red' },
 *         overrides	: [ { element : 'lang', attributes : { 'lang' : null } } ]
 *     };
 */
CKEDITOR.config.language_style =
	{
		element		: 'span',
		attributes	: { 'lang' : '#(language)'},
		overrides	: [  ]
	};



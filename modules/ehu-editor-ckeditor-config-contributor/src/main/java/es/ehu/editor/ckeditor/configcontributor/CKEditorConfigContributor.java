/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */

package es.ehu.editor.ckeditor.configcontributor;

import com.liferay.document.library.kernel.util.AudioProcessorUtil;
import com.liferay.petra.string.StringBundler;
import com.liferay.petra.string.StringPool;
import com.liferay.petra.string.StringUtil;
import com.liferay.portal.kernel.editor.configuration.BaseEditorConfigContributor;
import com.liferay.portal.kernel.editor.configuration.EditorConfigContributor;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.json.JSONUtil;
import com.liferay.portal.kernel.language.Language;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.ColorScheme;
import com.liferay.portal.kernel.portlet.RequestBackedPortletURLFactory;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.Validator;

import java.util.Locale;
import java.util.Map;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author UPV/EHU
 * Se quitan los estilos h1, pre, code y se añaden los estilos h5 y h6
 * Se quitan las opciones 'Underline', 'Strikethrough', '-', 'RemoveFormat'
 * Se quitan las opciones 'TextColor', 'BGColor'
 * Se añade el plugin 'HelpBtn' (ehuhelpbtn)
 * Se añade el plugin 'Langswitch'
 * Ha de tener el permiso ADVANCED_EDITION para poder ver el botón de código HTML
 * Se elimina la opción de incrustar video e imagen
 * 
 */
@Component(
	immediate = true,
	property = {"editor.name=ckeditor", "editor.name=ckeditor_classic",},
	
	service = EditorConfigContributor.class
)
public class CKEditorConfigContributor extends BaseEditorConfigContributor {

	@Override
	public void populateConfigJSONObject(
		JSONObject jsonObject, Map<String, Object> inputEditorTaglibAttributes,
		ThemeDisplay themeDisplay,
		RequestBackedPortletURLFactory requestBackedPortletURLFactory) {

		
		_themeDisplay = themeDisplay;
		
		jsonObject = _createJSONObject(jsonObject, inputEditorTaglibAttributes, themeDisplay, requestBackedPortletURLFactory);

		
		jsonObject.put(
			"autoSaveTimeout", 3000
		).put(
			"closeNoticeTimeout", 8000
		).put(
			"entities", Boolean.FALSE
		);

		String extraPlugins =
			"addimages,autogrow,autolink,colordialog,filebrowser," +
				"itemselector,lfrpopup,media,stylescombo,videoembed";

		boolean inlineEdit = GetterUtil.getBoolean(
			(String)inputEditorTaglibAttributes.get(
				ATTRIBUTE_NAMESPACE + ":inlineEdit"));

		if (inlineEdit) {
			extraPlugins += ",ajaxsave,restore";
		}
		
		// se añaden los nuevos plugins UPV/EHU
		if (Validator.isNotNull(extraPlugins)) {
			extraPlugins =  extraPlugins + ",ehuhelpbtn,langswitch";
		} else {
			extraPlugins = "ehuhelpbtn,langswitch";
		}// se añaden los nuevos plugins UPV/EHU

		jsonObject.put(
			"extraPlugins", extraPlugins
		).put(
			"filebrowserWindowFeatures",
			"title=" + _language.get(themeDisplay.getLocale(), "browse")
		).put(
			"pasteFromWordRemoveFontStyles", Boolean.FALSE
		).put(
			"pasteFromWordRemoveStyles", Boolean.FALSE
		).put(
			"removePlugins", "elementspath"
		).put(
			"stylesSet", _getStyleFormatsJSONArray(themeDisplay.getLocale())
		).put(
			"title", false
		);

		JSONArray toolbarSimpleJSONArray = _getToolbarSimpleJSONArray(
			inputEditorTaglibAttributes);

		jsonObject.put(
			"toolbar_editInPlace", toolbarSimpleJSONArray
		).put(
			"toolbar_email", toolbarSimpleJSONArray
		).put(
			"toolbar_liferay", toolbarSimpleJSONArray
		).put(
			"toolbar_liferayArticle", toolbarSimpleJSONArray
		).put(
			"toolbar_phone", toolbarSimpleJSONArray
		).put(
			"toolbar_simple", toolbarSimpleJSONArray
		).put(
			"toolbar_tablet", toolbarSimpleJSONArray
		).put(
			"toolbar_text_advanced",
			_getToolbarTextAdvancedJSONArray(inputEditorTaglibAttributes)
		).put(
			"toolbar_text_simple",
			_getToolbarTextSimpleJSONArray(inputEditorTaglibAttributes)
		);
	}
	
	
	private JSONObject _createJSONObject(
			JSONObject jsonObject, Map<String, Object> inputEditorTaglibAttributes,
			ThemeDisplay themeDisplay,
			RequestBackedPortletURLFactory requestBackedPortletURLFactory) {

			jsonObject.put("allowedContent", Boolean.TRUE);

			StringBundler sb = new StringBundler(5);

			sb.append("cke_editable html-editor");

			ColorScheme colorScheme = themeDisplay.getColorScheme();

			if (Validator.isNotNull(colorScheme.getCssClass())) {
				sb.append(StringPool.SPACE);
				sb.append(HtmlUtil.escape(colorScheme.getCssClass()));
			}

			String cssClasses = GetterUtil.getString(
				inputEditorTaglibAttributes.get(
					ATTRIBUTE_NAMESPACE + ":cssClasses"));

			if (Validator.isNotNull(cssClasses)) {
				sb.append(StringPool.SPACE);
				sb.append(HtmlUtil.escape(cssClasses));
			}

			jsonObject.put(
				"bodyClass", sb.toString()
			).put(
				"contentsCss",
				JSONUtil.putAll(
					HtmlUtil.escape(themeDisplay.getClayCSSURL()),
					HtmlUtil.escape(themeDisplay.getMainCSSURL()),
					HtmlUtil.escape(
						PortalUtil.getStaticResourceURL(
							themeDisplay.getRequest(),
							PortalUtil.getPathContext() +
								"/o/frontend-editor-ckeditor-web/ckeditor/skins" +
									"/moono-lexicon/editor.css")),
					HtmlUtil.escape(
						PortalUtil.getStaticResourceURL(
							themeDisplay.getRequest(),
							PortalUtil.getPathContext() +
								"/o/frontend-editor-ckeditor-web/ckeditor/skins" +
									"/moono-lexicon/dialog.css")))
			).put(
				"contentsLangDirection",
				HtmlUtil.escapeJS(
					getContentsLanguageDir(inputEditorTaglibAttributes))
			);

			String contentsLanguageId = getContentsLanguageId(
				inputEditorTaglibAttributes);

			contentsLanguageId = StringUtil.replace(contentsLanguageId, "iw", "he");
			contentsLanguageId = StringUtil.replace(contentsLanguageId, '_', '-');

			jsonObject.put(
				"contentsLanguage", contentsLanguageId
			).put(
				"height", 265
			);

			String languageId = getLanguageId(themeDisplay);

			languageId = StringUtil.replace(languageId, "iw", "he");
			languageId = StringUtil.replace(languageId, '_', '-');

			jsonObject.put("language", languageId);

			boolean resizable = GetterUtil.getBoolean(
				(String)inputEditorTaglibAttributes.get(
					ATTRIBUTE_NAMESPACE + ":resizable"));

			if (resizable) {
				String resizeDirection = GetterUtil.getString(
					inputEditorTaglibAttributes.get(
						ATTRIBUTE_NAMESPACE +
							":resizeDirection"));

				jsonObject.put("resize_dir", resizeDirection);
			}

			jsonObject.put("resize_enabled", resizable);
			
		return jsonObject;
	}

	private JSONObject _getStyleFormatJSONObject(
		String styleFormatName, String element, String cssClass) {

		return JSONUtil.put(
			"attributes",
			() -> {
				if (Validator.isNotNull(cssClass)) {
					return JSONUtil.put("class", cssClass);
				}

				return null;
			}
		).put(
			"element", element
		).put(
			"name", styleFormatName
		);
	}

	private JSONArray _getStyleFormatsJSONArray(Locale locale) {
		/* se modifican los textos de los estilos
		return JSONUtil.putAll(
			_getStyleFormatJSONObject(
				_language.get(locale, "normal"), "p", null),
			_getStyleFormatJSONObject(
				_language.format(locale, "heading-x", "1"), "h1", null),
			_getStyleFormatJSONObject(
				_language.format(locale, "heading-x", "2"), "h2", null),
			_getStyleFormatJSONObject(
				_language.format(locale, "heading-x", "3"), "h3", null),
			_getStyleFormatJSONObject(
				_language.format(locale, "heading-x", "4"), "h4", null),
			_getStyleFormatJSONObject(
				_language.get(locale, "preformatted-text"), "pre", null),
			_getStyleFormatJSONObject(
				_language.get(locale, "cited-work"), "cite", null),
			_getStyleFormatJSONObject(
				_language.get(locale, "computer-code"), "code", null),
			_getStyleFormatJSONObject(
				_language.get(locale, "info-message"), "div",
				"overflow-auto portlet-msg-info"),
			_getStyleFormatJSONObject(
				_language.get(locale, "alert-message"), "div",
				"overflow-auto portlet-msg-alert"),
			_getStyleFormatJSONObject(
				_language.get(locale, "error-message"), "div",
				"overflow-auto portlet-msg-error"));*/
		
		String jsonp  = _language.get(locale, "upv-ehu.ckeditor.text-style.normal");
		if (jsonp == null) {
			jsonp  = "normal" ;
		}
	
		String jsonh2  = _language.format(locale, "upv-ehu.ckeditor.text-style.heading-x", "2");
		if (jsonh2 == null) {
			jsonh2  = "heading 2" ;
		}
		String jsonh3  = _language.format(locale, "upv-ehu.ckeditor.text-style.heading-x", "3");
		if (jsonh3 == null) {
			jsonh3  = "heading 3" ;
		}
		String jsonh4  = _language.format(locale, "upv-ehu.ckeditor.text-style.heading-x", "4");
		if (jsonh4 == null) {
			jsonh4  = "heading 4" ;
		}
		String jsonh5  = _language.format(locale, "upv-ehu.ckeditor.text-style.heading-x", "5");
		if (jsonh5 == null) {
			jsonh5  = "heading 5" ;
		}
		String jsonh6  = _language.format(locale, "upv-ehu.ckeditor.text-style.heading-x", "6");
		if (jsonh6 == null) {
			jsonh6  = "heading 6" ;
		}
		String jsoninfo  = _language.get(locale, "upv-ehu.ckeditor.text-style.info-message");
		if (jsoninfo == null) {
			jsoninfo  = "info-message"  ;
		}
		String jsonalert  = _language.get(locale, "upv-ehu.ckeditor.text-style.alert-message");
		if (jsonalert == null) {
			jsonalert  = "alert-message" ;
		}
		String jsonerror  = _language.get(locale,"upv-ehu.ckeditor.text-style.error-message");
		if (jsonerror == null) {
			jsonerror  = "error-message" ;
		}
		String jsonsuccess  = _language.get(locale,"upv-ehu.ckeditor.text-style.success-message");
		if (jsonsuccess == null) {
			jsonsuccess  = "success-message" ;
		}

		return JSONUtil.putAll(
				_getStyleFormatJSONObject(jsonp, "p", null ),
				_getStyleFormatJSONObject( jsonh2, "h2", null ),
				_getStyleFormatJSONObject( jsonh3, "h3", null ),
				_getStyleFormatJSONObject( jsonh4, "h4", null ),
				_getStyleFormatJSONObject( jsonh5, "h5", null ),
				_getStyleFormatJSONObject( jsonh6, "h6", null ),
				_getStyleFormatJSONObject( jsoninfo, "div", "portlet-msg-info" ),
				_getStyleFormatJSONObject( jsonalert, "div", "portlet-msg-alert" ),
				_getStyleFormatJSONObject( jsonerror, "div", "portlet-msg-error" ),
				_getStyleFormatJSONObject( jsonsuccess, "div", "portlet-msg-success" ) );
	}

	private JSONArray _getToolbarSimpleJSONArray(
		Map<String, Object> inputEditorTaglibAttributes) {

		return JSONUtil.putAll(
			toJSONArray("['Undo', 'Redo']"),
			//se quita underline
		//	toJSONArray("['Styles', 'Bold', 'Italic', 'Underline']"), 
			toJSONArray("['Styles', 'Bold', 'Italic']"), 
			// se añade Langswitch
			toJSONArray("['Langswitch']"),
			toJSONArray("['NumberedList', 'BulletedList']"),
			toJSONArray("['Link', Unlink]"),
			//se quitan las opciones de incrustar video e imagen
			//toJSONArray("['Table', 'ImageSelector', 'VideoSelector']"),
			toJSONArray("['Table']"),
			 // se añade el botón HelpBtn
			toJSONArray("['HelpBtn']")
		).put(
			() -> {
				if (AudioProcessorUtil.isEnabled()) {
					return toJSONArray("['AudioSelector']");
				}

				return null;
			}
		).put(
			() -> {
				if (isShowSource(inputEditorTaglibAttributes)) {
					return toJSONArray("['Source', 'Expand']");
				}

				return null;
			}
		);
	}

	private JSONArray _getToolbarTextAdvancedJSONArray(
		Map<String, Object> inputEditorTaglibAttributes) {

		return JSONUtil.putAll(
			toJSONArray("['Undo', 'Redo']"), toJSONArray("['Styles']"),
			// se añade Langswitch
			toJSONArray("['Langswitch']"),
			//Se quitan las opciones 'FontColor', 'BGColor'
		//	toJSONArray("['FontColor', 'BGColor']"), 
			//Se quita la opción underline y Strikethrough
		//	toJSONArray("['Bold', 'Italic', 'Underline', 'Strikethrough']"), 
			toJSONArray("['Bold', 'Italic']"),
			// Se quita RemoveFormat
		//	toJSONArray("['RemoveFormat']"),
			toJSONArray("['NumberedList', 'BulletedList']"),
			toJSONArray("['IncreaseIndent', 'DecreaseIndent']"),
			toJSONArray("['IncreaseIndent', 'DecreaseIndent']"),
			toJSONArray("['Link', Unlink]")
		).put(
			() -> {
				if (isShowSource(inputEditorTaglibAttributes)) {
					return toJSONArray("['Source', 'Expand']");
				}

				return null;
			}
		);
	}

	private JSONArray _getToolbarTextSimpleJSONArray(
		Map<String, Object> inputEditorTaglibAttributes) {

		return JSONUtil.putAll(
			toJSONArray("['Undo', 'Redo']"),
			//Se quita la opción underline 
		//	toJSONArray("['Styles', 'Bold', 'Italic', 'Underline']"),
			toJSONArray("['Styles', 'Bold', 'Italic']"),
			// se añade Langswitch
			toJSONArray("['Langswitch']"),
			toJSONArray("['NumberedList', 'BulletedList']"),
			toJSONArray("['Link', Unlink]")
		).put(
			() -> {
				if (isShowSource(inputEditorTaglibAttributes)) {
					return toJSONArray("['Source', 'Expand']");
				}

				return null;
			}
		);
	}

	protected boolean isShowSource(
			Map<String, Object> inputEditorTaglibAttributes) {

		boolean override = GetterUtil.getBoolean(
				inputEditorTaglibAttributes.get(
					ATTRIBUTE_NAMESPACE + ":showSource"),
				true);
			
		boolean advancedPermission = JournalPermission.contains(_themeDisplay.getPermissionChecker(), _themeDisplay.getScopeGroupId(), "ADVANCED_EDITION");
		return advancedPermission && override;
		
	
	}
	
	@Reference
	private Language _language;

	private static final Log _log = LogFactoryUtil.getLog(CKEditorConfigContributor.class);
	
	private static ThemeDisplay _themeDisplay;

	public static final String ATTRIBUTE_NAMESPACE = "liferay-ui:input-editor";

}
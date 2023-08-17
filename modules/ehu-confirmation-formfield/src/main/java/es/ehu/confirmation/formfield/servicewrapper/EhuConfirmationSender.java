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

package es.ehu.confirmation.formfield.servicewrapper;

import com.liferay.dynamic.data.mapping.constants.DDMPortletKeys;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldTypeServicesRegistry;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldValueRenderer;
import com.liferay.dynamic.data.mapping.model.DDMForm;
import com.liferay.dynamic.data.mapping.model.DDMFormField;
import com.liferay.dynamic.data.mapping.model.DDMFormInstance;
import com.liferay.dynamic.data.mapping.model.DDMFormInstanceRecord;
import com.liferay.dynamic.data.mapping.model.DDMFormInstanceSettings;
import com.liferay.dynamic.data.mapping.model.DDMFormLayout;
import com.liferay.dynamic.data.mapping.model.DDMFormLayoutColumn;
import com.liferay.dynamic.data.mapping.model.DDMFormLayoutPage;
import com.liferay.dynamic.data.mapping.model.DDMFormLayoutRow;
import com.liferay.dynamic.data.mapping.model.DDMStructure;
import com.liferay.dynamic.data.mapping.model.LocalizedValue;
import com.liferay.dynamic.data.mapping.storage.DDMFormFieldValue;
import com.liferay.dynamic.data.mapping.storage.DDMFormValues;
import com.liferay.mail.kernel.model.MailMessage;
import com.liferay.mail.kernel.service.MailService;
import com.liferay.petra.io.unsync.UnsyncStringWriter;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.Language;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.GroupLocalService;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.UserLocalService;
import com.liferay.portal.kernel.template.Template;
import com.liferay.portal.kernel.template.TemplateConstants;
import com.liferay.portal.kernel.template.TemplateManagerUtil;
import com.liferay.portal.kernel.template.TemplateResource;
import com.liferay.portal.kernel.template.URLTemplateResource;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.HashMapBuilder;
import com.liferay.portal.kernel.util.HtmlParser;
import com.liferay.portal.kernel.util.ListUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.util.PrefsProps;
import com.liferay.portal.kernel.util.PropsKeys;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.Writer;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.function.Function;

import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author UPV/EHU
 */
@Component(immediate = true, service = EhuConfirmationSender.class)
public class EhuConfirmationSender {

	/**
	 * 
	 * @param ddmFormInstanceRecord
	 * @param serviceContext
	 * @param destinationEmails
	 * 
	 * fvcalderon001: se añade el campo destinationEmails
	 */

	public void sendEmailNotification(
		DDMFormInstanceRecord ddmFormInstanceRecord,
		ServiceContext serviceContext, final List<String> destinationEmails) {

		try {
			MailMessage mailMessage = _createMailMessage(
				ddmFormInstanceRecord, serviceContext, destinationEmails);

			_mailService.sendEmail(mailMessage);
		}
		catch (Exception exception) {
			_log.error("Unable to send form email", exception);
		}
	}

	/**
	 * 
	 * @param ddmFormInstanceRecord
	 * @return
	 * @throws PortalException
	 */
	protected Map<String, List<DDMFormFieldValue>> getDDMFormFieldValuesMap(
			DDMFormInstanceRecord ddmFormInstanceRecord)
		throws PortalException {

		DDMFormValues ddmFormValues = ddmFormInstanceRecord.getDDMFormValues();

		return ddmFormValues.getDDMFormFieldValuesMap(true);
	}

	/**
	 * 
	 * @param ddmFormFieldValues
	 * @param locale
	 * @return
	 */
	protected Map<String, Object> getFieldProperties(
		List<DDMFormFieldValue> ddmFormFieldValues, Locale locale) {

		DDMFormField ddmFormField = _getDDMFormField(ddmFormFieldValues);

		if (Objects.equals(ddmFormField.getType(), "fieldset")) {
			return null;
		}

		if (Objects.equals(ddmFormField.getType(), "paragraph")) {
			return HashMapBuilder.<String, Object>put(
				"label", _getLabel(ddmFormField, locale)
			).put(
				"value", _getParagraphText(ddmFormField, locale)
			).build();
		}

		List<String> renderedDDMFormFieldValues = ListUtil.toList(
			ddmFormFieldValues,
			new Function<DDMFormFieldValue, String>() {

				@Override
				public String apply(DDMFormFieldValue ddmFormFieldValue) {
					//fvcalderon001: enviar un correo en varios idiomas y no sólo en el locale que se ha
					// añadido el registro.
					String value = _renderDDMFormFieldValue(ddmFormFieldValue, locale);
					if (Validator.isBlank(value)) {
						String [] ORDERED_LANGUAGE_IDS = new String [] {"eu_ES", "es_ES", "en_GB", "fr_FR", "de_DE"};
						for (String languageId : ORDERED_LANGUAGE_IDS) {
					    	Locale currentlocale = LocaleUtil.fromLanguageId(languageId);
					    	value = _renderDDMFormFieldValue(ddmFormFieldValue, currentlocale);
					    	if (!Validator.isBlank(value)) {
					    		return value;
					    	}
						}
						return value;
					}else {
						return value;
					}
					//return _renderDDMFormFieldValue(ddmFormFieldValue, locale);
					//fvcalderon001: enviar un correo en varios idiomas y no sólo en el locale que se ha
					// añadido el registro.
				}

			});

		return HashMapBuilder.<String, Object>put(
			"label", _getLabel(ddmFormField, locale)
		).put(
			"value",
			StringUtil.merge(
				renderedDDMFormFieldValues, StringPool.COMMA_AND_SPACE)
		).build();
	}

	/**
	 * 
	 * @param fieldNames
	 * @param ddmFormFieldValuesMap
	 * @param locale
	 * @return
	 */
	protected List<Object> getFields(
		List<String> fieldNames,
		Map<String, List<DDMFormFieldValue>> ddmFormFieldValuesMap,
		Locale locale) {

		List<Object> fields = new ArrayList<>();

		for (String fieldName : fieldNames) {
			List<DDMFormFieldValue> ddmFormFieldValues =
				ddmFormFieldValuesMap.get(fieldName);

			if (ddmFormFieldValues == null) {
				continue;
			}

			fields.add(getFieldProperties(ddmFormFieldValues, locale));

			fields.addAll(
				_getNestedFields(
					ddmFormFieldValues, ddmFormFieldValuesMap, locale));
		}

		return fields;
	}

	/**
	 * 
	 * @param ddmFormInstanceRecord
	 * @param serviceContext
	 * @param destinationEmails
	 * @return
	 * @throws Exception
	 * 
	 * fvcalderon001: se añade el campo destinationEmails
	 */
	private MailMessage _createMailMessage(
			DDMFormInstanceRecord ddmFormInstanceRecord,
			ServiceContext serviceContext, List<String> destinationEmails)
		throws Exception {

		DDMFormInstance ddmFormInstance =
			ddmFormInstanceRecord.getFormInstance();

		InternetAddress fromInternetAddress = new InternetAddress(
			_getEmailFromAddress(ddmFormInstance),
			_getEmailFromName(ddmFormInstance));

		String subject = _getEmailSubject(ddmFormInstance);

		String body = _getEmailBody(
			serviceContext, ddmFormInstance, ddmFormInstanceRecord);

		MailMessage mailMessage = new MailMessage(
			fromInternetAddress, subject, body, true);

		/**
		 * Se obtienen los campos de tipo formfield confirmation para enviar el correo
		InternetAddress[] toAddresses = InternetAddress.parse(
			_getEmailToAddress(ddmFormInstance));*/
		InternetAddress[] toAddresses = InternetAddress.parse(StringUtil.merge(destinationEmails, StringPool.COMMA));
		
		// fvcalderon001: Se obtienen los campos de tipo formfield confirmation para enviar el correo

		mailMessage.setTo(toAddresses);

		return mailMessage;
	}

	/**
	 * 
	 * @param serviceContext
	 * @param ddmFormInstance
	 * @param ddmFormInstanceRecord
	 * @return
	 * @throws Exception
	 */
	private Template _createTemplate(
			ServiceContext serviceContext, DDMFormInstance ddmFormInstance,
			DDMFormInstanceRecord ddmFormInstanceRecord)
		throws Exception {

		Template template = TemplateManagerUtil.getTemplate(
			TemplateConstants.LANG_TYPE_FTL,
			_getTemplateResource(_TEMPLATE_PATH), false);

		_populateParameters(
			template, serviceContext, ddmFormInstance, ddmFormInstanceRecord);

		return template;
	}

	/**
	 * 
	 * @param ddmFormFieldValues
	 * @return
	 */
	private DDMFormField _getDDMFormField(
		List<DDMFormFieldValue> ddmFormFieldValues) {

		DDMFormFieldValue ddmFormFieldValue = ddmFormFieldValues.get(0);

		return ddmFormFieldValue.getDDMFormField();
	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @return
	 * @throws Exception
	 */
	private DDMFormLayout _getDDMFormLayout(DDMFormInstance ddmFormInstance)
		throws Exception {

		DDMStructure ddmStructure = ddmFormInstance.getStructure();

		return ddmStructure.getDDMFormLayout();
	}

	/**
	 * 
	 * @param serviceContext
	 * @param ddmFormInstance
	 * @param ddmFormInstanceRecord
	 * @return
	 * @throws Exception
	 */
	private String _getEmailBody(
			ServiceContext serviceContext, DDMFormInstance ddmFormInstance,
			DDMFormInstanceRecord ddmFormInstanceRecord)
		throws Exception {

		Template template = _createTemplate(
			serviceContext, ddmFormInstance, ddmFormInstanceRecord);

		return _render(template);
	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @return
	 * @throws Exception
	 */
	private String _getEmailFromAddress(DDMFormInstance ddmFormInstance)
		throws Exception {

		DDMFormInstanceSettings formInstancetings =
			ddmFormInstance.getSettingsModel();

		String defaultEmailFromAddress = _prefsProps.getString(
			ddmFormInstance.getCompanyId(), PropsKeys.ADMIN_EMAIL_FROM_ADDRESS);

		// fvcalderon001: evitar error de envio si el usu no rellena
		/*return GetterUtil.getString(
			formInstancetings.emailFromAddress(), defaultEmailFromAddress);
			
		*/
		return Validator.isBlank(formInstancetings.emailFromAddress()) ? defaultEmailFromAddress : formInstancetings.emailFromAddress();
		
		// fvcalderon001: evitar error de envio si el usu no rellena
	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @return
	 * @throws Exception
	 */
	private String _getEmailFromName(DDMFormInstance ddmFormInstance)
		throws Exception {

		DDMFormInstanceSettings formInstancetings =
			ddmFormInstance.getSettingsModel();

		String defaultEmailFromName = _prefsProps.getString(
			ddmFormInstance.getCompanyId(), PropsKeys.ADMIN_EMAIL_FROM_NAME);

		// fvcalderon001: evitar error de envio si el usu no rellena
		/*
		return GetterUtil.getString(
			formInstancetings.emailFromName(), defaultEmailFromName);*/
		return Validator.isBlank(formInstancetings.emailFromName()) ? defaultEmailFromName : formInstancetings.emailFromName();
		// fvcalderon001: evitar error de envio si el usu no rellena

	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @return
	 * @throws Exception
	 */
	private String _getEmailSubject(DDMFormInstance ddmFormInstance)
		throws Exception {

		DDMFormInstanceSettings formInstancetings =
			ddmFormInstance.getSettingsModel();

		DDMStructure ddmStructure = ddmFormInstance.getStructure();

		DDMForm ddmForm = ddmStructure.getDDMForm();

		Locale locale = ddmForm.getDefaultLocale();

		ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
			"content.Language", locale, getClass());

		String defaultEmailSubject = _language.format(
			resourceBundle, "new-x-form-submitted",
			ddmFormInstance.getName(locale), false);
		
		// fvcalderon001: ponemos título por defecto

		/*return GetterUtil.getString(
			formInstancetings.emailSubject(), defaultEmailSubject);*/
		
		String subject =  GetterUtil.getString(
				formInstancetings.emailSubject(), defaultEmailSubject);
		if (Validator.isBlank(subject)) {
			subject =  LanguageUtil.format(resourceBundle, "webform-lang-email.subject.confirm", ddmFormInstance.getName(locale), false);

		}
		return subject;

		
		// fvcalderon001: ponemos título por defecto
	}

	private String _getEmailToAddress(DDMFormInstance ddmFormInstance)
		throws Exception {

		String defaultEmailToAddress = StringPool.BLANK;

		DDMFormInstanceSettings formInstancetings =
			ddmFormInstance.getSettingsModel();

		User user = _userLocalService.fetchUser(ddmFormInstance.getUserId());

		if (user != null) {
			defaultEmailToAddress = user.getEmailAddress();
		}

		return GetterUtil.getString(
			formInstancetings.emailToAddress(), defaultEmailToAddress);
	}

	/**
	 * 
	 * @param ddmFormLayoutPage
	 * @return
	 */
	private List<String> _getFieldNames(DDMFormLayoutPage ddmFormLayoutPage) {
		List<String> fieldNames = new ArrayList<>();

		for (DDMFormLayoutRow ddmFormLayoutRow :
				ddmFormLayoutPage.getDDMFormLayoutRows()) {

			for (DDMFormLayoutColumn ddmFormLayoutColumn :
					ddmFormLayoutRow.getDDMFormLayoutColumns()) {

				fieldNames.addAll(ddmFormLayoutColumn.getDDMFormFieldNames());
			}
		}

		return fieldNames;
	}

	/**
	 * 
	 * @param ddmFormField
	 * @param locale
	 * @return
	 */
	private String _getLabel(DDMFormField ddmFormField, Locale locale) {
		LocalizedValue label = ddmFormField.getLabel();

		if (ddmFormField.isRequired()) {
			return label.getString(locale) + StringPool.STAR;
		}

		return label.getString(locale);
	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @param serviceContext
	 * @return
	 * @throws Exception
	 */
	private Locale _getLocale(
			DDMFormInstance ddmFormInstance, ServiceContext serviceContext)
		throws Exception {

		HttpServletRequest httpServletRequest = serviceContext.getRequest();

		String languageId = GetterUtil.getString(
			httpServletRequest.getParameter("languageId"),
			ddmFormInstance.getDefaultLanguageId());

		return LocaleUtil.fromLanguageId(languageId);
	}

	/**
	 * 
	 * @param ddmFormFieldValues
	 * @param ddmFormFieldValuesMap
	 * @param locale
	 * @return
	 */
	private List<Map<String, Object>> _getNestedFields(
		List<DDMFormFieldValue> ddmFormFieldValues,
		Map<String, List<DDMFormFieldValue>> ddmFormFieldValuesMap,
		Locale locale) {

		List<Map<String, Object>> nestedFields = new ArrayList<>();

		DDMFormField ddmFormField = _getDDMFormField(ddmFormFieldValues);

		Map<String, DDMFormField> nestedDDMFormFieldsMap =
			ddmFormField.getNestedDDMFormFieldsMap();

		for (String key : nestedDDMFormFieldsMap.keySet()) {
			nestedFields.add(
				getFieldProperties(ddmFormFieldValuesMap.get(key), locale));
		}

		return nestedFields;
	}

	/**
	 * 
	 * @param ddmFormLayoutPage
	 * @param ddmFormFieldValuesMap
	 * @param locale
	 * @return
	 */
	private Map<String, Object> _getPage(
		DDMFormLayoutPage ddmFormLayoutPage,
		Map<String, List<DDMFormFieldValue>> ddmFormFieldValuesMap,
		Locale locale) {

		return HashMapBuilder.<String, Object>put(
			"fields",
			getFields(
				_getFieldNames(ddmFormLayoutPage), ddmFormFieldValuesMap,
				locale)
		).put(
			"title",
			() -> {
				LocalizedValue title = ddmFormLayoutPage.getTitle();

				return title.getString(locale);
			}
		).build();
	}

	/**
	 * 
	 * @param ddmFormInstance
	 * @param ddmFormInstanceRecord
	 * @param locale
	 * @return
	 * @throws Exception
	 */
	private List<Object> _getPages(
			DDMFormInstance ddmFormInstance,
			DDMFormInstanceRecord ddmFormInstanceRecord, Locale locale)
		throws Exception {

		List<Object> pages = new ArrayList<>();

		DDMFormLayout ddmFormLayout = _getDDMFormLayout(ddmFormInstance);

		for (DDMFormLayoutPage ddmFormLayoutPage :
				ddmFormLayout.getDDMFormLayoutPages()) {

			pages.add(
				_getPage(
					ddmFormLayoutPage,
					getDDMFormFieldValuesMap(ddmFormInstanceRecord), locale));
		}

		return pages;
	}

	/**
	 * 
	 * @param ddmFormField
	 * @param locale
	 * @return
	 */
	private String _getParagraphText(DDMFormField ddmFormField, Locale locale) {
		LocalizedValue text = (LocalizedValue)ddmFormField.getProperty("text");

		if (text == null) {
			return StringPool.BLANK;
		}

		return _htmlParser.extractText(text.getString(locale));
	}

	private ResourceBundle _getResourceBundle(Locale locale) {
		return ResourceBundleUtil.getBundle(
			"content.Language", locale, getClass());
	}
	
	/**
	 * 
	 * @param groupId
	 * @param locale
	 * @return
	 * @throws Exception
	 */
	private String _getSiteName(long groupId, Locale locale) throws Exception {
		Group siteGroup = _groupLocalService.fetchGroup(groupId);

		if (siteGroup != null) {
			return siteGroup.getDescriptiveName(locale);
		}

		return StringPool.BLANK;
	}

	/**
	 * 
	 * @param templatePath
	 * @return
	 */
	private TemplateResource _getTemplateResource(String templatePath) {
		Class<?> clazz = getClass();

		ClassLoader classLoader = clazz.getClassLoader();

		URL templateURL = classLoader.getResource(templatePath);

		return new URLTemplateResource(templateURL.getPath(), templateURL);
	}

	/**
	 * 
	 * @param ddmFormInstanceRecord
	 * @param locale
	 * @return
	 */
	private String _getUserName(
		DDMFormInstanceRecord ddmFormInstanceRecord, Locale locale) {

		String userName = ddmFormInstanceRecord.getUserName();

		if (Validator.isNotNull(userName)) {
			return userName;
		}

		return _language.get(_getResourceBundle(locale), "someone");
	}

	/**
	 * 
	 * @param serviceContext
	 * @param ddmFormInstance
	 * @return
	 * @throws Exception
	 */
	private String _getViewFormEntriesURL(
			ServiceContext serviceContext, DDMFormInstance ddmFormInstance)
		throws Exception {

		String portletNamespace = _portal.getPortletNamespace(
			DDMPortletKeys.DYNAMIC_DATA_MAPPING_FORM_ADMIN);

		return _portal.getSiteAdminURL(
			serviceContext.getPortalURL(),
			_groupLocalService.getGroup(ddmFormInstance.getGroupId()),
			DDMPortletKeys.DYNAMIC_DATA_MAPPING_FORM_ADMIN,
			HashMapBuilder.put(
				portletNamespace.concat("mvcPath"),
				new String[] {"/admin/view_form_instance_records.jsp"}
			).put(
				portletNamespace.concat("formInstanceId"),
				new String[] {
					String.valueOf(ddmFormInstance.getFormInstanceId())
				}
			).build());
	}

	/**
	 * 
	 * @param serviceContext
	 * @param ddmFormInstance
	 * @param ddmFormInstanceRecord
	 * @return
	 * @throws Exception
	 */
	private String _getViewFormURL(
			ServiceContext serviceContext, DDMFormInstance ddmFormInstance,
			DDMFormInstanceRecord ddmFormInstanceRecord)
		throws Exception {

		//fvcalderon001: la URL del formulario será la página donde está el formulario
		/*
		 * 
		String portletNamespace = _portal.getPortletNamespace(
			DDMPortletKeys.DYNAMIC_DATA_MAPPING_FORM_ADMIN);

		return _portal.getSiteAdminURL(
			serviceContext.getPortalURL(),
			_groupLocalService.getGroup(ddmFormInstance.getGroupId()),
			DDMPortletKeys.DYNAMIC_DATA_MAPPING_FORM_ADMIN,
			HashMapBuilder.put(
				portletNamespace.concat("mvcPath"),
				new String[] {"/admin/view_form_instance_record.jsp"}
			).put(
				portletNamespace.concat("formInstanceRecordId"),
				new String[] {
					String.valueOf(
						ddmFormInstanceRecord.getFormInstanceRecordId())
				}
			).put(
				portletNamespace.concat("formInstanceId"),
				new String[] {
					String.valueOf(ddmFormInstance.getFormInstanceId())
				}
			).build());
			
			*/
		HttpServletRequest httpServletRequest = serviceContext.getRequest();
		ThemeDisplay themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
		return _portal.getLayoutFullURL(themeDisplay);
		//fvcalderon001: la URL del formulario será la página donde está el formulario
	}

	/**
	 * 
	 * @param template
	 * @param serviceContext
	 * @param ddmFormInstance
	 * @param ddmFormInstanceRecord
	 * @throws Exception
	 */
	private void _populateParameters(
			Template template, ServiceContext serviceContext,
			DDMFormInstance ddmFormInstance,
			DDMFormInstanceRecord ddmFormInstanceRecord)
		throws Exception {

		
		
		Locale locale = _getLocale(ddmFormInstance, serviceContext);
		
		template.put("formName", ddmFormInstance.getName(locale));

		template.put(
			"pages", _getPages(ddmFormInstance, ddmFormInstanceRecord, locale));
		template.put(
			"siteName", _getSiteName(ddmFormInstance.getGroupId(), locale));
		template.put("userName", _getUserName(ddmFormInstanceRecord, locale));

		template.put(
			"viewFormEntriesURL",
			_getViewFormEntriesURL(serviceContext, ddmFormInstance));
		template.put(
			"viewFormURL",
			_getViewFormURL(
				serviceContext, ddmFormInstance, ddmFormInstanceRecord));
		
		
		template.put("authorName", ddmFormInstance.getUserName());
		template.put("emailTitle", _getEmailSubject(ddmFormInstance));

		//fvcalderon001:  se añaden los parámetros que necesita la plantilla personalizada
		template.put("viewFormEntriesURL", _getViewFormEntriesURL(serviceContext, ddmFormInstance));
		template.put("viewFormURL", _getViewFormURL(serviceContext, ddmFormInstance, ddmFormInstanceRecord));
		
		//i18n
		template.put("rb", _getResourceBundle(locale));
		template.put("locale", locale);

		
		// logo
		HttpServletRequest httpServletRequest = serviceContext.getRequest();
		String logoUrl = _portal.getAbsoluteURL(httpServletRequest, "/o/dynamic-data-ehu-confirmation-formfield/images/logo_ehu.png");
		template.put("logoUrl", logoUrl);
		//fvcalderon001:  se añaden los parámetros que necesita la plantilla personalizada
	}

	/**
	 * 
	 * @param template
	 * @return
	 * @throws Exception
	 */
	private String _render(Template template) throws Exception {
		Writer writer = new UnsyncStringWriter();

		template.processTemplate(writer);

		return writer.toString();
	}

	/**
	 * 
	 * @param ddmFormFieldValue
	 * @param locale
	 * @return
	 */
	private String _renderDDMFormFieldValue(
		DDMFormFieldValue ddmFormFieldValue, Locale locale) {

		if (ddmFormFieldValue.getValue() == null) {
			return StringPool.BLANK;
		}

		DDMFormFieldValueRenderer ddmFormFieldValueRenderer =
			_ddmFormFieldTypeServicesRegistry.getDDMFormFieldValueRenderer(
				ddmFormFieldValue.getType());

		return ddmFormFieldValueRenderer.render(ddmFormFieldValue, locale);
	}
	
	/******* METODOS PERSONALIZADOS *****/
	
	protected ResourceBundle getResourceBundle(Locale locale) {
		return ResourceBundleUtil.getBundle("content.Language", locale, getClass());
	}
	

	private static final String _NAMESPACE = "form.form_entry";
	
	private static final Set<String> _mailSendBlacklist = new HashSet<>(Arrays.asList(PropsUtil.getArray(PropsKeys.MAIL_SEND_BLACKLIST)));
	
	private static final String _TEMPLATE_PATH =
		"/META-INF/resources/mailtemplates/form_entry_add_body.ftl";

	private static final Log _log = LogFactoryUtil.getLog(
			EhuConfirmationSender.class);

	@Reference
	private DDMFormFieldTypeServicesRegistry _ddmFormFieldTypeServicesRegistry;

	@Reference
	private GroupLocalService _groupLocalService;

	@Reference
	private HtmlParser _htmlParser;

	@Reference
	private Language _language;

	@Reference
	private MailService _mailService;

	@Reference
	private Portal _portal;

	@Reference
	private PrefsProps _prefsProps;

	@Reference
	private UserLocalService _userLocalService;
	
	
}
package es.ehu.confirmation.formfield;

import java.util.Locale;

import org.osgi.service.component.annotations.Component;

import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldValueValidationException;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldValueValidator;
import com.liferay.dynamic.data.mapping.model.DDMFormField;
import com.liferay.dynamic.data.mapping.model.Value;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Validator;

import es.ehu.confirmation.formfield.util.EhuConfirmationKeys;


@Component(
	immediate = true, property = "ddm.form.field.type.name=" + EhuConfirmationKeys.FIELD_NAME,
	service = DDMFormFieldValueValidator.class
)
public class EhuConfirmationDDMFormFieldValueValidator implements DDMFormFieldValueValidator {

	@Override
	public void validate(DDMFormField ddmFormField, Value value) throws DDMFormFieldValueValidationException {
		
		for (Locale availableLocale : value.getAvailableLocales()) {
			String valueString = value.getString(availableLocale);
			_log.error("valueString: " + valueString);
			if (Validator.isNotNull(valueString) && !Validator.isEmailAddress(valueString)) {
				throw new DDMFormFieldValueValidationException(String.format("\"%s\" is not a %s", valueString, ddmFormField.getDataType()));
			}
		}
	}
	
	private static final Log _log = LogFactoryUtil.getLog(
			EhuConfirmationDDMFormFieldValueValidator.class);
}
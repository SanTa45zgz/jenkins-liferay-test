package es.ehu.confirmation.formfield;

import com.liferay.dynamic.data.mapping.form.field.type.BaseDDMFormFieldType;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldType;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldTypeSettings;
import com.liferay.frontend.js.loader.modules.extender.npm.NPMResolver;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.confirmation.formfield.util.EhuConfirmationKeys;

/**
 * @author UPV/EHU
 */
@Component(
	immediate = true,
	property = {
		"ddm.form.field.type.description=ehu-confirmation-description",
		"ddm.form.field.type.display.order:Integer=11",
		"ddm.form.field.type.group=customized",
		"ddm.form.field.type.icon=envelope-open",
		"ddm.form.field.type.label=ehu-confirmation-label",
		"ddm.form.field.type.name=" + EhuConfirmationKeys.FIELD_NAME
	},
	service = DDMFormFieldType.class
)
public class EhuConfirmationDDMFormFieldType extends BaseDDMFormFieldType {
	
	@Override
	public Class<? extends DDMFormFieldTypeSettings> getDDMFormFieldTypeSettings() {
		return EhuConfirmationDDMFormFieldTypeSettings.class;
	}
	
	@Override
	public String getModuleName() {
		return _npmResolver.resolveModuleName("dynamic-data-ehu-confirmation-formfield/Confirmation/Confirmation.es");
	}
	
	@Override
	public String getName() {
		return EhuConfirmationKeys.FIELD_NAME;
	}

	@Override
	public boolean isCustomDDMFormFieldType() {
		return true;
	}
	
	@Reference
	private NPMResolver _npmResolver;
	
	private static final Log _log = LogFactoryUtil.getLog(
			EhuConfirmationDDMFormFieldType.class);
}
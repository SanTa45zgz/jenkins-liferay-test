package es.ehu.confirmation.formfield.servicewrapper;

import java.util.ArrayList;
import java.util.List;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.dynamic.data.mapping.model.DDMFormInstanceRecord;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceLocalService;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceRecordLocalServiceWrapper;
import com.liferay.dynamic.data.mapping.storage.DDMFormFieldValue;
import com.liferay.dynamic.data.mapping.storage.DDMFormValues;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceWrapper;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;


import es.ehu.confirmation.formfield.util.EhuConfirmationKeys;

@Component(
	immediate = true,
	service = ServiceWrapper.class
)
public class EhuConfirmationDDMFormInstanceRecordServiceWrapper extends DDMFormInstanceRecordLocalServiceWrapper {

	private static final Log _log = LogFactoryUtil.getLog(EhuConfirmationDDMFormInstanceRecordServiceWrapper.class);
	
	@Reference
	private DDMFormInstanceLocalService _ddmFormInstanceLocalService;
	
	@Reference
	private EhuConfirmationSender _confirmationSender;
	
	
	public EhuConfirmationDDMFormInstanceRecordServiceWrapper() {
		super(null);
	}

	
	@Override
	public DDMFormInstanceRecord addFormInstanceRecord(long userId, long groupId, long ddmFormInstanceId, DDMFormValues ddmFormValues, ServiceContext serviceContext) throws PortalException {
		_log.error("addFormInstanceRecord......................");

		final DDMFormInstanceRecord ddmFormInstanceRecord  = super.addFormInstanceRecord(userId, groupId, ddmFormInstanceId, ddmFormValues, serviceContext);
		
		// si se está publicando (no borrador)
		if (serviceContext.getWorkflowAction() == WorkflowConstants.ACTION_PUBLISH) {
			_log.error("envio add......................");
			// enviamos correos de confirmación en caso de encontrar campos tipo "confirmation"
			final List<String> confirmationValues = getConfirmationValues(ddmFormValues);
			
			if (!confirmationValues.isEmpty()) {
				_confirmationSender.sendEmailNotification(ddmFormInstanceRecord, serviceContext,confirmationValues);
				
			}
			
		}
		
		return ddmFormInstanceRecord;
	}
	
	@Override
	public DDMFormInstanceRecord updateFormInstanceRecord(long userId, long ddmFormInstanceRecordId,
			boolean majorVersion, DDMFormValues ddmFormValues, ServiceContext serviceContext) throws PortalException {
		_log.error("updateFormInstanceRecord......................");
		final DDMFormInstanceRecord ddmFormInstanceRecord  = super.updateFormInstanceRecord(userId, ddmFormInstanceRecordId, majorVersion, ddmFormValues, serviceContext);
		
		// si se está publicando (no borrador)
		if (serviceContext.getWorkflowAction() == WorkflowConstants.ACTION_PUBLISH) {
			_log.error("envio update......................");
			// enviamos correos de confirmación en caso de encontrar campos tipo "confirmation"
			final List<String> confirmationValues = getConfirmationValues(ddmFormValues);
			
			if (!confirmationValues.isEmpty()) {
				_confirmationSender.sendEmailNotification(ddmFormInstanceRecord, serviceContext,confirmationValues);
			}
			
		}
		
		return ddmFormInstanceRecord;
	}
	
	/**
	 * recupera la lista de correos de los campos tipo "ehuconfirmation"
	 */
	protected List<String> getConfirmationValues(DDMFormValues ddmFormValues) throws PortalException {
		final List<String> confirmationValues = new ArrayList<>();
		for (final DDMFormFieldValue ddmFormFieldValue : ddmFormValues.getDDMFormFieldValues()) {
			if (EhuConfirmationKeys.FIELD_NAME.equalsIgnoreCase(ddmFormFieldValue.getType())) {
				// se puede pasar null porque el campo no es internacionalizable
				final String correo = ddmFormFieldValue.getValue().getString(null);
				if (!Validator.isBlank(correo)) {
					confirmationValues.add(correo);
				}
			}
		}

		return confirmationValues;
	}
}

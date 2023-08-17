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

package es.ehu.xsl.content.web.configuration;

import aQute.bnd.annotation.metatype.Meta;

import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;

/**
 * @author UPV/EHU
 */
@ExtendedObjectClassDefinition(category = "xsl-content", scope = ExtendedObjectClassDefinition.Scope.SYSTEM)
@Meta.OCD(
	id = "es.ehu.xsl.content.web.configuration.XSLContentConfiguration",
	localization = "content/Language", name = "xsl-content-configuration-name"
)
public interface XSLContentConfiguration {

	@Meta.AD(
		deflt = "@portlet_context_url@", id = "valid.url.prefixes",
		name = "valid-url-prefixes", required = false
	)
	public String validUrlPrefixes();

	@Meta.AD(
		deflt = "false", id = "xml.doctype.declaration.allowed",
		name = "xml-doctype-declaration-allowed", required = false
	)
	public boolean xmlDoctypeDeclarationAllowed();

	@Meta.AD(
		deflt = "false", id = "xml.external.general.entities.allowed",
		name = "xml-external-general-entities-allowed", required = false
	)
	public boolean xmlExternalGeneralEntitiesAllowed();

	@Meta.AD(
		deflt = "false", id = "xml.external.parameter.entities.allowed",
		name = "xml-external-parameter-entities-allowed", required = false
	)
	public boolean xmlExternalParameterEntitiesAllowed();

	@Meta.AD(
		deflt = "true", id = "xsl.secure.processing.enabled",
		name = "xsl-secure-processing-enabled", required = false
	)
	public boolean xslSecureProcessingEnabled();

}
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
@ExtendedObjectClassDefinition(
	category = "xsl-content",
	scope = ExtendedObjectClassDefinition.Scope.PORTLET_INSTANCE
)
@Meta.OCD(
	id = "es.ehu.xsl.content.web.configuration.XSLContentPortletInstanceConfiguration",
	localization = "content/Language",
	name = "xsl-content-portlet-instance-configuration-name"
)
public interface XSLContentPortletInstanceConfiguration {

	@Meta.AD(
		deflt = "@portlet_context_url@/example.xml", name = "xml-url",
		required = false
	)
	public String xmlUrl();

	@Meta.AD(
		deflt = "@portlet_context_url@/example.xsl", name = "xsl-url",
		required = false
	)
	public String xslUrl();
	
	@Meta.AD(
		name = "application-id",
		id = "application-id",
		required = false
	)
	public String applicationId();
	
	
	@Meta.AD(
		name = "configParams",
		required = false
	)
	public String [] configParams();
}
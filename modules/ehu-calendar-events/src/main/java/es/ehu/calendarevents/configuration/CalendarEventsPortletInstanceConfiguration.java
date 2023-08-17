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

package es.ehu.calendarevents.configuration;

import aQute.bnd.annotation.metatype.Meta;

import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;

/**
 * @author UPV/EHU
 */
@ExtendedObjectClassDefinition(category = "calendar-events",
	scope = ExtendedObjectClassDefinition.Scope.PORTLET_INSTANCE
)
@Meta.OCD(
	id = "es.ehu.calendarevents.configuration.CalendarEventsPortletInstanceConfiguration",
	localization = "content/Language",
	name = "calendar-events-name-instance-configuration"
)
public interface CalendarEventsPortletInstanceConfiguration {

	@Meta.AD(deflt = "0", required = true)
	public int tipoVista();
}
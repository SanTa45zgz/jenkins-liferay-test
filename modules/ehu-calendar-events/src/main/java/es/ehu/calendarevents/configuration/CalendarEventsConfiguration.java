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
@ExtendedObjectClassDefinition(category = "calendar-events", scope = ExtendedObjectClassDefinition.Scope.SYSTEM)
@Meta.OCD(
		id = "es.ehu.calendarevents.configuration.CalendarEventsConfiguration",
		localization = "content/Language",
		name = "calendar-events-name-configuration"
)
public interface CalendarEventsConfiguration {

	@Meta.AD(name = "calendario-configuration-idstructures", required = false, 
			description = "calendario-conf-id-structures-description")
	public String[] idStructures();			
	
	@Meta.AD( name = "calendario-configuration-idcategories", required = false, 
			description = "calendario-configuration-idcategories-description" )
	public String[] idCategories();	

}
<%@page import="com.liferay.portal.kernel.portlet.PortletURLUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="com.liferay.portal.kernel.search.Indexer"%>
<%@ page import="com.liferay.portal.kernel.search.IndexerRegistryUtil"%>
<%@ page import="com.liferay.portal.kernel.util.Tuple"%>
<%@ page import="com.liferay.portal.kernel.search.Hits" %>
<%@ page import="com.liferay.portal.kernel.search.Sort" %>
<%@ page import="com.liferay.portal.kernel.search.SortFactoryUtil" %>

<%@ page import="com.liferay.counter.kernel.service.CounterLocalServiceUtil" %>
<%@ page import="com.liferay.portal.kernel.exception.NoSuchUserException" %>

<%@ page import="com.liferay.portal.kernel.captcha.CaptchaTextException" %>
<%@ page import="com.liferay.portal.kernel.bean.BeanParamUtil" %>
<%@ page import="com.liferay.portal.kernel.bean.BeanPropertiesUtil" %>
<%@ page import="com.liferay.portal.kernel.cal.Recurrence" %>
<%@ page import="com.liferay.portal.kernel.configuration.Filter" %>
<%@ page import="com.liferay.portal.kernel.dao.orm.QueryUtil" %>
<%@ page import="com.liferay.portal.kernel.dao.search.DAOParamUtil" %>
<%@ page import="com.liferay.portal.kernel.dao.search.DisplayTerms" %>
<%@ page import="com.liferay.portal.kernel.dao.search.ResultRow" %>
<%@ page import="com.liferay.portal.kernel.dao.search.RowChecker" %>
<%@ page import="com.liferay.portal.kernel.dao.search.SearchContainer" %>
<%@ page import="com.liferay.portal.kernel.dao.search.SearchEntry" %>

<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>
<%@ page import="com.liferay.portal.kernel.exception.SystemException" %>
<%@ page import="com.liferay.portal.kernel.io.unsync.UnsyncStringReader" %>
<%@ page import="com.liferay.portal.kernel.json.JSONArray" %>
<%@ page import="com.liferay.portal.kernel.json.JSONFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.json.JSONObject" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageWrapper" %>
<%@ page import="com.liferay.portal.kernel.language.UnicodeLanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.log.Log" %>
<%@ page import="com.liferay.portal.kernel.log.LogFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.log.LogUtil" %>
<%@ page import="com.liferay.portal.kernel.messaging.DestinationNames" %>
<%@ page import="com.liferay.portal.kernel.messaging.MessageBusUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.DynamicRenderRequest" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayPortletMode" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayPortletRequest" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayPortletResponse" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayPortletURL" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayWindowState" %>
<%@ page import="com.liferay.portal.kernel.search.Field" %>
<%@ page import="com.liferay.portal.kernel.servlet.BrowserSnifferUtil" %>
<%@ page import="com.liferay.portal.kernel.servlet.ServletContextUtil" %>
<%@ page import="com.liferay.portal.kernel.servlet.SessionErrors" %>
<%@ page import="com.liferay.portal.kernel.servlet.SessionMessages" %>
<%@ page import="com.liferay.portal.kernel.util.ArrayUtil" %>
<%@ page import="com.liferay.portal.kernel.util.BooleanWrapper" %>
<%@ page import="com.liferay.portal.kernel.util.CalendarFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.util.CalendarUtil" %>
<%@ page import="com.liferay.petra.string.CharPool" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ContentTypes" %>
<%@ page import="com.liferay.portal.kernel.util.DateFormatFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.util.DateUtil" %>
<%@ page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.util.FileUtil" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Http" %>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="com.liferay.portal.kernel.util.IntegerWrapper" %>
<%@ page import="com.liferay.portal.kernel.util.JavaConstants" %>
<%@ page import="com.liferay.portal.kernel.util.KeyValuePair" %>
<%@ page import="com.liferay.portal.kernel.util.KeyValuePairComparator" %>
<%@ page import="com.liferay.portal.kernel.util.ListUtil" %>
<%@ page import="com.liferay.portal.kernel.util.LocaleUtil" %>
<%@ page import="com.liferay.portal.kernel.util.LocalizationUtil" %>
<%@ page import="com.liferay.portal.kernel.util.LongWrapper" %>
<%@ page import="com.liferay.portal.kernel.util.MathUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ObjectValuePair" %>
<%@ page import="com.liferay.portal.kernel.util.ObjectValuePairComparator" %>
<%@ page import="com.liferay.portal.kernel.util.OrderByComparator" %>
<%@ page import="com.liferay.portal.kernel.util.OrderedProperties" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PrefsParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropertiesParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropertiesUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropsKeys" %>

<%@ page import="com.liferay.portal.kernel.util.ReleaseInfo" %>
<%@ page import="com.liferay.portal.kernel.util.ServerDetector" %>
<%@ page import="com.liferay.portal.kernel.util.SetUtil" %>

<%@ page import="com.liferay.portal.kernel.util.StackTraceUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringBundler" %>
<%@ page import="com.liferay.portal.kernel.util.StringComparator" %>
<%@ page import="com.liferay.petra.string.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Time" %>
<%@ page import="com.liferay.portal.kernel.util.TimeZoneUtil" %>
<%@ page import="com.liferay.portal.kernel.util.UnicodeFormatter" %>
<%@ page import="com.liferay.portal.kernel.util.UnicodeProperties" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.kernel.workflow.WorkflowConstants" %>
<%@ page import="com.liferay.portal.kernel.model.*" %>
<%@ page import="com.liferay.portal.kernel.model.impl.*" %>
<%@ page import="com.liferay.portal.kernel.security.auth.AuthTokenUtil" %>
<%@ page import="com.liferay.portal.kernel.security.auth.PrincipalException" %>
<%@ page import="com.liferay.portal.kernel.security.permission.ActionKeys" %>
<%@ page import="com.liferay.portal.kernel.security.permission.PermissionChecker" %>
<%@ page import="com.liferay.portal.kernel.service.*" %>
<%@ page import="com.liferay.portal.kernel.service.permission.GroupPermissionUtil" %>
<%@ page import="com.liferay.portal.kernel.service.permission.LayoutPermissionUtil" %>
<%@ page import="com.liferay.portal.kernel.service.permission.LayoutPrototypePermissionUtil" %>
<%@ page import="com.liferay.portal.kernel.service.permission.LayoutSetPrototypePermissionUtil" %>
<%@ page import="com.liferay.portal.kernel.service.permission.PortletPermissionUtil" %>
<%@ page import="com.liferay.portal.kernel.theme.PortletDisplay" %>
<%@ page import="com.liferay.portal.kernel.theme.ThemeDisplay" %>
<%@ page import="com.liferay.portal.kernel.util.Portal" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PortletCategoryKeys" %>
<%@ page import="com.liferay.portal.kernel.util.PortletKeys" %>
<%@ page import="com.liferay.portal.kernel.util.SessionClicks" %>
<%@ page import="com.liferay.portal.kernel.util.comparator.PortletCategoryComparator" %>
<%@ page import="com.liferay.portal.kernel.util.comparator.PortletTitleComparator" %>
<%@ page import="com.liferay.portal.kernel.portlet.InvokerPortlet" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortalPreferences" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletConfigFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletInstanceFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletURLUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.UserAttributes" %>




<%@ page import="java.io.Serializable" %>

<%@ page import="java.math.BigDecimal" %>

<%@ page import="java.net.InetAddress" %>
<%@ page import="java.net.UnknownHostException" %>

<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.text.MessageFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.MissingResourceException" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Stack" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.TreeSet" %>

<%@ page import="javax.portlet.MimeResponse" %>
<%@ page import="javax.portlet.PortletConfig" %>
<%@ page import="javax.portlet.PortletContext" %>
<%@ page import="javax.portlet.PortletException" %>
<%@ page import="javax.portlet.PortletMode" %>
<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="javax.portlet.PortletRequest" %>
<%@ page import="javax.portlet.PortletResponse" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.PortletURL" %>
<%@ page import="javax.portlet.RenderRequest" %>
<%@ page import="javax.portlet.RenderResponse" %>
<%@ page import="javax.portlet.ResourceURL" %>
<%@ page import="javax.portlet.UnavailableException" %>
<%@ page import="javax.portlet.ValidatorException" %>
<%@ page import="javax.portlet.WindowState" %>

<%@page import="com.liferay.portal.kernel.util.WebKeys"%>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%

/**
 * UPV/EHU
 *	Se sobreescribe con el contenido de /portlet/init.jsp de la version 6.2   
 */

PortletMode portletMode = liferayPortletRequest.getPortletMode();
WindowState windowState = liferayPortletRequest.getWindowState();

PortletURL currentURLObj = PortletURLUtil.getCurrent(liferayPortletRequest, liferayPortletResponse);

String currentURL = currentURLObj.toString();
%>


package es.ehu.editor.ckeditor.web.dynamicinclude;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.taglib.DynamicInclude;
import com.liferay.portal.kernel.util.StringUtil;


@Component(
	immediate = true,
	service = DynamicInclude.class
)
public class ResourcesJSPDynamicInclude implements DynamicInclude {
	
	private static final Log _log = LogFactoryUtil.getLog(ResourcesJSPDynamicInclude.class);
	
	@Override
	public void include(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, String key) throws IOException {
		final String ckeditor_additionalResources = StringUtil.read(this.getClass().getClassLoader().getResourceAsStream("META-INF/resources/ckeditor_additionalResources.html"));
		final PrintWriter printWriter = httpServletResponse.getWriter();
		printWriter.println(ckeditor_additionalResources);
	}

	@Override
	public void register(DynamicIncludeRegistry dynamicIncludeRegistry) {
		dynamicIncludeRegistry.register("com.liferay.frontend.editor.ckeditor.web#ckeditor#additionalResources");
	}
}

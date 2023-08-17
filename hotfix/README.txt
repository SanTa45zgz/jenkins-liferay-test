
Los jar se encuentran en la siguiente ubicación dentro del hotfix:
	- \binaries\MODULES_BASE_PATH\marketplace\Liferay Web Experience - Liferay Asset - Impl.lpkg\com.liferay.asset.publisher.web-VERSION.jar
	- \binaries\MODULES_BASE_PATH\marketplace\Liferay Forms and Workflow - Liferay Dynamic Data Mapping - API.lpkg\com.liferay.dynamic.data.mapping.service-VERSION.jar
	
En cada nuevo hotfix:
	- coger los nuevos .jar y ponerlos en esta carpeta ("wsliferay/hotfix")
	- borrar los viejos
	- modificar los "build.gradle" de los proyectos afectados en "wsliferay/ext", para que apunten a los nuevos .jar
	- modificar versión en fichero de configuración "es.ehu.bundle.blacklist.version.BundleBlacklistConfiguration.config"

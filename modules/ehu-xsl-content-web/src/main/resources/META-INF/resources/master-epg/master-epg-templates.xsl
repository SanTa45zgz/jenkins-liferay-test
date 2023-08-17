<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:ehu="http://www.ehu.eus" xmlns:exsl="http://exslt.org/common"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
	xmlns:propsUtil="com.liferay.portal.kernel.util.PropsUtil"
	xmlns:StringPool="com.liferay.portal.kernel.util.StringPool"
	exclude-result-prefixes="xalan"
	extension-element-prefixes="exsl languageUtil propsUtil StringPool xalan">

	<xsl:output method="xml" omit-xml-declaration="yes" />

	<xsl:variable name="master"
		select="ehu:app/ehu:masteres/ehu:master" />
	<xsl:variable name="asignatura"
		select="ehu:app/ehu:asignatura" />
	<xsl:variable name="profesor"
		select="ehu:app/ehu:profesor" />
	<xsl:variable name="anyoAcad"
		select="$master/ehu:anyoConsulta" />


	<xsl:template name="presentacion">
		<xsl:element name="div">
			<xsl:attribute name="class">bg-white p-20 ehu-sans</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:if
					test="$master/ehu:plazas/ehu:ofertadas and $master/ehu:plazas/ehu:ofertadas != 0">
					<xsl:element name="div">
						<xsl:attribute name="class">col-md-4</xsl:attribute>
						<h3>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.plazasOfertadas')" />
						</h3>
						<p>
							<xsl:value-of
								select="$master/ehu:plazas/ehu:ofertadas" />
						</p>
					</xsl:element>
				</xsl:if>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-4</xsl:attribute>
					<h3>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.modalidad')" />
					</h3>
					<p>
						<!-- Trello 615. Se pide mostrar la lista de modalidades completa -->
						<xsl:for-each select="$master/ehu:modalidadesImparticion/ehu:modalidadImparticion">
							<xsl:value-of select="./ehu:descripcion" />
							<xsl:if test="position() != last()">
								<xsl:value-of select="$comma" />
								<xsl:value-of select="$white_space" />
							</xsl:if>
						</xsl:for-each>						
					</p>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-4</xsl:attribute>
					<h3>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.idioma')" />
					</h3>
					<xsl:element name="p">
						<xsl:for-each select="$master/ehu:idiomas/ehu:idioma">
							<xsl:value-of select="." />
							<xsl:if test="position() != last()">
								<xsl:value-of select="$comma" />
								<xsl:value-of select="$white_space" />
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-4</xsl:attribute>
					<h3>
						<xsl:value-of
							select="languageUtil:get($locale,'credits')" />
					</h3>
					<p>
						<xsl:value-of
							select="format-number($master/ehu:numCredMaster,'###')" />
					</p>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-4</xsl:attribute>
					<h3>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.duration')" />
					</h3>
					<xsl:choose>
						<xsl:when
							test="$master/ehu:desDedicacion = languageUtil:get($locale,'upv-ehu.masters.service.partial')">
							<xsl:variable name="numCursos"
								select="format-number($master/ehu:numCredMaster div 30, '#.###,#', 'european')"></xsl:variable>
							<xsl:choose>
								<xsl:when test="$numCursos = 1">
									<p>
										<xsl:value-of select="$numCursos" />
										<xsl:value-of select="$white_space" />
										<xsl:value-of
											select="translate(languageUtil:get($locale,'ehu.curso'), $upper, $lower)" />
									</p>
								</xsl:when>
								<xsl:otherwise>
									<p>
										<xsl:value-of select="$numCursos" />
										<xsl:value-of select="$white_space" />
										<xsl:value-of
											select="translate(languageUtil:get($locale,'upv-ehu.masters.home.numCursos'), $upper, $lower)" />
									</p>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="numCursos"
								select="format-number($master/ehu:numCredMaster div 60, '#.###,#', 'european')"></xsl:variable>
							<xsl:choose>
								<xsl:when test="$numCursos = 1">
									<p>
										<xsl:value-of select="$numCursos" />
										<xsl:value-of select="$white_space" />
										<xsl:value-of
											select="translate(languageUtil:get($locale,'ehu.curso'), $upper, $lower)" />
									</p>
								</xsl:when>
								<xsl:otherwise>
									<p>
										<xsl:value-of select="$numCursos" />
										<xsl:value-of select="$white_space" />
										<xsl:value-of
											select="translate(languageUtil:get($locale,'upv-ehu.masters.home.numCursos'), $upper, $lower)" />
									</p>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
								 
				<xsl:choose>
					<xsl:when test="$master/ehu:mostrarPrecio='0'">
						<xsl:element name="div">
							<xsl:attribute name="class">col-md-4</xsl:attribute>
							<h3>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')" />
							</h3>
							<p>(*)</p>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if
							test="$master/ehu:precios/ehu:precio[ehu:tipo='ACAD']">
							<xsl:element name="div">
								<xsl:attribute name="class">col-md-4</xsl:attribute>
								<h3>
									<xsl:value-of
										select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')" />
								</h3>
								<xsl:variable name="precioFinalMaster"
									select="$master/ehu:numCredMaster * $master/ehu:precios/ehu:precio[ehu:tipo='ACAD' and ehu:vecesMatricula='1']/ehu:precio + sum($master/ehu:precios/ehu:precio[ehu:tipo='ADMIN']/ehu:precio)" />
								<p>
									<xsl:value-of
										select="format-number(round($precioFinalMaster div 100) * 100, '#.###,#', 'european')" />
									<xsl:value-of select="$white_space" />
									€
								</p>
							</xsl:element>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				 
			</xsl:element>

			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-12</xsl:attribute>
					<xsl:choose>
						<xsl:when
							test="$master[ehu:organizacion='C'] and languageUtil:getLanguageId($locale)='en_GB'">
							<h3>
								<xsl:value-of select="$master/ehu:textoInteruniv" />
							</h3>
						</xsl:when>
						<xsl:when test="$master[ehu:organizacion='C']">
							<h3>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.masterInter')" />
							</h3>
						</xsl:when>
						<xsl:otherwise>
							<h3>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.lugarImparticion')" />
							</h3>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each
						select="$master/ehu:lugaresImparticion/ehu:lugarImparticion">
						<p>
							<xsl:value-of select="ehu:desLugar"></xsl:value-of>
						</p>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>

			<h3>
				<xsl:value-of
					select="languageUtil:get($locale,'ehu.contacto')" />
			</h3>
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<p>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.responsableMaster')" />
						:
						<br />
						<xsl:value-of
							select="$master/ehu:responsable/ehu:nombre" />
						<br />
						<xsl:if
							test="$master/ehu:responsable/ehu:contacto/ehu:mail">
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of
									select="$master/ehu:responsable/ehu:contacto/ehu:mail" /></xsl:attribute>
								<xsl:attribute name="class">email-icon</xsl:attribute>
								<xsl:value-of
									select="$master/ehu:responsable/ehu:contacto/ehu:mail" />
							</xsl:element>
						</xsl:if>
					</p>
				</xsl:element>

				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<p>
						<xsl:value-of
							select="languageUtil:get($locale,'upv-ehu.masters.home.secretary')" />
						:
						<br />
						<xsl:value-of
							select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:nombre" />
						<br />
						<xsl:if
							test="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail">
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of
									select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail" /></xsl:attribute>
								<xsl:attribute name="class">email-icon</xsl:attribute>
								<xsl:value-of
									select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail" />
							</xsl:element>
						</xsl:if>
						<xsl:for-each
							select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:tfno">
							<br />
							<xsl:element name="a">
								<xsl:attribute name="href">tel:<xsl:value-of
									select="." /></xsl:attribute>
								<xsl:value-of select="." />
							</xsl:element>
						</xsl:for-each>
					</p>
				</xsl:element>
			</xsl:element>

			<xsl:if
				test="$master[ehu:organizacion='C'] and $master/ehu:responsable/ehu:contacto/ehu:web">
				<h3>WEB</h3>
				<xsl:element name="div">
					<xsl:attribute name="class">row</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">col-12</xsl:attribute>
						<xsl:element name="a">
							<xsl:attribute name="href"><xsl:value-of
								select="$master/ehu:responsable/ehu:contacto/ehu:web" /></xsl:attribute>
							<xsl:value-of
								select="$master/ehu:responsable/ehu:contacto/ehu:web" />
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>

		</xsl:element>
	</xsl:template>


	<xsl:template name="perfilAcceso">
		<h2>
			<xsl:value-of
				select="languageUtil:get($locale,'upv-ehu.masters.registration.title')" />
		</h2>

		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="h3">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:value-of
						select="languageUtil:get($locale,'ehu.valoracionMeritos')" />
				</xsl:element>

				<xsl:element name="ul">
					<xsl:attribute name="class">list-check</xsl:attribute>
					<xsl:for-each
						select="$master/ehu:valoracionesMeritos/ehu:valoracionMerito">
						<li>
							<strong>
								<xsl:value-of select="ehu:desCriterio" />
								:
							</strong>
							<xsl:value-of select="ehu:desDetalle" />
							(
							<xsl:value-of select="ehu:desValoracion" />
							)
						</li>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="h3">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:value-of
						select="languageUtil:get($locale,'upv-ehu.masters.registration.access-titles')" />
				</xsl:element>

				<xsl:element name="ul">
					<xsl:attribute name="class">list-check</xsl:attribute>
					<xsl:for-each
						select="$master/ehu:titulacionesAcceso/ehu:titulacionAcceso">
						<li>
							<xsl:value-of select="." />
						</li>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="programaFormativo">
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="id">myToggler</xsl:attribute>
					<xsl:element name="h2">
						<xsl:attribute name="class">header toggler-header toggler-header-expanded</xsl:attribute>
						<xsl:attribute name="aria-controls">sect01Carga</xsl:attribute>
						<xsl:attribute name="id">accordion01Carga</xsl:attribute>
						<xsl:attribute name="aria-disabled">true</xsl:attribute>
						<xsl:value-of
							select="languageUtil:get($locale,'upv-ehu.masters.registration.teaching-load')" />
						<xsl:element name="span">
							<xsl:attribute name="tabindex">0</xsl:attribute>
							<xsl:element name="span">
								<xsl:attribute name="class">hide-accessible</xsl:attribute>
								toggle-navigation
							</xsl:element>
						</xsl:element>
					</xsl:element>

					<xsl:element name="div">
						<xsl:attribute name="class">content toggler-content toggler-content-expanded caja-sin-padding</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
							<xsl:attribute name="role">region</xsl:attribute>
							<xsl:attribute name="id">sect01Carga</xsl:attribute>
							<xsl:attribute name="aria-labelledby">accordion01Carga</xsl:attribute>
							<xsl:element name="table">
								<xsl:attribute name="class">table table-hover</xsl:attribute>
								<caption>
									<xsl:value-of
										select="languageUtil:get($locale,'upv-ehu.masters.registration.teaching-load')" />
								</caption>
								<thead>
									<tr>
										<th>
											<xsl:value-of
												select="languageUtil:get($locale,'ehu.numCredOblig')" />
										</th>
										<th>
											<xsl:value-of
												select="languageUtil:get($locale,'ehu.numCredOpta')" />
										</th>
										<th>
											<xsl:value-of
												select="languageUtil:get($locale,'upv-ehu.masters.practices.tfm')" />
										</th>
										<xsl:if
											test="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='4']">
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'upv-ehu.masters.practices.internships')" />
											</th>
										</xsl:if>
										<th>
											<xsl:value-of
												select="languageUtil:get($locale,'ehu.total')" />
										</th>
									</tr>
								</thead>
								<tbody>
									<!-- Pintamos el orden del título según el idioma -->

									<!-- Euskera & English -->
									<xsl:if
										test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
										<tr>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredOblig,'###.#')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
											</td>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredOpta,'###.#')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
											</td>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredPrac,'###.#')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
											</td>


											<xsl:if
												test="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='4']">
												<td>
													<xsl:value-of
														select="format-number($master/ehu:numCredPracticum,'###.#')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
												</td>
											</xsl:if>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredMaster,'###.#')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
											</td>
										</tr>
									</xsl:if>

									<!-- Castellano & Francais -->
									<xsl:if
										test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
										<tr>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredOblig,'###.#')" />
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
											</td>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredOpta,'###.#')" />
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
											</td>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredPrac,'###.#')" />
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
											</td>
											<xsl:if
												test="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='4']">
												<td>
													<xsl:value-of
														select="format-number($master/ehu:numCredPracticum,'###.#')" />
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
												</td>
											</xsl:if>
											<td>
												<xsl:value-of
													select="format-number($master/ehu:numCredMaster,'###.#')" />
												&#160;
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
												&#160;
												<xsl:element name="abbr">
													<xsl:attribute name="title"><xsl:value-of
														select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
													ECTS
												</xsl:element>
											</td>
										</tr>
									</xsl:if>
								</tbody>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					

					<!-- ***** Especialidades ***** -->		
					
					<!-- Comprobamos si hay especialidades -->
					<xsl:variable name="especialidadesEs"> 
		       			 <xsl:for-each select="$master/ehu:especialidades/ehu:especialidad">
		          			<xsl:if test="ehu:tipo = 'E' or ehu:tipo = 'e'">
		                		<xsl:copy-of select="current()"/>
		            		</xsl:if>
		        		</xsl:for-each>
		    		</xsl:variable>
					<xsl:variable name="especialidadesE_set" select="exsl:node-set($especialidadesEs)/*" />
					
					<xsl:if test="$especialidadesE_set">		
						<xsl:element name="h2">
							<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
							<xsl:attribute name="aria-controls">sect02Especialidad</xsl:attribute>
							<xsl:attribute name="id">accordion02Especialidad</xsl:attribute>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.especialidades')" />
							<xsl:element name="span">
								<xsl:attribute name="tabindex">0</xsl:attribute>
								<xsl:element name="span">
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									toggle-navigation
								</xsl:element>
							</xsl:element>
						</xsl:element>

						<xsl:element name="div">
							<xsl:attribute name="class">content toggler-content toggler-content-collapsed</xsl:attribute>
							<xsl:attribute name="role">region</xsl:attribute>
							<xsl:attribute name="id">sect02Especialidad</xsl:attribute>
							<xsl:attribute name="aria-labelledby">accordion02Especialidad</xsl:attribute>
							<xsl:element name="ul">
								<xsl:attribute name="class">list-check</xsl:attribute>
								<xsl:for-each
									select="$master/ehu:especialidades/ehu:especialidad">
									<!-- bczgalee: incidencia Jira IOJ-117 -->
									<!-- pintamos solo las especialidades, no los itinerarios -->
									<xsl:if test="ehu:tipo = 'E' or ehu:tipo = 'e'">
									<!-- <xsl:if test="$master/ehu:especialidades/ehu:especialidad[ehu:tipo='E']"> -->
									
										<li>
											<xsl:value-of select="ehu:descripcion" />
											(
											<xsl:value-of
												select="languageUtil:get($locale,'ehu.credits')" />
											:
											<xsl:value-of
												select="format-number(ehu:minCredSuperar,'###.#')" />
											<xsl:element name="abbr">
												<xsl:attribute name="title"><xsl:value-of
													select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
												ECTS
											</xsl:element>
											)
										</li>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					
					<!-- ***** Itinerarios ***** -->
					
					<!-- Sacamos la lista de los itinerarios -->
					<xsl:variable name="especialidadesIt"> 
		       			 <xsl:for-each select="$master/ehu:especialidades/ehu:especialidad">
		          			<xsl:if test="ehu:tipo = 'I' or ehu:tipo = 'i'">
		                		<xsl:copy-of select="current()"/>
		            		</xsl:if>
		        		</xsl:for-each>
		    		</xsl:variable>
					<xsl:variable name="especialidadesI_set" select="exsl:node-set($especialidadesIt)/*" />
					
					<!-- Si existen itinerarios los pintamos -->
					<xsl:if test="$especialidadesI_set">
						<xsl:element name="h2">
							<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
							<xsl:attribute name="aria-controls">sect02Itinerario</xsl:attribute>
							<xsl:attribute name="id">accordion02Itinerario</xsl:attribute>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.itinerarios')" />
							<xsl:element name="span">
								<xsl:attribute name="tabindex">0</xsl:attribute>
								<xsl:element name="span">
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									toggle-navigation
								</xsl:element>
							</xsl:element>
						</xsl:element>

						<xsl:element name="div">
							<xsl:attribute name="class">content toggler-content toggler-content-collapsed</xsl:attribute>
							<xsl:attribute name="role">region</xsl:attribute>
							<xsl:attribute name="id">sect02Itinerario</xsl:attribute>
							<xsl:attribute name="aria-labelledby">accordion02Itinerarios</xsl:attribute>
							<xsl:element name="ul">
								<xsl:attribute name="class">list-check</xsl:attribute>
								<xsl:for-each
									select="$master/ehu:especialidades/ehu:especialidad">
									<!-- bczgalee: incidencia Jira IOJ-117 -->
									<!-- pintamos solo los itineraios -->
									<xsl:if test="ehu:tipo = 'I' or ehu:tipo = 'i'">
										<li>
											<xsl:value-of select="ehu:descripcion" />
											(
											<xsl:value-of
												select="languageUtil:get($locale,'ehu.credits')" />
											:
											<xsl:value-of
												select="format-number(ehu:minCredSuperar,'###.#')" />
											<xsl:element name="abbr">
												<xsl:attribute name="title"><xsl:value-of
													select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
												ECTS
											</xsl:element>
											)
										</li>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>					
					

					<xsl:element name="h2">
						<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
						<xsl:attribute name="aria-controls">sect03Programa</xsl:attribute>
						<xsl:attribute name="id">accordion03Programa</xsl:attribute>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.program')" />
						<xsl:element name="span">
							<xsl:attribute name="tabindex">0</xsl:attribute>
							<xsl:element name="span">
								<xsl:attribute name="class">hide-accessible</xsl:attribute>
								toggle-navigation
							</xsl:element>
						</xsl:element>
					</xsl:element>

					<xsl:element name="div">
						<xsl:attribute name="class">content toggler-content toggler-content-collapsed caja-sin-padding</xsl:attribute>
						<xsl:attribute name="role">region</xsl:attribute>
						<xsl:attribute name="id">sect03Programa</xsl:attribute>
						<xsl:attribute name="aria-labelledby">accordion03Programa</xsl:attribute>

						<xsl:if
							test="$master/ehu:asignaturas/ehu:asignatura[ehu:desClase=languageUtil:get($locale,'ehu.obligatoria.literal') and ehu:tipoAsignatura!='3' and ehu:tipoAsignatura!='4']">
							<xsl:element name="h3">
								<xsl:attribute name="class">p-20</xsl:attribute>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.numCredOblig')" />
							</xsl:element>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<caption>
										<xsl:value-of
											select="languageUtil:get($locale,'ehu.numCredOblig')" />
									</caption>
									<thead>
										<tr>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.materia')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.idiomas')" />
											</th>

											<!-- Pintamos el orden del título según el idioma -->
											<!-- Euskera & English -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
												<th>
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
												</th>
											</xsl:if>
											<!-- Castellano & Francais -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
												<th>
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
												</th>
											</xsl:if>

											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'upv-ehu.masters.syllabus.especialidades')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.sedeImparticion')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.modalidad')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$master/ehu:asignaturas/ehu:asignatura[ehu:desClase=languageUtil:get($locale,'ehu.obligatoria.literal') and ehu:tipoAsignatura!='3' and ehu:tipoAsignatura!='4']">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of
															select="languageUtil:get($locale,'upv-ehu.masters.url.subject')" />?p_anyo_ofd=<xsl:value-of
															select="ehu:anyoOfd" />&amp;p_anyo_pop=<xsl:value-of
															select="ehu:anyoPop" />&amp;p_cod_centro=<xsl:value-of
															select="ehu:codCentro" />&amp;p_cod_materia=<xsl:value-of
															select="ehu:codMateria" />&amp;p_cod_asignatura=<xsl:value-of
															select="ehu:codAsignatura" />&amp;p_tipo_asignatura=<xsl:value-of
															select="ehu:tipoAsignatura" />
													</xsl:attribute>
														<xsl:value-of select="ehu:desAsignatura" />
													</xsl:element>
												</td>
												<td>
													<xsl:for-each select="ehu:idiomas/ehu:idioma">
														<xsl:value-of select="." />
														<xsl:if test="position() != last()">
															,
															<xsl:value-of select="$white_space" />
														</xsl:if>
													</xsl:for-each>
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:numCreditos,'###.#')" />
												</td>
												<td>
													<xsl:choose>
														<xsl:when
															test="ehu:especialidades/ehu:especialidad/ehu:descripcion">
															<xsl:value-of
																select="ehu:especialidades/ehu:especialidad/ehu:descripcion" />
														</xsl:when>
														<xsl:otherwise>
															--
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:for-each
														select="ehu:sedesImparticion/ehu:lugarImparticion">
														<div>
															<xsl:value-of select="ehu:desEntidad" />
															(
															<xsl:value-of select="ehu:desLugar" />
															)
														</div>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each
														select="ehu:modalidadesImparticion/ehu:modalidadImparticion">
														<div>
															<xsl:value-of select="ehu:descripcion" />
														</div>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<xsl:if
							test="$master/ehu:asignaturas/ehu:asignatura[ehu:desClase=languageUtil:get($locale,'ehu.optativa.literal') and ehu:indCf='0']">
							<xsl:element name="h3">
								<xsl:attribute name="class">p-20</xsl:attribute>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.numCredOpta')" />
							</xsl:element>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<caption>
										<xsl:value-of
											select="languageUtil:get($locale,'ehu.numCredOpta')" />
									</caption>
									<thead>
										<tr>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.materia')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.idiomas')" />
											</th>
											<!-- Pintamos el orden del título según el idioma -->
											<!-- Euskera & English -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
												<th>
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
												</th>
											</xsl:if>
											<!-- Castellano & Francais -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
												<th>
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
												</th>
											</xsl:if>
											<!-- <th><xsl:value-of select="languageUtil:get($locale,'ehu.credits')"/> 
												<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> 
												ECTS</xsl:element></th> -->
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'upv-ehu.masters.syllabus.especialidades')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.sedeImparticion')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.modalidad')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$master/ehu:asignaturas/ehu:asignatura[ehu:desClase=languageUtil:get($locale,'ehu.optativa.literal') and ehu:indCf='0']">
											<xsl:sort
												select="ehu:especialidades/ehu:especialidad/ehu:descripcion"
												order="descending" />
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of
															select="languageUtil:get($locale,'upv-ehu.masters.url.subject')" />?p_anyo_ofd=<xsl:value-of
															select="ehu:anyoOfd" />&amp;p_anyo_pop=<xsl:value-of
															select="ehu:anyoPop" />&amp;p_cod_centro=<xsl:value-of
															select="ehu:codCentro" />&amp;p_cod_materia=<xsl:value-of
															select="ehu:codMateria" />&amp;p_cod_asignatura=<xsl:value-of
															select="ehu:codAsignatura" />&amp;p_tipo_asignatura=<xsl:value-of
															select="ehu:tipoAsignatura" />
													</xsl:attribute>
														<xsl:value-of select="ehu:desAsignatura" />
													</xsl:element>
												</td>
												<td>
													<xsl:for-each select="ehu:idiomas/ehu:idioma">
														<xsl:value-of select="." />
														<xsl:if test="position() != last()">
															,
															<xsl:value-of select="$white_space" />
														</xsl:if>
													</xsl:for-each>
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:numCreditos,'###.#')" />
												</td>
												<td>
													<xsl:choose>
														<xsl:when
															test="ehu:especialidades/ehu:especialidad/ehu:descripcion">
															<xsl:value-of
																select="ehu:especialidades/ehu:especialidad/ehu:descripcion" />
														</xsl:when>
														<xsl:otherwise>
															--
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:for-each
														select="ehu:sedesImparticion/ehu:lugarImparticion">
														<div>
															<xsl:value-of select="ehu:desEntidad" />
															(
															<xsl:value-of select="ehu:desLugar" />
															)
														</div>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each
														select="ehu:modalidadesImparticion/ehu:modalidadImparticion">
														<xsl:value-of select="ehu:descripcion" />
														<xsl:value-of select="$white_space" />
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<xsl:if
							test="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='3']">
							<xsl:element name="h3">
								<xsl:attribute name="class">p-20</xsl:attribute>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.practices.tfm')" />
							</xsl:element>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<caption>
										<xsl:value-of
											select="languageUtil:get($locale,'upv-ehu.masters.practices.tfm')" />
									</caption>
									<thead>
										<tr>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.materia')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.idiomas')" />
											</th>
											<!-- Pintamos el orden del título según el idioma -->
											<!-- Euskera & English -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
												<th>
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
												</th>
											</xsl:if>
											<!-- Castellano & Francais -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
												<th>
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
												</th>
											</xsl:if>
											<!-- <th><xsl:value-of select="languageUtil:get($locale,'ehu.credits')"/> 
												<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> 
												ECTS</xsl:element></th> -->
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'upv-ehu.masters.syllabus.especialidades')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.sedeImparticion')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.modalidad')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='3']">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of
															select="languageUtil:get($locale,'upv-ehu.masters.url.subject')" />?p_anyo_ofd=<xsl:value-of
															select="ehu:anyoOfd" />&amp;p_anyo_pop=<xsl:value-of
															select="ehu:anyoPop" />&amp;p_cod_centro=<xsl:value-of
															select="ehu:codCentro" />&amp;p_cod_asignatura=<xsl:value-of
															select="ehu:codAsignatura" />&amp;p_tipo_asignatura=<xsl:value-of
															select="ehu:tipoAsignatura" />
													</xsl:attribute>
														<!-- <xsl:attribute name="href">#descripcionTFM</xsl:attribute> -->
														<xsl:value-of select="ehu:desAsignatura" />
													</xsl:element>
												</td>
												<td>
													<xsl:for-each select="ehu:idiomas/ehu:idioma">
														<xsl:value-of select="." />
														<xsl:if test="position() != last()">
															,
															<xsl:value-of select="$white_space" />
														</xsl:if>
													</xsl:for-each>
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:numCreditos,'###.#')" />
												</td>
												<td>
													<xsl:choose>
														<xsl:when
															test="ehu:especialidades/ehu:especialidad/ehu:descripcion">
															<xsl:value-of
																select="ehu:especialidades/ehu:especialidad/ehu:descripcion" />
														</xsl:when>
														<xsl:otherwise>
															--
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:for-each
														select="ehu:sedesImparticion/ehu:lugarImparticion">
														<div>
															<xsl:value-of select="ehu:desLugar" />
														</div>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each
														select="ehu:modalidadesImparticion/ehu:modalidadImparticion">
														<div>
															<xsl:value-of select="ehu:descripcion" />
														</div>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<xsl:if
							test="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='4']">
							<xsl:element name="h3">
								<xsl:attribute name="class">p-20</xsl:attribute>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.practices.internships')" />
							</xsl:element>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<caption>
										<xsl:value-of
											select="languageUtil:get($locale,'upv-ehu.masters.practices.internships')" />
									</caption>
									<thead>
										<tr>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.materia')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.idiomas')" />
											</th>
											<!-- Pintamos el orden del título según el idioma -->
											<!-- Euskera & English -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
												<th>
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
													&#160;
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
												</th>
											</xsl:if>
											<!-- Castellano & Francais -->
											<xsl:if
												test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
												<th>
													<xsl:value-of
														select="languageUtil:get($locale,'ehu.credits')" />
													&#160;
													<xsl:element name="abbr">
														<xsl:attribute name="title"><xsl:value-of
															select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
														ECTS
													</xsl:element>
												</th>
											</xsl:if>
											<!-- <th><xsl:value-of select="languageUtil:get($locale,'ehu.credits')"/> 
												<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> 
												ECTS</xsl:element></th> -->
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'upv-ehu.masters.syllabus.especialidades')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.sedeImparticion')" />
											</th>
											<th>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.modalidad')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$master/ehu:asignaturas/ehu:asignatura[ehu:tipoAsignatura='4']">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of
															select="languageUtil:get($locale,'upv-ehu.masters.url.subject')" />?p_anyo_ofd=<xsl:value-of
															select="ehu:anyoOfd" />&amp;p_anyo_pop=<xsl:value-of
															select="ehu:anyoPop" />&amp;p_cod_centro=<xsl:value-of
															select="ehu:codCentro" />&amp;p_cod_asignatura=<xsl:value-of
															select="ehu:codAsignatura" />&amp;p_tipo_asignatura=<xsl:value-of
															select="ehu:tipoAsignatura" />
													</xsl:attribute>
														<xsl:value-of select="ehu:desAsignatura" />
													</xsl:element>
												</td>
												<td>
													<xsl:for-each select="ehu:idiomas/ehu:idioma">
														<xsl:value-of select="." />
														<xsl:if test="position() != last()">
															,
															<xsl:value-of select="$white_space" />
														</xsl:if>
													</xsl:for-each>
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:numCreditos,'###.#')" />
												</td>
												<td>
													<xsl:choose>
														<xsl:when
															test="ehu:especialidades/ehu:especialidad/ehu:descripcion">
															<xsl:value-of
																select="ehu:especialidades/ehu:especialidad/ehu:descripcion" />
														</xsl:when>
														<xsl:otherwise>
															--
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:for-each
														select="ehu:sedesImparticion/ehu:lugarImparticion">
														<div>
															<xsl:value-of select="ehu:desLugar" />
														</div>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each
														select="ehu:modalidadesImparticion/ehu:modalidadImparticion">
														<div>
															<xsl:value-of select="ehu:descripcion" />
														</div>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:if test="$master/ehu:cfFueraMaster">
			<xsl:element name="h2">
				<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
				<xsl:value-of
					select="languageUtil:get($locale,'ehu.xsl-content.master.complementos.fuera')" />
			</xsl:element>
			<xsl:element name="div">
				<xsl:attribute name="class">content toggler-content toggler-content-expanded caja-sin-padding</xsl:attribute>
				<xsl:call-template name="transform_text">
					<xsl:with-param name="text"
						select="$master/ehu:cfFueraMaster/ehu:texto" />
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>


	<xsl:template name="vistaAsignatura">
		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href">./<xsl:value-of
					select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>


		<xsl:choose>
			<xsl:when
				test="not($asignatura/ehu:desAsignatura) or $asignatura/ehu:desAsignatura=''">
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white p-20</xsl:attribute>
						<p>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.there-is-no-information-for-this-section')" />
						</p>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>

				<h1>
					<xsl:value-of select="$asignatura/ehu:desAsignatura" />
				</h1>

				<!-- Datos generales de la materia -->
				<xsl:if
					test="$asignatura/ehu:modalidadesImparticion or $asignatura/ehu:idiomas">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white asignaturacontenido p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.datosGeneralMater')" />
							</h2>
							<dl>
								<xsl:if test="$asignatura/ehu:modalidadesImparticion">
									<dt>
										<xsl:value-of
											select="languageUtil:get($locale,'ehu.modalidad')" />
									</dt>
									<xsl:for-each
										select="$asignatura/ehu:modalidadesImparticion/ehu:modalidadImparticion">
										<dd>
											<xsl:value-of select="ehu:descripcion" />
											<xsl:value-of select="$white_space" />
										</dd>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="$asignatura/ehu:idiomas">
									<dt>
										<xsl:value-of
											select="languageUtil:get($locale,'ehu.idioma')" />
									</dt>
									<xsl:for-each
										select="$asignatura/ehu:idiomas/ehu:idioma">
										<dd>
											<xsl:value-of select="." />
										</dd>
									</xsl:for-each>
								</xsl:if>
							</dl>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Descripcion y Contextualizacion de la Asignatura -->
				<xsl:if test="$asignatura/ehu:desContext">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.asigDescripcion')" />
							</h2>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text"
									select="$asignatura/ehu:desContext" />
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Profesorado -->
				<xsl:if test="$asignatura/ehu:profesorado/ehu:profesor">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.profesorado')" />
							</h2>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<thead>
										<tr>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.nombre')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.institucion')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.categoria')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.doctorDoctora')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.perfilDocente')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.area')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.emailCorto')" />
											</th>
										</tr>
									</thead>

									<tbody>
										<xsl:variable name="anyoOfd"
											select="$asignatura/ehu:anyoOfd" />
										<xsl:for-each
											select="$asignatura/ehu:profesorado/ehu:profesor">
											<tr>
												<td>
													<a>
														<!-- Se modificad la forma de acceder al nodo actual, ya que 
															daba errores <xsl:if test="current()[ehu:indUpv='1']"> -->
														<xsl:if test="self::node()[ehu:indUpv='1']">
															<xsl:attribute name="href">?p_redirect=consultaTutorias&amp;p_anyo_acad=<xsl:value-of
																select="$anyoOfd" />&amp;p_idp=<xsl:value-of
																select="ehu:idp" />
															</xsl:attribute>
														</xsl:if>
														<!-- Se modificad la forma de acceder al nodo actual, ya que 
															daba errores <xsl:if test="current()[ehu:indUpv='0']"> -->
														<xsl:if test="self::node()[ehu:indUpv='0']">
															<xsl:attribute name="href">?p_redirect=dameProfesorAjeno&amp;p_cod_master=<xsl:value-of
																select="$asignatura/ehu:codMaster" />&amp;p_idp=<xsl:value-of
																select="ehu:idp" />
															</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="ehu:nombre" />
													</a>
												</td>
												<td>
													<xsl:value-of select="ehu:desOrganismo" />
												</td>
												<td>
													<xsl:value-of select="ehu:desCategoria" />
												</td>
												<td>
													<xsl:value-of select="ehu:doctor" />
												</td>
												<td>
													<xsl:value-of select="ehu:bilingue" />
												</td>
												<td>
													<xsl:value-of select="ehu:desArea" />
												</td>
												<td>
													<xsl:value-of select="ehu:email" />
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Competencias -->
				<xsl:if test="$asignatura/ehu:competencias/ehu:competencia">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.competencias')" />
							</h2>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<thead>
										<tr>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.denominacion')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.Peso')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$asignatura/ehu:competencias/ehu:competencia">
											<tr>
												<td>
													<xsl:value-of select="ehu:descripcion" />
												</td>
												<td>
													<xsl:value-of select="ehu:peso" />
													%
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Tipos de docencia -->
				<xsl:if test="$asignatura/ehu:tiposDocencia/ehu:tipoDocencia">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.tiposDocencia')" />
							</h2>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<thead>
										<tr>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.type')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.horasPresenciales')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.horasNoPresenciales')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.horasTotales')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$asignatura/ehu:tiposDocencia/ehu:tipoDocencia">
											<tr>
												<td>
													<xsl:value-of
														select="ehu:desTipoGrupoPractico" />
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:horasPresencial,'###.#')" />
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:horasNoPresencial,'###.#')" />
												</td>
												<td>
													<xsl:value-of
														select="format-number(ehu:horasTotal,'###.#')" />
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Actividades formativas -->
				<xsl:if
					test="$asignatura/ehu:actividadesFormativas/ehu:actividadFormativa">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.actividadesFormativas')" />
							</h2>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<thead>
										<tr>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.denominacion')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.Horas')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.porcentajePresencialidad')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$asignatura/ehu:actividadesFormativas/ehu:actividadFormativa">
											<tr>
												<td>
													<xsl:value-of select="ehu:descripcion" />
												</td>
												<td>
													<xsl:value-of select="ehu:numHoras" />
												</td>
												<td>
													<xsl:value-of select="ehu:presencialidad" />
													%
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Sistemas de evaluación -->
				<xsl:if
					test="$asignatura/ehu:sistemasEvaluacionFormativas/ehu:sistemaEvaluacion">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.sistemasEvaluacion')" />
							</h2>

							<xsl:element name="div">
								<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
								<xsl:element name="table">
									<xsl:attribute name="class">table table-hover</xsl:attribute>
									<thead>
										<tr>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.denominacion')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.ponderacionMinima')" />
											</th>
											<th>
												<xsl:attribute name="scope">col</xsl:attribute>
												<xsl:value-of
													select="languageUtil:get($locale,'ehu.ponderacionMaxima')" />
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each
											select="$asignatura/ehu:sistemasEvaluacionFormativas/ehu:sistemaEvaluacion">
											<tr>
												<td>
													<xsl:value-of select="ehu:descripcion" />
												</td>
												<td>
													<xsl:value-of select="ehu:minPonderacion" />
													%
												</td>
												<td>
													<xsl:value-of select="ehu:maxPonderacion" />
													%
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Resultado de aprendizaje -->
				<xsl:if test="$asignatura/ehu:resulAprendizaje">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.syllabus.outcomes')" />
							</h2>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text"
									select="$asignatura/ehu:resulAprendizaje" />
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Convocatoria Ordinaria: orientaciones y renuncia -->
				<xsl:if test="$asignatura/ehu:infoEvalua">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.asigConvocatoriaOrdin')" />
							</h2>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text"
									select="$asignatura/ehu:infoEvalua" />
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Convocatoria Extraordinaria: orientaciones y renuncia -->
				<xsl:if test="$asignatura/ehu:convExtra">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.asigConvocatoriaExtra')" />
							</h2>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text"
									select="$asignatura/ehu:convExtra" />
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Temario -->
				<xsl:if test="$asignatura/ehu:temario/ehu:tema">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.temary')" />
							</h2>

							<xsl:choose>
								<xsl:when
									test="$asignatura/ehu:temario/ehu:tema/ehu:descripcionClob">
									<xsl:call-template name="transform_text">
										<xsl:with-param name="text"
											select="$asignatura/ehu:temario/ehu:tema/ehu:descripcionClob" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each
										select="$asignatura/ehu:temario/ehu:tema">
										<xsl:if test="ehu:denominacion">
											<xsl:value-of select="ehu:denominacion" />
										</xsl:if>
										<xsl:call-template name="transform_text">
											<xsl:with-param name="text"
												select="ehu:descripcion" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:element>
					</xsl:element>
				</xsl:if>

				<!-- Bibliografía -->
				<xsl:if test="$asignatura/ehu:bibliografia">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<h2>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.bibliography')" />
							</h2>

							<xsl:if
								test="$asignatura/ehu:bibliografia/ehu:materialOblig">
								<h4>
									<xsl:value-of
										select="languageUtil:get($locale,'ehu.asigMateriales')" />
								</h4>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text"
										select="$asignatura/ehu:bibliografia/ehu:materialOblig" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="$asignatura/ehu:bibliografia/ehu:biblioBasica">
								<h4>
									<xsl:value-of
										select="languageUtil:get($locale,'ehu.bibliografiaBasica')" />
								</h4>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text"
										select="$asignatura/ehu:bibliografia/ehu:biblioBasica" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="$asignatura/ehu:bibliografia/ehu:biblioProfun">
								<h4>
									<xsl:value-of
										select="languageUtil:get($locale,'ehu.biblioProfun')" />
								</h4>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text"
										select="$asignatura/ehu:bibliografia/ehu:biblioProfun" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$asignatura/ehu:bibliografia/ehu:revistas">
								<h4>
									<xsl:value-of
										select="languageUtil:get($locale,'ehu.revistas')" />
								</h4>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text"
										select="$asignatura/ehu:bibliografia/ehu:revistas" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="$asignatura/ehu:bibliografia/ehu:direccionesInternet">
								<h4>
									<xsl:value-of
										select="languageUtil:get($locale,'ehu.links')" />
								</h4>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text"
										select="$asignatura/ehu:bibliografia/ehu:direccionesInternet" />
								</xsl:call-template>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:if>

			</xsl:otherwise>
		</xsl:choose>






	</xsl:template>


	<xsl:template name="metodologiaYevaluacion">
		<xsl:choose>
			<xsl:when
				test="$master/ehu:metodologia and $master/ehu:procedimientos">
				<xsl:element name="div">
					<xsl:attribute name="class">row m-b-30 row-eq-height</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">col-md-6 bg-white p-20</xsl:attribute>
						<h2>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.metodologia')" />
						</h2>
						<xsl:call-template name="transform_text">
							<xsl:with-param name="text"
								select="$master/ehu:metodologia" />
						</xsl:call-template>
					</xsl:element>

					<xsl:element name="div">
						<xsl:attribute name="class">col-md-6 bg-white p-20</xsl:attribute>
						<h2>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.evaluacion')" />
						</h2>
						<xsl:call-template name="transform_text">
							<xsl:with-param name="text"
								select="$master/ehu:procedimientos" />
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$master/ehu:procedimientos">
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30 row-eq-height</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white p-20</xsl:attribute>
						<h2>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.evaluacion')" />
						</h2>
						<xsl:call-template name="transform_text">
							<xsl:with-param name="text"
								select="$master/ehu:procedimientos" />
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$master/ehu:metodologia">
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30 row-eq-height</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white p-20</xsl:attribute>
						<h2>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.metodologia')" />
						</h2>
						<xsl:call-template name="transform_text">
							<xsl:with-param name="text"
								select="$master/ehu:metodologia" />
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:when>
		</xsl:choose>


	</xsl:template>


	<xsl:template name="descripcionTFM">
		<xsl:element name="div">
			<xsl:attribute name="id">descripcionTFM</xsl:attribute>
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:attribute name="style">margin-top:-40px;</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:attribute name="class">list-check</xsl:attribute>
					<li>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.number-of-credits')" />
						<xsl:element name="abbr">
							<xsl:attribute name="title"><xsl:value-of
								select="languageUtil:get($locale,'ehu.title.ects')" /></xsl:attribute>
							ECTS
						</xsl:element>
						:
						<xsl:value-of
							select="format-number($master/ehu:numCredPrac,'###.#')"></xsl:value-of>
					</li>
					<li>
						<xsl:element name="a">
							<xsl:attribute name="href">./<xsl:value-of
								select="languageUtil:get($locale,'upv-ehu.masters.url.thesis-teachers')" /></xsl:attribute>
							<xsl:value-of
								select="languageUtil:get($locale,'upv-ehu.masters.syllabus.tfm-teachers')" />
						</xsl:element>
					</li>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="listaProfesorado">
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:attribute name="class">list-links</xsl:attribute>

					<xsl:for-each
						select="$master/ehu:profesorado/ehu:profesor[ehu:indUpv='1' and ehu:esProfTfm!='1']">
						<xsl:sort select="ehu:nombre" />
						<li>
							<a>
								<xsl:attribute name="href">?p_redirect=consultaTutorias&amp;p_anyo_acad=<xsl:value-of
									select="$anyoAcad" />&amp;p_idp=<xsl:value-of
									select="ehu:idp" />
							</xsl:attribute>
								<xsl:call-template name="CamelCase">
									<xsl:with-param name="text">
										<xsl:value-of select="ehu:nombre" />
									</xsl:with-param>
								</xsl:call-template>
							</a>
						</li>
					</xsl:for-each>

				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:if
			test="$master/ehu:profesorado/ehu:profesor[ehu:indUpv='0' and ehu:esProfTfm='0']">
			<h2>
				<xsl:value-of
					select="languageUtil:get($locale,'ehu.profesoradoAjeno')" />
			</h2>
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<xsl:element name="ul">
						<xsl:attribute name="class">list-links</xsl:attribute>
						<xsl:for-each
							select="$master/ehu:profesorado/ehu:profesor[ehu:indUpv='0' and ehu:esProfTfm='0']">
							<xsl:sort select="ehu:nombre" />
							<li>
								<a>
									<xsl:attribute name="href">?p_redirect=dameProfesorAjeno&amp;p_cod_master=<xsl:value-of
										select="$master/ehu:codMaster" />&amp;p_idp=<xsl:value-of
										select="ehu:idp" />
								</xsl:attribute>
									<xsl:call-template name="CamelCase">
										<xsl:with-param name="text">
											<xsl:value-of select="ehu:nombre" />
										</xsl:with-param>
									</xsl:call-template>
								</a>
							</li>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>

		<xsl:if test="$master/ehu:comisiones">
			<h2>
				<xsl:value-of
					select="languageUtil:get($locale,'ehu.comision')" />
			</h2>
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<xsl:for-each
						select="$master/ehu:comisiones/ehu:comision">
						<xsl:element name="h3">
							<xsl:attribute name="class">titcomoh4</xsl:attribute>
							<xsl:value-of select="ehu:desComision"></xsl:value-of>
						</xsl:element>
						<br />
						<dl>
							<xsl:for-each
								select="$master/ehu:comisiones/ehu:comision/ehu:miembros/ehu:miembro">

								<dt>
									<xsl:value-of select="ehu:desCargo"></xsl:value-of>
									:
								</dt>
								<dd>
									<xsl:value-of select="ehu:nombre"></xsl:value-of>
								</dd>

							</xsl:for-each>
						</dl>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:if>

	</xsl:template>


	<xsl:template name="listaProfesoradoTFM">
		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href">./<xsl:value-of
					select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>

		<h2>
			<xsl:value-of
				select="languageUtil:get($locale,'upv-ehu.masters.syllabus.tfm-teachers')" />
		</h2>

		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:attribute name="class">list-links</xsl:attribute>
					<xsl:for-each
						select="$master/ehu:profesorado/ehu:profesor[ehu:esProfTfm='1']">
						<xsl:sort select="ehu:nombre" />
						<li>
							<a>
								<!-- Se modificad la forma de acceder al nodo actual, ya que daba 
									errores -->
								<!-- <xsl:if test="current()[ehu:indUpv='1']"> -->
								<xsl:if test="self::node()[ehu:indUpv='1']">
									<xsl:attribute name="href">?p_redirect=consultaTutorias&amp;p_anyo_acad=<xsl:value-of
										select="$master/ehu:anyoOfd" />&amp;p_idp=<xsl:value-of
										select="ehu:idp" />
								</xsl:attribute>
								</xsl:if>
								<!-- Se modificad la forma de acceder al nodo actual, ya que daba 
									errores -->
								<!--<xsl:if test="current()[ehu:indUpv='0']"> -->
								<xsl:if test="self::node()[ehu:indUpv='0']">
									<xsl:attribute name="href">?p_redirect=dameProfesorAjeno&amp;p_cod_master=<xsl:value-of
										select="$master/ehu:codMaster" />&amp;p_idp=<xsl:value-of
										select="ehu:idp" />
								</xsl:attribute>
								</xsl:if>
								<xsl:call-template name="CamelCase">
									<xsl:with-param name="text">
										<xsl:value-of select="ehu:nombre" />
									</xsl:with-param>
								</xsl:call-template>
							</a>
						</li>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="vistaProfesor">
		<xsl:param name="urlBack" />

		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of
					select="$urlBack" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>

		<h1>
			<xsl:value-of select="$profesor/ehu:nombre" />
		</h1>
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<dl>
					<dt>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.departamento')" />
					</dt>
					<dd>
						<xsl:value-of select="$profesor/ehu:desDpto" />
					</dd>
					<dt>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.email')" />
					</dt>
					<dd>
						<xsl:element name="a">
							<xsl:attribute name="href">mailto:<xsl:value-of
								select="$profesor/ehu:email" /></xsl:attribute>
							<xsl:attribute name="class">email-icon</xsl:attribute>
							<xsl:value-of select="$profesor/ehu:email" />
						</xsl:element>
					</dd>
				</dl>
				<xsl:element name="ul">
					<xsl:attribute name="class">list-icons</xsl:attribute>
					<xsl:element name="li">
						<xsl:attribute name="class">linkplus</xsl:attribute>
						<xsl:element name="a">
							<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
							<xsl:attribute name="href">?p_redirect=fichaPDI&amp;p_idp=<xsl:value-of
								select="$profesor/ehu:idp" />
							</xsl:attribute>
							<xsl:value-of
								select="languageUtil:get($locale,'upv-ehu.masters.pdi')" />
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:call-template name="profesor-tutorias">
			<xsl:with-param name="tutorias"
				select="$profesor/ehu:tutorias" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="vistaProfesorAjeno">
		<xsl:param name="urlBack" />
		<xsl:param name="idp_ajeno" />
		<xsl:variable name="profesorAjeno"
			select="$master/ehu:profesorado/ehu:profesor" />

		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of
					select="$urlBack" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>

		<h1>
			<xsl:value-of select="$profesorAjeno/ehu:nombre" />
		</h1>
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<dl>
					<xsl:if test="$profesorAjeno/ehu:desCategoria">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.categoria')" />
						</dt>
						<dd>
							<xsl:value-of
								select="$profesorAjeno/ehu:desCategoria" />
						</dd>
					</xsl:if>
					<xsl:if test="$profesorAjeno/ehu:perfilDocente">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.perfilDocente')" />
						</dt>
						<dd>
							<xsl:value-of
								select="$profesorAjeno/ehu:perfilDocente" />
						</dd>
					</xsl:if>
					<xsl:if test="$profesorAjeno/ehu:desOrganismo">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.organismo')" />
						</dt>
						<dd>
							<xsl:value-of
								select="$profesorAjeno/ehu:desOrganismo" />
						</dd>
					</xsl:if>
					<xsl:if test="$profesorAjeno/ehu:desDpto">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.departamento')" />
						</dt>
						<dd>
							<xsl:value-of select="$profesorAjeno/ehu:desDpto" />
						</dd>
					</xsl:if>
					<xsl:if test="$profesorAjeno/ehu:desArea">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.area')" />
						</dt>
						<dd>
							<xsl:value-of select="$profesorAjeno/ehu:desArea" />
						</dd>
					</xsl:if>
					<xsl:if test="$profesorAjeno/ehu:email">
						<dt>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.email')" />
						</dt>
						<dd>
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of
									select="$profesorAjeno/ehu:email" /></xsl:attribute>
								<xsl:attribute name="class">email-icon</xsl:attribute>
								<xsl:value-of select="$profesorAjeno/ehu:email" />
							</xsl:element>
						</dd>
					</xsl:if>
				</dl>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="entidadesColaboradoras">
		<xsl:if
			test="$master/ehu:entidadesColaboradoras/ehu:entidadColaboradora/ehu:colaboraciones/ehu:colaboracion[@codigo='P' or @codigo='PE']">
			<xsl:element name="div">
				<xsl:attribute name="class">bg-dark m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">p-20 ehu-sans entidades</xsl:attribute>
					<h2>
						<xsl:value-of
							select="languageUtil:get( $locale, 'upv-ehu.masters.practices.collaborating-entities' )" />
					</h2>
					<xsl:element name="ul">
						<xsl:attribute name="class">unstyled</xsl:attribute>
						<xsl:for-each
							select="$master/ehu:entidadesColaboradoras/ehu:entidadColaboradora[ehu:colaboraciones/ehu:colaboracion[@codigo='P' or @codigo='PE']]">
							<li>
								<xsl:value-of select="ehu:desEntidad" />
							</li>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>


	<xsl:template name="responsableMaster">
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<h2>
					<xsl:value-of
						select="languageUtil:get( $locale, 'upv-ehu.masters.practices.internships-entities' )" />
				</h2>

				<p>
					<strong>
						<xsl:value-of
							select="languageUtil:get( $locale, 'upv-ehu.masters.practices.number-of-hours' )" />
						:
					</strong>
					<xsl:value-of
						select="languageUtil:get( $locale, 'upv-ehu.masters.practices.hours' )" />
				</p>

				<p>
					<xsl:value-of
						select="languageUtil:get( $locale, 'upv-ehu.masters.practices.contact' )" />
					:
					<xsl:call-template name="CamelCase">
						<xsl:with-param name="text">
							<xsl:value-of
								select="$master/ehu:responsable/ehu:nombre" />
						</xsl:with-param>
					</xsl:call-template>
				</p>

				<p>
					<xsl:element name="a">
						<xsl:attribute name="href">mailto:<xsl:value-of
							select="$master/ehu:responsable/ehu:contacto/ehu:mail" /></xsl:attribute>
						<xsl:attribute name="class">email-icon</xsl:attribute>
						<xsl:value-of
							select="$master/ehu:responsable/ehu:contacto/ehu:mail" />
					</xsl:element>
				</p>
				<xsl:for-each
					select="$master/ehu:responsable/ehu:contacto/ehu:tfno">
					<p>
						<xsl:element name="a">
							<xsl:attribute name="href">tel:<xsl:value-of
								select="." /></xsl:attribute>
							<xsl:value-of select="." />
						</xsl:element>
					</p>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="calendarioDocumentos">
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<p>
					<xsl:choose>
						<xsl:when
							test="languageUtil:getLanguageId($locale) = 'es_ES'">
							Consulta el
							<xsl:call-template
								name="formatearTextoCalendario">
								<xsl:with-param name="conector">
									y el
								</xsl:with-param>
							</xsl:call-template>
							del
							<xsl:value-of
								select="normalize-space($master/ehu:desMaster)" />
							.
						</xsl:when>
						<xsl:when
							test="languageUtil:getLanguageId($locale) = 'eu_ES'">
							Kontsulta ezazu
							<xsl:value-of
								select="normalize-space($master/ehu:desMaster)" />
							<xsl:text>ren </xsl:text>
							<xsl:call-template
								name="formatearTextoCalendario">
								<xsl:with-param name="conector">
									eta
								</xsl:with-param>
							</xsl:call-template>
							.
						</xsl:when>
						<xsl:otherwise>
							Check the
							<xsl:call-template
								name="formatearTextoCalendario">
								<xsl:with-param name="conector">
									and
								</xsl:with-param>
							</xsl:call-template>
							of
							<xsl:value-of
								select="normalize-space($master/ehu:desMaster)" />
							.
						</xsl:otherwise>
					</xsl:choose>
				</p>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="recursosMaster">
		<xsl:if
			test="$master/ehu:documentos/ehu:documento[ehu:tipo='MEMORIATI' or ehu:tipo='UNIQUALFINTI' or ehu:tipo='CUFINALTI' or ehu:tipo='DOCVERIFTI']">
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<h2>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.verificacion')" />
					</h2>

					<xsl:element name="ul">
						<xsl:attribute name="class">list-icons</xsl:attribute>
						<xsl:for-each
							select="$master/ehu:documentos/ehu:documento[ehu:tipo='MEMORIATI' or ehu:tipo='UNIQUALFINTI' or ehu:tipo='CUFINALTI' or ehu:tipo='DOCVERIFTI']">
							<xsl:element name="li">
								<xsl:attribute name="class">pdf</xsl:attribute>
								<xsl:call-template name="descargarFichero">
									<xsl:with-param name="document_type"
										select="ehu:tipo" />
									<xsl:with-param name="document_anyo_pop"
										select="ehu:anyoPop" />
									<xsl:with-param name="document_anyo_inf"
										select="''" />
									<xsl:with-param name="document_cod_master"
										select="ehu:codMaster" />
									<xsl:with-param name="document_title"
										select="ehu:titulo" />
									<xsl:with-param name="file_name"
										select="ehu:nombre" />
									<xsl:with-param name="extension"
										select="ehu:extension" />
									<xsl:with-param name="size" select="ehu:peso" />
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>


		<xsl:if
			test="$master/ehu:documentos/ehu:documento[starts-with(ehu:fase,'M')]">
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<h2>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.modificaciones')" />
					</h2>

					<xsl:if
						test="$master/ehu:documentos/ehu:documento[ehu:fase='M1']">
						<h4>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.modificacion')" />
							1
						</h4>
						<xsl:element name="ul">
							<xsl:attribute name="class">list-icons</xsl:attribute>
							<xsl:for-each
								select="$master/ehu:documentos/ehu:documento[ehu:fase='M1']">
								<xsl:element name="li">
									<xsl:attribute name="class">pdf</xsl:attribute>
									<xsl:call-template name="descargarFichero">
										<xsl:with-param name="document_type"
											select="ehu:tipo" />
										<xsl:with-param name="document_anyo_pop"
											select="ehu:anyoPop" />
										<xsl:with-param name="document_anyo_inf"
											select="''" />
										<xsl:with-param name="document_cod_master"
											select="ehu:codMaster" />
										<xsl:with-param name="document_fase"
											select="ehu:fase" />
										<xsl:with-param name="document_title"
											select="ehu:titulo" />
										<xsl:with-param name="file_name"
											select="ehu:nombre" />
										<xsl:with-param name="extension"
											select="ehu:extension" />
										<xsl:with-param name="size" select="ehu:peso" />
									</xsl:call-template>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					<xsl:if
						test="$master/ehu:documentos/ehu:documento[ehu:fase='M2']">
						<h4>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.modificacion')" />
							2
						</h4>
						<xsl:element name="ul">
							<xsl:attribute name="class">list-icons</xsl:attribute>
							<xsl:for-each
								select="$master/ehu:documentos/ehu:documento[ehu:fase='M2']">
								<xsl:element name="li">
									<xsl:attribute name="class">pdf</xsl:attribute>
									<xsl:call-template name="descargarFichero">
										<xsl:with-param name="document_type"
											select="ehu:tipo" />
										<xsl:with-param name="document_anyo_pop"
											select="ehu:anyoPop" />
										<xsl:with-param name="document_anyo_inf"
											select="''" />
										<xsl:with-param name="document_cod_master"
											select="ehu:codMaster" />
										<xsl:with-param name="document_fase"
											select="ehu:fase" />
										<xsl:with-param name="document_title"
											select="ehu:titulo" />
										<xsl:with-param name="file_name"
											select="ehu:nombre" />
										<xsl:with-param name="extension"
											select="ehu:extension" />
										<xsl:with-param name="size" select="ehu:peso" />
									</xsl:call-template>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					<xsl:if
						test="$master/ehu:documentos/ehu:documento[ehu:fase='M3']">
						<h4>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.modificacion')" />
							3
						</h4>
						<xsl:element name="ul">
							<xsl:attribute name="class">list-icons</xsl:attribute>
							<xsl:for-each
								select="$master/ehu:documentos/ehu:documento[ehu:fase='M3']">
								<xsl:element name="li">
									<xsl:attribute name="class">pdf</xsl:attribute>
									<xsl:call-template name="descargarFichero">
										<xsl:with-param name="document_type"
											select="ehu:tipo" />
										<xsl:with-param name="document_anyo_pop"
											select="ehu:anyoPop" />
										<xsl:with-param name="document_anyo_inf"
											select="''" />
										<xsl:with-param name="document_cod_master"
											select="ehu:codMaster" />
										<xsl:with-param name="document_fase"
											select="ehu:fase" />
										<xsl:with-param name="document_title"
											select="ehu:titulo" />
										<xsl:with-param name="file_name"
											select="ehu:nombre" />
										<xsl:with-param name="extension"
											select="ehu:extension" />
										<xsl:with-param name="size" select="ehu:peso" />
									</xsl:call-template>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					<xsl:if
						test="$master/ehu:documentos/ehu:documento[ehu:fase='M4']">
						<h4>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.modificacion')" />
							4
						</h4>
						<xsl:element name="ul">
							<xsl:attribute name="class">list-icons</xsl:attribute>
							<xsl:for-each
								select="$master/ehu:documentos/ehu:documento[ehu:fase='M4']">
								<xsl:element name="li">
									<xsl:attribute name="class">pdf</xsl:attribute>
									<xsl:call-template name="descargarFichero">
										<xsl:with-param name="document_type"
											select="ehu:tipo" />
										<xsl:with-param name="document_anyo_pop"
											select="ehu:anyoPop" />
										<xsl:with-param name="document_anyo_inf"
											select="''" />
										<xsl:with-param name="document_cod_master"
											select="ehu:codMaster" />
										<xsl:with-param name="document_fase"
											select="ehu:fase" />
										<xsl:with-param name="document_title"
											select="ehu:titulo" />
										<xsl:with-param name="file_name"
											select="ehu:nombre" />
										<xsl:with-param name="extension"
											select="ehu:extension" />
										<xsl:with-param name="size" select="ehu:peso" />
									</xsl:call-template>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:if>


		<xsl:if
			test="$master/ehu:documentos/ehu:documento[starts-with(ehu:tipo,'INFSEGUI') or starts-with(ehu:tipo,'UNISEGUI')]">
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<h2>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.seguimiento')" />
					</h2>

					<xsl:element name="ul">
						<xsl:attribute name="class">list-icons</xsl:attribute>
						<xsl:for-each
							select="$master/ehu:documentos/ehu:documento[starts-with(ehu:tipo,'INFSEGUI') or starts-with(ehu:tipo,'UNISEGUI')]">
							<xsl:sort select="ehu:anyoInf" order="descending" />
							<xsl:variable name="curso_academico">
								<xsl:value-of select="substring(ehu:anyoInf,1,4)" />
								/
								<xsl:value-of
									select="substring(number(substring(ehu:anyoInf,1,4))+1 ,3,4)" />
							</xsl:variable>
							<xsl:variable name="titulo">
								<xsl:value-of select="ehu:titulo" />
								<xsl:value-of select="$white_space" />
								(
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.curso')" />
								:
								<xsl:value-of select="$curso_academico" />
								)
							</xsl:variable>
							<xsl:element name="li">
								<xsl:attribute name="class">pdf</xsl:attribute>
								<xsl:call-template name="descargarFichero">
									<xsl:with-param name="document_type"
										select="ehu:tipo" />
									<xsl:with-param name="document_anyo_pop"
										select="ehu:anyoPop" />
									<xsl:with-param name="document_anyo_inf"
										select="ehu:anyoInf" />
									<xsl:with-param name="document_cod_master"
										select="ehu:codMaster" />
									<xsl:with-param name="document_title"
										select="$titulo" />
									<xsl:with-param name="file_name"
										select="ehu:nombre" />
									<xsl:with-param name="extension"
										select="ehu:extension" />
									<xsl:with-param name="size" select="ehu:peso" />
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>


		<xsl:if
			test="$master/ehu:documentos/ehu:documento[starts-with(ehu:tipo,'INFACRED') or starts-with(ehu:tipo,'UNIACRED') or starts-with(ehu:tipo,'CUACRED')]">
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<h2>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.acreditacion')" />
					</h2>
					<p>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.acredi.fechaAcredi')" />
						<xsl:text>: </xsl:text>
						<xsl:call-template name="formatFecha">
							<xsl:with-param name="date_wz"
								select="substring-before($master/ehu:documentos/ehu:documento[starts-with(ehu:tipo,'INFACRED') or starts-with(ehu:tipo,'UNIACRED') or starts-with(ehu:tipo,'CUACRED')]/ehu:fecha,'Z')" />
						</xsl:call-template>
					</p>
					<xsl:element name="ul">
						<xsl:attribute name="class">list-icons</xsl:attribute>
						<xsl:for-each
							select="$master/ehu:documentos/ehu:documento[starts-with(ehu:tipo,'INFACRED') or starts-with(ehu:tipo,'UNIACRED') or starts-with(ehu:tipo,'CUACRED')]">
							<xsl:sort select="ehu:anyoInf" order="descending" />
							<xsl:element name="li">
								<xsl:attribute name="class">pdf</xsl:attribute>
								<xsl:call-template name="descargarFichero">
									<xsl:with-param name="document_type"
										select="ehu:tipo" />
									<xsl:with-param name="document_anyo_pop"
										select="ehu:anyoPop" />
									<xsl:with-param name="document_anyo_inf"
										select="ehu:anyoInf" />
									<xsl:with-param name="document_cod_master"
										select="ehu:codMaster" />
									<xsl:with-param name="document_title"
										select="ehu:titulo" />
									<xsl:with-param name="file_name"
										select="ehu:nombre" />
									<xsl:with-param name="extension"
										select="ehu:extension" />
									<xsl:with-param name="size" select="ehu:peso" />
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>

		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<h3>
					<xsl:value-of
						select="languageUtil:get($locale,'ehu.more-info')" />
				</h3>

				<xsl:element name="ul">
					<xsl:attribute name="class">list-icons</xsl:attribute>
					<xsl:if test="$master/ehu:enlaceRutc">
						<xsl:element name="li">
							<xsl:attribute name="class">link</xsl:attribute>
							<xsl:element name="a">
								<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:value-of select="$master/ehu:enlaceRutc" />
								</xsl:attribute>
								<xsl:value-of select="$white_space" />
								<span>
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									<xsl:value-of
										select="languageUtil:get($locale,'opens-new-window')" />
								</span>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.xsl-content.doctorado.registro.uct')" />
								<xsl:value-of select="$white_space" />
								<xsl:element name="span">
									<xsl:attribute name="class">icon-external-link</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$master/ehu:enlaceSGIC">
						<xsl:element name="li">
							<xsl:attribute name="class">link</xsl:attribute>
							<xsl:element name="a">
								<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:value-of select="$master/ehu:enlaceSGIC" />
								</xsl:attribute>
								<xsl:value-of select="$white_space" />
								<span>
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									<xsl:value-of
										select="languageUtil:get($locale,'opens-new-window')" />
								</span>
								<xsl:value-of
									select="languageUtil:get($locale,'ehu.enlaceSGIC')" />
								<xsl:value-of select="$white_space" />
								<xsl:element name="span">
									<xsl:attribute name="class">icon-external-link</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:element name="li">
						<xsl:attribute name="class">link</xsl:attribute>
						<xsl:element name="a">
							<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<xsl:attribute name="href">https://www.ehu.eus/<xsl:value-of
								select="$p_cod_idioma" />/web/masterrak-eta-graduondokoak/masteres-universitarios/normativa</xsl:attribute>
							<xsl:value-of select="$white_space" />
							<span>
								<xsl:attribute name="class">hide-accessible</xsl:attribute>
								<xsl:value-of
									select="languageUtil:get($locale,'opens-new-window')" />
							</span>
							<xsl:value-of
								select="languageUtil:get($locale,'upv-ehu.masters.resources.regulation.link')" />
							<xsl:value-of select="$white_space" />
							<xsl:element name="span">
								<xsl:attribute name="class">icon-external-link</xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="piePagina">
		<xsl:if
			test="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail">
			<xsl:element name="a">
				<xsl:attribute name="id">contactoPiePagina</xsl:attribute>
				<xsl:attribute name="href">mailto:<xsl:value-of
					select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail" /></xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="class">fa fa-envelope fa-2x</xsl:attribute>
					<xsl:value-of select="$white_space" />
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="id">suggestionBoxFooter</xsl:attribute>
					<xsl:value-of
						select="languageUtil:get($locale,'upv-ehu.masters.home.suggestionbox')" />
				</xsl:element>
			</xsl:element>

			<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				
					<!-- xmlns:ehu -->
					<script type="text/javascript"> 
						document.addEventListener('DOMContentLoaded', function(){ 
							if(document.getElementById('footerContact')) {
								document.getElementById('footerContact').appendChild(document.getElementById('contactoPiePagina'));
							}
						});
					</script> 
				]]>
			</xsl:text>
		</xsl:if>
	</xsl:template>


	<xsl:template name="competencias">
		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href">./<xsl:value-of
					select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>

		<h2>
			<xsl:value-of
				select="languageUtil:get($locale,'ehu.competencias')" />
		</h2>
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:for-each
						select="$master/ehu:competencias/ehu:competencia">
						<li>
							<xsl:value-of select="ehu:descripcion" />
						</li>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="lineasDeInvestigacion">
		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href">./<xsl:value-of
					select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')" /></xsl:attribute>
				<xsl:call-template name="elemento_span_atras" />
				<xsl:value-of select="languageUtil:get($locale,'back')" />
			</xsl:element>
		</xsl:element>

		<h2>
			<xsl:value-of
				select="languageUtil:get($locale,'ehu.research-guidelines')" />
		</h2>
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:for-each
						select="$master/ehu:lineasInvestigacion/ehu:lineaInvestigacion ">
						<li>
							<xsl:value-of select="." />
						</li>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>


	<xsl:template name="presentacionMFPS">
		<xsl:element name="div">
			<xsl:attribute name="class">bg-white p-20 ehu-sans</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:if
					test="$master/ehu:plazas/ehu:ofertadas and $master/ehu:plazas/ehu:ofertadas != 0">
					<xsl:element name="div">
						<xsl:attribute name="class">col-md-4</xsl:attribute>
						<h3>
							<xsl:value-of
								select="languageUtil:get($locale,'ehu.plazasOfertadas')" />
						</h3>
						<p>
							<xsl:value-of
								select="$master/ehu:plazas/ehu:ofertadas" />
						</p>
					</xsl:element>
				</xsl:if>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-4</xsl:attribute>
					<h3>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.modalidad')" />
					</h3>
					<p>
						<xsl:choose>
							<xsl:when
								test="count($master/ehu:modalidadesImparticion/ehu:modalidadImparticion) > 1">
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.semipresential')" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="$master/ehu:modalidadesImparticion/ehu:modalidadImparticion/ehu:descripcion" />
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</xsl:element>
								 				
				<xsl:choose>
					<xsl:when test="$master/ehu:mostrarPrecio='0'">
						<xsl:element name="div">
							<xsl:attribute name="class">col-md-4</xsl:attribute>
							<h3>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')" />
							</h3>
							<p>(*)</p>
						</xsl:element>
					</xsl:when>
					<xsl:when
						test="$master/ehu:precios/ehu:precio[ehu:tipo='ACAD']">
						<xsl:element name="div">
							<xsl:attribute name="class">col-md-4</xsl:attribute>
							<h3>
								<xsl:value-of
									select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')" />
							</h3>
							<xsl:variable name="precioFinalMaster"
								select="$master/ehu:numCredMaster * $master/ehu:precios/ehu:precio[ehu:tipo='ACAD' and ehu:vecesMatricula='1']/ehu:precio + sum($master/ehu:precios/ehu:precio[ehu:tipo='ADMIN']/ehu:precio)" />
							<p>
								<xsl:value-of
									select="format-number(round($precioFinalMaster div 100) * 100, '#.###,#', 'european')" />
								<xsl:value-of select="$white_space" />
								€
							</p>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
				
			</xsl:element>

			<h3>
				<xsl:value-of
					select="languageUtil:get($locale,'ehu.contacto')" />
			</h3>
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<p>
						<xsl:value-of
							select="languageUtil:get($locale,'ehu.responsableMaster')" />
						:
						<br />
						<xsl:value-of
							select="$master/ehu:responsable/ehu:nombre" />
						<br />
						<xsl:if
							test="$master/ehu:responsable/ehu:contacto/ehu:mail">
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of
									select="$master/ehu:responsable/ehu:contacto/ehu:mail" /></xsl:attribute>
								<xsl:attribute name="class">email-icon</xsl:attribute>
								<xsl:value-of
									select="$master/ehu:responsable/ehu:contacto/ehu:mail" />
							</xsl:element>
						</xsl:if>
					</p>
				</xsl:element>

				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<p>
						<xsl:value-of
							select="languageUtil:get($locale,'upv-ehu.masters.home.secretary')" />
						:
						<br />
						<xsl:value-of
							select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:nombre" />
						<br />
						<xsl:if
							test="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail">
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of
									select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail" /></xsl:attribute>
								<xsl:attribute name="class">email-icon</xsl:attribute>
								<xsl:value-of
									select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:mail" />
							</xsl:element>
						</xsl:if>
						<xsl:for-each
							select="$master/ehu:contactos/ehu:infContacto[ehu:tipo='CONTACTOADMIN']/ehu:contacto/ehu:tfno">
							<br />
							<xsl:element name="a">
								<xsl:attribute name="href">tel:<xsl:value-of
									select="." /></xsl:attribute>
								<xsl:value-of select="." />
							</xsl:element>
						</xsl:for-each>
					</p>
				</xsl:element>
			</xsl:element>

		</xsl:element>
	</xsl:template>


	<xsl:template name="descargarFichero">
		<xsl:param name="document_type" />
		<xsl:param name="document_anyo_pop" />
		<xsl:param name="document_anyo_inf" />
		<xsl:param name="document_cod_master" />
		<xsl:param name="document_fase" />
		<xsl:param name="document_title" />
		<xsl:param name="file_name" />
		<xsl:param name="extension" />
		<xsl:param name="size" />
		<a>
			<xsl:attribute name="href">?p_redirect=descargaFichero&amp;p_tipo=<xsl:value-of
				select="$document_type" />&amp;p_anyo_pop=<xsl:value-of
				select="$document_anyo_pop" />&amp;p_cod_master=<xsl:value-of
				select="$document_cod_master" />&amp;p_anyo_inf=<xsl:value-of
				select="$document_anyo_inf" />&amp;p_fase=<xsl:value-of
				select="$document_fase" /></xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:value-of select="$white_space" />
			<span>
				<xsl:attribute name="class">hide-accessible</xsl:attribute>
				<xsl:value-of
					select="languageUtil:get($locale,'opens-new-window')" />
			</span>
			<xsl:choose>
				<xsl:when test="$document_title != $void">
					<xsl:value-of select="$document_title" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$file_name" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="($size != $void) and ($extension != $void)">
				<xsl:text> (</xsl:text>
				<xsl:element name="abbr">
					<xsl:variable name="literal-extension"
						select="concat('ehu.ext.', $extension)" />
					<xsl:attribute name="title"><xsl:value-of
						select="languageUtil:get($locale, $literal-extension)" /></xsl:attribute>
					<xsl:value-of select="$extension" />
					<xsl:value-of select="$white_space" />
				</xsl:element>
				<span>
					<xsl:value-of
						select="substring-before($size,  $white_space)" />
				</span>
				<xsl:element name="abbr">
					<xsl:choose>
						<xsl:when test="contains($size, Kb)">
							<xsl:attribute name="title">
								<xsl:value-of
								select="languageUtil:get($locale, 'ehu.ext.Kb')" />
							</xsl:attribute>
							<xsl:value-of
								select="substring-after($size,  $white_space)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="title">
								<xsl:value-of
								select="languageUtil:get($locale, 'ehu.ext.Mb')" />
							</xsl:attribute>
							<xsl:value-of
								select="substring-after($size,  $white_space)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:value-of select="$white_space" />
			<span>
				<xsl:attribute name="class">icon-external-link</xsl:attribute>
			</span>
		</a>
	</xsl:template>

	<xsl:template name="formatearTextoCalendario">
		<xsl:param name="conector" />			
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of
				select="normalize-space('?p_redirect=descargaFichero&amp;p_tipo=CALENDOCENTE&amp;p_anyo_pop=')" /><xsl:value-of
				select="$master/ehu:documentos/ehu:documento[ehu:tipo='CALENDOCENTE']/ehu:anyoPop" /><xsl:value-of
				select="normalize-space('&amp;p_cod_master=')" /><xsl:value-of
				select="$master/ehu:documentos/ehu:documento[ehu:tipo='CALENDOCENTE']/ehu:codMaster" /></xsl:attribute>
			<xsl:value-of
				select="languageUtil:get($locale,'upv-ehu.masters.calendar.calendario')" />
		</xsl:element>
		<xsl:if
			test="$master/ehu:documentos/ehu:documento[ehu:tipo='CALENEVAL']">
			<xsl:text>, </xsl:text>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of
					select="normalize-space('?p_redirect=descargaFichero&amp;p_tipo=CALENEVAL&amp;p_anyo_pop=')" />
					<xsl:value-of
					select="$master/ehu:documentos/ehu:documento[ehu:tipo='CALENEVAL']/ehu:anyoPop" />					
					<xsl:value-of
					select="normalize-space('&amp;p_cod_master=')" />
					<xsl:value-of
					select="$master/ehu:documentos/ehu:documento[ehu:tipo='CALENEVAL']/ehu:codMaster" />
				</xsl:attribute>
				<xsl:value-of
					select="languageUtil:get($locale,'upv-ehu.masters.calendar.calendarioEval')" />
			</xsl:element>
		</xsl:if>
		<xsl:value-of select="$conector" />
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of
				select="normalize-space('?p_redirect=descargaFichero&amp;p_tipo=HORARIO&amp;p_anyo_pop=')" />
				<xsl:value-of
				select="$master/ehu:documentos/ehu:documento[ehu:tipo='HORARIO']/ehu:anyoPop" />
				<xsl:value-of
				select="normalize-space('&amp;p_cod_master=')" />
				<xsl:value-of
				select="$master/ehu:documentos/ehu:documento[ehu:tipo='HORARIO']/ehu:codMaster" />
			</xsl:attribute>
			<xsl:value-of
				select="languageUtil:get($locale,'upv-ehu.masters.calendar.horario')" />
		</xsl:element>
	</xsl:template>


	<xsl:template name="formatFecha">
		<xsl:param name="date_wz" />
		<xsl:choose>
			<xsl:when
				test="languageUtil:getLanguageId($locale) = 'eu_ES'">
				<xsl:variable name="yearInit"
					select="substring($date_wz,1,4)" />
				<xsl:variable name="monthInit"
					select="substring($date_wz,6,2)" />
				<xsl:variable name="dayInit"
					select="substring($date_wz,9,2)" />
				<!-- Pintamos la fecha en formato EU -->
				<xsl:value-of select="$yearInit" />
				/
				<xsl:value-of select="$monthInit" />
				/
				<xsl:value-of select="$dayInit" />
			</xsl:when>
			<xsl:when
				test="languageUtil:getLanguageId($locale) = 'es_ES'">
				<xsl:variable name="yearInit"
					select="substring($date_wz,1,4)" />
				<xsl:variable name="monthInit"
					select="substring($date_wz,6,2)" />
				<xsl:variable name="dayInit"
					select="substring($date_wz,9,2)" />
				<!-- Pintamos la fecha en formato ES -->
				<xsl:value-of select="$dayInit" />
				/
				<xsl:value-of select="$monthInit" />
				/
				<xsl:value-of select="$yearInit" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="yearInit"
					select="substring($date_wz,1,4)" />
				<xsl:variable name="monthInit"
					select="substring($date_wz,6,2)" />
				<xsl:variable name="dayInit"
					select="substring($date_wz,9,2)" />
				<!-- Pintamos la fecha en formato EN -->
				<xsl:value-of select="$monthInit" />
				/
				<xsl:value-of select="$dayInit" />
				/
				<xsl:value-of select="$yearInit" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
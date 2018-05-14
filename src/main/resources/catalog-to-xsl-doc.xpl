<p:declare-step version="1.0"
            xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:cx="http://xmlcalabash.com/ns/extensions"
            xmlns:catalog="urn:oasis:names:tc:entity:xmlns:xml:catalog"
            xmlns:xsldoc="top:marchand:xml:xsl:doc"
            type="xsldoc:catalog-to-xsl-doc"
            name="main"
            exclude-inline-prefixes="#all">
	
	<p:input port="source" sequence="false"/>
	<p:option name="projectName" required="true"/>
	<p:option name="absoluteRootFolder" required="true"/>
	<p:option name="outputFolder" required="true"/>
	
	<p:declare-step type="xsldoc:accumulate">
		<p:input port="source"/>
		<p:output port="result"/>
		<p:option name="absoluteRootFolder" required="true"/>
		<!--
		    implemented in Java
		-->
	</p:declare-step>
	
	<p:declare-step type="xsldoc:generate-index">
		<p:option name="projectName" required="true"/>
		<p:option name="outputFolder" required="true"/>
		<!--
		    implemented in Java
		-->
	</p:declare-step>
	
	<p:for-each name="sources">
		<p:iteration-source select="/*/catalog:uri">
			<p:pipe step="main" port="source"/>
		</p:iteration-source>
		<p:choose>
			<p:when test="/*[ends-with(@uri,'.xsl')]">
				<p:load>
					<p:with-option name="href" select="/*/resolve-uri(@uri,base-uri(.))"/>
				</p:load>
			</p:when>
			<p:otherwise>
				<p:identity>
					<p:input port="source">
						<p:empty/>
					</p:input>
				</p:identity>
			</p:otherwise>
		</p:choose>
	</p:for-each>
	
	<p:for-each name="generate">
		<p:xslt output-base-uri="file:/whatever">
			<p:input port="stylesheet">
				<p:document href="get-xfile-dependencies.xsl"/>
			</p:input>
			<p:with-param name="includeContent" select="'false'"/>
		</p:xslt>
		<p:xslt>
			<p:input port="stylesheet">
				<p:document href="getFileContent.xsl"/>
			</p:input>
			<p:with-param name="levelsToKeep" select="'0'"/>
		</p:xslt>
		<p:xslt>
			<p:input port="stylesheet">
				<p:document href="calculateRelativePaths.xsl"/>
			</p:input>
			<p:with-param name="absoluteRootFolder" select="$absoluteRootFolder"/>
			<p:with-param name="levelsToKeep" select="'0'"/>
		</p:xslt>
		<p:xslt>
			<p:input port="stylesheet">
				<p:document href="calculateHtmlOutputFile.xsl"/>
			</p:input>
			<p:with-param name="outputFolder" select="$outputFolder"/>
		</p:xslt>
		<xsldoc:accumulate name="accumulate">
			<p:with-option name="absoluteRootFolder" select="$absoluteRootFolder"/>
		</xsldoc:accumulate>
		<p:xslt>
			<p:input port="source">
				<p:pipe step="accumulate" port="result"/>
			</p:input>
			<p:input port="stylesheet">
				<p:document href="prepareTOC.xsl"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
		<p:xslt name="toc">
			<p:input port="stylesheet">
				<p:document href="makeTOC.xsl"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
		<p:sink/>
		<p:xslt name="doc">
			<p:input port="source">
				<p:pipe step="accumulate" port="result"/>
			</p:input>
			<p:input port="stylesheet">
				<p:document href="makeDoc.xsl"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
		<p:sink/>
		<p:xslt name="index">
			<p:input port="source">
				<p:pipe step="accumulate" port="result"/>
			</p:input>
			<p:input port="stylesheet">
				<p:document href="makeIndex.xsl"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
		<p:sink/>
		<p:identity>
			<p:input port="source">
				<p:pipe step="toc" port="secondary"/>
				<p:pipe step="doc" port="secondary"/>
				<p:pipe step="index" port="secondary"/>
			</p:input>
		</p:identity>
	</p:for-each>
	
	<p:for-each>
		<p:store method="xhtml">
			<p:with-option name="href" select="p:base-uri()"/>
		</p:store>
	</p:for-each>
	
	<xsldoc:generate-index cx:depends-on="generate">
		<p:with-option name="projectName" select="$projectName"/>
		<p:with-option name="outputFolder" select="$outputFolder"/>
	</xsldoc:generate-index>
	
</p:declare-step>

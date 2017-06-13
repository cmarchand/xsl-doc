<?xml version= "1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:local="com:oxiane:xml"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:p="http://www.w3.org/ns/xproc" 
				xmlns:xslt="http://www.w3.org/1999/XSL/Transform"
				version="2.0"
				exclude-result-prefixes="#all">

	<!--
		Genère un fichier XML qui montre toutes les dépendance (xpl, xsl, xsd, etc) d'un fichier de "type XML"
	-->

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:param name="includeContent" as="xs:string" required="yes"/>
	<xsl:variable name="getContent" select="$includeContent eq 'true'" as="xs:boolean"/>

	<!-- DEFAULT -->
	<xsl:template match="*" priority="-2">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="text()" priority="-1"/>

	<!--ROOT MATCHING (any kind of file)-->
	<xsl:template match="/">
		<xsl:param name="dependance-type" select="'first-doc'" as="xs:string"/>
		<xsl:param name="rel-uri" as="xs:string?"/>
		<xsl:variable name="uri" select="base-uri(/)"/>
		<file dependance-type="{$dependance-type}" name="{local:get-fileName(string($uri))}" base-uri="{$uri}">
			<xsl:if test="not(empty($rel-uri))">
				<xsl:attribute name="rel-uri" select="$rel-uri"/>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="caller.uri" select="$uri" tunnel="yes"/>
			</xsl:apply-templates>
			<xsl:if test="$getContent">
				<content>
					<xsl:copy-of select="."/>
				</content>
			</xsl:if>
		</file>
	</xsl:template>

	<!-- XPROC MATCHING -->
	<xsl:template match="p:import[@href='http://xmlcalabash.com/extension/steps/library-1.0.xpl']" priority="1">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="p:import[@href] | p:document[@href]">
		<xsl:param name="caller.uri" tunnel="yes"/>
		<xsl:variable name="this.uri" select="resolve-uri(@href,base-uri(.))"/>
		<xsl:if test="$caller.uri != $this.uri">
			<xsl:apply-templates select="document($this.uri)">
				<xsl:with-param name="dependance-type" select="name()"/>
				<xsl:with-param name="rel-uri" select="@href"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="p:import | p:document" priority="-1">
		<xsl:message>[ERROR] <xsl:value-of select="name()"/> sans @href !</xsl:message>
	</xsl:template>
	
	<!--xsl:template match="efl:drl/p:with-option[@name='drlPath']">
		<xsl:param name="caller.uri" tunnel="yes"/>
		<xsl:variable name="quot">'</xsl:variable>
		<xsl:variable name="this.rel.uri" select="translate(@select, $quot, '')"/>
		<xsl:variable name="this.uri" select="resolve-uri($this.rel.uri,base-uri(.))"/>
		<xsl:if test="$caller.uri != $this.uri">
			<file dependance-type="efl:drl" base-uri="{$this.uri}">
				<xsl:choose>
					<xsl:when test="not(empty($this.rel.uri))">
						<xsl:attribute name="rel-uri" select="$this.rel.uri"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="name" select="local:get-fileName(string($this.uri))"/>	
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$getContent">
					<content>
						<xsl:choose>
							<xsl:when test="unparsed-text-available($this.uri)">
								<xsl:value-of select="unparsed-text($this.uri)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:comment>[ERROR] CONTENT IS NOT AVAILABLE (with utf-8 encoding)</xsl:comment>
								<xsl:value-of select="unparsed-text($this.uri)"/>
							</xsl:otherwise>
						</xsl:choose>
					</content>
				</xsl:if>
			</file>
		</xsl:if>
	</xsl:template-->
	
	<!--XSLT MATCHING-->

	<xsl:template match="xslt:import | xslt:include">
		<xsl:param name="caller.uri" tunnel="yes"/>
		<xsl:variable name="this.uri" select="resolve-uri(@href,base-uri(.))"/>
		<xsl:if test="$caller.uri != $this.uri">
			<xsl:apply-templates select="document($this.uri)">
				<xsl:with-param name="dependance-type" select="name()"/>
				<xsl:with-param name="rel-uri" select="@href"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<!--XSD include-->
	<xsl:template match="xs:include">
		<xsl:param name="caller.uri" tunnel="yes"/>
		<xsl:variable name="this.uri" select="resolve-uri(@schemaLocation,base-uri(.))"/>
		<xsl:if test="$caller.uri != $this.uri">
			<xsl:apply-templates select="document($this.uri)">
				<xsl:with-param name="dependance-type" select="name()"/>
				<xsl:with-param name="rel-uri" select="@schemaLocation"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:function name="local:get-fileName" as="xs:string">
		<xsl:param name="uri" as="xs:string"/>
		<xsl:sequence select="tokenize($uri,'/')[last()]"/>
	</xsl:function>
</xsl:stylesheet>

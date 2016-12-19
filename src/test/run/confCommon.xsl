<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:efl="http://els.eu/ns/efl"
	xmlns:conf="http://els.eu/ns/efl/config" xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="#all"
	version="3.0">

	<!--Ne pas importer d'autres xslt ici. mais si besoin indiquer celles qu'il faut importer nécessaire avec celle-ci-->
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> June 6, 2014</xd:p>
			<xd:p><xd:b>Authors:</xd:b> mricaud</xd:p>
			<xd:p>Librairies de fonctions permettant de récupérer des valeurs dans un fichier config.xml (configx.dtd)</xd:p>
		</xd:desc>
	</xd:doc>

	<xd:doc>
		<xd:desc>
			<xd:p>Récupère dans la config un groupe par son nom</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="conf:getConfigGroup" as="element(groupe)?">
		<xsl:param as="xs:anyURI" name="configUri"/>
		<xsl:param as="xs:string" name="groupeName"/>
		<xsl:variable name="config" select="document($configUri)" as="document-node()"/>
		<xsl:if test="empty($config)">
			<xsl:message terminate="yes" select="concat($configUri,': est vide')"/>
		</xsl:if>
		<xsl:variable name="ret" select="$config//groupe[@nom = $groupeName]"/>
		<xsl:if test="empty($ret)">
			<xsl:message terminate="yes" select="concat('rien trouvé pour le groupe ',$groupeName)"/>
		</xsl:if>
		<xsl:sequence select="$ret"/>
	</xsl:function>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 6, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>This program only calculates output file URI</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:import href="lib/identity.xsl"/>
    <xsl:import href="lib/common.xsl"/>
    
    <xsl:param name="outputFolder" as="xs:string"/>
    <xsl:variable name="outputFolderURI" as="xs:anyURI" select="resolve-uri($outputFolder)"/>
    
    <xsl:template match="file">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="htmlOutputUri" select="resolve-uri(local:getDocumentationFileURI(string-join(($outputFolderURI,@root-rel-uri),'/')))"/>
            <xsl:attribute name="indexOutputUri" select="resolve-uri(local:getIndexFileURI(string-join(($outputFolderURI,@root-rel-uri),'/')))"/>
            <xsl:attribute name="welcomeOutputUri" select="resolve-uri(local:getWelcomeFileURI(string-join(($outputFolderURI,@root-rel-uri),'/')))"></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
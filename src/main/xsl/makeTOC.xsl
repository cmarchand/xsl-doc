<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:local="top:marchand:xml:local"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This program generates the TOC of an XSL and her dependencies. It produces the xhtml document directly via result-document</xd:p>
            <xd:p><xd:b>Created on:</xd:b> Jul 1, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="outputFolder" as="xs:string" required="yes"/>
    <xsl:variable name="outputFolderUri" as="xs:anyURI" select="if (ends-with($outputFolder,'/')) then $outputFolder else concat($outputFolder,'/')"/>
    
    <xsl:template match="/data">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Table of Contents</title>
            </head>
            <body>
                <xsl:apply-templates></xsl:apply-templates>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="*[starts-with(local-name(), 'by-')]">
        <details open="open">
            <summary>Content by <xsl:value-of select="substring(local-name(),4)"/></summary>
            <ul><xsl:apply-templates select="element"/></ul>
        </details>
    </xsl:template>
    
    <xsl:template match="element">
        <li>
            <a href="{local:getHtmlFileName(@relUri)}#{@id}"><xsl:value-of select="@name"></xsl:value-of></a>
        </li>
    </xsl:template>
    
    
    <!--xsl:function name="local:getImageDesc" as="xs:string">
        <xsl:param name="type" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$type eq 'template'"><xsl:sequence select=""></xsl:sequence></xsl:when>
        </xsl:choose>
    </xsl:function-->
    
    <xsl:function name="local:getHtmlFileName" as="xs:string">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:variable name="relUriSeq" select="tokenize($relUri,'/')" as="xs:string*"/>
        <xsl:variable name="sourceFileName" as="xs:string" select="$relUriSeq[last()]"/>
        
    </xsl:function>
    
</xsl:stylesheet>
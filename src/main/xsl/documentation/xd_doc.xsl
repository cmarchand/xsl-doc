<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0" default-mode="documentation">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 7, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>Generates documentation for Oxygen format</xd:p>
        </xd:desc>
        <xd:param name="">
        </xd:param>
    </xd:doc>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template match="xd:doc">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="xd:desc">
        <div class="xd§docDesc" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="xd:param">
        <div xmlns="http://www.w3.org/1999/xhtml" class="xd§docParam">
            <span class="xd§docLabel">param</span><span class="xd§docName"><xsl:value-of select="@name"/></span><xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    <xsl:template match="xd:return">
        <div xmlns="http://www.w3.org/1999/xhtml" class="xd§docParam">
            <span class="xd§docLabel">return</span><span class="xd§docName"><xsl:value-of select="@name"/><xsl:apply-templates mode="#current"/></span>
        </div>
    </xsl:template>
    <xsl:template match="xd:p | xd:b | xd:i | xd:a | xd:pre">
        <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@* | text()"><xsl:copy-of select="."/></xsl:template>
    
    <xsl:function name="xd:getCssCode" as="xs:string?">
        <xsl:sequence>
            .xd§docDesc {border: solid 1px #4d4d4d; border-radius: 2px;}
            .xd§docName {text-weight: bold; background-color: #ffe6e6; color: white;}
            .xd§docLabel {background-color: #ffe6e6; color: white;}
        </xsl:sequence>
    </xsl:function>
    
</xsl:stylesheet>
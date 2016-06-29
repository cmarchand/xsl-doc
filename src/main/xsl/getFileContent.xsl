<?xml version="1.0" encoding="UTF-8"?>
<!--
This Source Code Form is subject to the terms of 
the Mozilla Public License, v. 2.0. If a copy of 
the MPL was not distributed with this file, You 
can obtain one at https://mozilla.org/MPL/2.0/.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    exclude-result-prefixes="xs math xd"
    version="3.0">

    <xsl:import href="identity.xsl"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 28, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> Christophe Marchand - christophe@marchand.top</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="file">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="document(resolve-uri(@base-uri))">
                <xsl:with-param name="xsl-name" select="@name" tunnel="yes"/>
                <xsl:with-param name="base-uri" select="@base-uri" tunnel="yes"/>
                <xsl:with-param name="rel-uri" select="@rel-uri" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsl:template">
        <xsl:param name="xsl-name" as="xs:string" tunnel="yes"/>
        <xsl:param name="base-uri" as="xs:string" tunnel="yes"/>
        <xsl:param name="rel-uri" as="xs:string?" tunnel="yes"/>
        <element type="template" origine="{generate-id(.)}">
            <xsl:choose>
                <xsl:when test="exists(@match)">
                    <xsl:attribute name="match" select="@match"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="local:extractName(@name)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="exists(@mode)">
                <xsl:attribute name="mode-name" select="local-name(@mode)"/>
                <xsl:attribute name="mode-namespace" select="namespace-uri(@mode)"/>
            </xsl:if>
            <xsl:if test="preceding-sibling::*[1][self::xd:doc][not(@scope='stylesheet')]">
                <xsl:copy-of select="preceding-sibling::*[1][self::xd:doc]"/>
            </xsl:if>
        </element>
    </xsl:template>
    
    <xsl:template match="xsl:param">
        <element type="parameter" origine="{generate-id(.)}">
            <xsl:copy-of select="local:extractName(@name)"/>
            <xsl:apply-templates select="@* except @name"/>
        </element>
    </xsl:template>
    
    <xsl:template match="xsl:variable">
        <element type="variable" origine="{generate-id(.)}">
            <xsl:copy-of select="local:extractName(@name)"/>
            <xsl:apply-templates select="@* except @name"/>
        </element>
    </xsl:template>
    
    <xsl:template match="xsl:function">
        <element type="function" origine="{generate-id(.)}">
            <xsl:copy-of select="local:extractName(@name)"/>
            <xsl:apply-templates select="@* except @name"/>
            <xsl:copy-of select="local:calcSignature(.)"/>
        </element>
    </xsl:template>
    <!-- here, we don't care -->
    <xsl:template match="xd:*"/>
    
    <xsl:template match="xsl:*">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="text()"/>
    <xsl:template match="comment()"/>
    
    <xsl:function name="local:extractName" as="attribute()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$name castable as xs:QName">
                <xsl:variable name="qname" select="xs:QName($name)" as="xs:QName"/>
                <xsl:sequence>
                    <xsl:attribute name="name" select="local-name-from-QName($qname)"/>
                    <xsl:attribute name="namespace" select="namespace-uri-from-QName($qname)"/>
                </xsl:sequence>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence>
                    <xsl:attribute name="name" select="$name"/>
                </xsl:sequence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="local:calcSignature" as="attribute(signature)">
        <xsl:param name="function" as="element(xsl:function)"/>
        <xsl:variable name="qname" as="xs:QName" select="xs:QName($function/@name)"/>
        <xsl:variable name="NS" select="namespace-uri-from-QName($qname)"/>
        <xsl:variable name="name" select="local-name-from-QName($qname)"/>
        <xsl:variable name="functionName" as="xs:string" select="concat('Q{',$NS,'}',$name,'(')"/>
        <xsl:variable name="parameters" as="xs:string*" select="for $i in $function/xsl:param return local:getType($i)"/>
        <xsl:sequence>
            <xsl:attribute name="signature" select="concat($functionName, string-join($parameters,','),')')"/>
        </xsl:sequence>
    </xsl:function>
    
    <xsl:function name="local:getType" as="xs:string">
        <xsl:param name="param" as="element(xsl:param)"/>
        <xsl:sequence select="if($param/@as) then $param/@as else 'item()'"/>
    </xsl:function>
        
</xsl:stylesheet>
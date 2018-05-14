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
    xmlns:idgen="top:marchand:xml:idgen"
    exclude-result-prefixes="#all"
    version="3.0">

    <xsl:import href="lib/identity.xsl"/>
    <xsl:import href="lib/id-generator.xsl"/>
    
    <xsl:param name="levelsToKeep" as="xs:string"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This program extract from input files all (root+1) components, and generates an ID for each</xd:p>
            <xd:p><xd:b>Created on:</xd:b> Jun 28, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> Christophe Marchand - christophe@marchand.top</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/file" priority="+1">
        <xsl:copy>
            <xsl:attribute name="levelsToKeep" select="$levelsToKeep"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="document(resolve-uri(@base-uri))">
                <xsl:with-param name="xsl-name" select="@name" tunnel="yes"/>
                <xsl:with-param name="base-uri" select="@base-uri" tunnel="yes"/>
                <xsl:with-param name="rel-uri" select="@rel-uri" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

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
        <component type="template" id="{generate-id(.)}" path="{idgen:getXPath(.)}">
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
        </component>
    </xsl:template>
    
    <xsl:template match="xsl:accumulator | xs:attribute-set |
        xsl:character-map | xsl:decimal-format | xsl:import-schema |
        xsl:key | xsl:mode | xsl:namespace-alias | xsl:preserve-space |
        xsl:strip-space | xsl:param | xsl:variable | xsl:function">
        <component type="{local-name(.)}" id="{generate-id(.)}" path="{idgen:getXPath(.)}">
            <xsl:copy-of select="local:extractName((@name, @elements, @schema-location, @stylesheet-prefix, 'unnamed')[1])"/>    <!-- patch for strip-spaces -->
            <xsl:apply-templates select="@* except @name"/>
            <xsl:if test="self::xsl:function">
                <xsl:copy-of select="local:calcSignature(.)"/>
            </xsl:if>
        </component>
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
        <xsl:sequence>
            <xsl:attribute name="signature" select="idgen:calcSignature($function)"/>
        </xsl:sequence>
    </xsl:function>
        
</xsl:stylesheet>
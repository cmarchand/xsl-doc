<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 5, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>Prepares the Table Of Content</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <data tocOutputUri="{file/@tocOutputUri}">
            <by-file label="file">
                <xsl:apply-templates select="file" mode="by-file"/>
            </by-file>
            <by-type label="type">
                <xsl:for-each-group select=".//element" group-by="@type">
                    <group name="{current-grouping-key()}">
                        <xsl:apply-templates select="current-group()" mode="grouping">
                            <xsl:with-param name="groupName" select="current-grouping-key()"/>
                        </xsl:apply-templates>
                    </group>
                </xsl:for-each-group>
            </by-type>
            <by-namespace label="namespace">
                <xsl:for-each-group select=".//element" group-by="@namespace">
                    <group name="{current-grouping-key()}">
                        <xsl:apply-templates select="current-group()" mode="grouping">
                            <xsl:with-param name="groupName" select="current-grouping-key()"/>
                        </xsl:apply-templates>
                    </group>
                </xsl:for-each-group>
            </by-namespace>
            <by-mode label="mode">
                <xsl:for-each-group select=".//element[@type='template']" group-by="(@mode,'')[1]">
                    <group name="{current-grouping-key()}">
                        <xsl:apply-templates select="current-group()" mode="grouping">
                            <xsl:with-param name="groupName" select="current-grouping-key()"/>
                        </xsl:apply-templates>
                    </group>
                </xsl:for-each-group>
            </by-mode>
        </data>
    </xsl:template>
    
    <xsl:template match="file" mode="by-file">
        <xsl:variable name="relUri" select="@root-rel-uri"/>
        <xsl:variable name="absUri" select="@base-uri"/>
        <group name="{$relUri}" rel-uri="{$relUri}" base-uri="{$absUri}">
            <xsl:apply-templates select="element" mode="by-file">
                <xsl:with-param name="relUri" select="$relUri"/>
            </xsl:apply-templates>
        </group>
        <xsl:apply-templates select="file" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="element" mode="by-file">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:copy>
            <xsl:attribute name="relUri" select="$relUri"/>
            <xsl:apply-templates select="@*" mode="#default"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="element" mode="grouping">
        <xsl:param name="groupName" as="xs:string"/>
        <xsl:copy>
            <xsl:attribute name="relUri" select="../@root-rel-uri"/>
            <xsl:apply-templates select="@*" mode="#default"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*" mode="#default">
        <xsl:copy-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>
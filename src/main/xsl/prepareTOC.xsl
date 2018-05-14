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
    
    <xsl:template match="/file">
        <data>
            <xsl:sequence select="@tocOutputUri|@root-rel-uri|@type"/>
            <by-file label="file">
                <xsl:for-each-group select="component" group-by="(@rel-uri,/file/@rel-uri)[1]">
                    <group name="{current-grouping-key()}">
                        <xsl:sequence select="(current-group()[1]/@rel-uri,/file/@rel-uri)[1]"/>
                        <xsl:sequence select="(current-group()[1]/@root-rel-uri,/file/@root-rel-uri)[1]"/>
                        <xsl:sequence select="current-group()"/>
                    </group>
                </xsl:for-each-group>
            </by-file>
            <by-type label="type">
                <xsl:for-each-group select="component" group-by="@type">
                    <group name="{current-grouping-key()}">
                        <xsl:sequence select="current-group()"/>
                    </group>
                </xsl:for-each-group>
            </by-type>
            <by-namespace label="namespace">
                <xsl:for-each-group select="component" group-by="@namespace">
                    <group name="{current-grouping-key()}">
                        <xsl:sequence select="current-group()"/>
                    </group>
                </xsl:for-each-group>
            </by-namespace>
            <by-mode label="mode">
                <xsl:for-each-group select="component[@type='template']" group-by="(@mode,'')[1]">
                    <group name="{current-grouping-key()}">
                        <xsl:sequence select="current-group()"/>
                    </group>
                </xsl:for-each-group>
            </by-mode>
        </data>
    </xsl:template>
    
</xsl:stylesheet>

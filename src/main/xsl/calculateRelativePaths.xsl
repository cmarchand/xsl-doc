<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    
    <xsl:import href="lib/identity.xsl"/>
    <xsl:import href="lib/common.xsl"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 1, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> Christophe Marchand &lt;christophe@marchand.top&gt; </xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- the root folder where all xsl sources are in the project -->
    <xsl:param name="absoluteRootFolder" as="xs:string" required="yes"/>
    <xsl:param name="levelsToKeep" as="xs:string"/>
    <xsl:param name="projectName" as="xs:string"/>
    
    <xsl:variable name="absoluteRootUri" as="xs:anyURI">
        <xsl:choose>
            <xsl:when test="starts-with($absoluteRootFolder,'file:/')">
                <xsl:sequence select="resolve-uri($absoluteRootFolder)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- if starts with file:, but not with file:/, add the missing / -->
                <xsl:sequence select="resolve-uri(concat('file:/',substring($absoluteRootFolder,6)))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable> 
    <xsl:variable name="nLevelsToKeep" as="xs:integer" select="number($levelsToKeep) cast as xs:integer"></xsl:variable>
    
    <xsl:template match="/">
        <xsl:comment><xsl:value-of select="$absoluteRootUri"/></xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="file">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="root-rel-uri">
                <xsl:choose>
                    <xsl:when test="(@catalog-name,@package-name)[1][matches(.,'^http://www\.daisy\.org/')]">
                        <xsl:sequence select="replace((@catalog-name,@package-name)[1],'^http://www\.daisy\.org/','org/daisy/')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat(replace($projectName,'[^a-zA-Z0-9\.-]','_'),
                                                     '/',local:normalizeFilePath(local:getRelativePath($absoluteRootUri,@base-uri)))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="decoupe" as="xs:string+" select="tokenize(@base-uri,'/')"/>
            <xsl:attribute name="index-label" select="string-join($decoupe[position() ge (count($decoupe)-$nLevelsToKeep)],'/')"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@base-uri">
        <xsl:attribute name="base-uri" select="local:normalizeFilePath(.)"/>
    </xsl:template>

</xsl:stylesheet>
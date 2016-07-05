<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    
    <xsl:import href="identity.xsl"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 1, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- the root folder where all xsl sources are in the project -->
    <xsl:param name="absoluteRootFolder" as="xs:string" required="yes"/>
    <xsl:variable name="absoluteRootUri" as="xs:anyURI" select="resolve-uri($absoluteRootFolder)"/>
    
    <xsl:template match="file">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="root-rel-uri" select="local:normalizeFilePath(local:getRelativePath($absoluteRootUri,@base-uri))"></xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@base-uri">
        <xsl:attribute name="base-uri" select="local:normalizeFilePath(.)"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Normalize the URI path. I.E. removes any /./ and folder/.. moves</xd:desc>
        <xd:param name="path">The path to normalize</xd:param>
        <xd:return>The normalized path, as a <html:tt>xs:string</html:tt></xd:return>
    </xd:doc>
    <xsl:function name="local:normalizeFilePath">
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="local:removeLeadingDotSlash(local:removeSingleDot(local:removeDoubleDot($path)))"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Removes single dot in path URI. . are always a self reference, so ./ can always be removed safely</xd:desc>
        <xd:param name="path">The path to remove single dots from</xd:param>
        <xd:return>The clean path, as xs:string</xd:return>
    </xd:doc>
    <xsl:function name="local:removeSingleDot" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" select="replace($path, '/\./','/')"/>
        <xsl:choose>
            <xsl:when test="matches($temp, '/\./')">
                <xsl:sequence select="local:removeSingleDot($temp)"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Removes the leading "./" from the path</xd:desc>
        <xd:param name="path">The path to clean</xd:param>
        <xd:return>The clean path</xd:return>
    </xd:doc>
    <xsl:function name="local:removeLeadingDotSlash">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" select="replace($path, '^\./','')"/>
        <xsl:choose>
            <xsl:when test="starts-with($temp, './')">
                <xsl:sequence select="local:removeLeadingDotSlash($temp)"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:removeDoubleDot" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" as="xs:string" select="replace($path,'/[^./]*/\.\./','/')"/>
        <xsl:choose>
            <xsl:when test="matches($temp,'/[^./]*/\.\./')">
                <xsl:sequence select="local:removeDoubleDot($temp)"></xsl:sequence>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:isAbsoluteUri" as="xs:boolean">
        <xsl:param name="path" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$path eq ''"><xsl:sequence select="false()"/></xsl:when>
            <xsl:otherwise><xsl:sequence select="matches($path,'[a-zA-Z0-9]+:.*')"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:getRelativePath" as="xs:string">
        <xsl:param name="source" as="xs:string"/>
        <xsl:param name="target" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$source eq ''"><xsl:message error-code="GRP001">local:getRelativePath('','<xsl:value-of select="$target"/>') : first argument must not be an empty string</xsl:message></xsl:when>
            <xsl:when test="local:isAbsoluteUri($source)">
                <xsl:choose>
                    <xsl:when test="not(local:isAbsoluteUri($target))"><xsl:sequence select="string-join((tokenize($source,'/'),tokenize($target,'/')),'/')"/></xsl:when>
                    <xsl:otherwise>
                        <!-- si les protocoles sont differents, on renvoie $target -->
                        <xsl:variable name="protocole" select="local:getProtocol($source)"/>
                        <xsl:choose>
                            <xsl:when test="$protocole eq local:getProtocol($target)">
                                <!-- combien d'éléments en début d'URI sont identiques ? -->
                                <xsl:variable name="sourceSeq" select="tokenize(substring($source,string-length($protocole)+1),'/')" as="xs:string*"/>
                                <xsl:variable name="targetSeq" select="tokenize(substring($target,string-length($protocole)+1),'/')" as="xs:string*"/>
                                <xsl:variable name="nbCommonElements" as="xs:integer" select="local:getNbEqualsElements($sourceSeq, $targetSeq)"/>
                                <xsl:variable name="goUpLevels" as="xs:integer" select="count($sourceSeq) - $nbCommonElements"/>
                                <xsl:variable name="goUp" as="xs:string*" select="(for $i in (1 to $goUpLevels) return '..')" />
                                <xsl:sequence select="string-join(($goUp, subsequence($targetSeq, $nbCommonElements+1)),'/')"></xsl:sequence>
                            </xsl:when>
                            <xsl:otherwise><xsl:sequence select="$target"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="absoluteSource" as="xs:string" select="xs:string(resolve-uri($source))"/>
                <xsl:choose>
                    <xsl:when test="local:isAbsoluteUri($absoluteSource)">
                        <xsl:sequence select="local:getRelativePath($absoluteSource, $target)"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:message error-code="GRP002"><xsl:value-of select="$source"/> can not be resolved as an absolute URI</xsl:message></xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:getProtocol" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="protocol" select="substring-before($path,':')"/>
        <xsl:choose>
            <xsl:when test="string-length($protocol) gt 0"><xsl:sequence select="$protocol"/></xsl:when>
            <xsl:otherwise><xsl:message error-code="GPR001">local:protocol('<xsl:value-of select="$path"/>') : path must be an absolute URI</xsl:message></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:getNbEqualsElements" as="xs:integer">
        <xsl:param name="seq1" as="item()*"/>
        <xsl:param name="seq2" as="item()*"/>
        <xsl:choose>
            <xsl:when test="deep-equal($seq1[1],$seq2[1])">
                <xsl:sequence select="local:getNbEqualsElements(tail($seq1), tail($seq2))+1"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="0"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
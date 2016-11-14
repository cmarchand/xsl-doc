<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sc="top:marchand:xml:source-code"
    exclude-result-prefixes="xs math xd"
    default-mode="source-code"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 7, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>Generates a HTML view of xml</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="*">
        <div xmlns="http://www.w3.org/1999/xhtml" class="sc§element">
            <span class="sc§marker">&lt;</span><span class="sc§elName"><xsl:value-of select="name(.)"/></span>
            <xsl:choose>
                <xsl:when test="sc:getAttrLength(@*) gt 100">
                    <div class="sc§attributes"><xsl:apply-templates select="@*"><xsl:with-param name="retLine" select="true()"/></xsl:apply-templates></div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="@*"><xsl:text> </xsl:text></xsl:if>
                    <xsl:apply-templates select="@*">
                        <xsl:with-param name="retLine" select="false()"/>
                    </xsl:apply-templates></xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="empty(node())"><span xmlns="http://www.w3.org/1999/xhtml" class="sc§marker">/&gt;</span></xsl:when>
                <xsl:otherwise>
                    <span xmlns="http://www.w3.org/1999/xhtml" class="sc§marker">&gt;</span>
                    <xsl:apply-templates mode="#current"/>
                    <span class="sc§marker">&lt;/</span><span class="sc§elName"><xsl:value-of select="name(.)"/></span><span class="sc§marker">&gt;</span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="comment() | processing-instruction()">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:param name="retLine" as="xs:boolean" select="false()"/>
        <span xmlns="http://www.w3.org/1999/xhtml" class="sc§attName"><xsl:value-of select="name(.)"/>=</span><span class="sc§attValue" xmlns="http://www.w3.org/1999/xhtml">&quot;<xsl:value-of select="."/>&quot;</span>
        <xsl:choose>
            <xsl:when test="$retLine"><br xmlns="http://www.w3.org/1999/xhtml"/></xsl:when>
            <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="sc:getCssCode" as="xs:string" visibility="public">
        <xsl:sequence>
            div.sc§element { margin-left: 12px; font-name: "Lucida Console", Monaco, monospace; }
            div.sc§attributes { margin-left: 24px; }
            .sc§marker { color: #002db3; }
            .sc§elName { color: #3385ff; }
            .sc§attName { color: #ff9933; }
            .sc§attValue { color: #b35900; }
        </xsl:sequence>
    </xsl:function>
    
    <xsl:function name="sc:getAttrLength" as="xs:integer" visibility="private">
        <xsl:param name="attrs" as="attribute()*"/>
        <xsl:sequence select="sum(for $a in $attrs return string-length(name($a))+3+string-length($a) )"/>
    </xsl:function>
    
</xsl:stylesheet>
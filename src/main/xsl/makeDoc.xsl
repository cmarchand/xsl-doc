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
            <xd:p>Generates the documentation</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:for-each-group select="//file" group-by="@htmlOutputUri">
            <xsl:apply-templates select="//file[@htmlOutputUri=current-grouping-key()][1]"/>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="file">
        <!--xsl:message>while processing <xsl:value-of select="base-uri(.)"/>, creating <xsl:value-of select="@htmlOutputUri"/></xsl:message-->
        <xsl:result-document method="xhtml" version="5" indent="yes" href="{@htmlOutputUri}">
            <xsl:variable name="xsl" select="document(@base-uri)"/>
            <!--xsl:message>root element of <xsl:value-of select="@base-uri"/> is Q{<xsl:value-of select="namespace-uri($xsl/*)"/>}<xsl:value-of select="local-name($xsl/*)"/></xsl:message-->
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>Documentation of <xsl:value-of select="@root-rel-uri"/></title>
                    <style type="text/css">
                        table { border-collapse: collapse; }
                        th, td { text-align: left; border: solid white 1px; }
                        th { background-color: #cccccc; }
                        .hideable { border: solid black 1px; border-radius: 5px; margin: 3px; margin-bottom: 5px; padding: 3px;}
                        .content { padding-left: 7px; }
                    </style>
                </head>
                <body>
                    <h2>Documentation of <xsl:value-of select="@root-rel-uri"/></h2>
            <xsl:apply-templates select="$xsl" mode="doc">
                <xsl:with-param name="file" select="." tunnel="yes"/>
            </xsl:apply-templates>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="/" mode="doc">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!--xsl:template match="xsl:stylesheet | xsl:transform" mode="doc">
        <xsl:param name="file" as="element(file)" tunnel="yes"/>
        <xsl:message>in template match stylesheet</xsl:message>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Documentation of <xsl:value-of select="$file/@root-rel-uri"/></title>
            </head>
            <body>
                <xsl:apply-templates select="*" mode="#current"/>                
            </body>
        </html>
    </xsl:template-->
    
    <xsl:template match="xsl:import | xsl:include"/>
    
    <xsl:template match="xsl:stylesheet | xsl:transform" mode="doc">
        <xsl:param name="file" as="element(file)" tunnel="yes"/>
        <xsl:apply-templates select="*" mode="#current"/>
    </xsl:template>
    
    <xsl:template mode="doc" match="xsl:accumulator | xs:attribute-set | 
        xsl:character-map | xsl:decimal-format | xsl:import-schema | 
        xsl:key | xsl:mode | xsl:namespace-alias | xsl:preserve-space | 
        xsl:strip-space | xsl:param | xsl:variable | xsl:template | xsl:function">
        <xsl:param name="file" as="element(file)" tunnel="yes"/>
        <xsl:variable name="id" select="generate-id()"/>
        <xsl:variable name="element" select="$file/element[@id eq $id]"/>
        <xsl:apply-templates select="$element" mode="doc">
            <xsl:with-param name="source" select="."/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="file" mode="doc">
        <xsl:apply-templates select="element" mode="#current"/>
    </xsl:template>
    <xsl:template match="element" mode="doc">
        <xsl:variable name="id" select="@id"></xsl:variable>
        <a id="{$id}" xmlns="http://www.w3.org/1999/xhtml"/>
        <div xmlns="http://www.w3.org/1999/xhtml" class="hideable">
            <details open="open" xmlns="http://www.w3.org/1999/xhtml">
                <summary>
                    <xsl:copy-of select="local:decodeTypeElement(@type)"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>
                    <xsl:if test="@mode">
                        <br/><strong>mode</strong> : <xsl:value-of select="@mode"/>
                    </xsl:if>
                </summary>
                <div class="content">
                    <table xmlns="http://www.w3.org/1999/xhtml">
                        <xsl:for-each select="@* except (@name, @id)">
                            <xsl:if test="normalize-space(.)">
                                <tr>
                                    <th><xsl:value-of select="local-name(.)"></xsl:value-of></th>
                                    <td><xsl:value-of select="."/></td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </table>
                    <!--xsl:variable name="code" select=""></xsl:variable-->
                </div>
            </details>
        </div>
    </xsl:template>
    
    <xsl:function name="local:decodeTypeElement">
        <xsl:param name="type" as="xs:string"/>
        <xsl:variable name="ret" as="item()">
            <xsl:choose>
                <xsl:when test="$type eq 'param'">Parameter</xsl:when>
                <xsl:when test="$type = ('template','function','variable','character-map','decimal-format','accumulator','attribute-set','import-schema','key','mode','namespace-alias','preserve-space','stri-space')">
                    <xsl:value-of select="string-join(for $t in tokenize($type,'-') return concat(upper-case(substring($t,1,1)),substring($t,2)),' ')"/>
                </xsl:when>
                <xsl:otherwise><span class="error" xmlns="http://www.w3.org/1999/xhtml"><xsl:value-of select="concat('Unknown element type: ',$type)"/></span></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$ret"/>
    </xsl:function>
    
</xsl:stylesheet>
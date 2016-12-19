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
    xmlns:generic="http://marchand.top/xml/xsl/documentation/generic"
    xmlns:idgen="top:marchand:xml:idgen" 
    xmlns:sc="top:marchand:xml:source-code"
    exclude-result-prefixes="xs math xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 6, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>Generates the documentation of each file</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="lib/id-generator.xsl"/>
    <xsl:import href="documentation/xd_doc.xsl"/>
    <xsl:import href="source-code.xsl"/>

    <xsl:template match="/">
        <xsl:for-each-group select="//file" group-by="@htmlOutputUri">
            <xsl:apply-templates select="//file[@htmlOutputUri=current-grouping-key()][1]"/>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="file">
        <xsl:result-document method="xhtml" version="5" indent="yes" href="{@htmlOutputUri}">
            <xsl:variable name="xsl" select="document(@base-uri)"/>
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>Documentation of <xsl:value-of select="@root-rel-uri"/></title>
                    <style type="text/css">
                        table{
                            border-collapse:collapse;
                        }
                        th,
                        td{
                            text-align:left;
                            border:solid white 1px;
                        }
                        th{
                            background-color:#cccccc;
                        }
                        .hideable{
                            border:solid black 1px;
                            border-radius:5px;
                            margin:3px;
                            margin-bottom:5px;
                            padding:3px;
                        }
                        .content{
                            padding-left:7px;
                        }<!-- generic documentation style, mostly for comments -->
                        .generic§docDesc{
                            border:solid 1px #4d4d4d;
                            border-radius:2px;
                            background-color:#e6e6e6;
                        }<!-- insert here calls to various *:getCssCode functions from various implementation of documentation processing -->
                        <xsl:value-of select="xd:getCssCode()"/>
                        <xsl:value-of select="sc:getCssCode()"/>
                    </style>
                </head>
                <body>
                    <h2>Documentation of <xsl:value-of select="@root-rel-uri"/></h2>
                    <xsl:apply-templates select="$xsl//*[@scope='stylesheet']" mode="documentation"/>
                    <!--xsl:message><xsl:copy-of select="$xsl//*[@scope='stylesheet']"/></xsl:message-->
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

    <xsl:template match="xsl:import | xsl:include"/>

    <xsl:template match="xsl:stylesheet | xsl:transform" mode="doc">
        <xsl:param name="file" as="element(file)" tunnel="yes"/>
        <xsl:apply-templates select="*" mode="#current"/>
    </xsl:template>

    <xsl:template mode="doc"
        match="xsl:accumulator | xsl:attribute-set | 
        xsl:character-map | xsl:decimal-format | xsl:import-schema | 
        xsl:key | xsl:mode | xsl:namespace-alias | xsl:preserve-space | 
        xsl:strip-space | xsl:param | xsl:variable | xsl:template | xsl:function">
        <xsl:param name="file" as="element(file)" tunnel="yes"/>
        <xsl:variable name="path" select="idgen:getXPath(.)"/>
        <!--xsl:text>XPath = </xsl:text><xsl:value-of select="$path"/-->
        <xsl:choose>
            <xsl:when test="ancestor::xd:*"><xsl:next-match></xsl:next-match></xsl:when>
            <xsl:otherwise>
                <xsl:variable name="element" as="element(element)">
                    <xsl:choose>
                        <xsl:when test="self::xsl:function">
                            <xsl:variable name="signature" as="xs:string" select="idgen:calcSignature(.)"/>
                            <xsl:sequence select="$file/element[@signature eq $signature]" />
                        </xsl:when>
                        <xsl:otherwise><xsl:sequence select="$file/element[@path eq $path]"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!--xsl:if test="empty($element)">
                    <xsl:text>Element est vide</xsl:text>
                </xsl:if-->
                <xsl:variable name="this" select="."/>
                <xsl:variable name="documentation-element" as="element()?"
                    select="preceding-sibling::*[1][not(namespace-uri(.) eq 'http://www.w3.org/1999/XSL/Transform')][not(@scope='stylesheet')]"/>
                <xsl:variable name="documentation-comment" as="comment()?"
                    select="preceding-sibling::comment()[1][following-sibling::*[1][. is $this]]"/>
                <xsl:variable name="documentation" as="item()?">
                    <xsl:choose>
                        <xsl:when test="empty($documentation-comment)">
                            <xsl:sequence select="$documentation-element"/>
                        </xsl:when>
                        <xsl:when test="empty($documentation-element)">
                            <xsl:sequence select="$documentation-comment"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence
                                select="$documentation-comment[$documentation-element = preceding-sibling::*] union $documentation-element[$documentation-comment = preceding-sibling::comment()]"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="code" as="element()">
                    <div class="code" xmlns="http://www.w3.org/1999/xhtml">
                        <details>
                            <summary>Source code</summary>
                            <xsl:apply-templates mode="source-code" select="."/>
                        </details>
                    </div>
                </xsl:variable>
                <xsl:apply-templates select="$element" mode="doc">
                    <xsl:with-param name="documentation" select="$documentation"/>
                    <xsl:with-param name="code" select="$code"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="element" mode="doc">
        <xsl:param name="documentation" as="item()?"/>
        <xsl:param name="code" as="element()"/>
        <xsl:variable name="id" select="@id"/>
        <a id="{$id}" xmlns="http://www.w3.org/1999/xhtml"/>
        <div xmlns="http://www.w3.org/1999/xhtml" class="hideable">
            <details open="open" xmlns="http://www.w3.org/1999/xhtml">
                <summary>
                    <xsl:copy-of select="local:decodeTypeElement(@type)"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="(@name, @match)[1]"/>
                    <xsl:if test="@mode">
                        <br/><strong>mode</strong> : <xsl:value-of select="@mode"/>
                    </xsl:if>
                </summary>
                <div class="content">
                    <!--table xmlns="http://www.w3.org/1999/xhtml">
                        <xsl:for-each select="@* except (@name, @id, @path)">
                            <xsl:if test="normalize-space(.)">
                                <tr>
                                    <th>
                                        <xsl:value-of select="local-name(.)"/>
                                    </th>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </table-->
                    <xsl:apply-templates select="$documentation" mode="documentation"/>
                    <xsl:copy-of select="$code"/>
                </div>
            </details>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:a docid="" href=""/>
        </xd:desc>
    </xd:doc>
    <xsl:template mode="documentation" match="comment()">
        <div class="generic§docDesc" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="text()" mode="doc"/>

    <xsl:function name="local:decodeTypeElement">
        <xsl:param name="type" as="xs:string"/>
        <xsl:variable name="ret" as="item()">
            <xsl:choose>
                <xsl:when test="$type eq 'param'">Parameter</xsl:when>
                <xsl:when
                    test="$type = ('template','function','variable','character-map','decimal-format','accumulator','attribute-set','import-schema','key','mode','namespace-alias','preserve-space','stri-space')">
                    <xsl:value-of
                        select="string-join(for $t in tokenize($type,'-') return concat(upper-case(substring($t,1,1)),substring($t,2)),' ')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <span class="error" xmlns="http://www.w3.org/1999/xhtml">
                        <xsl:value-of select="concat('Unknown element type: ',$type)"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$ret"/>
    </xsl:function>

</xsl:stylesheet>

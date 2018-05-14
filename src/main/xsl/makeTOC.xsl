<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:local="top:marchand:xml:local"
    exclude-result-prefixes="#all"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This program generates the TOC of an XSL and her dependencies. It produces the xhtml document directly via result-document</xd:p>
            <xd:p><xd:b>Created on:</xd:b> Jul 1, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:import href="lib/common.xsl"/>
    
    <!--xsl:param name="outputFolder" as="xs:string" required="yes"/-->
    <!--xsl:variable name="outputFolderUri" as="xs:anyURI" select="resolve-uri(if (ends-with($outputFolder,'/')) then $outputFolder else concat($outputFolder,'/'))"/-->
    
    <xsl:template match="/data">
        <xsl:result-document href="{@tocOutputUri}" method="xhtml" indent="yes">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>Table of Contents</title>
                    <base href="{string-join(for $i in 2 to count(tokenize(local:getTocFileUri(@root-rel-uri),'/')) return '..','/')}"/>
                    <style type="text/css">
                        .niv1{
                        border: 1px solid black;
                        border-radius: 3px;
                        padding:3px;
                        }
                        .niv2{
                        border: 1px solid #777777;
                        border-radius: 3px;
                        padding: 3px;
                        margin-left: 15px;
                        }
                        div.niv1<xsl:text disable-output-escaping="yes">></xsl:text>details<xsl:text disable-output-escaping="yes">></xsl:text>summary{
                        background-color: #75baff;
                        }
                        div.niv2<xsl:text disable-output-escaping="yes">></xsl:text>details<xsl:text disable-output-escaping="yes">></xsl:text>summary{
                        background-color: #99ccff;
                        }
                    </style>
                </head>
                <body>
                    <xsl:apply-templates></xsl:apply-templates>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*[starts-with(local-name(), 'by-')]">
        <div class="niv1" xmlns="http://www.w3.org/1999/xhtml">
            <details open="open">
                <xsl:variable name="type" as="xs:string" select="substring(local-name(),4)"/>
                <summary>Content by <xsl:value-of select="$type"/></summary>
                <xsl:apply-templates >
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </details>
        </div>
    </xsl:template>
    
    <xsl:template match="group">
        <xsl:param name="type" as="xs:string"/>
        <div class="niv2" xmlns="http://www.w3.org/1999/xhtml">
            <details>
                <summary>
                    <xsl:choose>
                        <xsl:when test="$type eq 'file'">
                            <xsl:message>local:getDocumentationFileURI(<xsl:value-of select="@rel-uri"/>)-&lt;<xsl:value-of select="local:getDocumentationFileURI(@rel-uri)"/></xsl:message>
                                <xsl:message>
                                    <xsl:copy-of select="."/>
                                </xsl:message>
                            <a href="{local:getDocumentationFileURI(@rel-uri)}" target="doc"><xsl:value-of select="@name"/></a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="(@name[normalize-space()],concat('no ',../@label))[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </summary>
                <ul><xsl:apply-templates /></ul>
            </details>
        </div>
    </xsl:template>
    
    <xsl:template match="element">
        <li xmlns="http://www.w3.org/1999/xhtml">
            <a href="{local:getDocumentationFileURI(@relUri)}#{@id}" target="doc"><xsl:value-of select="(@name,@match)[1]"/></a>
        </li>
    </xsl:template>
    
</xsl:stylesheet>
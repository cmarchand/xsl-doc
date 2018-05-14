<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    
    <xsl:include href="lib/common.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 25, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>Generates the index file</xd:p>
        </xd:desc>
    </xd:doc>
        
    <xsl:template match="/file">
        <xsl:result-document method="html" indent="yes" encoding="UTF-8" href="{@welcomeOutputUri}" doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN http://www.w3.org/TR/html4/frameset.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>Documentation of <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="(@catalog-name,@package-name,@name)[1]"/></title>
                    <base href="{string-join(for $i in 2 to count(tokenize(local:getWelcomeFileURI(@root-rel-uri),'/')) return '..','/')}"/>
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
                    <frameset cols="25%,75%">
                        <frame name="toc" src="{local:getTocFileUri(@root-rel-uri)}"/>
                        <frame name="doc" src="{local:getDocumentationFileURI(@root-rel-uri)}"/>
                    </frameset>
            </html>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>
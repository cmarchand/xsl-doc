<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs math xd"
    xmlns:xsldoc="top:marchand:xml:xsl:doc"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 6, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="xsldoc:sData" as="xs:string"/>
    <xsl:param name="xsldoc:programName" as="xs:string" select="''"/>
    <xsl:param name="xsldoc:absoluteRootDir" as="xs:string"/>
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
        
    <xsl:template name="xsldoc:main" expand-text="yes">
        <xsl:variable name="data" as="map(xs:string, xs:string)">
            <xsl:variable name="pairs" as="xs:string+" select="tokenize($xsldoc:sData,'\|')"/>
            <xsl:variable name="items" as="map(xs:string,xs:string)*">
                <xsl:for-each select="$pairs">
                    <xsl:variable name="entry" as="xs:string+" select="tokenize(., '@')"/>
                    <xsl:sequence select="map:entry($entry[1], $entry[2])"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="map:merge($items)"/>
        </xsl:variable>
        <html>
            <head>
                <title>{if(string-length($xsldoc:programName)) then concat($xsldoc:programName,' ') else ''}XSL documentation</title>
            </head>
            <body>
                <h3>{if(string-length($xsldoc:programName)) then concat($xsldoc:programName,' ') else ''}XSL documentation</h3>
                <ul>
                    <xsl:for-each select="map:keys($data)">
                        <xsl:variable name="relativePath" as="xs:string" select="."/> <!-- substring(., string-length($xsldoc:absoluteRootDir))-->
                        <xsl:variable name="target" as="xs:string" select="map:get($data, $relativePath)"/>
                        <li><a href="{$target}"><xsl:value-of select="$relativePath"/></a></li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>
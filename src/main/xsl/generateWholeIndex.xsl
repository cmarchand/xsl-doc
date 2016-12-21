<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs math xd map xsldoc"
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
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
        
    <xsl:template name="xsldoc:main" expand-text="yes">
        <entries>
            <xsl:variable name="pairs" as="xs:string+" select="tokenize($xsldoc:sData,'\|')"/>
            <xsl:for-each select="$pairs">
                <xsl:variable name="entry" as="xs:string+" select="tokenize(., '@')"/>
                <entry label="{$entry[1]}" value="{$entry[2]}" levelsToKeep="{$entry[3]}"/> 
            </xsl:for-each>
        </entries>
    </xsl:template>
    
</xsl:stylesheet>
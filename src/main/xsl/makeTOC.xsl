<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This program generates the TOC of an XSL and her dependencies. It produces the xhtml document directly via result-document</xd:p>
            <xd:p><xd:b>Created on:</xd:b> Jul 1, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="outputFolder" as="xs:string" required="yes"/>
    <xsl:variable name="outputFolderUri" as="xs:anyURI" select="if (ends-with($outputFolder,'/')) then $outputFolder else concat($outputFolder,'/')"/>
    
    <xsl:template match="file[@dependance-type='first-doc']">
        
    </xsl:template>
    
</xsl:stylesheet>
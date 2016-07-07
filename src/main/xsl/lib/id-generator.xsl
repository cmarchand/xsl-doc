<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:idgen="top:marchand:xml:idgen"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 7, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>This XSL defines a function to generate an id that is guaranteed to be unique, 
                and which is guaranteed to be the same when executed multiple times in different executions or multiple load of source document</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:function name="idgen:getXPath" as="xs:string">
        <xsl:param name="el" as="node()"/>
        <xsl:variable name="path" as="xs:string" select="path($el)"/>
        <xsl:sequence select="$path"/>
    </xsl:function>
    
</xsl:stylesheet>
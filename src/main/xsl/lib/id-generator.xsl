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
    
    <xsl:function name="idgen:calcSignature" as="xs:string">
        <xsl:param name="function" as="element(xsl:function)"/>
        <xsl:variable name="qname" as="xs:string" select="$function/@name"/>
        <xsl:variable name="prefix" as="xs:string" select="substring-before($qname,':')"/>
        <xsl:variable name="NS" as="xs:anyURI">
            <xsl:choose>
                <xsl:when test="string-length($prefix) gt 0">
                    <xsl:value-of select="$function/ancestor-or-self::*/namespace::*[name() eq $prefix][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$function/ancestor-or-self::*/namespace::*[name() eq ''][1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="name" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains($qname,':')"><xsl:value-of select="substring-after($qname,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$qname"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="functionName" as="xs:string" select="concat('Q{',$NS,'}',$name,'(')"/>
        <xsl:variable name="parameters" as="xs:string*" select="for $i in $function/xsl:param return idgen:getType($i)"/>
        <xsl:variable name="useWhenClause" as="xs:string?" select="if ($function/@use-when and $function/@use-when != '') then (concat('/',$function/@use-when)) else ()"/>
        <xsl:sequence select="concat($functionName, string-join($parameters,','),')',$useWhenClause)"/>
    </xsl:function>
    
    <xsl:function name="idgen:getType" as="xs:string">
        <xsl:param name="param" as="element(xsl:param)"/>
        <xsl:sequence select="if($param/@as) then $param/@as else 'item()'"/>
    </xsl:function>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.xemelios.org/namespaces#cge" xmlns:n="http://www.xemelios.org/namespaces#cge" version="2.0">
    <xsl:template name="number">
        <xsl:param name="num"/>
        <xsl:param name="hide.zero">0</xsl:param>
        <xsl:choose>
            <xsl:when test="string-length(string($num)) = 0"/>
            <xsl:when test="number($num) = 0">
                <xsl:choose>
                    <xsl:when test="$hide.zero eq '1'"/>
                    <xsl:otherwise><xsl:value-of select="format-number(0,'# ##0,00;-# ##0,00','decformat')"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string(number($num)) = 'NaN'"/>
            <xsl:when test="contains($num,'-')">
                <b class="negative"><xsl:value-of select="format-number($num,'# ##0,00;-# ##0,00','decformat')"/></b>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number($num,'# ##0,00;-# ##0,00','decformat')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

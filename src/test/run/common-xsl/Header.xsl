<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY egrave "&#232;">
<!ENTITY euro "&#8364;">
<!ENTITY agrave "&#224;">
<!ENTITY eacute "&#233;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.xemelios.org/namespaces#cge" xmlns:n="http://www.xemelios.org/namespaces#cge" version="2.0">
    <xsl:template name="header">
        <xsl:param name="Entete"/>
        <xsl:param name="Titre"/>
        <xsl:param name="Titre.Plus"/>
        
        <table width="100%" style="border-style:none;border-width:0px;cell-padding:0px;cell-spacing:0px;-fs-table-paginate: paginate;" >
            <colgroup>
                <col width="40%"/>
                <col width="40%"/>
                <col width="20"/>
            </colgroup>
            <tbody>
                <tr style="border:none;" id="lineEntete1">
                    <td style="border:none;" class="titre bold"><h3 style="text-align: left;"><xsl:value-of select="$Entete//n:Collectivite/@Libelle"/></h3></td>
                    <td style="border:none;"><!--&nbsp;--></td>
                    <td style="border:none;"><!--&nbsp;--><h3 style="text-align: right;">Exercice <xsl:value-of select="$Entete//n:Collectivite/@Exercice"/></h3></td>
                </tr>
                <xsl:if test="$Titre"><tr><td colspan="3" style="border:none;" class="titre center"><h1><xsl:value-of select="$Titre"/></h1></td></tr></xsl:if>
                <xsl:if test="$Titre.Plus"><tr><td colspan="3" style="border:none;" class="titre center"><xsl:copy-of select="$Titre.Plus/child::node()"/></td></tr></xsl:if>
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template name="header.table">
        <xsl:param name="Entete"/>
        <xsl:param name="Titre"/>
        <xsl:param name="Titre.Plus"/>
        <xsl:param name="colspan">1</xsl:param>
        
        <tr style="border:none;">
            <th style="border:none;" class="titre bold"><h3 style="text-align: left;"><xsl:value-of select="$Entete//n:Collectivite/@Libelle"/></h3></th>
            <xsl:choose>
                <xsl:when test="number($colspan)=1"><th style="border:none;"><!--&nbsp;--></th></xsl:when>
                <xsl:otherwise><th style="border:none;" colspan="{number($colspan)-2}"><!--&nbsp;--></th></xsl:otherwise>
            </xsl:choose>
            <th style="border:none;"><!--&nbsp;--><h3 style="text-align: right;">Exercice <xsl:value-of select="$Entete//n:Collectivite/@Exercice"/></h3></th>
        </tr>
        <xsl:if test="$Titre"><tr><th colspan="{$colspan}" style="border:none;text-align:center;" class="titre"><h1><xsl:value-of select="$Titre"/></h1></th></tr></xsl:if>
        <xsl:if test="$Titre.Plus"><tr><th colspan="{$colspan}" style="border:none;text-align:center;" class="titre"><xsl:copy-of select="$Titre.Plus/child::node()"/></th></tr></xsl:if>
    </xsl:template>
    
    <xsl:template name="iso-date-header">
        <xsl:param name="datebrute"/>
        <xsl:choose>
            <xsl:when test="string-length($datebrute)>0 and not(contains($datebrute,'..'))">        
                <xsl:value-of select="substring($datebrute, 9, 2)"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="substring($datebrute,6,2)"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="substring($datebrute, 1, 4)"/>
            </xsl:when>
            <xsl:when test="string-length($datebrute)>0 and contains($datebrute,'..')">
                <xsl:value-of select="$datebrute"/>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
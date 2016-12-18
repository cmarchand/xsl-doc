<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:efl="http://els.eu/ns/efl" xmlns:om="http://els.eu/ns/efl/offresMetiers"
  exclude-result-prefixes="#all" version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>Suppression des espaces du document en entrée pour tous les éléments. Permet de simuler
      cette suppression faite par l'export BaseX.</xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc>Suppression des espaces dans tous les éléments</xd:desc>
  </xd:doc>
  <xsl:strip-space elements="*"/>

  <xd:doc>
    <xd:desc>
      <xd:p>Copie par défaut</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:private="top:marchand:xml:xsldoc:exposeComponents"
  exclude-result-prefixes="xs private"
  version="3.0">

  <xsl:import href="lib/identity.xsl"/>
  <xsl:import href="lib/common.xsl"/>

  <xsl:template match="file">
    <xsl:variable name="this" as="element()" select="."/>
    <xsl:variable name="file" as="element(file)">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@dependance-type = ('xsl:import', 'xsl:include', 'xsl:use-package')">
        <xsl:for-each select="$file/component">
          <component id="{generate-id(.)}" idref="{@id}">
            <xsl:sequence select="../@rel-uri | ../@root-rel-uri | @type | @name | @match"/>
            <xsl:choose>
              <xsl:when test="../@dependance-type = ('xsl:import', 'xsl:include')">
                <xsl:call-template name="visibility">
                  <xsl:with-param name="type" select="@type"/>
                  <xsl:with-param name="name" select="@name"/>
                  <xsl:with-param name="declared-visibility" select="@visibility"/>
                  <xsl:with-param name="expose"
                    select="document($this/parent::*/@base-uri)/*/xsl:expose"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="@visibility = ('public', 'final')">
                <xsl:variable name="visibility" as="attribute(visibility)?">
                  <xsl:call-template name="visibility">
                    <xsl:with-param name="type" select="@type"/>
                    <xsl:with-param name="name" select="@name"/>
                    <xsl:with-param name="declared-visibility" select="()"/>
                    <xsl:with-param name="expose" select="
                        private:translate(document($this/parent::*/@base-uri)
                        /*/xsl:use-package[@href = $this/@rel-uri]/xsl:accept)" />
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$visibility">
                    <xsl:if test="not($visibility = 'hidden')">
                      <xsl:sequence select="$visibility"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="visibility" select="'private'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </component>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@dependance-type = 'first-doc'"/>
    </xsl:choose>
    <xsl:sequence select="$file"/>
  </xsl:template>
  
  <xsl:function name="private:translate" as="element(xsl:expose)*">
    <xsl:param name="accepts" as="element(xsl:accept)*"/>
    <xsl:sequence>
      <xsl:apply-templates select="$accepts" mode="translate"/>
    </xsl:sequence>
  </xsl:function>
  
  <xsl:template match="xsl:accept" mode="translate" as="element(xsl:expose)">
    <xsl:element name="expose" namespace="{namespace-uri(.)}">
      <xsl:copy-of select="@*"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

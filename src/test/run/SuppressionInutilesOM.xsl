<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:om="http://els.eu/ns/efl/offresMetiers" xmlns:saxon="http://saxon.sf.net/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:efl="http://els.eu/ns/efl"
  xmlns:local="suppressioninutilsOM" xmlns:conf="http://els.eu/ns/efl/config"
  exclude-result-prefixes="xs math xd" version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Création d'un script shell pour recopie des fichiers dans le repertoire Copie de
        Sauvegarde et chargement de la base XML</xd:p>
      <xd:p>Cette XSLT s'exécute avec le template nommé « main »</xd:p>
      <xd:p>Résultat de cette XSLT :</xd:p>
      <xd:ul>
        <xd:li>sur la sortie par défaut : le script shell de copie / déplacement des
          fichiers</xd:li>
        <xd:li>dans un fichier texte donné par $p-scriptXmlDb : le script de chargement pour la base
          XML</xd:li>
      </xd:ul>
      <xd:p>On utilise le streaming de XSLT 3 pour lire des infos au début de certains
        fichiers.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:mode name="stream" streamable="yes"></xsl:mode>
  <xsl:include href="eflCommon.xsl"/>
  <!--xsl:include href="../lib/xslt/confCommon.xsl"/-->
  <xsl:param as="xs:string" name="p-configUri" required="yes"/>
  <xsl:param name="p-debug" select="'debug'"></xsl:param>
  <xsl:variable as="xs:anyURI" name="configUri" select="xs:anyURI($p-configUri)"/>
  <xsl:variable name="configCopieEtCreationBase"
    select="conf:getConfigGroup($configUri,'CopieEtCreationBase')" as="element(groupe)"/>
  <xd:doc>
    <xd:desc>
      <xd:p>le nom de fichier absolu de la collection</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:param name="p-collection" select="'collection.xml'" as="xs:string"/>
  <xd:doc>
    <xd:desc>repertoire du dossier de sauvegarde des OM</xd:desc>
  </xd:doc>
  <xsl:param name="p-omSauv" select="'./sauvegarde/'" as="xs:string"/>
  <xsl:variable name="EFL_VERSION" select="'1.00.01'" as="xs:string"/>
  <xsl:variable name="filename-collection" select="$p-collection[normalize-space() != '']"
    as="xs:string"/>
  <xsl:variable name="doc-collection"
    select="if ($filename-collection !='') then doc($filename-collection) else ()"/>
  <xsl:variable name="anneeCourante" select="number(year-from-dateTime(current-dateTime()))"/>
  
  <xsl:key name="book-collection" match="file" use="substring-before(@filename,'.')"/>
  <xd:doc>
    <xd:desc>
      <xd:p>un saut de lignu unix pour les fichiers texte générés</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="newline" select="'&#x0A;'" as="xs:string"/>
  <xd:doc>
    <xd:desc>
      <xd:p> </xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:for-each select="tokenize(normalize-space(string()),' ')">
      <xsl:variable name="nomFichier" select="local:nomFichier(.)"/>
      <xsl:variable name="pdc">/<xsl:value-of
        select="((key('book-collection',$nomFichier,$doc-collection)))/ancestor-or-self::*/@code"
        separator="/"/>
      </xsl:variable>
      <xsl:variable name="ASauvegarder" select="local:ASauvegarder(concat('file:',.),$nomFichier,$pdc)"/>
      <xsl:if test="$p-debug='debug'">
      <xsl:message>
        <xsl:value-of select="."/> - <xsl:value-of select="$nomFichier"/> - PDC :
        <xsl:value-of select="$pdc"/> - <xsl:value-of select="$ASauvegarder"/></xsl:message>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$ASauvegarder != 'OK'">
          <xsl:text> # supprimé : </xsl:text>
          <xsl:value-of select="$ASauvegarder"/>
          <xsl:text> 
rm </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>
</xsl:text>
        </xsl:when>
        <xsl:otherwise># conservé : <xsl:value-of select="."/>
          <xsl:text>
</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:p>Détermine si le fichier est à ignorer. Sont à ignorer : tables alphabétiques, archives
        de fichiers (ex. mf2009.xml), ouvrages fpat et assoc</xd:p>
    </xd:desc>
    <xd:param name="elemFichier">élément fichier généré par le template "main"</xd:param>
    <xd:return>true si on doit ignorer le fichier, false sinon</xd:return>
  </xd:doc>
  <xsl:function name="local:ASauvegarder" as="xs:string">
    <xsl:param name="uriDoc" as="xs:string"></xsl:param>
    <xsl:param name="nomDoc" as="xs:string"/>
    <xsl:param name="pdc" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$pdc = '/'">
        <xsl:value-of select="'Pas dans collection'"/>
      </xsl:when>
      <xsl:when test="$nomDoc = 'collection'">
        <xsl:value-of select="'fichier collection'"/>
      </xsl:when>
      <xsl:when test="$nomDoc = 'fpat'">
        <xsl:value-of select="'fichier fpat'"/>
      </xsl:when>
      <xsl:when test="$nomDoc = 'asso'">
        <xsl:value-of select="'fichier asso'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="extraitsFichier">
          <extrait>
            <xsl:call-template name="stream">
              <xsl:with-param name="filename" select="$uriDoc"></xsl:with-param>
            </xsl:call-template>
          </extrait>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="lower-case($extraitsFichier/extrait/attributs/@archive) = 'oui'">
            <xsl:value-of select="'fichier archive'"/>
          </xsl:when>
          <xsl:when test="$extraitsFichier/extrait/root-name/text() = ('alphamem' , 'talpha')">
            <xsl:value-of select="'fichier table alpha'"/>
          </xsl:when>
          <xsl:when test="$configCopieEtCreationBase/sgroupe[@nom=$pdc]/var[@nom='a_sauvegarder']">
            <xsl:value-of
              select="if ($configCopieEtCreationBase/sgroupe[@nom=$pdc]/var[@nom='a_sauvegarder'] = 'true') then 'OK' else 'PDC pas à sauvegarder'"
            />
          </xsl:when>
          <xsl:when
            test="$configCopieEtCreationBase/sgroupe[starts-with($pdc,@nom)]/var[@nom='a_sauvegarder']">
            <xsl:value-of
              select="if ($configCopieEtCreationBase/sgroupe[starts-with($pdc,@nom)][1]/var[@nom='a_sauvegarder']/text() = 'true') then 'OK' else 'début de PDC pas à sauvegarder'"
            />
          </xsl:when>
          <xsl:when
            test="$configCopieEtCreationBase/sgroupe[starts-with($pdc,@nom)]/var[@nom='annee_a_sauvegarder']">
            <xsl:variable name="annee"
              select="number($configCopieEtCreationBase/sgroupe[starts-with($pdc,@nom)][1]/var[@nom='annee_a_sauvegarder'])"/>
            <xsl:variable name="anneeRevue"
              select="string(tokenize(($extraitsFichier/extrait/attributs/@an,$extraitsFichier/extrait/attributs/@date,$extraitsFichier/extrait/attributs/@anneePublication,$extraitsFichier/extrait/attributs/@date,$extraitsFichier/extrait/attributs/@anneePublication)[1],'/')[last()])"> </xsl:variable>
            <xsl:variable name="anneeRevue">
              <xsl:choose>
                <xsl:when test="string-length($anneeRevue) = 4">
                  <xsl:value-of select="$anneeRevue"/>
                </xsl:when>
                <xsl:when test="starts-with($anneeRevue,'0') or starts-with($anneeRevue,'1')">
                  <xsl:value-of select="concat('20',$anneeRevue)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('19',$anneeRevue)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:value-of
              select="if ((number($anneeRevue) + number($annee)) &gt; $anneeCourante) then 'OK' else concat('fichier trop vieux : ',$anneeRevue)"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'OK'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function name="local:nomFichier">
    <xsl:param name="nom"/>
    <xsl:value-of select="tokenize(tokenize($nom,'\.')[1],'/')[last()]"/>
  </xsl:function>
  <xsl:template name="stream">
    <xsl:param name="filename" as="xs:string"/>
    <xsl:stream href="{$filename}">
      <xsl:apply-templates select="/*" mode="stream"></xsl:apply-templates>
      <!-- 
        <xsl:for-each
          select="(self::*[@an, @date,@anneePublication], *[@date,@anneePublication])[1]">
          <noeud>
            <xsl:value-of select="local:nomFichier(.)"/>
          </noeud>
          <attributs>
            <xsl:value-of select="@*"/>
          </attributs>
        </xsl:for-each>
         -->
    </xsl:stream>
  </xsl:template>
  <xsl:template match="*" mode="stream">
    <root-name>
      <xsl:value-of select="local-name(.)"></xsl:value-of>
    </root-name>
    <attributs>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="*/@*"/>
    </attributs>    
  </xsl:template>
  
</xsl:stylesheet>

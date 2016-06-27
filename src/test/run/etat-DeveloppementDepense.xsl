<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY egrave "&#232;">
<!ENTITY euro "&#8364;">
<!ENTITY agrave "&#224;">
<!ENTITY eacute "&#233;">
]>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:n="http://www.xemelios.org/namespaces#cge" xmlns:added="http://www.xemelios.org/namespaces#added" version="2.0">
    <xsl:character-map name="accents">
        <xsl:output-character character="à" string="&amp;#224;"/>
        <xsl:output-character character="é" string="&amp;#233;"/>
        <xsl:output-character character="è" string="&amp;#232;"/>
        <xsl:output-character character="ê" string="&amp;#234;"/>
        <xsl:output-character character="ë" string="&amp;#235;"/>
        <xsl:output-character character="î" string="&amp;#238;"/>
        <xsl:output-character character="ï" string="&amp;#239;"/>
        <xsl:output-character character="ô" string="&amp;#244;"/>
        <xsl:output-character character="ù" string="&amp;#249;"/>
    </xsl:character-map>

    <xsl:decimal-format name="decformat" decimal-separator="," grouping-separator=" " digit="#" pattern-separator=";" NaN="NaN" minus-sign="-"/>
    
    <!-- Inclusion des XSL externes -->
    <xsl:include href="./common-xsl/Style.xsl"/>
    <xsl:include href="./common-xsl/Error.xsl"/>
    <xsl:include href="./common-xsl/Navigate.xsl"/>
    <xsl:include href="./common-xsl/Header.xsl"/>
    <xsl:include href="./common-xsl/Number.xsl"/>
    
    <!-- Paramètres d'entrée -->
    <xsl:param name="show.formulaire"/>
    <xsl:param name="browser-destination"/>
    
    <!-- Paramètres Web -->
    <xsl:param name="is.web">-1</xsl:param>
    <xsl:param name="context.path"/>
    
    <!-- Paramètres d'entrée de la liste de résultat -->
    <xsl:param name="libPoste">0</xsl:param>
    
    <!-- Paramètres d'erreur -->
    <xsl:param name="error.message">nomessage</xsl:param>

    <!-- Paramètres d'entrée de la liste de résultat -->
    <xsl:param name="numCompte">0</xsl:param>
    <xsl:param name="ministere">0</xsl:param>
    <xsl:param name="programme">0</xsl:param>
    <xsl:param name="article">0</xsl:param>
    <xsl:param name="generatedId">0</xsl:param>
    
    <!-- Variables -->
    <xsl:variable name="page-format" select="paysage"/>
    <xsl:variable name="NumPage" select="/n:CompteGestionEtat/n:DeveloppementDepense/n:PageDeveloppementDepense/n:Pied/@NumPage"/>
    <xsl:variable name="LastPage" select="/n:CompteGestionEtat/n:DeveloppementDepense/n:PageDeveloppementDepense/@added:LastPage"/>
    <xsl:variable name="isLastPage" select="/n:CompteGestionEtat/n:DeveloppementDepense/n:PageDeveloppementDepense/@added:isLastPage"/>
    <xsl:variable name="Entete">
        <xsl:copy-of  select="/n:CompteGestionEtat/n:Entete"/>
    </xsl:variable>
    
    <xsl:output method="xhtml" indent="yes" use-character-maps="accents" encoding="ISO-8859-1"/>

    <!-- pour eviter les sorties parasites de tags non matches -->
    <xsl:template match="*"/>
 
    <xsl:template match="/n:CompteGestionEtat">
        <html>
            <head>
                <title>D&#233;veloppement des d&#233;penses budg&#233;taires par minist&#232;re et programme</title>                
                <xsl:call-template name="style"/>                
            </head>
            <body>
                <xsl:if test="$error.message!='nomessage'">
                    <xsl:attribute name="onload">javascript:showDialog('<xsl:value-of select="$error.message"/>');</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="Error"><!--xsl:with-param name="error.message" select="$error.message"/--></xsl:call-template>
                <xsl:call-template name="navigate">
                    <xsl:with-param name="docId">cg-etat</xsl:with-param>
                    <xsl:with-param name="etatId">DeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="elementId">PageDeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="sous.elementId">LigneDeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="NumPage" select="$NumPage"/>
                    <xsl:with-param name="LastPage" select="$LastPage"/>
                    <xsl:with-param name="isLastPage" select="$isLastPage"/>
                    <xsl:with-param name="Entete" select="$Entete"/>
                    <xsl:with-param name="show.formulaire" select="$show.formulaire"/>
                    <xsl:with-param name="show.formulaire.compte" select="1"/>
                    <xsl:with-param name="show.depense.recette" select="0"/>
                    <xsl:with-param name="is.web" select="$is.web"/>
                    <xsl:with-param name="context.path" select="$context.path"/>
                </xsl:call-template>
                <!--xsl:call-template name="header" >
                    <xsl:with-param name="Entete" select="$Entete"/>
                    <xsl:with-param name="Titre">D&#233;veloppement des d&#233;penses budg&#233;taires par minist&#232;re et programme</xsl:with-param>
                </xsl:call-template-->
                <xsl:call-template name="mainTable">
                    <xsl:with-param name="el" select="n:DeveloppementDepense/n:PageDeveloppementDepense"/>
                </xsl:call-template>
                <!--p class="showPrint">
                    <center>Page <xsl:choose><xsl:when test="$LastPage and string-length($LastPage) > 0"><xsl:value-of select="$NumPage"/> / <xsl:value-of select="$LastPage"/></xsl:when><xsl:otherwise>- <xsl:value-of select="$NumPage"/></xsl:otherwise></xsl:choose></center>
                </p-->
                <xsl:call-template name="navigate">
                    <xsl:with-param name="docId">cg-etat</xsl:with-param>
                    <xsl:with-param name="etatId">DeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="elementId">PageDeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="sous.elementId">LigneDeveloppementDepense</xsl:with-param>
                    <xsl:with-param name="NumPage" select="$NumPage"/>
                    <xsl:with-param name="LastPage" select="$LastPage"/>
                    <xsl:with-param name="isLastPage" select="$isLastPage"/>
                    <xsl:with-param name="Entete" select="$Entete"/>
                    <xsl:with-param name="show.formulaire" select="$show.formulaire"/>
                    <xsl:with-param name="show.formulaire.compte" select="1"/>
                    <xsl:with-param name="show.depense.recette" select="0"/>
                    <xsl:with-param name="ancre">#footer</xsl:with-param>
                    <xsl:with-param name="display.logos.entete">0</xsl:with-param>
                    <xsl:with-param name="is.web" select="$is.web"/>
                    <xsl:with-param name="context.path" select="$context.path"/>
                </xsl:call-template>
                <div id="footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="mainTable">
        <xsl:param name="el"/>
        <table width="100%" id="main">
            <colgroup>
                <col width="20%"/>
                <col width="25%"/>
                <col width="10%"/>
                <col width="20%"/>
                <col width="10%"/>
                <col width="15%"/>
            </colgroup>
            <thead>
                <xsl:call-template name="header.table" >
                    <xsl:with-param name="Entete" select="$Entete"/>
                    <xsl:with-param name="Titre">D&#233;veloppement des d&#233;penses budg&#233;taires par minist&#232;re et programme</xsl:with-param>
                    <xsl:with-param name="colspan">6</xsl:with-param>
                </xsl:call-template>
                <tr  class="titre">
                    <td class="titre2 center bold bordered">Comptes</td>
                    <td class="titre2 center bold bordered">Montant OAD</td> 
                    <td class="titre2 center bold bordered">Minist&#232;re</td>
                    <td class="titre2 center bold bordered">Programmes</td>
                    <td class="titre2 center bold bordered">Article<br/>ex&#233;cution</td>
                    <td class="titre2 center bold bordered">D&#233;penses admises</td>
                </tr>
            </thead>
            <tbody>
                <xsl:variable name="nums.comptes" select="distinct-values($el/n:LigneDeveloppementDepense/@NumCompte)"/>
                <xsl:for-each select="$nums.comptes">
                    <xsl:sort select="."/>
                    <xsl:variable name="this.compte" select="."/>
                    
                    
                    <xsl:variable name="lignes.this.compte" select="$el/n:LigneDeveloppementDepense[@NumCompte=$this.compte]"/>
                    <xsl:variable name="nb.lignes.this.compte" select="count($lignes.this.compte)"/>
                    
                    <xsl:variable name="ministeres.lignes.this.compte" select="distinct-values($lignes.this.compte/@Ministere)"/>
                    
                    <xsl:variable name="min.ministere" select="min($lignes.this.compte/@Ministere)"/>
                    <xsl:variable name="min.ministere.lignes" select="$lignes.this.compte[number(@Ministere)=$min.ministere]"/>
                    
                    <xsl:variable name="min.article.ministere.lignes" select="min($min.ministere.lignes/@ArticleExec)"/>
                    
                    <xsl:variable name="first" select="$min.ministere.lignes[1]/@added:generated-id"/>
                    
                    
                    <xsl:variable name="position.compte" select="position()"/>
                    
                    <tr class="mask">
                        <td class="titre center bold borderedNot">
                            <xsl:attribute name="rowspan" select="$nb.lignes.this.compte"/>
                            <h3 style="color: black;"><xsl:value-of select="."/></h3>
                        </td>
                        <td colspan="5">&#160;</td>
                    </tr>
                    <xsl:for-each select="$ministeres.lignes.this.compte">
                        <xsl:sort select="." data-type="text"/>
                        <xsl:variable name="this.ministere" select="."/>
                        <xsl:variable name="lignes.this.ministere" select="$lignes.this.compte[@Ministere=$this.ministere]"/>
                        
                        <xsl:variable name="position.ministere" select="position()"/>
                        
                        <xsl:variable name="programme.this.ministeres.lignes.this.compte" select="distinct-values($lignes.this.ministere/@Programme)"/>
                        
                        <xsl:for-each select="$programme.this.ministeres.lignes.this.compte">
                            <xsl:sort select="."/>
                            <xsl:variable name="this.programme" select="."/>
                            <xsl:variable name="lignes.this.programme" select="$lignes.this.ministere[@Programme=$this.programme]"/>
                            
                            <xsl:for-each select="$lignes.this.programme[string-length(@ArticleExec) &gt; 0]">
                                <xsl:sort select="@ArticleExec" data-type="text"/>
                                <xsl:variable name="articleExec" select="@ArticleExec"/>
                                <xsl:variable name="position.programme" select="position()"/>
                                <tr>
                                    <!--xsl:choose>
                                        <xsl:when test="$generatedId = '0' and $numCompte != '0' and @NumCompte=$numCompte and $this.ministere=$ministere and $this.programme=$programme and $articleExec=$article">
                                            <xsl:attribute name="id">highlighted</xsl:attribute>
                                        </xsl:when>
                                        <xsl:when test="$generatedId != '0' and @added:generated-id=$generatedId">
                                            <xsl:attribute name="id">highlighted</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise-->
                                            <xsl:choose>
                                                <xsl:when test="(position() mod 2) = 0">
                                                    <xsl:attribute name="id">colorised3</xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="id">colorised2</xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        <!--/xsl:otherwise>
                                    </xsl:choose-->
                                    <xsl:choose>
                                        <xsl:when test="@MtDebit"><xsl:attribute name="class">NotTotal</xsl:attribute></xsl:when>
                                    </xsl:choose>
                                    
                                    <td class="montant bordered">
                                        <xsl:choose>
                                            <xsl:when test="$generatedId = '0' and $numCompte != '0' and @NumCompte=$numCompte and $this.ministere=$ministere and $this.programme=$programme and $articleExec=$article">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="$generatedId != '0' and @added:generated-id=$generatedId">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:call-template name="number"><xsl:with-param name="num" select="@MtDebit"/></xsl:call-template> &euro;</td>
                                    <td class="bordered center"><xsl:value-of select="$this.ministere"/></td>
                                    <xsl:if test="$position.programme eq 1">
                                        <td class="bordered center">
                                            <xsl:choose>
                                                <xsl:when test="$generatedId = '0' and $numCompte != '0' and @NumCompte=$numCompte and $this.ministere=$ministere and $this.programme=$programme and $articleExec=$article">
                                                    <xsl:attribute name="id">highlighted</xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="$generatedId != '0' and @added:generated-id=$generatedId">
                                                    <xsl:attribute name="id">highlighted</xsl:attribute>
                                                </xsl:when>
                                            </xsl:choose>                                            
                                            <xsl:attribute name="rowspan" select="count($lignes.this.programme) - 1"/>
                                            <xsl:value-of select="$this.programme"/>
                                        </td>
                                    </xsl:if>
                                    <td class="bordered center">
                                        <xsl:choose>
                                            <xsl:when test="$generatedId = '0' and $numCompte != '0' and @NumCompte=$numCompte and $this.ministere=$ministere and $this.programme=$programme and $articleExec=$article">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="$generatedId != '0' and @added:generated-id=$generatedId">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:value-of select="@ArticleExec"/></td>
                                    <td class="montant bordered">
                                        <xsl:choose>
                                            <xsl:when test="$generatedId = '0' and $numCompte != '0' and @NumCompte=$numCompte and $this.ministere=$ministere and $this.programme=$programme and $articleExec=$article">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="$generatedId != '0' and @added:generated-id=$generatedId">
                                                <xsl:attribute name="id">highlighted</xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:call-template name="number"><xsl:with-param name="num" select="@MtDebit"/></xsl:call-template> &euro;<!--
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:text disable-output-escaping="yes">xemelios:/customLink?srcDocId=cg-etat&amp;srcEtatId=DeveloppementDepense&amp;srcElementId=PageDeveloppementDepense&amp;srcCollectivite=</xsl:text><xsl:value-of select="$Entete//n:Collectivite/@Siret"/>
                                            <xsl:text disable-output-escaping="yes">&amp;srcBudget=</xsl:text><xsl:value-of select="$Entete//n:Collectivite/@CodeBudget"/>
                                            <xsl:text disable-output-escaping="yes">&amp;sp1=</xsl:text><xsl:value-of select="$Entete//n:Collectivite/@Exercice"/>
                                            <xsl:text disable-output-escaping="yes">&amp;comptable=</xsl:text><xsl:value-of select="$Entete//n:Collectivite/@Siret"/>
                                            <xsl:text disable-output-escaping="yes">&amp;ministere=</xsl:text><xsl:value-of select="$this.ministere"/>
                                            <xsl:text disable-output-escaping="yes">&amp;programme=</xsl:text><xsl:value-of select="$this.programme"/>
                                            <xsl:text disable-output-escaping="yes">&amp;articleExec=</xsl:text><xsl:value-of select="@ArticleExec"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="number"><xsl:with-param name="num" select="@MtDebit"/></xsl:call-template> &euro;</xsl:element>
                                    --></td>
                                </tr>
                            </xsl:for-each>
                            <xsl:variable name="ligne.total.this.programme" select="$lignes.this.programme[string-length(@ArticleExec) eq 0]"/>
                            <tr>
                                <!--td class="libelleLigne bold bordered">&#160;<xsl:value-of select="$this.compte"/></td-->
                                <td class="bold bordered center totalAnnexeII" colspan="4">
                                    <xsl:choose>
                                        <xsl:when test="$generatedId != '0' and $ligne.total.this.programme/@added:generated-id=$generatedId">
                                            <xsl:attribute name="id">highlighted</xsl:attribute>
                                        </xsl:when>
                                    </xsl:choose>
                                    Total Programme <xsl:value-of select="$this.programme"/></td>
                                <td class="montant bold bordered totalAnnexeII">
                                    <xsl:choose>
                                        <xsl:when test="$generatedId != '0' and $ligne.total.this.programme/@added:generated-id=$generatedId">
                                            <xsl:attribute name="id">highlighted</xsl:attribute>
                                        </xsl:when>
                                    </xsl:choose>
                                    <xsl:call-template name="number"><xsl:with-param name="num" select="$ligne.total.this.programme/@MtDebit"/></xsl:call-template> &euro;</td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:variable name="ligne.total.this.compte" select="$lignes.this.compte[string-length(@Ministere) eq 0]"/>
                    <tr>
                        <td class="bold totalAnnexeII1 bordered right">Total du compte <xsl:value-of select="$this.compte"/></td>
                        <td class="montant bold bordered totalAnnexeII1"><xsl:call-template name="number"><xsl:with-param name="num" select="$ligne.total.this.compte/@MtDebit"/></xsl:call-template> &euro;</td>
                        <td class="montant bold bordered totalAnnexeII1" colspan="4"><xsl:call-template name="number"><xsl:with-param name="num" select="$ligne.total.this.compte/@MtDebit"/></xsl:call-template> &euro;</td>
                    </tr>
                </xsl:for-each>
            </tbody>
            <tfoot>
                <tr>
                    <!--td class="borderedNot">&nbsp;</td>
                    <td class="borderedNot">&nbsp;</td-->
                    <td class="borderedNot center numPage" colspan="6">Page <xsl:choose><xsl:when test="$LastPage and string-length($LastPage) > 0"><xsl:value-of select="$NumPage"/> / <xsl:value-of select="$LastPage"/></xsl:when><xsl:otherwise>- <xsl:value-of select="$NumPage"/></xsl:otherwise></xsl:choose></td>
                </tr>
            </tfoot>
        </table>
    </xsl:template>
  
</xsl:transform>

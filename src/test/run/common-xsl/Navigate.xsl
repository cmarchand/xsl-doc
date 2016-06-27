<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY egrave "&#232;">
<!ENTITY euro "&#8364;">
<!ENTITY agrave "&#224;">
<!ENTITY eacute "&#233;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.xemelios.org/namespaces#cge" xmlns:n="http://www.xemelios.org/namespaces#cge" version="2.0">
    <xsl:template name="navigate">
        <xsl:param name="docId"/>
        <xsl:param name="etatId"/>
        <xsl:param name="elementId"/>
        <xsl:param name="sous.elementId"/>
        <xsl:param name="Entete"/>
        <xsl:param name="NumPage"/>
        <xsl:param name="LastPage"/>
        <xsl:param name="isLastPage"/>
        <xsl:param name="show.formulaire"/>
        <xsl:param name="show.formulaire.compte" select="1"/>
        <xsl:param name="show.depense.recette" select="0"/>
        <xsl:param name="element.path"/>
        <xsl:param name="path.plus"/>
        <xsl:param name="ancre"/>
        <xsl:param name="display.logos.entete">0</xsl:param>
        <xsl:param name="is.web"/>
        <xsl:param name="context.path"/>
        
        <div class="formulaire">
            <xsl:if test="$display.logos.entete eq '1'">
                <table width="100%">
                    <colgroup>
                        <col/>
                        <col width="50%"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th style="text-align: left;" valign="middle"><img src="xemelios:/resource?logo_marianne.png" alt="LogoMarianne"/></th>
                            <th>&#160;</th>
                            <th style="text-align: right;" valign="middle"><img src="xemelios:/resource?logo_ministere.png" alt="LogoMinistere"/></th>
                        </tr>
                    </tbody>
                </table>
            </xsl:if>
            <table width="100%">
                <colgroup>
                    <col width="20%"/>
                    <col/>
                    <col width="20%"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th style="text-align: left;" valign="middle">
                            <xsl:choose>
                                <xsl:when test="$NumPage > 1"><xsl:element name="a"><xsl:attribute name="class">precsuiv</xsl:attribute><xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=1]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if></xsl:attribute><img src="xemelios:/resource?navigate_beginning.png" alt="[1]"/></xsl:element></xsl:when>
                                <xsl:otherwise><img src="xemelios:/resource?navigate_beginning_inactive.png" alt="[{$LastPage}]"/></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="$NumPage eq '1'"><img src="xemelios:/resource?navigate_left_inactive.png" alt="Page Précédente"/></xsl:when>
                                <xsl:otherwise><xsl:element name="a"><xsl:attribute name="class">precsuiv</xsl:attribute><xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage - 1"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if></xsl:attribute><img src="xemelios:/resource?navigate_left.png" alt="&lt;&lt; Page Précédente"/></xsl:element></xsl:otherwise>
                            </xsl:choose>
                        </th>
                        <th style="text-align: center;" valign="middle">
                            <xsl:element name="a"><xsl:attribute name="class">sommaire</xsl:attribute><xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=Accueil&amp;elementId=PageAccueil&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[@Modele='03']</xsl:attribute><img src="xemelios:/resource?navigate_summary.png" alt="Sommaire"/></xsl:element><br/>
                            
                            <xsl:if test="number($is.web) &gt; 0">
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$context.path"/>/print.do?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage"/>]</xsl:attribute>
                                    <xsl:attribute name="style">text-decoration: none;</xsl:attribute><img src="xemelios:/resource?print.png" alt="Imprimer ..."/>
                                </xsl:element>
                            </xsl:if>    
                            <br/>
                            <xsl:call-template name="formulaire">
                                <xsl:with-param name="docId" select="$docId"/>
                                <xsl:with-param name="etatId" select="$etatId"/>
                                <xsl:with-param name="elementId" select="$elementId"/>
                                <xsl:with-param name="sous.elementId" select="$sous.elementId"/>
                                <xsl:with-param name="Entete" select="$Entete"/>
                                <xsl:with-param name="NumPage" select="$NumPage"/>
                                <xsl:with-param name="isLastPage" select="$isLastPage"/>
                                <xsl:with-param name="show.formulaire" select="$show.formulaire"/>
                                <xsl:with-param name="show.formulaire.compte" select="$show.formulaire.compte"/>
                                <xsl:with-param name="show.depense.recette" select="$show.depense.recette"/>
                                <xsl:with-param name="element.path" select="$element.path"/>
                                <xsl:with-param name="path.plus" select="$path.plus"/>
                                <xsl:with-param name="ancre" select="$ancre"/>
                            </xsl:call-template>
                        </th>
                        <th style="text-align: right;" valign="middle">
                            <xsl:choose>
                                <xsl:when test="$isLastPage eq '1'"><img src="xemelios:/resource?navigate_right_inactive.png" alt="Page Suivante"/></xsl:when>
                                <xsl:otherwise><xsl:element name="a"><xsl:attribute name="class">precsuiv</xsl:attribute><xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage + 1"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if></xsl:attribute><img src="xemelios:/resource?navigate_right.png" alt="Page Suivante &gt;&gt;"/></xsl:element></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="number($NumPage) &lt; number($LastPage)">&nbsp;&nbsp;<xsl:element name="a"><xsl:attribute name="class">precsuiv</xsl:attribute><xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$LastPage"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if></xsl:attribute><img src="xemelios:/resource?navigate_end.png" alt="[{$LastPage}]"/></xsl:element></xsl:when>
                                <xsl:otherwise><img src="xemelios:/resource?navigate_end_inactive.png" alt="[{$LastPage}]"/></xsl:otherwise>
                            </xsl:choose>
                        </th>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template name="formulaire">
        <xsl:param name="docId"/>
        <xsl:param name="etatId"/>
        <xsl:param name="elementId"/>
        <xsl:param name="sous.elementId"/>
        <xsl:param name="Entete"/>
        <xsl:param name="NumPage"/>
        <xsl:param name="isLastPage"/>
        <xsl:param name="show.formulaire"/>
        <xsl:param name="show.formulaire.compte"/>
        <xsl:param name="show.depense.recette"/>
        <xsl:param name="element.path"/>
        <xsl:param name="path.plus"/>
        <xsl:param name="ancre"/>
        
        <xsl:choose>
            <xsl:when test="$NumPage eq '1' and $isLastPage eq '1'"/>
            <xsl:otherwise>
        <span style="color:navy;">
            <xsl:choose>
                <xsl:when test="$show.formulaire='' or ($NumPage eq '1' and $isLastPage eq '1')">
                    <!--xsl:element name="a">
                        <xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if>&amp;xsl:param=(show.formulaire,1)<xsl:if test="$ancre"><xsl:value-of select="$ancre"/></xsl:if></xsl:attribute>
                        <xsl:attribute name="style">text-decoration: none;</xsl:attribute><u>Critères de recherche</u>
                    </xsl:element-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if>&amp;xsl:param=(show.formulaire,1)&amp;xsl:param=(show.formulaire.compte,<xsl:value-of select="$show.formulaire.compte"/>)<xsl:if test="$ancre"><xsl:value-of select="$ancre"/></xsl:if></xsl:attribute>
                        <xsl:attribute name="style">text-decoration: none;</xsl:attribute><img src="xemelios:/resource?navigate_open_criteres.png" alt="Montrer"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>           
                    <!--xsl:element name="a">
                        <xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if>&amp;xsl:param=(show.formulaire,)<xsl:if test="$ancre"><xsl:value-of select="$ancre"/></xsl:if></xsl:attribute>
                        <xsl:attribute name="style">text-decoration: none;</xsl:attribute><u>Critères de recherche</u>
                        </xsl:element-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">xemelios:/query?docId=<xsl:value-of select="$docId"/>&amp;etatId=<xsl:value-of select="$etatId"/>&amp;elementId=<xsl:value-of select="$elementId"/>&amp;sp1=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Exercice"/>&amp;collectivite=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@Siret"/>&amp;budget=<xsl:value-of select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>&amp;path=[n:Pied/@NumPage=<xsl:value-of select="$NumPage"/>]<xsl:if test="$path.plus"><xsl:value-of select="$path.plus"/></xsl:if>&amp;xsl:param=(show.formulaire,)&amp;xsl:param=(show.formulaire.compte,<xsl:value-of select="$show.formulaire.compte"/>)<xsl:if test="$ancre"><xsl:value-of select="$ancre"/></xsl:if></xsl:attribute>
                        <xsl:attribute name="style">text-decoration: none;</xsl:attribute><img src="xemelios:/resource?navigate_close_criteres.png" alt="Cacher"/>
                    </xsl:element>                                 
                </xsl:otherwise>
            </xsl:choose>            
        </span>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
        <div>
            <xsl:choose>
                <xsl:when test="$show.formulaire='' or ($NumPage eq '1' and $isLastPage eq '1')">
                    <xsl:attribute name="style">display: none;</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style">display: block;</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>      
            <form name="formulaireRecherchePage" method="GET" action="xemelios:/query" width="100%">
                <table width="100%">
                    <caption>Accéder à une page</caption>
                    <colgroup>
                        <col width="40%"/>
                        <col width="20%"/>
                        <col width="40%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td style="text-align: right;" valign="middle"><label for="gotoPage">Page n°</label></td>
                            <td valign="middle"><input id="gotoPage" type="text" name="page"/></td>
                            <td style="text-align: left;" valign="middle"><input type="image" value="Rechercher ..." name="submit" src="xemelios:/resource?zoom.png"/></td>
                        </tr>
                    </tbody>
                </table>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">docId</xsl:attribute>
                    <xsl:attribute name="value" select="$docId"/>
                </input>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">etatId</xsl:attribute>
                    <xsl:attribute name="value" select="$etatId"/>
                </input>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">elementId</xsl:attribute>
                    <xsl:attribute name="value" select="$elementId"/>
                </input>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">collectivite</xsl:attribute>
                    <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@Siret"/>
                </input>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">budget</xsl:attribute>
                    <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>
                </input>
                <input>
                    <xsl:attribute name="type">hidden</xsl:attribute>
                    <xsl:attribute name="name">sp1</xsl:attribute>
                    <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@Exercice"/>
                </input>
                <input type="hidden" name="path" value="[n:Pied/@NumPage=%page%]"/>                
            </form>
            <xsl:if test="$show.formulaire.compte and $show.formulaire.compte!=0">
                <!--br/-->
                <form name="formulaireRechercheCompte" method="GET" action="xemelios:/query" width="100%">
                    <table width="100%">
                    <caption>Accéder à un compte</caption>
                    <colgroup>
                        <col width="40%"/>
                        <col width="20%"/>
                        <col width="40%"/>
                    </colgroup>
                        <tbody>
                            <tr>
                                <td style="text-align: right;">
                                    <xsl:choose>
                                        <xsl:when test="$etatId eq 'DeveloppementRecette'"><label for="gotoCompte">Compte de recette n°</label></xsl:when>
                                        <xsl:otherwise><label for="gotoCompte">Compte n°</label></xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td><input id="gotoCompte" type="text" name="compte"/></td>
                                <td style="text-align: left;"><input type="image" value="Rechercher ..." name="submit" src="xemelios:/resource?zoom.png"/></td>
                            </tr>
                            <xsl:if test="$show.depense.recette">
                                <tr>
                                    <td colspan="3">
                                        <table width="100%">
                                            <colgroup>
                                                <col width="45%"/>
                                                <col width="3%"/>
                                                <col width="7%"/>
                                                <col width="45%"/>
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <td style="text-align: right;"><label>D&eacute;pense</label></td>
                                                    <td style="text-align: left;"><input name="codrd" type="radio" value="D"/></td>
                                                    <td style="text-align: right;"><label>Recette</label></td>
                                                    <td style="text-align: left;"><input name="codrd" type="radio" value="R"/></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </xsl:if>
                        </tbody>
                    </table>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">docId</xsl:attribute>
                        <xsl:attribute name="value" select="$docId"/>
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">etatId</xsl:attribute>
                        <xsl:attribute name="value" select="$etatId"/>
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">elementId</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$sous.elementId!=''">
                                <xsl:attribute name="value" select="$sous.elementId"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value" select="$elementId"/>
                            </xsl:otherwise>
                        </xsl:choose>                    
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">collectivite</xsl:attribute>
                        <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@Siret"/>
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">budget</xsl:attribute>
                        <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@CodeBudget"/>
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">sp1</xsl:attribute>
                        <xsl:attribute name="value" select="$Entete//n:Infos/n:Collectivite/@Exercice"/>
                    </input>
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">path</xsl:attribute>
                        <xsl:attribute name="value">[<xsl:if test="string-length($element.path)>0"><xsl:value-of select="$element.path"/>/</xsl:if>@NumCompte=%compte%]<xsl:if test="$show.depense.recette">[<xsl:if test="string-length($element.path)>0"><xsl:value-of select="$element.path"/>/</xsl:if>@CodRD=%codrd%]</xsl:if></xsl:attribute>
                    </input>  
                    <input>
                        <xsl:attribute name="type">hidden</xsl:attribute>
                        <xsl:attribute name="name">xsl:param</xsl:attribute>
                        <xsl:attribute name="value">(numCompte,%compte%)</xsl:attribute>
                    </input>              
                </form>
            </xsl:if>
        </div><!--
        __________________________________________-->
    </xsl:template>
</xsl:stylesheet>

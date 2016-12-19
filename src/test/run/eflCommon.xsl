<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com" xmlns:efl="http://els.eu/ns/efl"
  xmlns:om="http://els.eu/ns/efl/offresMetiers" xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="#all" version="3.0">
  <!-- EFL_VERSION : 1.00.13 -->
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 25, 2014</xd:p>
      <xd:p><xd:b>Authors:</xd:b> dp, amalguy, mricaud</xd:p>
      <xd:p>Librairies de fonctions générique utilisées aux EFL</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:include href="functx.xslt"/>
  <xd:doc>
    <xd:desc>
      <xd:p>Niveau à partir duquel les logs sont</xd:p>
      <xd:ul>
        <xd:li>affichés sur la console via un xsl:message (log.level.alert)</xd:li>
        <xd:li>génèrés via un élément "log" dans le document source (log.level.markup)</xd:li>
      </xd:ul>
      <xd:p>La valeur de ces paramètres est à définir dans la XSLT utilisant les logs</xd:p>
      <xd:p>Si ce n'est pas le cas, ce sont les valeurs des paramêtres alert et markup dans la f° de
        log qui définissent seuls la génération des logs. </xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:param name="log.level.alert" as="xs:string?" required="no"/>
  <xsl:param name="log.level.markup" as="xs:string?" required="no"/>
  <!--===================================================	-->
  <!--								COMMON VAR			-->
  <!--===================================================	-->
  <xd:doc>
    <xd:desc>
      <xd:p>Variable double quot, peut être utile dans un concat par exemple</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="dquot" as="xs:string">"</xsl:variable>
  <xd:doc>
    <xd:desc>
      <xd:p>Variable utile "regAnySpace" : espace insécable, fine ou autre</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="regAnySpace">\p{Z}</xsl:variable>
  <!--===================================================	-->
  <!--							LOG and MESSAGES											-->
  <!--===================================================	-->
  <xd:doc>
    <xd:desc>
      <xd:p>Log des erreurs ou warning xslt</xd:p>
    </xd:desc>
    <xd:param name="xsltName">Nom de la xslt appelante. Typiquement : "<xsl:variable name="xsltName"
        select="tokenize(static-base-uri(),'/')[last()]"/>"</xd:param>
    <xd:param name="level">Level du log : (info | debug | warning | error | fatal | fixme |
      todo)</xd:param>
    <xd:param name="code">Code erreur pour s'y retrouver plus facilement (peut servir à filter les
      erreurs "dpm / dsi" ainsi qu'a faire des requête xpath pour compter le nombre d'erreurs d'un
      code spécifique</xd:param>
    <xd:param name="alert">Détermine si on génère un xsl:message ou pas</xd:param>
    <xd:param name="markup">Détermine si on génère un élément "log" en sortie ou pas</xd:param>
    <xd:param name="description">Description de l'erreur</xd:param>
    <xd:param name="xpath">XPath spécifique. Si omis le xpath est calculé en fonction du contexte
      courant</xd:param>
    <xd:param name="base-uri">URI du fichier pour lequel le log est créé</xd:param>
  </xd:doc>
  <xsl:template name="efl:log">
    <xsl:param name="xsltName" as="xs:string" required="yes"/>
    <xsl:param name="level" select="'info'" as="xs:string"/>
    <xsl:param name="code" select="'undefined'" as="xs:string"/>
    <xsl:param name="alert"
      select="if ($level = 'error' or $level = 'fatal') then (true()) else (false())"
      as="xs:boolean"/>
    <xsl:param name="markup" select="true()" as="xs:boolean"/>
    <xsl:param name="description" as="item()*"/>
  	<xsl:param name="messageDescription" as="item()*" select="$description"/>
    <xsl:param name="logXpath" select="false()" as="xs:boolean"/>
    <xsl:param name="xpathContext" select="." as="item()"/>
    <xsl:param name="logMessageAsXMLFragment" as="xs:boolean" select="true()"/>
    <xsl:param name="xpath" as="xs:string?" required="no"/>
    <xsl:param name="base-uri" as="xs:string?" required="no"/>
  	<xsl:param name="TU" as="xs:boolean" select="false()" tunnel="yes"/>
    <!--Si $logXpath=false() pas la peine de risquer une erreur sur un $xpathContext "." qui pourrait ne pas exister (dans un analyze-string par exemple "." est un string pas un context xpath)-->
    <xsl:variable name="xpath"
      select=" if (exists($xpath)) then ($xpath) else (if ($logXpath) then (efl:get-xpath($xpathContext)) else (''))"
      as="xs:string"/>
    <!--checking param-->
    <xsl:variable name="levelValues"
      select="('info','debug','warning','error', 'fatal','fixme','todo')" as="xs:string*"/>
    <xsl:if test="not(some $levelName in $levelValues satisfies $level = $levelName)">
      <xsl:call-template name="efl:log">
        <!--<xsl:with-param name="xsltName" select="tokenize(static-base-uri(),'/')[last()]"/> ne fonctionne pas en java pour hervé Rolland -->
        <xsl:with-param name="xsltName" select="'eflCommon.xsl'"/>
        <xsl:with-param name="alert" select="true()"/>
        <xsl:with-param name="markup" select="false()"/>
        <xsl:with-param name="description" xml:space="preserve">Appel du template log avec valeur du parametre level = "<xsl:value-of select="$level"/>" non autorisé</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <!--logging par xsl:message si $alert (c'est-à-dire explicitement demandé ou level approprié) et niveau de log configuré pour être traité -->
    <xsl:variable name="alertWithLevelToProcess"
      select="if (not($logMessageAsXMLFragment))then
      (if (exists($log.level.alert)) 
      then (efl:isLogToBeProcessed($level, $log.level.alert)) 
      else ($alert))
      else false()"/>
    <xsl:if test="$alertWithLevelToProcess">
      <xsl:variable name="msg">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="upper-case($level)"/>
        <xsl:text>][</xsl:text>
        <xsl:if test="exists($base-uri)">
          <xsl:value-of select="concat(tokenize($base-uri, '/')[last()], ' / ')"/>
        </xsl:if>
        <xsl:value-of select="$xsltName"/>
        <xsl:text>][</xsl:text>
        <xsl:value-of select="$code"/>
        <xsl:text>] </xsl:text>
        <!--suppression des accents car mal géré au niveau des invites de commande-->
        <xsl:sequence select="efl:normalize-no-diacritic($description)"/>
        <xsl:if test="$logXpath">
          <xsl:text>&#10; xpath=</xsl:text>
          <xsl:value-of select="$xpath"/>
        </xsl:if>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$level = 'fatal'">
          <!--<xsl:message terminate="yes" select="$msg"/>-->
          <xsl:message terminate="no" select="$msg"/>
          <!--On préfère ne jamais tuer le process, on pourra compter le nombre d'erreurs fatal mais si risque d'effet "boule de neige"-->
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="no" select="$msg"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  	<!-- Add source BC/CI as description's prefix -->
  	<xsl:variable name="source" as="xs:string?">
  		<xsl:try>
  			<xsl:value-of 
  				select="
  				efl:getBC-CISourceLabel(
  				if (exists($xpathContext) and $xpathContext instance of node()) then
  				$xpathContext
  				else
  				.)"/>  	  				
  			<xsl:catch/>
  		</xsl:try>
  	</xsl:variable>
  	<xsl:variable name="msg" as="item()*"> 
  		<xsl:sequence 
  			select="if ($messageDescription instance of xs:string) 
  							then concat($source, $messageDescription)
  							else ($source, $messageDescription)"/>
  	</xsl:variable>

  	<!-- logging via xsl:message with XMLFragment -->
    <xsl:if test="$logMessageAsXMLFragment">
      <xsl:message>
        <log level="{if ($level='warning') then 'warn' else $level}" code="{$code}" source="{$xsltName}">
          <xsl:if test="$logXpath">
            <xsl:attribute name="xpath" select="$xpath"/>
          </xsl:if>
          <xsl:if test="$xpathContext instance of node()">
            <xsl:attribute name="element" select="name($xpathContext/ancestor-or-self::*[1])"/>
          </xsl:if>
          <xsl:sequence select="$msg"/>
        </log>
      </xsl:message>
    </xsl:if>
    <!--logging via balise log si $markup et niveau de log configuré pour être traité -->
    <xsl:variable name="markupAndLevelToProcess"
      select="if (exists($log.level.markup)) then ($markup and efl:isLogToBeProcessed($level, $log.level.markup)) else ($markup)"/>
    <xsl:if test="$markupAndLevelToProcess">
      <log level="{$level}" code="{$code}" xsltName="{$xsltName}">
        <xsl:if test="$logXpath">
          <xsl:attribute name="xpath" select="$xpath"/>
        </xsl:if>
        <xsl:if test="$xpathContext instance of node()">
          <!--que l'on soit sur un noeud attribut ou element ou autre, on créer un attribut avec le nom de l'élément "courant"-->
          <xsl:attribute name="element" select="name($xpathContext/ancestor-or-self::*[1])"/>
        </xsl:if>
        <!-- Mise en commentaire permet d'éviter d'ajouter du contenu textuel-->
        <!-- (Même si $description contient déjà un commentaire ou un "double tiret", la serialisation xsl:comment fonctionnera ! (testé) ) -->        
      	<xsl:comment>
        	<xsl:sequence select="if ($TU) then $msg else $description"/>
        </xsl:comment>
      </log>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:desc>Récupération de la priorité d'un niveau</xd:desc>
  </xd:doc>
  <xsl:function name="efl:getLevelPriority" as="xs:integer">
    <xsl:param name="level" as="xs:string" required="yes"/>
    <xsl:choose>
      <xsl:when test="$level='fatal'">50000</xsl:when>
      <xsl:when test="$level='error'">40000</xsl:when>
      <xsl:when test="$level='warning'">30000</xsl:when>
      <xsl:when test="$level='info'">20000</xsl:when>
      <xsl:when test="$level='debug'">10000</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xd:doc>
    <xd:desc>Vérifie si les logs d'un niveau donné sont à traiter en fonction d'un flag indiquant
      quels niveaux sont à traiter</xd:desc>
    <xd:desc>
      <xd:p>Ce flag correspond </xd:p>
      <xd:ul>
        <xd:li>
          <xd:p>soit au premier niveau dans l'ordre des priorités pour lequel les logs doivnt être
            traités</xd:p>
          <xd:p>- log d'un niveau avec priorité supérieure ou égale : traité</xd:p>
          <xd:p>- log d'un niveau avec priorité inférieure : non traité</xd:p>
        </xd:li>
        <xd:li>soit à "all" : tous les logs, quel que soit leur niveau, sont à traiter</xd:li>
        <xd:li>soit à "off" : aucun log, quel que soit son niveau, n'est à traiter</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:function name="efl:isLogToBeProcessed" as="xs:boolean">
    <xsl:param name="level" as="xs:string"/>
    <xsl:param name="levelProcessFlag" as="xs:string"/>
    <xsl:value-of
      select="if ($levelProcessFlag = 'all') then (true()) 
					else (if ($levelProcessFlag = 'off') then (false()) 
						  else (boolean(efl:getLevelPriority($level) >= efl:getLevelPriority($levelProcessFlag))))"
		/>
	</xsl:function>

	<xd:doc>
		<xd:desc>
			<xd:p>Récupération d'un label identifiant la BC ou le CI courant</xd:p>
		</xd:desc>
		<xd:param name="currentContext" as="element()?">Contexte courant</xd:param>
		<xd:return>
			<xd:p>Texte identifiant la BC ou le CI source :</xd:p>
			<xd:ul>
				<xd:li>BC : BC [code] :</xd:li>
				<xd:li>CI : CI [type-ci] [fichierCI]#[idCI]</xd:li>
			</xd:ul>
		</xd:return>
	</xd:doc>
	<xsl:function name="efl:getBC-CISourceLabel" as="xs:string?">
		<xsl:param name="currentContext" as="element()"/>
		<xsl:variable name="root" as="element()" select="root($currentContext)/*"/>
		<xsl:choose>
			<xsl:when test="not(exists($root))"/>
			<xsl:when test="$root[self::doc]">
				<xsl:value-of select="concat('BC ', $root/@code, ' : ')"/>
			</xsl:when>
			<xsl:when test="$root[self::induits]">
				<xsl:variable name="ci.type" as="xs:string" 
					select="substring-after($root/@type, 'ci-')"/>
				<xsl:variable name="ci" as="element()" 
					select="$currentContext/ancestor-or-self::*[self::contenu-induit or self::contenuInduit]"/>
				<xsl:variable name="ci.pos" as="xs:integer" 
					select="count($ci/preceding::*[self::contenu-induit or self::contenuInduit])+1"/>
				<xsl:variable name="ci.file" as="xs:string" select="$ci/@file"/>
				<xsl:variable name="ci.id" as="xs:string?" select="$ci/@cible-id"/>
				<xsl:value-of select="efl:getCISourceLabel($ci.type, $ci.pos, $ci.file, $ci.id)"/>
			</xsl:when>
		</xsl:choose>			
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Récupération d'un label identifiant un CI</xd:p>
		</xd:desc>
		<xd:param name="ci.type" as="xs:string">Type de CI (actualisation, formulaire, simulateur, ...)</xd:param>
		<xd:param name="ci.pos" as="xs:string">Postionnement du CI dans le document en entrée</xd:param>
		<xd:param name="ci.file" as="xs:string">Fichier duquel est issu le CI</xd:param>
		<xd:param name="ci.id" as="xs:string">Identifiant du CI dans le fichier origine</xd:param>
		<xd:return>
			<xd:p>Texte identifiant le CI : "CI [type-ci] [fichierCI]#[idCI] :"</xd:p>
		</xd:return>
	</xd:doc>	
	<xsl:function name="efl:getCISourceLabel" as="xs:string">
		<xsl:param name="ci.type" as="xs:string"/>
		<xsl:param name="ci.pos" as="xs:integer"/>
		<xsl:param name="ci.file" as="xs:string"/>
		<xsl:param name="ci.id" as="xs:string?"/>
		<xsl:variable name="ci.fileName" as="xs:string?" select="efl:getFileName($ci.file, false())"/>
		<xsl:variable name="_ci.fileName" as="xs:string"  
			select="if (normalize-space($ci.fileName) != '') then $ci.fileName else '?'"/>
		<xsl:variable name="_ci.pos" as="xs:string?"
			select="if ($ci.pos=0) then '' else concat(' n°', $ci.pos)"/>
		<xsl:variable name="_ci.id" as="xs:string"
			select="if (exists($ci.id)) then $ci.id else '?'"/>
		<xsl:value-of 
			select="concat('CI ', $ci.type, $_ci.pos, ' ', $_ci.fileName, '#', $_ci.id, ' : ')"/>
	</xsl:function>
	
	<!--===================================================	-->
	<!--					DATE							-->
	<!--===================================================	-->

	<xd:doc>
		<xd:desc>
			<xd:p>Converti une date au format ISO : AAAA-MM-JJ, avec comme format d'entrée :</xd:p>
			<xd:ul>
				<xd:li>AAAA-MM-JJ (date déjà au format ISO) : dans ce cas la fonction retourne cette
					date</xd:li>
				<xd:li>JJ/MM/AAAA (ou JJ-MM-AAAA ou JJ/MM/AA)</xd:li>
			</xd:ul>
			<xd:param name="dateValue">valeur de la date que l'on veut convertir en date
				ISO</xd:param>
			<xd:param name="sep">séparateur dans la date d'origine ($s)</xd:param>
			<xd:param name="xsltName">nom de la XSLT appelant cette fonction, pour l'affichage de
				messages d'erreur contextualisés</xd:param>
			<xd:param name="contextForErrors">string indiquant le contexte d'appel de cette
				fonction, pour pouvoir identifier les dates qu'on ne peut pas convertir</xd:param>
		</xd:desc>
		<xd:return>La date en xs:string (au cas où la conversion échouerai, on renvoie la string
			d'origine)</xd:return>
	</xd:doc>
	<xsl:function name="efl:makeIsoDate" as="xs:string">
		<xsl:param name="dateValue" as="xs:string?"/>
		<xsl:param name="sep" as="xs:string"/>
		<xsl:param name="xsltName" as="xs:string"/>
		<xsl:param name="contextForErrors" as="xs:string"/>

		<xsl:variable name="s" select="string($dateValue)"/>
		<xsl:variable name="sToken" select="tokenize($s, $sep)" as="xs:string*"/>
		<xsl:variable name="regJJMMAAAA" as="xs:string" select="concat('^\d{2}', $sep, '\d{2}', $sep, '\d{4}$')"/>
		<xsl:variable name="regJMMAAAA" as="xs:string" select="concat('^\d', $sep, '\d{2}', $sep, '\d{4}$')"/>
		<xsl:variable name="regJJMMAA" as="xs:string" select="concat('^\d{2}', $sep, '\d{2}', $sep, '\d{2}')"/>
		<xsl:variable name="regJMMAA" as="xs:string" select="concat('^\d', $sep, '\d{2}', $sep, '\d{2}')"/>
		
		<xsl:choose>
			<!--sans string on ne peut rien faire : on renvoie la string vide-->
			<xsl:when test="not(exists($dateValue)) or empty($s)">
				<xsl:sequence select="''"/>
			</xsl:when>
			<!-- date déjà au format ISO, donc rien à faire -->
			<xsl:when test="matches($s, '^\d{4}-\d{2}-\d{2}$')">
				<xsl:sequence select="$s"/>
			</xsl:when>
			<!--sans séparateur on ne peut rien faire : on renvoie la string-->
			<xsl:when test="$sep = ''">
				<xsl:sequence select="$s"/>
			</xsl:when>
			<!--La date est dans un format correct JJ/MM/AAAA, on la convertie en "AAAA-MM-JJ" -->
			<xsl:when test="matches($s, $regJJMMAAAA)">
				<xsl:sequence select="concat($sToken[3], '-', $sToken[2], '-', $sToken[1])"/>
			</xsl:when>
			<!--La date est dans un format correct J/MM/AAAA, on la convertie en "AAAA-MM-JJ" en remettant le 0 devant le jour -->
			<xsl:when test="matches($s, $regJMMAAAA)">
				<xsl:sequence select="concat($sToken[3], '-', $sToken[2], '-0', $sToken[1])"/>
			</xsl:when>
			<!--Le format est correct sauf l'année qui est sur 2 chiffres : on estime qu'au dela de l'année courante on était au siècle dernier -->
			<xsl:when test="matches($s, $regJJMMAA)">
				<xsl:variable name="currentAAAA" select="year-from-date(current-date())"
					as="xs:integer"/>
				<xsl:variable name="currentAA__"
					select="substring(string($currentAAAA), 1, 2) cast as xs:integer"
					as="xs:integer"/>
				<xsl:variable name="current__AA"
					select="substring(string($currentAAAA), 3, 2) cast as xs:integer"
					as="xs:integer"/>
				<xsl:variable name="AA" select="xs:integer($sToken[3])" as="xs:integer"/>
				<xsl:variable name="AAAA"
					select="if ($AA gt $current__AA) then (concat($currentAA__ -1, $AA)) else (concat($currentAA__, $AA))"
					as="xs:string"/>
				<xsl:sequence select="concat($AAAA, '-', $sToken[2], '-', $sToken[1])"/>
			</xsl:when>
			<!--Le format est correct sauf l'année qui est sur 2 chiffres : on estime qu'au dela de l'année courante on était au siècle dernier -->
			<xsl:when test="matches($s, $regJMMAA)">
				<xsl:variable name="currentAAAA" select="year-from-date(current-date())"
					as="xs:integer"/>
				<xsl:variable name="currentAA__"
					select="substring(string($currentAAAA), 1, 2) cast as xs:integer"
					as="xs:integer"/>
				<xsl:variable name="current__AA"
					select="substring(string($currentAAAA), 3, 2) cast as xs:integer"
					as="xs:integer"/>
				<xsl:variable name="AA" select="xs:integer($sToken[3])" as="xs:integer"/>
				<xsl:variable name="AAAA"
					select="if ($AA gt $current__AA) then (concat($currentAA__ -1, $AA)) else (concat($currentAA__, $AA))"
					as="xs:string"/>
				<xsl:sequence select="concat($AAAA, '-', $sToken[2], '-0', $sToken[1])"/>
			</xsl:when>
			<!--format non reconnu : on renvoie la string-->
			<xsl:otherwise>
				<xsl:call-template name="efl:log">
					<xsl:with-param name="xsltName" select="$xsltName"/>
					<xsl:with-param name="level" select="'error'"/>
					<xsl:with-param name="code" select="'makeIsoDate'"/>
					<xsl:with-param name="xpathContext" select="$contextForErrors"/>
					<xsl:with-param name="markup" select="false()"/>
					<!--xsl:with-param name="description">Dans '<xsl:value-of select="$contextForErrors"/>', la date '<xsl:value-of select="$s"/>' n'est pas dans le bon format. Il se peut que le tri par date ne soit pas correct. Format attentu : JJ/MM/AAAA ou JJ/MM/AA au pire (on essayera de deviner le siècle...)</xsl:with-param-->
				  <!-- amélioration des logs : sur une seule ligne ! -->
				  <xsl:with-param name="description" select="concat('Dans ''',$contextForErrors,''', la date ''',$s,''' n''est pas dans le bon format. Il se peut que le tri par date ne soit pas correct. Format attentu : JJ/MM/AAAA ou JJ/MM/AA au pire (on essayera de deviner le siècle...)')"/>
				</xsl:call-template>
				<xsl:sequence select="$s"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
 
  <xd:doc>
    <xd:desc>Récupréation d'une xs:date à partir d'une date au format JJ/MM/AAAA</xd:desc>
    <xd:param name="date">Date 'chaine de caractères' au format JJ/MM/AAAA</xd:param>
    <xd:return>Date au format xs:date, 1900-01-01 si la date n'a pas pu être interprétée</xd:return>
  </xd:doc>
  <xsl:function name="efl:getDate" as="xs:date?">
    <xsl:param name="date" as="xs:string"/>
  	<xsl:variable name="isoDate" select="efl:makeIsoDate($date, '[^\d]', '', '')"/>
  	<xsl:choose>
  	  <xsl:when test="$date castable as xs:date"><xsl:value-of select="$date"/></xsl:when>
  	  <xsl:when test="matches($isoDate,'\d{4}-\d{2}-\d{2}')">
  	    <xsl:variable name="split" select="tokenize($isoDate,'-')"/>
  	    <xsl:variable name="annee" select="number($split[1])"/>
  	    <xsl:variable name="maxJours" as="xs:integer">
  	      <xsl:choose>
  	      <xsl:when test="$split[2]=('01','03','05','07','08','10','12')">31</xsl:when>
  	      <xsl:when test="$split[2]=('04','06','09','11')">30</xsl:when>
  	      <xsl:when test="$annee mod 4=0 and (not($annee mod 100=0) or($annee mod 400=0)) and $split[2]='02'">29</xsl:when>
  	      <xsl:otherwise>28</xsl:otherwise>
  	      </xsl:choose>
  	    </xsl:variable>
  	    <xsl:choose>
  	      <xsl:when test="number($split[3]) &lt;= $maxJours"><xsl:value-of select="xs:date($isoDate)"/></xsl:when>
  	      <xsl:otherwise><xsl:value-of select="xs:date('1900-01-01')"/></xsl:otherwise>
  	    </xsl:choose>
  	  </xsl:when>
  		<xsl:otherwise><xsl:value-of select="xs:date('1900-01-01')"/></xsl:otherwise>
  	</xsl:choose>
  </xsl:function>
  <!--===================================================	-->
  <!--					STRING							-->
  <!--===================================================	-->
  <xd:doc>
    <xd:desc>
      <xd:p>Normalize the string: remove diacritic marks.</xd:p>
    </xd:desc>
    <xd:param name="string"/>
    <xd:return>the <xd:b>string</xd:b> normalized</xd:return>
  </xd:doc>
  <xsl:function name="efl:normalize-no-diacritic" as="xs:string">
    <xsl:param name="string" as="xs:string"/>
    <xsl:sequence select="replace(normalize-unicode($string, 'NFD'), '[\p{M}]', '')"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>"carriage return line feed" : renvoie N retour charriots</xd:p>
    </xd:desc>
    <xd:param name="n">nombre de retour charriots à renvoyer</xd:param>
  </xd:doc>
  <xsl:function name="efl:crlf" as="xs:string*">
    <xsl:param name="n" as="xs:integer"/>
    <!--pas de sens pour les chiffres négatifs-->
    <xsl:if test="$n gt 0">
      <xsl:for-each select="1 to $n">
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Signature 0 args de efl:crlf() : renvoie par défaut 1 retour charriot.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:function name="efl:crlf" as="xs:string">
    <xsl:sequence select="efl:crlf(1)"/>
  </xsl:function>
  <!--===================================================	-->
  <!--										XML															-->
  <!--===================================================	-->
  <!--Récupère le chemin Xpath complet du noeud courant dans le fichier XML avec les prédicats de position ([n])-->
  <!--cf. http://www.xsltfunctions.com/xsl/functx_path-to-node-with-pos.html-->
  <xsl:template match="*" name="efl:get-xpath" mode="get-xpath">
    <xsl:param name="node" select="." as="node()"/>
    <xsl:param name="nsprefix" select="''"/>
    <xsl:param name="display_position" select="true()"/>
    <xsl:for-each select="$node/ancestor-or-self::*">
      <xsl:variable name="id" select="generate-id(.)"/>
      <xsl:variable name="name" select="name()"/>
      <xsl:choose>
        <xsl:when test="not(contains(name(),':'))">
          <xsl:value-of
            select="concat('/',if ($nsprefix!='') then (concat($nsprefix,':')) else(''), name())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('/', name())"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="../*[name()=$name]">
        <xsl:if test="generate-id(.)=$id and $display_position">
          <!--ajouter and position() != 1 si on veut virer les [1]-->
          <xsl:text>[</xsl:text>
          <xsl:value-of select="format-number(position(),'0')"/>
          <xsl:text>]</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:if test="not($node/self::*)">
      <xsl:value-of select="concat('/@',name($node))"/>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:p>fonction efl:get-xpath renvoie un chemin xpath du noeud courant</xd:p>
      <xd:p>Si la fonction saxon:path() est disponible alors on l'utilisera nativement. Sinon ou on
        utilisera le template efl:get-xpath</xd:p>
    </xd:desc>
    <xd:param name="node">noeud dont on veut le xpath</xd:param>
    <xd:return>Chemin xpath de $node</xd:return>
  </xd:doc>
  <xsl:function name="efl:get-xpath" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <xsl:choose>
      <xsl:when test="function-available('saxon:path')">
        <xsl:value-of select="saxon:path($node)" use-when="function-available('saxon:path')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="xpath">
          <xsl:call-template name="efl:get-xpath">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$xpath"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>fonction efl:get-xpath avec des arguments plus nombreux (on fait alors appele au
        template efl:get-xpath plutôt que la fonction saxon:path)</xd:p>
    </xd:desc>
    <xd:param name="node">noeud dont on veut le xpath</xd:param>
    <xd:param name="nsprefix">ajout d'un prefixe devant les noeud</xd:param>
    <xd:param name="display_position">affiche la position dans le chemin xpath généré</xd:param>
    <xd:return>Chemin xpath de $node formaté comme indiqué par $nsprefix et
      $display_position</xd:return>
  </xd:doc>
  <xsl:function name="efl:get-xpath" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <xsl:param name="nsprefix" as="xs:string"/>
    <xsl:param name="display_position" as="xs:boolean"/>
    <xsl:variable name="xpath">
      <xsl:call-template name="efl:get-xpath">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="nsprefix" select="$nsprefix"/>
        <xsl:with-param name="display_position" select="$display_position"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="string-join(tokenize($xpath,'/'),'/')"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Copie un élément et ses attribut et "continue" le traitement dans le mode courant (ou
        sans mode si absent)</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template name="efl:copyAndContinue">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:p>Fonction qui affiche un noeud (élément, attribut ...) sous forme de string
        lisible</xd:p>
    </xd:desc>
    <xd:param name="node">Le noeud a affiché</xd:param>
    <xd:return>Un représentation textuelle du noeud</xd:return>
  </xd:doc>
  <xsl:function name="efl:displayNode" as="xs:string">
    <xsl:param name="node" as="item()"/>
    <xsl:variable name="tmp" as="xs:string*">
      <xsl:choose>
        <xsl:when test="empty($node)">empty_sequence</xsl:when>
        <xsl:when test="$node/self::*">
          <xsl:text>element():</xsl:text>
          <xsl:value-of select="name($node)"/>
          <xsl:if test="$node/@*">
            <xsl:text>_</xsl:text>
          </xsl:if>
          <xsl:for-each select="$node/@*">
            <xsl:sort/>
            <xsl:value-of
              select="concat('@',name(),'=',$dquot,.,$dquot,if (position()!=last()) then ('_') else (''))"
            />
          </xsl:for-each>
        </xsl:when>
        <!--FIXME : ce test ne marche pas...-->
        <xsl:when test="$node/self::text()">
          <xsl:text>text() </xsl:text>
          <xsl:value-of select="substring($node,1,30)"/>
        </xsl:when>
        <xsl:when test="$node/self::comment()">
          <xsl:text>comment() </xsl:text>
          <xsl:value-of select="substring($node,1,30)"/>
        </xsl:when>
        <xsl:when test="$node/self::processing-instruction()">
          <xsl:text>processing-instruction() </xsl:text>
          <xsl:value-of select="substring($node,1,30)"/>
        </xsl:when>
        <xsl:when test="$node/self::document-node()">
          <xsl:text>document-node() </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>unrecognized node type</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="string-join($tmp,'')"/>
  </xsl:function>
  <!-- Application de la fonction saxon:evaluate à un contexte donné, retourne la séquence de noeuds correspondants -->
  <!-- SSI saxon:evaluate est disponible -->
  <xd:doc>
    <xd:desc>
      <xd:p>Applique (ssi saxon:evaluate est disponible) de la fonction saxon:evaluate à un contexte
        donné, retourne la séquence correspondantes</xd:p>
    </xd:desc>
    <xd:param name="xpath">xpath a évaluer</xd:param>
    <xd:param name="e">noeud contexte</xd:param>
  </xd:doc>
  <xsl:function name="efl:evaluate-xpath">
    <xsl:param name="xpath" as="xs:string"/>
    <xsl:param name="e"/>
    <xsl:sequence use-when="function-available('saxon:evaluate')" select="$e/saxon:evaluate($xpath)"
    />
  </xsl:function>
  <!--===================================================	-->
  <!--										FILE														-->
  <!--===================================================	-->
  <xd:doc>
    <xd:desc>
      <xd:p>Renvoi le nom du fichier à partir de son path absolu ou relatif</xd:p>
      <xd:p>Si filePath est vide, renvoi une string vide (non pas empty sequence)</xd:p>
    </xd:desc>
    <xd:param name="filePath">path du fichier</xd:param>
    <xd:param name="withExt">avec ou sans extension</xd:param>
    <xd:return>Nom du fichier avec ou sans extension</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFileName" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:param name="withExt" as="xs:boolean"/>
    <xsl:variable name="fileNameWithExt" select="functx:substring-after-last-match($filePath, '/')"/>
    <xsl:variable name="fileNameNoExt"
      select="functx:substring-before-last-match($fileNameWithExt, '\.')"/>
    <xsl:variable name="ext" select="efl:getFileExt($fileNameWithExt)"/>
    <xsl:sequence
      select="concat('', $fileNameNoExt, if ($withExt) then (concat('.', $ext)) else (''))"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Signature 1arg de efl:getFileName. Par défaut l'extension du fichier est présente</xd:p>
    </xd:desc>
    <xd:param name="filePath">path du fichier</xd:param>
    <xd:return>Nom du fichier avec extension</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFileName" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:sequence select="efl:getFileName($filePath, true())"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Renvoi l'extension d'un fichier à partir de son path absolu ou relatif</xd:p>
      <xd:p>Si $filePath est vide, renvoi une string vide (non pas empty sequence)</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:return>Extension du fichier</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFileExt" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:sequence select="concat('',functx:substring-after-last-match($filePath,'\.'))"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Renvoi le path du niveau désiré dans l'arborescence de fichier d'un fichier
        donné.</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:param name="level">Niveau d'arborescence (1 = dossier parent du fichier, 2 = dossier
      grand-parent, etc.). Ne peut pas être inférieur à 1</xd:param>
    <xd:return>Path du dossier</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFolderPath" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="normalizedLevel" as="xs:integer"
      select="if ($level ge 1) then ($level) else (1)"/>
    <xsl:value-of select="string-join(tokenize($filePath,'/')[position() le last()-$level],'/')"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Signature 1arg de efl:getFolderPath. Par défaut renvoi le path du dossier dans lequel se
        trouve le fichier (level = 1)</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:return>Path du dossier dans lequel se trouve le fichier</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFolderPath" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:sequence select="efl:getFolderPath($filePath,1)"/>
  </xsl:function>
  <xd:doc>
    <xd:desc>
      <xd:p>Récupère le nom d'un dossier d'un fichier donné.</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:param name="level">Niveau d'arborescence (1 = dossier parent du fichier, 2 = dossier
      grand-parent, etc.). Ne peut pas être inférieur à 1</xd:param>
    <xd:return>Nom du dossier (pour un niveau = $level d'arborescence) du path d'un
      fichier.</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFolderName" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:value-of select="tokenize($filePath,'/')[last()-$level]"/>
  </xsl:function>
  <!--par défaut donne le nom du dossier parent-->
  <xd:doc>
    <xd:desc>
      <xd:p>Signature 1arg de efl:getFolderName.</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:return>Nom du dossier dans lequel se trouve le fichier</xd:return>
  </xd:doc>
  <xsl:function name="efl:getFolderName" as="xs:string">
    <xsl:param name="filePath" as="xs:string?"/>
    <xsl:value-of select="efl:getFolderName($filePath,1)"/>
  </xsl:function>
  
  <xd:doc>
    <xd:desc>Retourne l'URI du fichier avec la notation package JAVA</xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:return>URI du fichier en notation package JAVA (sans l'extension du fichier) : 
      a/b/c/file.ext ==> a.b.c.file</xd:return>    
  </xd:doc>
  <xsl:function name="efl:getFilePackageURI" as="xs:string">
    <xsl:param name="filePath" as="xs:string"/>
    <xsl:variable name="fileSchema" as="xs:string" select="'file:/'"/>
    <xsl:variable name="uriWithoutFileSchema" as="xs:string" 
      select="if (starts-with($filePath, $fileSchema)) 
              then substring-after($filePath, $fileSchema) else $filePath"/>
    <xsl:variable name="uriWithNoStartingSlash" as="xs:string"
      select="if (starts-with($uriWithoutFileSchema, '/')) 
      then substring-after($uriWithoutFileSchema, '/') else $uriWithoutFileSchema"/>
    <xsl:variable name="uri" as="xs:string"
      select="functx:substring-before-last-match($uriWithNoStartingSlash, '\.')"/>
    <xsl:value-of select="replace($uri, '/', '.')"/>
  </xsl:function>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Retourne l'URI d'un fichier source d'un projet en notation package JAVA</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:param name="project">Nom du projet auquel appartient le fichier</xd:param>
    <xd:param name="depth">Profondeur du chemin de définition du fichier relativement au répertoire racine du projet</xd:param>
    <xd:return>URI du fichier source en notation package JAVA : project.relative-project-path.file</xd:return>
  </xd:doc>
  <xsl:function name="efl:getSourceFilePackageURI" as="xs:string">
    <xsl:param name="filePath" as="xs:string"/>
    <xsl:param name="project" as="xs:string"/>    
    <xsl:param name="depth" as="xs:integer"/>    
    <xsl:variable name="filePackageURI" as="xs:string" select="efl:getFilePackageURI($filePath)"/>
    <xsl:value-of select="concat($project, '.', 
      string-join(reverse(reverse(tokenize($filePackageURI, '\.'))[position()&lt;=$depth]), '.'))"/>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p>Retourne l'URI d'un fichier source du projet GenBcOm en notation package JAVA</xd:p>
    </xd:desc>
    <xd:param name="filePath">Path du fichier</xd:param>
    <xd:return>URI du fichier source en notation package JAVA : GenBcOm.module.xslt.file</xd:return>
  </xd:doc>
  <xsl:function name="efl:getGenBcOmSourceFilePackageURI" as="xs:string">
    <xsl:param name="filePath" as="xs:string"/>
    <xsl:value-of select="efl:getSourceFilePackageURI($filePath, 'GenBcOm', 3)"/>
  </xsl:function>
  
</xsl:stylesheet>

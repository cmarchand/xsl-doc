<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="top:marchand:xml:local"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 6, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmarchand</xd:p>
            <xd:p>A library with all common functions</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:variable name="_debug" as="xs:boolean" select="false()"/>
    
    <xd:doc>
        <xd:desc>Returns the relative URI of target HTML file</xd:desc>
        <xd:param name="relUri">The XSL relative URI</xd:param>
        <xd:return>The computed HTML file relative URI</xd:return>
    </xd:doc>
    <xsl:function name="local:getDocumentationFileURI" as="xs:string">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:variable name="relUriSeq" select="tokenize($relUri,'/')" as="xs:string*"/>
        <xsl:variable name="sourceFileName" as="xs:string" select="$relUriSeq[last()]"/>
        <xsl:variable name="intermediaryDirectory" as="xs:string" select="local:getIntermediaryDirectory($sourceFileName)"/>
        <xsl:variable name="targetFileName" as="xs:string" select="concat(replace($sourceFileName, '\.','_'),'-doc.html')"/>
        <xsl:variable name="ret" as="xs:string" select="string-join(($relUriSeq[position() &lt; last()],$intermediaryDirectory,$targetFileName),'/')"/>
        <!--xsl:if test="$_debug">
            <xsl:message select="concat('documentationFileUri -> ',$ret)"/>
        </xsl:if-->
        <xsl:sequence select="$ret"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns the relative URI of target HTML file</xd:desc>
        <xd:param name="relUri">The XSL relative URI</xd:param>
        <xd:return>The computed HTML file relative URI</xd:return>
    </xd:doc>
    <xsl:function name="local:getIndexFileURI" as="xs:string">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:variable name="relUriSeq" select="tokenize($relUri,'/')" as="xs:string*"/>
        <xsl:variable name="sourceFileName" as="xs:string" select="$relUriSeq[last()]"/>
        <xsl:variable name="intermediaryDirectory" as="xs:string" select="local:getIntermediaryDirectory($sourceFileName)"/>
        <xsl:variable name="targetFileName" as="xs:string" select="concat(replace($sourceFileName, '\.','_'),'-index.html')"/>
        <xsl:variable name="ret" as="xs:string" select="string-join(($relUriSeq[position() &lt; last()],$intermediaryDirectory,$targetFileName),'/')"/>
        <xsl:if test="$_debug">
            <xsl:message select="concat('indexFileURI -> ',$ret)"/>
        </xsl:if>
        <xsl:sequence select="$ret"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns the relative URI of wecome HTML file</xd:desc>
        <xd:param name="relUri">The XSL relative URI</xd:param>
        <xd:return>The computed HTML file relative URI</xd:return>
    </xd:doc>
    <xsl:function name="local:getWelcomeFileURI" as="xs:string">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:variable name="relUriSeq" select="tokenize($relUri,'/')" as="xs:string*"/>
        <xsl:variable name="sourceFileName" as="xs:string" select="$relUriSeq[last()]"/>
        <xsl:variable name="targetFileName" as="xs:string" select="concat(replace($sourceFileName, '\..*',''),'.html')"/>
        <xsl:variable name="ret" as="xs:string" select="string-join(($relUriSeq[position() &lt; last()],$targetFileName),'/')"/>
        <xsl:if test="$_debug">
            <xsl:message select="concat('welcomeFileURI -> ',$ret)"/>
        </xsl:if>
        <xsl:sequence select="$ret"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns the relative URI of TOC HTML file</xd:desc>
        <xd:param name="relUri">The XSL relative URI</xd:param>
        <xd:return>The computed relative URI to TOC file</xd:return>
    </xd:doc>
    <xsl:function name="local:getTocFileUri" as="xs:string">
        <xsl:param name="relUri" as="xs:string"/>
        <xsl:variable name="relUriSeq" select="tokenize($relUri,'/')" as="xs:string*"/>
        <xsl:variable name="sourceFileName" as="xs:string" select="$relUriSeq[last()]"/>
        <xsl:variable name="intermediaryDirectory" as="xs:string" select="local:getIntermediaryDirectory($sourceFileName)"/>
        <xsl:variable name="targetFileName" as="xs:string" select="concat(replace($sourceFileName, '\..*',''),'-toc.html')"/>
        <xsl:variable name="ret" as="xs:string" select="string-join(($relUriSeq[position() &lt; last()],$intermediaryDirectory,$targetFileName),'/')"/>
        <xsl:if test="$_debug">
            <xsl:message select="concat('tocFileUri -> ',$ret)"/>
        </xsl:if>
        <xsl:sequence select="$ret"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns the file name, without extension, preceded by an underscore</xd:desc>
        <xd:param>The source file name</xd:param>
        <xd:return>The intermediary directory name</xd:return>
    </xd:doc>
    <xsl:function name="local:getIntermediaryDirectory" as="xs:string">
        <xsl:param name="sourceFileName" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($sourceFileName,'/')">
                <xsl:sequence select="error(QName('top:marchand:xml:local','getIntermediaryDirectory_1'),'Q{top:marchand:xml:local}getIntermediaryDirectory(xs:string) does not accept qualified file names')"/>
            </xsl:when>
            <xsl:when test="contains($sourceFileName,'\\')">
                <xsl:sequence select="error(QName('top:marchand:xml:local','getIntermediaryDirectory_2'),'Q{top:marchand:xml:local}getIntermediaryDirectory(xs:string) does not accept qualified file names')"/>
            </xsl:when>
        </xsl:choose>
        <xsl:sequence select="concat('_',replace($sourceFileName, '\..*',''))"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Normalize the URI path. I.E. removes any /./ and folder/.. moves</xd:desc>
        <xd:param name="path">The path to normalize</xd:param>
        <xd:return>The normalized path, as a <html:tt>xs:string</html:tt></xd:return>
    </xd:doc>
    <xsl:function name="local:normalizeFilePath">
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="local:removeLeadingDotSlash(local:removeSingleDot(local:removeDoubleDot($path)))"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Removes single dot in path URI. . are always a self reference, so ./ can always be removed safely</xd:desc>
        <xd:param name="path">The path to remove single dots from</xd:param>
        <xd:return>The clean path, as xs:string</xd:return>
    </xd:doc>
    <xsl:function name="local:removeSingleDot" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" select="replace($path, '/\./','/')"/>
        <xsl:choose>
            <xsl:when test="matches($temp, '/\./')">
                <xsl:sequence select="local:removeSingleDot($temp)"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Removes the leading "./" from the path</xd:desc>
        <xd:param name="path">The path to clean</xd:param>
        <xd:return>The clean path</xd:return>
    </xd:doc>
    <xsl:function name="local:removeLeadingDotSlash">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" select="replace($path, '^\./','')"/>
        <xsl:choose>
            <xsl:when test="starts-with($temp, './')">
                <xsl:sequence select="local:removeLeadingDotSlash($temp)"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Removes .. in an URI when it is preceded by a folder reference. So, removes /xxxx/.. </xd:desc>
        <xd:param name="path">The path to clean</xd:param>
        <xd:return>The clean path</xd:return>
    </xd:doc>
    <xsl:function name="local:removeDoubleDot" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="temp" as="xs:string" select="replace($path,'/[^./]*/\.\./','/')"/>
        <xsl:choose>
            <xsl:when test="matches($temp,'/[^./]*/\.\./')">
                <xsl:sequence select="local:removeDoubleDot($temp)"></xsl:sequence>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="$temp"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns true if the provided URI is absolute, false otherwise</xd:desc>
        <xd:param name="path">The URI to test</xd:param>
        <xd:return><html:tt>true</html:tt> if the URI is absolute</xd:return>
    </xd:doc>
    <xsl:function name="local:isAbsoluteUri" as="xs:boolean">
        <xsl:param name="path" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$path eq ''"><xsl:sequence select="false()"/></xsl:when>
            <xsl:otherwise><xsl:sequence select="matches($path,'[a-zA-Z0-9]+:.*')"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Returns the relative path from source to target.</xd:p>
            <xd:p>Both source and target must be absolute URI</xd:p>
            <xd:p>If there is no way to walk a relative path from source to target, then absolute target URI is returned</xd:p>
        </xd:desc>
        <xd:param name="source">The source URI</xd:param>
        <xd:param name="target">The target URI</xd:param>
        <xd:return>The relative path to walk from source to target</xd:return>
    </xd:doc>
    <xsl:function name="local:getRelativePath" as="xs:string">
        <xsl:param name="source" as="xs:string"/>
        <xsl:param name="target" as="xs:string"/>
        <xsl:if test="$_debug">
            <xsl:message>getRelativePath(<xsl:value-of select="$source"/>, <xsl:value-of select="$target"/>) -></xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$source eq ''">
                <xsl:sequence 
                    select="error(
                    QName('top:marchand:xml:local','getRelativePath_1'),
                    concat('local:getRelativePath(&quot;&quot;,&quot;',
                        $target,
                        '&quot;) : first argument must not be an empty string'))"/>
            </xsl:when>
            <xsl:when test="local:isAbsoluteUri($source)">
                <xsl:choose>
                    <xsl:when test="not(local:isAbsoluteUri($target))">
                        <xsl:sequence select="string-join((tokenize($source,'/'),tokenize($target,'/')),'/')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- si les protocoles sont differents, on renvoie $target -->
                        <xsl:variable name="protocole" select="local:getProtocol($source)"/>
                        <xsl:choose>
                            <xsl:when test="$protocole eq local:getProtocol($target)">
                                <!-- combien d'éléments en début d'URI sont identiques ? -->
                                <xsl:variable name="sourceSeq" select="tokenize(substring(local:normalizeFilePath($source),string-length($protocole)+1),'/')" as="xs:string*"/>
                                <xsl:variable name="targetSeq" select="tokenize(substring(local:normalizeFilePath($target),string-length($protocole)+1),'/')" as="xs:string*"/>
                                <xsl:variable name="nbCommonElements" as="xs:integer" select="local:getNbEqualsElements($sourceSeq, $targetSeq)"/>
                                <xsl:variable name="goUpLevels" as="xs:integer" select="count($sourceSeq) - $nbCommonElements"/>
                                <xsl:variable name="goUp" as="xs:string*" select="(for $i in (1 to $goUpLevels) return '..')" />
                                <xsl:sequence select="string-join(($goUp, subsequence($targetSeq, $nbCommonElements+1)),'/')"></xsl:sequence>
                            </xsl:when>
                            <xsl:otherwise><xsl:sequence select="$target"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="absoluteSource" as="xs:string" select="xs:string(resolve-uri($source))"/>
                <xsl:choose>
                    <xsl:when test="local:isAbsoluteUri($absoluteSource)">
                        <xsl:sequence select="local:getRelativePath($absoluteSource, $target)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence 
                            select="error(
                            QName('top:marchand:xml:local','getRelativePath_1'),
                            concat($source, ' can not be resolved as an absolute URI'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Returns the protocol of this URI</xd:desc>
        <xd:param name="path">The URI to check</xd:param>
        <xd:return>The protocol of the URI</xd:return>
    </xd:doc>
    <xsl:function name="local:getProtocol" as="xs:string">
        <xsl:param name="path" as="xs:string"/>
        <xsl:variable name="protocol" select="substring-before($path,':')"/>
        <xsl:choose>
            <xsl:when test="string-length($protocol) gt 0"><xsl:sequence select="$protocol"/></xsl:when>
            <xsl:otherwise>
                <xsl:sequence 
                    select="error(
                    QName('top:marchand:xml:local','getProtocol'),
                    concat('protocol(',$path,') : path must be an absolute URI'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Compare pair to pair seq1 and seq2 items, and returns the numbers of deeply-equals items</xd:desc>
        <xd:param name="seq1">The first sequence</xd:param>
        <xd:param name="seq2">The second sequence</xd:param>
    </xd:doc>
    <xsl:function name="local:getNbEqualsElements" as="xs:integer">
        <xsl:param name="seq1" as="item()*"/>
        <xsl:param name="seq2" as="item()*"/>
        <xsl:choose>
            <xsl:when test="deep-equal($seq1[1],$seq2[1])">
                <xsl:sequence select="local:getNbEqualsElements(tail($seq1), tail($seq2))+1"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="0"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="xsl:*" mode="visibility" as="attribute(visibility)?">
        <xsl:call-template name="visibility">
            <xsl:with-param name="type" select="local-name()"/>
            <xsl:with-param name="name" select="@name"/>
            <xsl:with-param name="declared-visibility" select="@visibility"/>
            <xsl:with-param name="expose" select="/*/xsl:expose"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="visibility" as="attribute(visibility)?">
        <xsl:param name="type" as="xs:string" required="yes"/>
        <xsl:param name="name" as="attribute(name)?"/>
        <xsl:param name="declared-visibility" as="attribute(visibility)?"/>
        <xsl:param name="expose" as="element(xsl:expose)*"/>
        <xsl:choose>
            <xsl:when test="$type='param'">
                <xsl:attribute name="visibility" select="'public'"/>
            </xsl:when>
            <xsl:when test="$type=('template',
                                   'function',
                                   'attribute-set',
                                   'variable',
                                   'mode')">
                <xsl:variable name="expose" as="element(xsl:expose)*" select="$expose[@component=('*',$type)]"/>
                <xsl:variable name="explicit-exposed-visibility" as="attribute(visibility)*"
                              select="$expose[$name=tokenize(@names,'\s+')]/@visibility"/>
                <xsl:choose>
                    <xsl:when test="$explicit-exposed-visibility">
                        <xsl:sequence select="$explicit-exposed-visibility[last()]"/>
                    </xsl:when>
                    <xsl:when test="$declared-visibility">
                        <xsl:sequence select="$declared-visibility"/>
                    </xsl:when>
                    <xsl:when test="$name">
                        <xsl:variable name="prefix" as="xs:string?"
                                      select="if (contains($name,':')) then substring-before($name,':') else ()"/>
                        <xsl:variable name="local-name" as="xs:string"
                                      select="if (contains($name,':')) then substring-after($name,':') else $name"/>
                        <xsl:variable name="exposed-visibility" as="attribute(visibility)?"
                                      select="$expose[some $name in tokenize(@names,'\s+')
                                                      satisfies (
                                                        $name='*'
                                                        or exists($prefix) and $name=concat($prefix,':*')
                                                        or $name=concat('*:',$local-name)
                                                      )]
                                              /@visibility"/>
                        <xsl:if test="$exposed-visibility">
                            <xsl:sequence select="$exposed-visibility"/>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>

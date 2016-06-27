<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY egrave "&#232;">
<!ENTITY euro "&#8364;">
<!ENTITY agrave "&#224;">
<!ENTITY eacute "&#233;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.xemelios.org/namespaces#cge" xmlns:n="http://www.xemelios.org/namespaces#cge" version="2.0">
    <xsl:template name="Error">
        <!--xsl:param name="error.message"/-->
        <script>
            function hideDialog() {
                var dialogBox = document.getElementById("dialogBox");
                dialogBox.style.visibility = "hidden";
            }
            
            function showDialog(content) {
                var dialogBox = document.getElementById("dialogBox");
                var dialogContent = document.getElementById("dialogContent");
                dialogContent.innerHTML = content;
                dialogBox.style.visibility = "visible";
            }
        </script>
        <div id="dialogBox" style="visibility: hidden; position: absolute; left: 10px; top: 10px; width: 800px; height: 100px; border-style: solid; border-width: 1px; border-color: #00006A; background-color: white; z-index: 1000;">
            <table border="0" width="100%">
                <tr>
                    <td style="width: 100%; font-weight:bold;" id="dialogContent"></td>
                    <td valign="top" align="right">
                        <a href="javascript:hideDialog();"><img src="img/bt_fermer.gif" border="0"/></a>
                    </td>
                </tr>
            </table>
        </div>
        
        <!--table width="100%" style="border-style:none;border-width:0px;cell-padding:0px;cell-spacing:0px">
            <colgroup>
                <col width="25%"/>
                <col width="50%"/>
                <col width="25%"/>
            </colgroup>
            <tbody>
                <tr style="border:none;">
                    <td style="border:none;">&nbsp;</td>
                    <td id="message">
                        <center width="100%">
                            <xsl:value-of select="$error.message"/>                     
                        </center>
                        <br/></td>
                    <td style="border:none;">&nbsp;</td>
                </tr>
            </tbody>
        </table-->
    </xsl:template>
</xsl:stylesheet>
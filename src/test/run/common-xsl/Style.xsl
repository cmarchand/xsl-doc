<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.xemelios.org/namespaces#cge" xmlns:n="http://www.xemelios.org/namespaces#cge" version="2.0">
    <xsl:template name="style">
        <style type="text/css" media="all"> 
            table#main {border-spacing: 0px; background-color: white; border: #000000 solid 2px;border-collapse: collapse; } 
            table#mainBorderedNot {border-spacing: 0px; background-color: white; border: #000000 none 2px; border-collapse: collapse; }
            
            .bordered { border: #000000 solid 1px;}
            .borderedBold { border: #000000 solid 2px;}
            
            .borderedNot { border: #000000 none 1px;}
            
            .bordureRight { border-right: #000000 solid 1px; }
            .bordureLeft { border-left: #000000 solid 1px; }
            
            .bordureTop { border-top: #000000 solid 1px; }
            .bordureTopBold { border-top: #000000 solid 2px; }
            
            .bordureBottom { border-bottom: #000000 solid 1px; }
            .bordureBottomBold { border-bottom: #000000 solid 2px; }
            
            .borderedNotTop { border-bottom: #000000 solid 1px ; border-left: #000000 solid 1px ; border-right: #000000 solid 1px ;}
            .borderedNotBottom { border-top: #000000 solid 1px ; border-left: #000000 solid 1px ; border-right: #000000 solid 1px ;}
            .borderedNotLeft { border-top: #000000 solid 1px ; border-bottom: #000000 solid 1px ; border-right: #000000 solid 1px ;}
            .borderedNotRight { border-top: #000000 solid 1px ; border-bottom: #000000 solid 1px ; border-left: #000000 solid 1px ;}

            b.negative { color: red;}
            
            tr#colorised1 td {background-color: #FFFFC5; }
            tr#colorised2 td {background-color: #FFFFE0; } /* jaune pale */
            tr#colorised3 td {background-color: #D9EEFF; } /* bleu pale */
            
            tr#highlighted td {background-color: #FFFF68; font-weight:bold; }
            tr#highlighted td  a { font-weight: bold; }
            tr#highlighted td  a:hover { color: #FF4000; }
            
            a:link { color: #0000FF; background: transparent; }
            a:visited { color: #FF3ABA; background: transparent; }
            
            td#highlighted {background-color: #FFFF68; font-weight:bold; }
            
            td#padding2 { padding-left: 20px;}
            td#padding4 { padding-left: 40px;}
            td#padding6 { padding-left: 60px;}
            td#padding8 { padding-left: 80px;}
            td#padding10 { padding-left: 100px;}
            td#padding12 { padding-left: 120px;}
            td#padding14 { padding-left: 140px;}
            td#padding70 { padding-left: 200px;}
            td#padding77 { padding-left: 220px;}
            
            
            a.precsuiv { color: #0000FF; background: transparent; font-style: normal; text-decoration: none;}
            a.sommaire:visited { color: #0000FF; background: transparent; font-style: normal;}
            
            tr.mask td {heigth: 0px; font-size: 0px;}
            tr[id!=mask] td { height: 20px;}
            
            td.right { text-align: right; } 
            td.left { text-align: left; } 
            td.center { text-align: center; } 
            td.bold { font-weight:bold; } 
            td.montant { white-space: nowrap;text-align: right;} 
            
            
            td.font { background-color: #FFFFFF; }
            
            
            tr.lineEntete1 td { height: 20px;}
                        
            div p { padding-left: 75px;} 
            div p input { padding-left: 20px;}
            
            td#message { border: red solid 2px; text-align: center; v-align: middle; color: red; width: 50%;}
            
            /* ici */
            
            img {border: none;}
            
            .formulaire {display: block;}
            .navigate {display: block;}
            .showPrint { display: none;}
        </style>
        <style type="text/css" media="screen">
            .numPage {font-family: verdana, sans-serif; font-size: 12px; }
            /*.numCompte { position:absolute; left: 10em; font-size: 14px; font-weight: bold;}*/            
            
            h1 { font-size: 20px; color: #003535; font-weight: bold; } 
            h2 { font-size: 14px; color: #004545; text-align: center;}
            h3 { font-size: 12px; color: #005555; text-align: center;}
            
            span {font-size: 18px; font-weight: bold;}
            
            span a:link {color: #0000FF; font-size: 18px; font-weight: bold; font-style: underline;}
            span a:visited {color: #0000FF; font-size: 18px; font-weight: bold; font-style: underline;}
            tr.paddingLeft td { padding-left: 20px;}
            
            tr.total td { font-weight:bold; font-size: 12px;}
            tr.total td  a { font-weight: bold; font-size: 12px;}
            tr.total td  a:hover { color: #FF4000; font-size: 12px;}
            
            tr.Total td { font-weight:bold; font-size: 12px;}
            tr.Total td  a { font-weight: bold; font-size: 12px;}
            tr.Total td  a:hover { color: #FF4000; font-size: 12px;}
            
            td.totalAnnexeII1 { background-color: #FFFF9A; font-size: 13px;}
            td.totalAnnexeII { color: navy; background-color: #FFFFBB; font-size: 12px;}
            
            tr.NotTotal td{ font-size: 12.5px;}

            a {font-size: 12.5px;}
            
            td.titre { font-size: 12px;} 
            td.titre2 { font-size: 11px;}
            td.titre3 { font-size: 10px;}
            
            td.libelleLigne { text-align: right; font-size: 12px; } 
            td.libelleLigne2 { text-align: right; font-size: 10px; }
            
            caption { color: navy; font-size: 12px; font-weight: bold;}
            label { font-size: 11px; font-weight: bold;}
        </style>
        <style type="text/css" media="print">
            body {font-family: verdana, sans-serif; font-size: 8px; } 
            .numPage {font-family: verdana, sans-serif; font-size: 12px; }
            /*.numCompte { position:absolute; left: 10em; font-size: 14px; font-weight: bold;}*/            
            
            h1 { font-size: 18px; color: #003535; font-weight: bold; } 
            h2 { font-size: 12px; color: #004545; text-align: center;}
            h3 { font-size: 10px; color: #005555; text-align: center;}
            
            span {font-size: 16px; font-weight: bold;}
            
            span a:link {color: #0000FF; font-size: 16px; font-weight: bold; font-style: underline;}
            span a:visited {color: #0000FF; font-size: 16px; font-weight: bold; font-style: underline;}

            tr.paddingLeft td { padding-left: 18px;}
            
            tr.total td { font-weight:bold; font-size: 10px;}
            tr.total td  a { font-weight: bold; font-size: 10px;}
            tr.total td  a:hover { color: #FF4000; font-size: 10px;}
            
            tr.Total td { font-weight:bold; font-size: 10px;}
            tr.Total td  a { font-weight: bold; font-size: 10px;}
            tr.Total td  a:hover { color: #FF4000; font-size: 10px;}
            
            td.totalAnnexeII1 { background-color: #FFFF9A; font-size: 11px;}
            td.totalAnnexeII { color: navy; background-color: #FFFFBB; font-size: 10px;}
            
            tr.NotTotal td { font-size: 7px;}

            a {font-size: 10px;}

            td.titre { font-size: 10px;} 
            td.titre2 { font-size: 9px;}
            td.titre3 { font-size: 8px;}
            
            td.libelleLigne { text-align: right; font-size: 10px; } 
            td.libelleLigne2 { text-align: right; font-size: 8px; }
            
            caption { color: navy; font-size: 10px; font-weight: bold;}
            label { font-size: 9px; font-weight: bold;}
            
            .formulaire {display: none;}
            .navigate {display: none;}
            .hidePrint { display: none;}
            .showPrint { display: block;}
            
            a {text-decoration: none;color: black;}
            
            table#main {width=100%; border-spacing: 0px; background-color: white; border: #000000 solid 2px;border-collapse: collapse; -fs-table-paginate: paginate;}
            table#mainBorderedNot {border-spacing: 0px; background-color: white; border: #000000 none 2px; border-collapse: collapse;  -fs-table-paginate: paginate;}
            
            tr { page-break-inside: avoid;}
            
            tr#colorised1 td {background-color: #FFFFFF; }
            tr#colorised2 td {background-color: #FFFFFF; }
            
            tr#highlighted td {background-color: #FFFFFF; font-weight: normal;}            
            
            td#padding2 { padding-left: 5px;}
            td#padding4 { padding-left: 10px;}
            td#padding6 { padding-left: 15px;}
            td#padding8 { padding-left: 20px;}
            td#padding10 { padding-left: 25px;}
            td#padding12 { padding-left: 30px;}
            td#padding14 { padding-left: 35px;}
            td#padding70 { padding-left: 40px;}
            td#padding77 { padding-left: 50px;}
            
            td.bold { font-weight:bold; } 
            
            tr.total td { font-weight:bold; font-size: 10px;}
            
            tr.total td  a { font-weight: bold; font-size: 10px;}
            tr.total td  a:hover { color: #FF4000; font-size: 10px;}
            
            tr#highlighted td  a { font-weight: normal; }
            
            .bordureRight { border: #000000 solid 1px ; }
             .bordered { border: #000000 solid 1px;}
        </style>
    </xsl:template>
    
</xsl:stylesheet>

<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/banco.asp" -->
<%
' *** Edit Operations: declare variables

Dim MM_editAction
Dim MM_abortEdit
Dim MM_editQuery
Dim MM_editCmd

Dim MM_editConnection
Dim MM_editTable
Dim MM_editRedirectUrl
Dim MM_editColumn
Dim MM_recordId

Dim MM_fieldsStr
Dim MM_columnsStr
Dim MM_fields
Dim MM_columns
Dim MM_typeArray
Dim MM_formVal
Dim MM_delim
Dim MM_altVal
Dim MM_emptyVal
Dim MM_i

MM_editAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_editAction = MM_editAction & "?" & Request.QueryString
End If

' boolean to abort record edit
MM_abortEdit = false

' query string to execute
MM_editQuery = ""
%>
<%
' *** Insert Record: set variables

If (CStr(Request("MM_insert")) = "formulario") Then

  MM_editConnection = MM_banco_STRING
  MM_editTable = "boletim"
  MM_editRedirectUrl = "cadastradoboletim.asp"
  MM_fieldsStr  = "nome|value|email|value|endereco|value|cidade|value|estado|value|profissao|value"
  MM_columnsStr = "nome|',none,''|email|',none,''|endereco|',none,''|cidade|',none,''|estado|',none,''|profissao|',none,''"

  ' create the MM_fields and MM_columns arrays
  MM_fields = Split(MM_fieldsStr, "|")
  MM_columns = Split(MM_columnsStr, "|")
  
  ' set the form values
  For MM_i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_fields(MM_i+1) = CStr(Request.Form(MM_fields(MM_i)))
  Next

  ' append the query string to the redirect URL
  If (MM_editRedirectUrl <> "" And Request.QueryString <> "") Then
    If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0 And Request.QueryString <> "") Then
      MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
    Else
      MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
    End If
  End If

End If
%>
<%
' *** Insert Record: construct a sql insert statement and execute it

Dim MM_tableValues
Dim MM_dbValues

If (CStr(Request("MM_insert")) <> "") Then

  ' create the sql insert statement
  MM_tableValues = ""
  MM_dbValues = ""
  For MM_i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_formVal = MM_fields(MM_i+1)
    MM_typeArray = Split(MM_columns(MM_i+1),",")
    MM_delim = MM_typeArray(0)
    If (MM_delim = "none") Then MM_delim = ""
    MM_altVal = MM_typeArray(1)
    If (MM_altVal = "none") Then MM_altVal = ""
    MM_emptyVal = MM_typeArray(2)
    If (MM_emptyVal = "none") Then MM_emptyVal = ""
    If (MM_formVal = "") Then
      MM_formVal = MM_emptyVal
    Else
      If (MM_altVal <> "") Then
        MM_formVal = MM_altVal
      ElseIf (MM_delim = "'") Then  ' escape quotes
        MM_formVal = "'" & Replace(MM_formVal,"'","''") & "'"
      Else
        MM_formVal = MM_delim + MM_formVal + MM_delim
      End If
    End If
    If (MM_i <> LBound(MM_fields)) Then
      MM_tableValues = MM_tableValues & ","
      MM_dbValues = MM_dbValues & ","
    End If
    MM_tableValues = MM_tableValues & MM_columns(MM_i)
    MM_dbValues = MM_dbValues & MM_formVal
  Next
  MM_editQuery = "insert into " & MM_editTable & " (" & MM_tableValues & ") values (" & MM_dbValues & ")"

  If (Not MM_abortEdit) Then
    ' execute the insert
    Set MM_editCmd = Server.CreateObject("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_editConnection
    MM_editCmd.CommandText = MM_editQuery
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close

    If (MM_editRedirectUrl <> "") Then
      Response.Redirect(MM_editRedirectUrl)
    End If
  End If

End If
%>
<%
Dim registro
Dim registro_numRows

Set registro = Server.CreateObject("ADODB.Recordset")
registro.ActiveConnection = MM_banco_STRING
registro.Source = "SELECT * FROM boletim"
registro.CursorType = 0
registro.CursorLocation = 2
registro.LockType = 1
registro.Open()

registro_numRows = 0
%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Instituto de Odontologia Frujeri &amp; Frujeri</title>
<script language="JavaScript">
<!--
function mmLoadMenus() {
  if (window.mm_menu_1115101523_0) return;
                                                                                    window.mm_menu_1115101523_0 = new Menu("root",149,22,"Verdana, Arial, Helvetica, sans-serif",11,"#FFFFFF","#336699","#205CA5","#FFFFFF","left","middle",3,0,200,-5,7,true,true,true,0,false,false);
  mm_menu_1115101523_0.addMenuItem("Dent�stica&nbsp;e&nbsp;Pr�tese");
  mm_menu_1115101523_0.addMenuItem("Endodontia");
  mm_menu_1115101523_0.addMenuItem("Estomatologia");
  mm_menu_1115101523_0.addMenuItem("Implantodontia");
  mm_menu_1115101523_0.addMenuItem("Ortodontia");
  mm_menu_1115101523_0.addMenuItem("Periodontia");
  mm_menu_1115101523_0.addMenuItem("Radiologia");
   mm_menu_1115101523_0.hideOnMouseOut=true;
   mm_menu_1115101523_0.bgColor='#FFFFFF';
   mm_menu_1115101523_0.menuBorder=1;
   mm_menu_1115101523_0.menuLiteBgColor='#FFFFFF';
   mm_menu_1115101523_0.menuBorderBgColor='#205CA5';
window.mm_menu_1115105914_0 = new Menu("root",92,17,"Verdana, Arial, Helvetica, sans-serif",11,"#FFFFFF","#336699","#205CA5","#FFFFFF","left","middle",3,0,200,-5,7,true,true,true,0,true,true);
  mm_menu_1115105914_0.addMenuItem("Novo&nbsp;item");
   mm_menu_1115105914_0.hideOnMouseOut=true;
   mm_menu_1115105914_0.bgColor='#FFFFFF';
   mm_menu_1115105914_0.menuBorder=1;
   mm_menu_1115105914_0.menuLiteBgColor='#FFFFFF';
   mm_menu_1115105914_0.menuBorderBgColor='#205CA5';

                
                        window.mm_menu_1115111130_0 = new Menu("root",149,22,"Verdana, Arial, Helvetica, sans-serif",11,"#FFFFFF","#205CA5","#205CA5","#FFFFFF","left","middle",3,0,200,-5,7,true,true,true,0,false,false);
  mm_menu_1115111130_0.addMenuItem("Dent�stica&nbsp;e&nbsp;Pr�tese","window.open('artigos_dentistica.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Endodontia","window.open('artigos_endo.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Estomatologia","window.open('artigos_estomato.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Implantodontia","window.open('artigos_implanto.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Ortodontia","window.open('artigos_orto.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Pediatria","window.open('artigos_pediatria.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Periodontia","window.open('artigos_perio.htm', '_parent');");
  mm_menu_1115111130_0.addMenuItem("Radiologia","window.open('artigos_radio.htm', '_parent');");
   mm_menu_1115111130_0.hideOnMouseOut=true;
   mm_menu_1115111130_0.bgColor='#FFFFFF';
   mm_menu_1115111130_0.menuBorder=1;
   mm_menu_1115111130_0.menuLiteBgColor='#FFFFFF';
   mm_menu_1115111130_0.menuBorderBgColor='#205CA5';

mm_menu_1115111130_0.writeMenus();
} // mmLoadMenus()

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' \n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+'\n'; }
  } if (errors) alert('Certifique-se de que o(s) seguinte(s) campo(s) esteja(m) preenchido(s) corretamente:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
<script language="JavaScript" src="mm_menu.js"></script>
</head>

<body topmargin="0" leftmargin="0" link="#205CA5" vlink="#205CA5" alink="#205CA5">
<script language="JavaScript1.2">mmLoadMenus();</script>
<table border="0" cellPadding="0" cellSpacing="0" width="782" height="50">
  <tbody>
    <tr>
      <td width="740" height="94" align="left" valign="top" background="principal/img/fundo_logo.gif">
        <p align="center"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="99" height="81" align="left">
          <param name="movie" value="principal/logo2.swf">
          <param name="quality" value="high">
          <embed src="principal/logo2.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="99" height="81"></embed></object>
        <br>
        <br>
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="197" height="26" align="left">
          <param name="movie" value="principal/logo1.swf">
          <param name="quality" value="high">
          <embed src="principal/logo1.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="197" height="26"></embed></object>
        <br>
        <br>
        </p>
        <p align="center"> 
          <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="534" height="15">
            <param name="movie" value="principal/logo3.swf">
            <param name="quality" value="high">
            <embed src="principal/logo3.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="534" height="15"></embed></object>
        </p>
      </td>
      <td align="right" bgColor="#205CA5" vAlign="top" background="principal/img/fundo_logo.gif" width="38" height="50">&nbsp; </td>
    </tr>
  </tbody>
</table>
<table border="0" cellPadding="0" cellSpacing="0" height="100%" width="610">
  <tbody>
  
  <tr>
    <td bgColor="#93BEE2" height="592" vAlign="top" width="152">
      <table border="0" cellPadding="0" cellSpacing="0" width="150">
        <tbody>
          <tr bgColor="#205CA5">
            <td bgcolor="#205CA5"> <br>
                <br>
                <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="javascript:;" onMouseOver="MM_showMenu(window.mm_menu_1115111130_0,150,-2,null,'image1')" onMouseOut="MM_startTimeout();"><img src="principal/img/lc_artigos.gif" name="image1" width="150" height="18" border="0" id="image1"></a> 
              <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="curiosidades.htm">
                <img border="0" src="principal/img/lc_curiosidades.gif" width="150" height="18"> 
              </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="historia_odontologia.htm">
                <img border="0" src="principal/img/lc_historia.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="links.htm">
                <img border="0" src="principal/img/lc_links.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="mensagens.htm">
                <img border="0" src="principal/img/lc_mensagens.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="novidades.htm">
                <img border="0" src="principal/img/lc_novidades.gif" width="150" height="18"></a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="pensamentos.htm">
                <img border="0" src="principal/img/lc_pensamentos.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="odonto_arte.htm">
                <img border="0" src="principal/img/lc_artes.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="odonto_dicas.htm">
                <img border="0" src="principal/img/lc_dicas.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="odonto_forca.htm">
                <img border="0" src="principal/img/lc_forca.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
              <a href="crianca.htm">
                <img border="0" src="principal/img/lc_crianca.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br> 
              <a href="orientando.htm">
                <img border="0" src="principal/img/lc_orientando.gif" width="150" height="18"> </a> <img src="principal/img/linha.gif" width="150" height="1"><br>
             <tr>
            <td bgcolor="#93BEE2"><img src="principal/img/curva1.gif" width="150" height="19"></td>
          </tr>
        <form action="http://www.odontologia.com.br/busca.asp" method="post" name="busca" onsubmit="return validar_busca()">
          <input name="id" type="hidden" value="25">
          <tr>
            <td bgColor="#93BEE2" vAlign="bottom"><img border="0" src="principal/img/botao_busca.gif" width="150" height="23"><br>
&nbsp;
              <input name="words" size="14">
              <img border="0" src="principal/img/seta_direita.gif" width="13" height="13">
              <br>
            </td>
          </tr>
          <tr>
            <td bgcolor="#205CA5"><img height="15" src="principal/img/curva_busca.gif" width="150"></td>
          </tr>
        </form>
        <tr align="left">
          <td vAlign="top" bgcolor="#93BEE2"><br>
            <a href="livrodevisitas.asp"><img border="0" src="principal/img/botao_odonto_lc_livro_visitas.gif" width="131" height="36"></a><br>
            <a href="boletim.asp"><img border="0" src="principal/img/botao_boletim.gif" width="119" height="27"></a><br>
            <a href="recomende.htm"><img border="0" src="principal/img/botao_recomende.gif" width="127" height="33"></a>
            <br>
            <img border="0" src="principal/img/botao_odonto_cadastrese.gif" width="131" height="36"><br>
            <p>
              <br>
              <br>
            <a href="quem_somos.htm"><img border="0" src="principal/img/botao_quemsomos.gif" width="150" height="10"></a><br>
            <a href="direitos_autorais.htm"><img border="0" src="principal/img/botao_dir_autorais.gif" width="150" height="14"></a><br>
              <a href="falecomagente.asp"><img align="top" border="0" src="principal/img/botao_contate.gif" width="150" height="11"></a><br>
            </p>
            <p>&nbsp;
            </p>
            <p>
              <br>
            <a href="principal.htm"><img border="0" src="principal/img/pagina_de_entrada.gif" width="150" height="48"></a><br>
            </p>
          </td>
        </tr>
        </tbody>
        
      </table>
    </td>
    <td colSpan="3" height="592" vAlign="top" width="646">
       <table border="0" cellPadding="0" cellSpacing="0" width="632" bgcolor="#205CA5">
        <tbody>
          <tr>
            <td bgcolor="#205CA5" height="20" vAlign="top" width="21">&nbsp;</td>
            <td bgColor="#205CA5" height="20" vAlign="top" width="607">&nbsp;&nbsp;&nbsp; <a href="nossa_historia.htm"> <img border="0" src="principal/img/botao_historia.gif" width="110" height="18"></a><img align="top" border="0" src="principal/img/botao_meio.gif" width="17" height="18"><a href="corpo_clinico.htm"><img border="0" src="principal/img/botao_corpoclinico.gif" width="100" height="18"></a><img align="top" border="0" src="principal/img/botao_meio.gif" width="17" height="18"><a href="localizacao.htm"><img border="0" src="principal/img/botao_localizacao.gif" width="100" height="18"></a><img alt border="0" src="principal/img/botao_meio.gif" width="17" height="18"><a href="webmail.htm"><img border="0" src="principal/img/botao_webmail.gif" width="90" height="18"></a><img border="0" src="principal/img/botao_fim_desativado.gif" width="17" height="18"><a href="http://"><!-- <img src="/images/botao_meio.gif" width="17" height="18" alt="" border="0"><a href="/imagens.asp"><img src="/images/botao_imagens.gif" width="69" height="18" alt="" border="0"></a> -->
            </a> </td>
          </tr>
          <tr>
            <td bgColor="#93BEE2" height="25" vAlign="top" width="21"><img src="principal/img/curva3.gif" width="8" height="9"></td>
            <td bgColor="#93BEE2" height="25" width="607"> &nbsp;<a href="aniversariantes.htm"><img border="0" src="principal/img/botao_aniversariantes.gif" width="156" height="14"></a>&nbsp;&nbsp;&nbsp;&nbsp;
              <a href="atendimento.htm"><img border="0" src="principal/img/botao_atendimento.gif" width="96" height="14"></a>&nbsp;&nbsp;&nbsp;
              <a href="boletim.asp"><img border="0" src="principal/img/botao_boletim2.gif" width="100" height="14"></a>&nbsp;
              <a href="livrodevisitas.asp"><img src="principal/img/botao_livro_visita.gif" border="0" width="107" height="14"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
          </tr>
          <tr>
            <td bgColor="#205CA5" colSpan="2" width="630"><img height="1" src="vazio.gif" width="3"></td>
          </tr>
        </tbody>
      </table>
      <table border="0" width="632" height="784" cellspacing="0">
        <tbody>
          <tr>
           <td height="1" width="6"></td>
            <td class="um" height="1" width="445">
              <p align="right"></td>
            <td height="1" width="14" bordercolor="#205CA5"></td>
            <td class="um" height="1" width="153" bgcolor="#93BEE2" bordercolor="#205CA5" bordercolorlight="#205CA5" bordercolordark="#205CA5">
              <p align="left">
                <script language="JavaScript">
hoje=new Date()
dia=hoje.getDate()
dias=hoje.getDay()
mes=hoje.getMonth()
ano=hoje.getYear()
hora=hoje.getHours()
minutos=hoje.getMinutes()
minutos=((minutos<10)?':0':':')+minutos;
if(dia<10)
 dia=+dia
if(ano<2000)
 ano=1990+ano
function NArray(n){
 this.length=n
}
NomeMes=new NArray(12)
NomeMes[0]="janeiro"
NomeMes[1]="fevereiro"
NomeMes[2]="mar�o"
NomeMes[3]="abril"
NomeMes[4]="maio"
NomeMes[5]="junho"
NomeMes[6]="julho"
NomeMes[7]="agosto"
NomeMes[8]="setembro"
NomeMes[9]="outubro"
NomeMes[10]="novembro"
NomeMes[11]="dezembro"
function WriteDate(){
document.write("<p align=right><font color=#205CA5 size=1 face=Arial>"+dia+" de "+NomeMes[mes]+" de "+ano+"</font></right>")
}
<!--linha de execu��o-->
WriteDate()
</script></td>
          </tr>
          <tr>
            <td width="6" height="776"></td>
            <td valign="top" align="left" width="445" height="776"> <p style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0"><font size="1" face="arial"><a href="principal.htm">Instituto 
                de Odontologia Frujeri &amp; Frujeri</a> ::&nbsp;<font color="#205CA5">Boletim 
                IOFF</font> :: Cadastro</font> <br>
                <br>
              <div align="center"></div>
              <table width="436" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td background="principal/img/bgr_topint.jpg" align="right"><img src="principal/img/img_tit_cadastro.gif" width="111" height="50"><img src="principal/img/cadastre-se.jpg" width="100" height="100"> 
                  </td>
                </tr>
              </table>
              <p align="center" style="word-spacing: 0; line-height: 100%;"><font size="1" face="Arial Black"><span style="mso-fareast-font-family: Times New Roman; mso-bidi-font-family: Times New Roman; color: #205CA5; mso-ansi-language: PT-BR; mso-fareast-language: PT-BR; mso-bidi-language: AR-SA">CADASTRE-SE
              NO IOFF PARA O RECEBIMENTO DO NOSSO BOLETIM !</span></font><p align="left" style="word-spacing: 0; line-height: 100%;"><span style="font-size:7.5pt;font-family:Arial;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:PT-BR;mso-fareast-language:
PT-BR;mso-bidi-language:AR-SA">&nbsp;&nbsp;<span style="color:#205CA5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              </span></span><font size="1" face="Arial"><span style="color: #205CA5; mso-fareast-font-family: Times New Roman; mso-ansi-language: PT-BR; mso-fareast-language: PT-BR; mso-bidi-language: AR-SA">Se
              voc� deseja receber nosso boletim com novidades, informa��es e
              atualiza��es do nosso portal, preencha os campos abaixo com seus
              dados.<br>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Preste muita aten��o
              no preenchimento: escreva corretamente o seu e-mail, pois � por
              este endere�o que n�s entraremos em contato com voc�.</span></font><p align="center" style="word-spacing: 0; line-height: 100%;"><font color="#336699" size="1" face="arial black"><img src="principal/img/rc_cadastro.gif" width="445" height="15"></font> 
              <form ACTION="<%=MM_editAction%>" method="POST" name="formulario" id="formulario" onSubmit="MM_validateForm('nome','','R','email','','RisEmail','endereco0','','R','cidade','','R','profissao','','R');return document.MM_returnValue">
                
                <font size="1" face="Arial, Helvetica, sans-serif"> </font> 
                <table width="457" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td width="65"><font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">NOME:</font></td>
                    <td width="388" colspan="3"><font size="1" face="Arial, Helvetica, sans-serif"> 
                      <input name="nome" type="text" id="nome" style="font-family: arial; font-size: 8 pt" size="50">
                      </font></td>
                  </tr>
                  <tr> 
                    <td width="65"><font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">E-MAIL:</font></td>
                    <td colspan="3" width="388"><input name="email" type="text" id="email" style="font-family: arial; font-size: 8 pt" size="50"></td>
                  </tr>
                  <tr> 
                    <td width="65"><font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">ENDERE&Ccedil;O:</font></td>
                    <td colspan="3" width="388"> <input name="endereco" type="text" id="endereco0" style="font-family: arial; font-size: 8 pt" onBlur="MM_validateForm('endereco0','','R');return document.MM_returnValue" size="50"></td>
                  </tr>
                  <tr> 
                    <td width="65"><font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">CIDADE:</font></td>
                    <td width="116"><input name="cidade" type="text" style="font-family: arial; font-size: 8 pt" onBlur="MM_validateForm('nome','','R','email','','RisEmail','endereco0','','R','cidade','','R','profissao','','R');return document.MM_returnValue" size="20"></td>
                    <td width="78">&nbsp;&nbsp;&nbsp;&nbsp; <font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">ESTADO:</font></td>
                    <td width="190"><select size="1" name="estado" style="font-family: arial; font-size: 8 pt">
                        <option selected>Estado</option>
                        <option>Acre</option>
                        <option>Alagoas</option>
                        <option>Amap�</option>
                        <option>Amazonas</option>
                        <option>Bahia</option>
                        <option>Cear�</option>
                        <option>Distrito Federal</option>
                        <option>Esp�rito Santo</option>
                        <option>Goi�s</option>
                        <option>Maranh�o</option>
                        <option>Mato Grosso</option>
                        <option>Mato Grosso do Sul</option>
                        <option>Minas Gerais</option>
                        <option>Par�</option>
                        <option>Para�ba</option>
                        <option>Paran�</option>
                        <option>Pernambuco</option>
                        <option>Piau�</option>
                        <option>S�o Paulo</option>
                        <option>Rio de Janeiro</option>
                        <option>Rio Grande do Norte</option>
                        <option>Rio Grande do Sul</option>
                        <option>Rond�nia</option>
                        <option>Roraima</option>
                        <option>Santa Catarina</option>
                        <option>Sergipe</option>
                        <option>Tocantins</option>
                      </select></td>
                  </tr>
                  <tr> 
                    <td width="65"><font size="1" face="Arial, Helvetica, sans-serif" color="#205CA5">PROFISS�O:</font></td>
                    <td colspan="3" width="388"><input type="text" name="profissao" size="20" style="font-family: Arial; font-size: 8 pt"></td>
                  </tr>
                </table>
                <p align="center"> <font face="Arial"> 
                  <input name="Enviar" type="submit" id="enviar" value="Enviar" style="font-family: arial; font-size: 8 pt">
                  <input name="limpar" type="reset" id="limpar" value="Limpar" style="font-family: arial; font-size: 8 pt">
                  </font> 
                  <input type="hidden" name="MM_insert" value="formulario">
                </form>
              <p style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">
              <p align="center" style="word-spacing: 0; line-height: 100%;"><font color="#205CA5" face="arial"><font color="#336699" size="1" face="arial black"><br>
                </font></font><br>
                <br>
                <br>
            </td>
            <td vAlign="bottom" width="14" height="776"><img alt border="0" height="1" src="principal/img/vazio.gif" width="10"></td>
            <td align="right" vAlign="top" width="139" bgcolor="#93BEE2">
              <p><br>
              <img border="0" src="principal/img/rc_pesquisa.gif" width="150" height="15">
                <!-- Iniciar Enquete -->
<br>
<script language="javascript">
<!--
function Abrir()
{
window.open("http://www.perguntando.com.br/cgi-bin/pergunta.cgi?modo=relatorio&id=0060807","resp","resizable=no,toolbar=no,status=no,menubar=no,scrollbars=no,width=482,height=285");
}
//-->
</script>
<table border=0 bgcolor="#205CA5"><td bgcolor="#000000"> 
<table width="150" cellpadding=2 cellspacing=3 border=0 bgcolor="#FFFFFF"> 
<tr><td width="150" colspan=2> 
<font face="arial" size=1 color=#205CA5><B>Qual � o seu maior receio no
atendimento odontol�gico?
</b></font>
<font face="verdana" size=-1 color=#000000><B> 
<form action="http://www.perguntando.com.br/cgi-bin/pergunta.cgi" onSubmit=Abrir() target="resp">
<input type=hidden name=id value=0060807>
<input type=hidden name=modo value=resposta>
</b></font>
</td></tr>
<tr valign=middle><td width="25">
<input type="radio" name="resp" value="r1" checked> 
</td><td width="125"><font face="Arial" size="1" color="#205CA5">Acidentes</font>  
</td></tr>
<tr valign=middle><td width="25">
<input type="radio" name="resp" value="r2"> 
</td><td width="125"><font size="1" face="Arial" color="#205CA5">Alta-rota�ao (motorzinho)</font> 
</td></tr>
<tr valign=middle><td width="25">
<input type="radio" name="resp" value="r3"> 
</td><td width="125"><font size="1" face="Arial" color="#205CA5">Anestesia</font> 
</td></tr>
<tr valign=middle><td width="25">
<input type="radio" name="resp" value="r4"> 
</td><td width="125"><font size="1" face="Arial" color="#205CA5">Dor</font> 
</td></tr>
<tr valign=middle><td width="25">
<input type="radio" name="resp" value="r5"> 
</td><td width="125"><font size="1" face="Arial" color="#205CA5">N�o tenho receio</font> 
</td></tr>
<tr valign=middle><td width="150" colspan=2><center> 
<input type=image onClick="submit" 
src="http://www.perguntando.com.br/botao.jpg" onMouseOver="src='http://www.perguntando.com.br/botaob.jpg'" 
onMouseOut="src='http://www.perguntando.com.br/botao.jpg'" alt=Responder border=1 width=55 height=20>
<br>
<a href="Javascript:Abrir()"><font face="Arial" size="1" color="#205CA5">Resultado Parcial</font><font face="verdana" size=-2 color=#000000><BR></font></a>
    </center>
</td></tr></table></td></table></form>
<!-- Fim Enquete -->
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p><a href="recomende.htm"><br>
              </a></p>
              <p>&nbsp;</p>
              <p>&nbsp;
              <p>&nbsp;
              <p>&nbsp;
              <p><br>
              <br>
              <br>
              <p>&nbsp;
              <p>&nbsp;
              <p>&nbsp;
              <p><br>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p> 
                  <br>
                  <br>
            </td>
          </tr>
        </tbody>
      </table>
    </td>
  </tr>
  <tr>
    <td bgColor="#93BEE2" vAlign="top" width="152">&nbsp;</td>
    <td vAlign="top" width="460"><img height="3" src="principal/img/vazio.gif" width="15">
      <table align="center" border="0" cellPadding="0" cellSpacing="0">
        <tbody>
          <tr>
            <td class="um">
              <p align="center"><font size="1" face="Arial"><font color="#205CA5"><a href="mailto:ioff@ioff.com.br">�
              </a>
              </font><a href="mailto:ioff@ioff.com.br"><font color="#205CA5">INSTITU</font>TO
              DE ODONTOLOGIA F<u>RUJ<font color="#205CA5">ERI &amp; FRUJERI</font></u></a>
              - Todos os direitos reservados<br>
              <br>
              &lt; WEB DESIGNER - <a href="mailto:felipe.frujeri@pop.com.br">Felipe
              Frujeri</a> &gt;</font></p>
            </td>
          </tr>
        </tbody>
      </table>
    </td>
    <td vAlign="top" width="19" bgcolor="#93BEE2">&nbsp;</td>
    <td vAlign="top" width="153" bgcolor="#93BEE2">&nbsp;</td>
  </tr>
  </tbody>
  
</table>
</body>

    </html>
<%
registro.Close()
Set registro = Nothing
%>


<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - CSS
:Requires: db2html-footnote db2html-callout db2html-qanda gettext theme-colors theme-icons theme-html

REMARK: Describe this module
-->


<!--@@==========================================================================
db2html.css.file
The file to output CSS to

This parameter allows you to output the CSS to separate file which is referenced
by each HTML file.  If this parameter is blank, then the CSS is embedded inside
a #{style} tag in the HTML instead.
-->
<xsl:param name="db2html.css.file" select="''"/>


<!--**==========================================================================
db2html.css
Outputs the CSS that controls the appearance of the entire document
$css_file: Whether to create a CSS file when @{db2html.css.file} is set.

This template outputs a #{style} or #{link} tag and calls *{db2html.css.content}
to output the actual CSS directives.  An external CSS file will only be created
when ${css_file} is true.  This is only set to true by the top-level chunk to
avoid creating the same file multiple times.
-->
<xsl:template name="db2html.css">
  <xsl:param name="css_file" select="false()"/>
  <xsl:choose>
    <xsl:when test="$db2html.css.file != ''">
      <xsl:if test="$css_file">
        <exsl:document href="{$db2html.css.file}" method="text">
          <xsl:call-template name="db2html.css.content"/>
        </exsl:document>
      </xsl:if>
      <link rel="stylesheet" type="text/css" href="{$db2html.css.file}"/>
    </xsl:when>
    <xsl:otherwise>
      <style type="text/css">
        <xsl:call-template name="db2html.css.content"/>
      </style>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db2html.css.content
Outputs the actual CSS directives

This template is called by *{db2html.css} to output CSS content.  It also calls
templates from other modules to output CSS specific to the content addressed in
those modules.

This template calls *{db2html.css.custom} at the end.  That template may be used
by extension stylesheets to extend or override the CSS.
-->
<xsl:template name="db2html.css.content">
  <xsl:variable name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:variable>
  <xsl:variable name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="theme.html.css"/>
  <xsl:text>
<!-- == common == -->
sub { font-size: 0.83em; }
sub sub { font-size: 1em; }
sup { font-size: 0.83em; }
sup sup { font-size: 1em; }
table.table-pgwide { width: 100%; }


td.td-colsep { border-</xsl:text><xsl:value-of select="$right"/><xsl:text>: solid 1px; }
td.td-rowsep { border-bottom: solid 1px; }
thead { border-top: solid 2px; border-bottom: solid 2px; }
tfoot { border-top: solid 2px; border-bottom: solid 2px; }

/*
.block { margin-top: 1em; }
.block .block-first { margin-top: 0; }
*/
.block-indent {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text> left: 1.72em;
  margin-</xsl:text><xsl:value-of select="right"/><xsl:text>: 1em;
}
.block-indent .block-indent { margin-left: 0em; margin-right: 0em; }
td .block-indent  { margin-left: 0em; margin-right: 0em; }
dd .block-indent  { margin-left: 0em; margin-right: 0em; }
.block-verbatim { white-space: pre; }
div.title {
  margin-bottom: 0.2em;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.title-formal { padding-left: 0.2em; padding-right: 0.2em; }
div.title-formal .label { font-weight: normal; }

<!-- == linktrail == -->
ul.linktrail {
  display: block;
  margin: 0.2em 0 0 0;
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
}
li.linktrail { display: inline; margin: 0; padding: 0; }
<!-- FIXME: rtl? -->
li.linktrail::before {
  content: '&#x00A0; /&#x00A0;&#x00A0;';
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
<!-- FIXME: rtl? -->
li.linktrail-first::before, li.linktrail-only::before { content: ''; }

<!-- == navbar == -->
div.navbar {
 margin: 1em 0 1em 0;
  padding: 0.5em 1em 0.5em 1em;
  clear: both;
  background-color: </xsl:text><xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.head div.navbar:first-child { margin-top: 0; }
div.navbar img { border: 0; vertical-align: -0.4em; }
table.navbar { width: 100%; margin: 0; border: none; }
table.navbar td { padding: 0; border: none; }
td.navbar-next {
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
}
a.navbar-prev::before {
  <!-- FIXME: rtl -->
  content: '</xsl:text><xsl:choose>
  <xsl:when test="$left = 'left'"><xsl:text>&#x25C0;&#x00A0;&#x00A0;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>&#x25B6;&#x00A0;&#x00A0;</xsl:text></xsl:otherwise>
  </xsl:choose><xsl:text>';
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
a.navbar-next::after {
  <!-- FIXME: rtl -->
  content: '</xsl:text><xsl:choose>
  <xsl:when test="$left = 'left'"><xsl:text>&#x00A0;&#x00A0;&#x25B6;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>&#x00A0;&#x00A0;&#x25C0;</xsl:text></xsl:otherwise>
  </xsl:choose><xsl:text>';
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}

div.sidenav {
  padding: 0.5em 1em 0 1em;
  background-color: </xsl:text><xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.sidenav div.autotoc {
  background-color: </xsl:text><xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: none; padding: 0; margin: 0;
}
div.sidenav div.autotoc div.autotoc { margin-top: 0.5em; }
div.sidenav div.autotoc li { margin-bottom: 0.5em; }
div.sidenav div.autotoc div.autotoc div.autotoc {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
  margin-top: 0;
}
div.sidenav div.autotoc div.autotoc div.autotoc li { margin-bottom: 0; }

<!-- == autotoc == -->
div.autotoc {
  <!-- FIXME: hack -->
  display: table;
  margin-top: 1em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
  padding: 0.5em 1em 0.5em 1em;
  background-color: </xsl:text><xsl:value-of select="$theme.color.blue_background"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$theme.color.blue_border"/><xsl:text>;
}
div.autotoc ul { margin: 0; padding: 0; }
div.autotoc li { list-style-type: none; margin: 0; }
div.autotoc div.autotoc-title { margin-bottom: 0.5em; }
div.autotoc div.autotoc { border: none; padding: 0; margin-top: 0; margin-bottom: 0.5em; }
div.autotoc div.autotoc div.autotoc { margin-bottom: 0; }

<!-- == bibliography == -->
span.bibliolabel {
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}

<!-- == block == -->
div.epigraph {
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 20%;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 0;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.programlisting .userinput {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}


<!-- == unsorted == -->
dl.index dt { margin-top: 0; }
dl.index dd { margin-top: 0; margin-bottom: 0; }
dl.indexdiv dt { margin-top: 0; }
dl.indexdiv dd { margin-top: 0; margin-bottom: 0; }
dl.setindex dt { margin-top: 0; }
dl.setindex dd { margin-top: 0; margin-bottom: 0; }
div.simplelist {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
}
div.simplelist table { margin-left: 0; border: none; }
div.simplelist td {
  padding: 0.5em;
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
/*
div.simplelist td.td-first {
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
}
*/

span.accel { text-decoration: underline; }
span.acronym { font-family: sans-serif; }
span.application { font-style: italic; }
span.classname, span.exceptionname, span.interfacename { font-family: monospace; }
span.code {
  font-family: monospace;
  border: solid 1px </xsl:text><xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  padding-left: 0.2em;
  padding-right: 0.2em;
}
pre span.code { border: none; padding: 0; }
span.command {
  font-family: monospace;
  border: solid 1px </xsl:text><xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  padding-left: 0.2em;
  padding-right: 0.2em;
}
pre span.command { border: none; padding: 0; }
span.computeroutput { font-family: monospace; }
<!-- FIXME: stderr red text -->
span.constant { font-family: monospace; }
span.database { font-family: monospace; }
span.email { font-family: monospace; }
span.emphasis { font-style: italic; }
span.emphasis-bold { font-style: normal; font-weight: bold; }
span.envar { font-family: monospace; }
<!-- FIXME: error* red text -->
span.filename { font-family: monospace; }
span.firstterm { font-style: italic; }
span.foreignphrase { font-style: italic; }
span.function { font-family: monospace; }

dt.glossterm span.glossterm { font-style: normal; }
<!--
dt.glossterm { margin-left: 0em; }
dd + dt.glossterm { margin-top: 2em; }
dd.glossdef, dd.glosssee, dd.glossseealso { margin-top: 0em;  margin-bottom: 0; }
-->

span.glossterm { font-style: italic; }

span.guibutton, span.guilabel, span.guimenu, span.guimenuitem, span.guisubmenu, span.interface {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
span.keycap {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
span.lineannotation { font-style: italic; }
span.literal { font-family: monospace; }
span.markup  { font-family: monospace; }
span.medialabel { font-style: italic; }
span.methodname { font-family: monospace; }
span.ooclass, span.ooexception, span.oointerface { font-family: monospace; }
span.option { font-family: monospace; }
span.parameter { font-family: monospace; }
span.paramdef span.parameter { font-style: italic; }
span.prompt { font-family: monospace; }
span.property { font-family: monospace; }
span.replaceable  { font-style: italic; }
span.returnvalue { font-family: monospace; }
span.sgmltag { font-family: monospace; }
span.structfield, span.structname { font-family: monospace; }
span.symbol { font-family: monospace; }
span.systemitem { font-family: monospace; }
span.token { font-family: monospace; }
span.type { font-family: monospace; }
span.uri { font-family: monospace; }
span.userinput { font-family: monospace; }
span.varname { font-family: monospace; }
span.wordasword { font-style: italic; }
<!-- FIXME below -->

</xsl:text>
  <xsl:call-template name="db2html.footnote.css"/>
  <xsl:call-template name="db2html.callout.css"/>
  <xsl:call-template name="db2html.qanda.css"/>
<xsl:call-template name="db2html.css.custom"/>
</xsl:template>


<!--**==========================================================================
db2html.css.custom
Allows extension stylesheets to extend or override CSS
:Stub: true

This stub template has no content.  Extension stylesheets can override this
template to output extra CSS.
-->
<xsl:template name="db2html.css.custom"/>

</xsl:stylesheet>

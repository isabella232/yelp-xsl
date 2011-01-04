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
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:msg="http://projects.gnome.org/yelp/gettext/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal msg"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Blocks
Handle simple Mallard block elements.
:Revision:version="1.0" date="2010-06-03" status="final"

This stylesheet contains templates for handling most Mallard block elements,
except the list and table elements.
-->


<!--**==========================================================================
mal2html.pre
Output an HTML #{pre} element.
:Revision:version="1.0" date="2010-06-03" status="final"
$node: The source element to output a #{pre} for.

This template outputs an HTML #{pre} element along with a wrapper #{div} element
for CSS styling. It should be called for verbatim block elements. It will
automatically strip leading and trailing newlines using *{utils.strip_newlines}.
-->
<xsl:template name="mal2html.pre">
  <xsl:param name="node" select="."/>
  <xsl:param name="numbered" select="contains(concat(' ', @style, ' '), 'numbered')"/>
  <xsl:variable name="first" select="$node/node()[1]/self::text()"/>
  <xsl:variable name="last" select="$node/node()[last()]/self::text()"/>
  <div>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
    </xsl:attribute>
    <xsl:if test="$numbered">
      <pre class="numbered"><xsl:call-template name="utils.linenumbering">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template></pre>
    </xsl:if>
    <pre>
      <xsl:attribute name="class">
        <xsl:text>contents </xsl:text>
        <xsl:if test="$html.syntax.highlight and $node/@mime">
          <xsl:choose>
            <xsl:when test="@mime = 'application/x-shellscript'">
              <xsl:text>syntax brush-bash-script</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-csrc' or @mime = 'text/x-chdr' or
                            @mime = 'text/x-c++hdr' or @mime = 'text/x-c++src' or
                            @mime = 'text/x-objcsrc'">
              <xsl:text>syntax brush-clang</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-csharp'">
              <xsl:text>syntax brush-csharp</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/css'">
              <xsl:text>syntax brush-css</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-patch'">
              <xsl:text>syntax brush-diff</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/html' or @mime = 'application/xml' or
                            substring(@mime, string-length(@mime) - 3) = '+xml'">
              <xsl:text>syntax brush-html</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-java'">
              <xsl:text>syntax brush-java</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'application/javascript'">
              <xsl:text>syntax brush-javascript</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-scheme' or @mime = 'text/x-emacs-lisp'">
              <xsl:text>syntax brush-lisp</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-lua'">
              <xsl:text>syntax brush-lua</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-pascal'">
              <xsl:text>syntax brush-pascal</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'application/x-perl'">
              <xsl:text>syntax brush-perl5</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'application/x-php'">
              <xsl:text>syntax brush-php-script</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-python'">
              <xsl:text>syntax brush-python</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'application/x-ruby'">
              <xsl:text>syntax brush-ruby</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'text/x-sql'">
              <xsl:text>syntax brush-sql</xsl:text>
            </xsl:when>
            <xsl:when test="@mime = 'application/x-yaml'">
              <xsl:text>syntax brush-yaml</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:attribute>
      <xsl:if test="$first">
        <xsl:call-template name="utils.strip_newlines">
          <xsl:with-param name="string" select="$first"/>
          <xsl:with-param name="leading" select="true()"/>
          <xsl:with-param name="trailing" select="count(node()) = 1"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode"
                           select="node()[not(self::text() and (position() = 1 or position() = last()))]"/>
      <xsl:if test="$last and (count(node()) != 1)">
        <xsl:call-template name="utils.strip_newlines">
          <xsl:with-param name="string" select="$last"/>
          <xsl:with-param name="leading" select="false()"/>
          <xsl:with-param name="trailing" select="true()"/>
        </xsl:call-template>
      </xsl:if>
    </pre>
  </div>
</xsl:template>


<!--%%==========================================================================
mal2html.block.mode
Process Mallard elements in block mode.
:Revision:version="1.0" date="2010-06-03" status="final"
$restricted: Whether this is restricted block mode.

This mode is applied to elements in block context. It should be called by
templates for pages, sections, and block container elements. Certain elements
may appear in both block an inline mode, and the processing expectations for
those elements is different depending on context.

Implementations of this mode should generally output a wrapper div and process
the child elements, either in %{mal2html.block.mode} or %{mal2html.inline.mode},
or using special processing for particular content models.

When this mode encounters unknown content, templates in the same mode are
applied to the children, but the ${restricted} parameter is set to #{true}.
When ${restricted} is #{true}, unknown block elements are ignored. This is
in accordance with the Mallard specification on fallback block content.
-->
<xsl:template mode="mal2html.block.mode" match="*">
  <xsl:param name="restricted" select="false()"/>
  <xsl:if test="not($restricted)">
    <xsl:message>
      <xsl:text>Unmatched block element: </xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:message>
    <xsl:apply-templates mode="mal2html.block.mode">
      <xsl:with-param name="restricted" select="true()"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal2html.block.mode" match="text()"/>


<!-- = desc = -->
<xsl:template mode="mal2html.block.mode" match="mal:desc">
  <div class="desc">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<!-- = code = -->
<xsl:template mode="mal2html.block.mode" match="mal:code">
  <xsl:call-template name="mal2html.pre"/>
</xsl:template>

<!-- = comment = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment">
  <xsl:if test="$mal2html.editor_mode
                or processing-instruction('mal2html.show_comment')">
    <div class="comment">
      <xsl:call-template name="html.lang.attrs"/>
      <div class="inner">
        <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
        <xsl:apply-templates mode="mal2html.block.mode" select="mal:cite"/>
        <div class="contents">
          <xsl:for-each select="*[not(self::mal:title or self::mal:cite)]">
            <xsl:apply-templates mode="mal2html.block.mode" select="."/>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:if>
</xsl:template>

<!-- = comment/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:cite">
  <div class="cite cite-comment">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:choose>
      <xsl:when test="@date">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'comment.cite.name-date.format'"/>
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="format" select="true()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'comment.cite.name.format'"/>
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="format" select="true()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:comment.name">
  <xsl:param name="node"/>
  <xsl:choose>
    <xsl:when test="$node/@href">
      <a href="{$node/@href}">
        <xsl:apply-templates mode="mal2html.inline.mode" select="$node/node()"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="mal2html.inline.mode" select="$node/node()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:comment.date">
  <xsl:param name="node"/>
  <xsl:value-of select="$node/@date"/>
</xsl:template>

<!-- = example = -->
<xsl:template mode="mal2html.block.mode" match="mal:example">
  <div class="example">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = figure = -->
<xsl:template mode="mal2html.block.mode" match="mal:figure">
  <div class="figure">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <a href="#" class="zoom">
        <xsl:attribute name="data-zoom-in-title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'View images at normal size'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="data-zoom-out-title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'Scale images down'"/>
          </xsl:call-template>
        </xsl:attribute>
      </a>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
    </div>
  </div>
</xsl:template>

<!-- = listing = -->
<xsl:template mode="mal2html.block.mode" match="mal:listing">
  <div class="listing">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = note = -->
<xsl:template mode="mal2html.block.mode" match="mal:note">
  <xsl:variable name="notestyle">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @style, ' '), ' advanced ')">
        <xsl:text>advanced</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' bug ')">
        <xsl:text>bug</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' important ')">
        <xsl:text>important</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' sidebar ')">
        <xsl:text>sidebar</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' tip ')">
        <xsl:text>tip</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' warning ')">
        <xsl:text>warning</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="class">
      <xsl:text>note</xsl:text>
      <xsl:if test="normalize-space($notestyle) != ''">
        <xsl:value-of select="concat(' note-', $notestyle)"/>
      </xsl:if>
    </xsl:attribute>
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <div class="contents">
        <xsl:apply-templates mode="mal2html.block.mode" select="*[not(self::mal:title)]"/>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = info = -->
<xsl:template mode="mal2html.block.mode" match="mal:info"/>

<!-- = p = -->
<xsl:template mode="mal2html.block.mode" match="mal:p">
  <p class="p">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </p>
</xsl:template>

<!-- = quote = -->
<xsl:template mode="mal2html.block.mode" match="mal:quote">
  <div class="quote">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <blockquote class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:cite)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </blockquote>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:cite"/>
    </div>
  </div>
</xsl:template>

<!-- = quote/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:quote/mal:cite">
  <div class="cite cite-quote">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:apply-templates mode="mal2html.inline.mode"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mal2html.inline.mode"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- FIXME: i18n -->
    <xsl:if test="@date">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@date"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </div>
</xsl:template>

<!-- = screen = -->
<xsl:template mode="mal2html.block.mode" match="mal:screen">
  <xsl:call-template name="mal2html.pre"/>
</xsl:template>

<!-- = synopsis = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis">
  <div class="synopsis">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.block.mode" match="mal:title">
  <div class="title title-{local-name(..)}">
    <xsl:call-template name="html.lang.attrs"/>
    <span class="title">
      <xsl:apply-templates mode="mal2html.inline.mode"/>
    </span>
  </div>
</xsl:template>

</xsl:stylesheet>

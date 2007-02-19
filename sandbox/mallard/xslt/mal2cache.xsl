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

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:mal='http://www.gnome.org/~shaunm/mallard'
                xmlns='http://www.gnome.org/~shaunm/mallard'
                version='1.0'>

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match='/mal:cache'>
  <cache>
    <xsl:for-each select="mal:page">
      <xsl:apply-templates select="document(@href)/*">
        <xsl:with-param name="href" select="@href"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </cache>
</xsl:template>

<xsl:template match="mal:topic">
  <xsl:param name="href"/>
  <topic>
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:value-of select="$href"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </topic>
</xsl:template>

<xsl:template match="mal:guide">
  <xsl:param name="href"/>
  <guide>
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:value-of select="$href"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </guide>
</xsl:template>

<xsl:template match="mal:section">
  <section>
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
  </section>
</xsl:template>

<xsl:template match="mal:title">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="mal:info">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="node() | text()"/>

</xsl:stylesheet>

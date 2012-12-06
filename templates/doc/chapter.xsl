<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <!-- WRAPPER -->
      <xsl:import href="../wrapper.xsl"/>
      <xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
      <xsl:template name="content"><xsl:apply-templates/></xsl:template>
      
   <!-- Where am I relative to the root. Lets mirrors host this in subfolders -->
      <xsl:variable name="docroot" select="'../../../..'"/>

   <!-- Title -->
      <xsl:variable name="html.head.title" select="concat(/chapter/chapter_id,'. ',/chapter/title)"/>

   <xsl:variable name="html.head.append">

      <!-- CSS -->
         <link rel="stylesheet" type="text/css" href="{$staticroot}/doc/chapter.css"/>

      <!-- Canonical -->
         <link rel="canonical" href="{/chapter/canonical_url}"/>

   </xsl:variable>
 
   <!-- JavaScript -->
      <xsl:variable name="html.body.append">
         <script type="text/javascript" src="{$staticroot}/doc/chapter.js"/>
      </xsl:variable>

   <!-- Table of Contents -->
      <xsl:variable name="html.body.outer.append">
         <div id="toc">
            <ul class="hidden"/>
            <img src="{$staticroot}/doc/contents.png" width="16" height="155"/>
         </div>
      </xsl:variable>

   <!-- CONTENT -->
      <xsl:template match="/chapter">

         <!-- Navigation -->
         <a class="previous_page" href="{prev_url}"><![CDATA[<-previous]]></a>
         <xsl:if test="next_url">
            <a class="next_page"  href="{next_url}"><![CDATA[next->]]></a>
         </xsl:if>

         <!-- Chapter Wrapper -->
         <div id="chapter" class="chapter{@class}">

            <xsl:if test="current_url">
               <p id="old_version_warning">
                  <span class="closebar"><a href="#" title="Close">X</a></span>
                  <strong>WARNING:</strong>
                  <xsl:text> This documentation is for an old version of Exim (</xsl:text>
                  <a href="{current_url}">latest</a>
                  <xsl:text>)</xsl:text>
               </p>
            </xsl:if>

            <!-- Chapter Title -->
            <h2 id="{@id}" class="{@class}">
               <a href="{this_url}">
                  <xsl:value-of select="concat('Chapter ',chapter_id,' - ',title)"/>
               </a>
            </h2>

            <!-- Chapter Info -->
               <xsl:apply-templates select="*[name()!='section']"/>
               <xsl:apply-templates select="section"/>
         </div>

         <!-- Navigation -->
            <a class="previous_page" href="{prev_url}"><![CDATA[<-previous]]></a>
            <a class="toc_page"      href="{toc_url}"><![CDATA[Table of Contents]]></a>
            <xsl:if test="next_url">
               <a class="next_page"  href="{next_url}"><![CDATA[next->]]></a>
            </xsl:if>

      </xsl:template>

   <!-- Section -->
      <xsl:template match="/chapter/section">
         <!-- Section Wrapper -->
         <div class="section{@class}">

            <!-- Section Title -->
            <xsl:choose>
               <xsl:when test="@class='index'">
                  <h3 id="{@id}" class="{@class}">
                     <xsl:value-of select="title"/>
                  </h3>
               </xsl:when>
               <xsl:otherwise>
                  <h3 id="{@id}" class="{@class}">
                     <xsl:value-of select="concat(position(),'. ',title)"/>
                  </h3>
               </xsl:otherwise>
            </xsl:choose>

            <!-- Section Paragraphs -->
            <xsl:apply-templates select="*"/>
         </div>
      </xsl:template>

   <!-- Section paragraph -->
      <xsl:template match="/chapter/section/para">
         <p>
            <xsl:if test="@revisionflag!=''"><xsl:attribute name="class">changed</xsl:attribute></xsl:if>
            <xsl:apply-templates/>
         </p>
      </xsl:template>

   <!-- Ignore -->
      <xsl:template match="chapter_id|this_url|prev_url|next_url|toc_url|canonical_url|current_url|title_uri|old_versions"/>

</xsl:stylesheet>

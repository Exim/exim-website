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
         <link rel="stylesheet" type="text/css" href="{$docroot}/doc/chapter.css"/>

      <!-- Canonical -->
         <link rel="canonical" href="{/chapter/canonical_url}"/>

   </xsl:variable>
 
   <!-- JavaScript -->
      <xsl:variable name="html.body.append">
         <script type="text/javascript" src="{$docroot}/doc/chapter.js"/>
      </xsl:variable>

   <!-- Table of Contents -->
      <xsl:variable name="html.body.outer.append">
         <div id="toc">
            <ul class="hidden"/>
            <img src="../../../../doc/contents.png" width="16" height="155"/>
         </div>
      </xsl:variable>

   <!-- CONTENT -->
      <xsl:template match="/chapter">

         <!-- Navigation -->
           <a class="previous_page" href="{prev_url}"><![CDATA[<-previous]]></a>
           <a class="next_page"     href="{next_url}"><![CDATA[next->]]></a>

         <!-- Chapter Title -->
            <h2 id="{@id}" class="{@class}">
               <xsl:value-of select="concat('Chapter ',chapter_id,' - ',title)"/>
            </h2>

         <!-- Chapter Info -->
            <div id="chapter" class="chapter{@class}">
               <xsl:apply-templates select="*[name()!='section']"/>
               <xsl:apply-templates select="section"/>
            </div>

         <!-- Navigation -->
            <a class="previous_page" href="{prev_url}"><![CDATA[<-previous]]></a>
            <a class="next_page"     href="{next_url}"><![CDATA[next->]]></a>

      </xsl:template>

   <!-- Section -->
      <xsl:template match="/chapter/section">

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
         <div class="section{@class}">
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
      <xsl:template match="chapter_id|prev_url|next_url|canonical_url"/>

</xsl:stylesheet>

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

   <!-- CONTENT -->
      <xsl:template match="/chapter">

         <!-- Navigation -->
           <a class="previous_page" href="{prev_url}"><![CDATA[<-previous]]></a>
           <a class="next_page"     href="{next_url}"><![CDATA[next->]]></a>

         <!-- Chapter Title -->
            <h2>
               <xsl:value-of select="concat('Chapter ',chapter_id,' - ',title)"/>
            </h2>

         <!-- Chapter Info -->
            <div id="chapter">
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
            <h3 id="{@id}">
               <xsl:value-of select="concat(position(),'. ',title)"/>
            </h3>

         <!-- Section Paragraphs -->
            <xsl:apply-templates select="*"/>
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

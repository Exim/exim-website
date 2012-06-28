<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <!-- WRAPPER -->
      <xsl:import href="../wrapper.xsl"/>
      <xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
      <xsl:template name="content"><xsl:apply-templates/></xsl:template>
      
   <!-- Where am I relative to the root. Lets mirrors host this in subfolders -->
      <xsl:variable name="docroot" select="'../../../..'"/>

   <!-- Title -->
      <xsl:variable name="html.head.title" select="/book/bookinfo/title"/>

   <xsl:variable name="html.head.append">

      <!-- CSS -->
         <link rel="stylesheet" type="text/css" href="{$staticroot}/doc/index.css"/>

      <!-- Canonical -->
         <link rel="canonical" href="{/book/canonical_url}"/>

   </xsl:variable>
 
   <!-- JavaScript -->
      <xsl:variable name="html.body.append">
         <script type="text/javascript" src="{$staticroot}/doc/index.js"/>
      </xsl:variable>

   <!-- CONTENT -->
      <xsl:template match="/book">
         <xsl:if test="current_url">
            <p id="old_version_warning">
               <strong>WARNING:</strong>
	       <xsl:text> This documentation is for an old version of Exim (</xsl:text>
	       <a href="{current_url}">latest</a>
               <xsl:text>)</xsl:text>
            </p>
         </xsl:if>
         <div id="info">
            <xsl:apply-templates select="bookinfo"/>
         </div>
         <div id="options" class="hidden">
            <img src="{$docroot}/doc/plus-12x12.png"  width="12" height="12" class="expand"/>
            <img src="{$docroot}/doc/minus-12x12.png" width="12" height="12" class="collapse"/>
	    <xsl:text>Expand/Collapse all Chapters</xsl:text>
         </div>
         <div id="index">
            <ul id="chapters">
               <xsl:apply-templates select="chapter"/>
            </ul>
         </div>
      </xsl:template>

   <!-- Info -->
      <xsl:template match="/book/bookinfo">
         <h2>
            <xsl:apply-templates select="title"/>
         </h2>
         <p>
            <xsl:text>Copyright</xsl:text>
            <xsl:value-of select="concat(' © ',copyright/year)"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="copyright/holder"/><br/>
            <xsl:text>Revision </xsl:text>
            <xsl:apply-templates select="revhistory/revision/revnumber"/>
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="revhistory/revision/date"/>
         </p>
      </xsl:template>

   <!-- Chapter -->
      <xsl:template match="/book/chapter">

         <!-- Calculate the URL to the chapter. Store in $chapter_url -->
            <xsl:variable name="chapter_url">
               <xsl:choose>
                  <xsl:when test="position()&lt;10">
                     <xsl:value-of select="concat(/book/prepend_chapter,'ch',0,position(),'.html')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat(/book/prepend_chapter,'ch',position(),'.html')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

         <!-- Chapter info -->
            <li class="chapter">
               <xsl:if test="section">
                  <div class="button"/>
               </xsl:if>

               <span class="chapter_title">
                  <xsl:if test="not(section)">
                     <xsl:attribute name="class">chapter_title nosub</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="concat(position(),'. ')"/>
                  <a href="{$chapter_url}">
                     <xsl:apply-templates select="title"/>
                  </a>
               </span>

               <xsl:if test="section">
                  <ul class="sections">
                     <xsl:apply-templates select="section">
                        <xsl:with-param name="chapter_url" select="$chapter_url"/>
                     </xsl:apply-templates>
                  </ul>
               </xsl:if>
            </li>
      </xsl:template>

   <!-- Section -->
      <xsl:template match="/book/chapter/section">
         <xsl:param name="chapter_url"/>
         <li class="section">
            <xsl:value-of select="concat(position(),'. ')"/>
            <a class="section_title" href="{$chapter_url}#{@id}">
               <xsl:apply-templates select="title"/>
            </a>
         </li>
      </xsl:template>

   <!-- Chapter/Section Title -->
      <xsl:template match="title|chapter/title|section/title">
         <xsl:apply-templates/>
      </xsl:template>

</xsl:stylesheet>

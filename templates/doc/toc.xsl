<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <!-- Define display/content information -->
      <xsl:output indent="no"/>
      <xsl:output encoding="UTF-8"/>
      <xsl:output media-type="text/xml"/>
      <xsl:output omit-xml-declaration="no"/>
   
   <!-- CONTENT -->
      <xsl:template match="/">
         <toc>
            <xsl:apply-templates select="book/chapter"/>
         </toc>
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
            <c>
               <u>
                  <xsl:value-of select="$chapter_url"/>
               </u>
               <t>
                     <xsl:apply-templates select="title"/>
               </t>
            </c>
      </xsl:template>

   <!-- Chapter/Section Title -->
      <xsl:template match="title|chapter/title">
         <xsl:apply-templates/>
      </xsl:template>

</xsl:stylesheet>

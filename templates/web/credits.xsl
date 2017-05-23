<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
		
		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Credits'"/>

	<!-- Canonical -->
		<xsl:variable name="html.head.append">
			<link rel="canonical" href="http://www.exim.org/credits.html"/>
		</xsl:variable>

	<!-- CONTENT -->
		<xsl:template name="content">

			<!-- Title -->
				<h2>
					<xsl:value-of select="$html.head.title"/>
				</h2>

         <!-- Website Credits -->
         <h3>Website Credits</h3>
            <ul>
               <li>
                  <xsl:text>Nigel Metheringham</xsl:text>
                  <p>Built/maintains the website.</p>
               </li>
               <li>
                  <a href="https://grepular.com/">Mike Cardwell</a>, of <a href="http://cardwellit.com/">Cardwell IT Ltd.</a>
                  <p>Redesigned and built the current layout/style of the website, in 2010.</p>
               </li>
               <li>
                  <xsl:text>Jennifer Greenley, of </xsl:text><a href="http://www.sharpblue.com/">Sharpblue</a>
                  <p>Designed the new Exim logo, in 2002.</p>
               </li>
            </ul>

         <!-- Software Credits -->
         <h3>Software Credits</h3>
            <ul>
               <li>
                  <xsl:text>Philip Hazel</xsl:text>
                  <p>Originally wrote, documented and supported Exim for many years prior to his retirement.</p>
               </li>
               <li>
                  <xsl:text>Exim Development Team</xsl:text>
                  <p>Currently continue with Exim development and support.  The team includes (although this is not an exhaustive list):-</p>
                  <ul>
                     <li>Alan Williams</li>
                     <li>David Woodhouse</li>
                     <li>Graeme Fowler</li>
                     <li>Heiko Schlittermann</li>
                     <li>Jeremy Harris</li>
                     <li>John Jetmore</li>
                     <li>Marc Haber</li>
                     <li>Mike Cardwell</li>
                     <li>Nigel Metheringham</li>
                     <li>Peter Bowyer</li>
                     <li>Phil Pennock</li>
                     <li>Tom Kistner</li>
                     <li>Tony Finch</li>
                     <li>Tony Sheen</li>
                  </ul>
               </li>
            </ul>

		</xsl:template>

</xsl:stylesheet>

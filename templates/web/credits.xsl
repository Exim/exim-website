<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
		
		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Website Credits'"/>

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

			<!-- Credits -->
				<ul>
					<li>
						<xsl:text>Nigel Metheringham</xsl:text>
						<p>Built/maintains the website.</p>
					</li>
					<li>
						<a href="https://secure.grepular.com/">Mike Cardwell</a>, of <a href="http://cardwellit.com/">Cardwell IT Ltd.</a>
						<p>Redesigned and built the current layout/style of the website, in 2010.</p>
					</li>
					<li>
						<xsl:text>Jennifer Greenley, of </xsl:text><a href="http://www.sharpblue.com/">Sharpblue</a>
						<p>Designed the new Exim logo, in 2002.</p>
					</li>
					<li>
						<a href="http://www.energis-squared.net/">Energis Squared</a><xsl:text> (formerly Planet Online)</xsl:text>
						<p>Provided the UK web site, the domain name registration and various other resources for the Exim community. Energis Squared also use Exim for their mail systems including systems with a userbase of several million users.</p>
					</li>
				</ul>

		</xsl:template>

</xsl:stylesheet>

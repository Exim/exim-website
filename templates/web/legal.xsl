<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- WRAPPER -->
	<xsl:import href="../wrapper.xsl"/>
	<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
	<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
	<xsl:variable name="html.head.title" select="'Legal'"/>

	<!-- Canonical -->
	<xsl:variable name="html.head.append">
	<link rel="canonical" href="https://www.exim.org/legal.html"/>
	</xsl:variable>

	<!-- CONTENT -->
	<xsl:template name="content">

	<!-- Title -->
	<h2><xsl:value-of select="$html.head.title"/></h2>

         <h3>Legal information</h3>
	 We, the Exim Maintainers, regard the domain to be owned by us as a
	 group.  However, due to the small size of the project and lack of
	 funding, the domain has to be nominally owned for registration purposes
	 by an individual.  As of 2022-11-22 this is
	 <a href="mailto:hs@schlittermann.de">Heiko Schlittermann</a>

	</xsl:template>
</xsl:stylesheet>

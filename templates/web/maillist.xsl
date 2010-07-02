<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
		
		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Mailing lists for Exim'"/>

        <!-- Canonical -->
                <xsl:variable name="html.head.append">
                        <link rel="canonical" href="http://www.exim.org/maillist.html"/>
                </xsl:variable>

	<!-- CONTENT -->
		<xsl:template name="content">

			<!-- Title -->
				<h2>
					<xsl:value-of select="$html.head.title"/>
				</h2>

			<!-- Lists -->
				<ul>
					<li>
						<a href="http://lists.exim.org/mailman/listinfo/exim-announce">exim-announce</a><br/>
						<xsl:text>A low volume moderated list consisting of announcements only of things of interest to Exim users (typically new releases). There is an </xsl:text>
						<a href="http://lists.exim.org/lurker/list/exim-announce.html">archive</a>
						<xsl:text> of messages since July 1999.</xsl:text>
					</li>
					<li>
						<a href="http://lists.exim.org/mailman/listinfo/exim-dev">exim-dev</a><br/>
						<xsl:text>A list dedicated to the ongoing development process for Exim. It is not the grown-up version of the users list. There are searchable </xsl:text>
						<a href="http://lists.exim.org/lurker/list/exim-dev.html">archives</a>
						<xsl:text> covering postings back to 2004.</xsl:text>
                                        </li>
                                        <li>
                                                <a href="http://lists.exim.org/mailman/listinfo/exim-users">exim-users</a><br/>
                                                <xsl:text>A discussion list about Exim covering use and development of the software. This also has a searchable </xsl:text>
						<a href="http://lists.exim.org/lurker/list/exim-users.html">archive</a>
						<xsl:text> covering postings back to 1996. Please have the courtesy to check the list before posting basic queries, the </xsl:text>
						<a href="{$docroot}/exim-html-4.40/doc/html/FAQ.html">FAQ</a>
						<xsl:text> also covers many things that get asked regularly on the list</xsl:text>
                                        </li>
                                        <li>
                                                <a href="http://lists.exim.org/mailman/listinfo/exim-future">exim-future</a><br/>
                                                <xsl:text>This list is intended for discussions of future development methodology and features aimed at Exim 5 onwards - i.e. anything that involves architectural changes. There are additionally some </xsl:text>
						<a href="http://wiki.exim.org/Exim5">wiki pages</a>
						<xsl:text> recording ideas as they get fleshed out (which may involve several alternatives).</xsl:text>
                                        </li>
				</ul>
		</xsl:template>

</xsl:stylesheet>

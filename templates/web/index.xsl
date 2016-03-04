<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
		
		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Exim Internet Mailer'"/>

	<xsl:variable name="html.head.append">

		<!-- CSS -->
			<link rel="stylesheet" type="text/css" href="{$staticroot}/css/index.css"/>

	        <!-- Canonical -->
                        <link rel="canonical" href="http://www.exim.org/"/>

	</xsl:variable>
 
	<!-- CONTENT -->
		<xsl:template name="content">

			<h2>Latest Version: <xsl:value-of select="/content/current_version"/></h2>

                <!-- Summary -->
			<p id="summary">
				<a href="http://www.exim.org/">
					<img src="i/exim-blue-ld-87x65.png" alt="Exim Logo" width="87" height="65"/>
				</a>
				<xsl:text>Exim is a message transfer agent (MTA) developed at the </xsl:text>
				<a href="http://www.cam.ac.uk/" title="University of Cambridge Home page">University of Cambridge</a>
				<xsl:text> for use on Unix systems connected to the Internet. It is freely available under the terms of the </xsl:text>
				<a href="http://www.gnu.org/licenses/gpl.html" title="GPL Information">GNU General Public Licence</a>
				<xsl:text>. In style it is similar to </xsl:text>
				<a href="http://freshmeat.net/projects/smail/" rel="nofollow">Smail 3</a>
				<xsl:text>, but its facilities are more general. There is a great deal of flexibility in the way mail can be routed, and there are extensive facilities for checking incoming mail. Exim can be installed in place of </xsl:text>
				<a href="http://www.sendmail.org/" title="Sendmail home page" rel="nofollow">Sendmail</a>
				<xsl:text>, although the configuration of Exim is quite different.</xsl:text>
			</p>

      <!-- Version Information -->
         <p id="obsolete_version_info">
            <xsl:text>All versions of Exim previous to version 4.x are now obsolete and everyone is very strongly recommended to upgrade to a current release. The last 3.x release was 3.36. It is obsolete and should not be used.</xsl:text>
         </p>

         <p id="version_info">
            <xsl:text>The current version is </xsl:text>
            <xsl:value-of select="/content/current_version"/>
	    This is a <b>security update</b>.  Please read <a href="static/doc/CVE-2016-1531.txt">CVE-2016-1531</a>
	    for more information.
         </p>

         <p id="beta_version_info">
            <xsl:text>There may be beta versions available from the ftp sites in the Testing directory. Many people are using these without problems, but they are not recommended unless you are willing to work with beta software.</xsl:text>
         </p>

                <!-- Book Information -->
                   
			<p id="book_info">
				<a href="http://www.uit.co.uk/exim-book">
					<img src="i/exim-book.png" width="74" height="100"/>
				</a>
				<xsl:text>You may wish to purchase </xsl:text>
				<a href="http://www.uit.co.uk/exim-book">The Exim SMTP Mail Server</a>
				<xsl:text> book, written by the original author of Exim, </xsl:text>
				<a href="http://en.wikipedia.org/wiki/Philip_Hazel">Philip Hazel</a>
				<xsl:text>. The table of contents, and a sample chapter can be viewed </xsl:text>
				<a href="http://www.uit.co.uk/BK-EOGR4/TOC">here</a>
				<xsl:text>.</xsl:text>
			</p>

		</xsl:template>

</xsl:stylesheet>

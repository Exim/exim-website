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
                        <link rel="canonical" href="https://www.exim.org/"/>

	</xsl:variable>
 
	<!-- CONTENT -->
		<xsl:template name="content">

			<h2>Latest Version: <xsl:value-of select="/content/current_version"/></h2>

                <!-- Summary -->
			<p id="summary">
				<a href="https://www.exim.org/">
					<img src="i/exim-blue-ld-87x65.png" alt="Exim Logo" width="87" height="65"/>
				</a>
				<xsl:text>Exim is a message transfer agent (MTA) developed at the </xsl:text>
				<a href="https://www.cam.ac.uk/" title="University of Cambridge Home page">University of Cambridge</a>
				<xsl:text> for use on Unix systems connected to the Internet. It is freely available under the terms of the </xsl:text>
				<a href="https://www.gnu.org/licenses/gpl.html" title="GPL Information">GNU General Public Licence</a>
				<xsl:text>. In style it is similar to </xsl:text>
				<a href="http://freecode.com/projects/smail/" rel="nofollow">Smail 3</a>
				<xsl:text>, but its facilities are more general. There is a great deal of flexibility in the way mail can be routed, and there are extensive facilities for checking incoming mail. Exim can be installed in place of </xsl:text>
				<a href="https://www.proofpoint.com/us/sendmail-open-source" title="Sendmail home page" rel="nofollow">Sendmail</a>
				<xsl:text>, although the configuration of Exim is quite different.</xsl:text>
			</p>

      <!-- Version Information -->
         <p id="obsolete_version_info">

            <xsl:text>All versions of Exim previous to version </xsl:text><xsl:value-of select="/content/current_version"/><xsl:text> are now obsolete. elease. The last 3.x release was 3.36. It is obsolete and should not be used.</xsl:text>

         </p>

         <p id="version_info">
            <xsl:text>The current version is </xsl:text>
            <xsl:value-of select="/content/current_version"/>
         </p>

	 <p> We fixed CVE-2017-16943 and CVE-2017-16944 with this release.
	 To address these two CVEs, please update to 4.89.1 or simply disable
	 the SMTP CHUNKING extension by using <code>chunking_advertise_hosts = </code> in the main configuration section.
	 </p>

         <p id="beta_version_info">
            <xsl:text>There may be beta versions available from the ftp sites in the Testing directory. Many people are using these without problems, but they are not recommended unless you are willing to work with beta software.</xsl:text>
         </p>

                <!-- Book Information -->
                   
			<p id="book_info">
				<a href="https://www.uit.co.uk/the-exim-smtp-mail-server">
					<img src="i/exim-book.png" width="74" height="100"/>
				</a>
				<xsl:text>You may wish to purchase </xsl:text>
				<a href="https://www.uit.co.uk/the-exim-smtp-mail-server">The Exim SMTP Mail Server</a>
				<xsl:text> book, written by the original author of Exim, </xsl:text>
				<a href="https://en.wikipedia.org/wiki/Philip_Hazel">Philip Hazel</a>
				<xsl:text>.</xsl:text>
			</p>

		</xsl:template>

</xsl:stylesheet>

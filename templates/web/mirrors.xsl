<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>

		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Download sites for Exim'"/>

        <!-- Canonical -->
                <xsl:variable name="html.head.append">
                        <link rel="canonical" href="https://www.exim.org/mirrors.html"/>
                </xsl:variable>

	<!-- CONTENT -->
		<xsl:template name="content">

			<!-- Title -->
				<h2>
					<xsl:value-of select="$html.head.title"/>
				</h2>



			<!-- General Mirror Info -->
				<p>
					<xsl:text>Exim is available from a number of FTP sites. It may also be supplied on some GNU CDs or with other software distributions. Further information on the binary and OS distributions can be found in the </xsl:text>
					<a href="https://wiki.exim.org/ObtainingExim">Exim Wiki.</a>
					If the mirrors do not work for you, you can download the tarballs from the
					<a href="https://ftp.exim.org/pub/exim/exim4/">origin.</a>.
					<xsl:text>.</xsl:text>
				</p>

            <h3>Exim Mirror Sites</h3>

            <p>A list of mirror sites is maintained within mirmon - see the links below for lists of mirrors and their current status:-</p>
            <ul>
               <li>
                  <a href="https://www.exim.org/mirmon/ftp_mirrors.html">Download Mirrors</a>
               </li>
               <li>
                  <a href="https://www.exim.org/mirmon/www_mirrors.html">Website Mirrors</a>
               </li>
            </ul>

	    <h3>Verification of Downloads</h3>

	    All published Tarballs are signed. The signatures are created with keys belonging to the developers:
	    <a href="{$staticroot}/keys/jgh@wizmail.org.asc">Jeremy Harris</a>,
	    <a href="{$staticroot}/keys/phil.pennock@spodhuis.org.asc">Phil Pennock</a>, or
	    <a href="{$staticroot}/keys/hs@schlittermann.de.asc">Heiko Schlittermann</a>. (Please crosscheck these keys
	    with keys you can find at other sources.)

            <h3>Mirroring Exim</h3>

            <p>If you are interested in running a mirror for exim, please look at <a href="howto/mirroring.html">Mirroring The Exim Website</a></p>


	    <h3>Exim Git Repositories</h3>

	    <p>If you prefer tracking our commits to the source tree directly via Git:
	    <ul>
		<li> Main Git Repository: <code>git://git.exim.org/exim.git</code></li>
		<li> Mirror at GitHub <a href="https://github.com/Exim/exim.git">https://github.com/Exim/exim.git</a></li>
	    </ul>
	    </p>

	    </xsl:template>

</xsl:stylesheet>

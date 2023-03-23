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



			<!-- General Download Info -->
				<p>
				<xsl:text>Exim is available as a native package for a number of software distributions.
				The sources are available as </xsl:text>
				<a href="https://downloads.exim.org/exim4/">tarballs</a>
				<xsl:text> and as a </xsl:text>
				<a href="#git">Git Repo (see below).</a>
				</p>

				<p>
				<xsl:text>Further information on the binary and OS distributions can be found in the </xsl:text>
				<a href="https://github.com/Exim/exim.wiki/ObtainingExim">Exim Wiki.</a>
				</p>

				<p>
				<xsl:text>If we published </xsl:text><em>maintenance</em><xsl:text> releases, you can find the tarballs in the </xsl:text>
				<a href="https://downloads.exim.org/exim4/fixes/">fixes area,</a>
				<xsl:text> and in individual </xsl:text><a href="#git">git branches</a><xsl:text> suffixed with </xsl:text><em>+fixes.</em>
				<xsl:text> Please note, that we normally we do not publish maintenance releases as tarballs, unless they contain
				critical changes.</xsl:text>
				</p>

	    <h3>Verification of Downloads</h3>

	    <p>
	    All published tarballs are cryptographically signed with an OpenPGP implementation (such as GnuPG).
	    The signatures are distributed alongside the tarballs.
	    The signatures are created with keys belonging to the developers.
	    The keys can be found in our
	    <a href="https://downloads.exim.org/Exim-Maintainers-Keyring.asc">maintainers keyring</a>.
	    (Please crosscheck these keys with keys you can find at other sources.)
	    </p>

	    <p>
	    The exim.org domain supports <a href="https://wiki.gnupg.org/WKD">the WKD mechanism</a> for OpenPGP key retrieval.
	    </p>

	    <h3 id="git">Exim Git Repositories</h3>

	    <p>If you prefer tracking our commits to the source tree directly via Git:
	    <ul>
		<li>Main Git Repository: <code>git://git.exim.org/exim.git</code></li>
		<li>Web interface: <a href="https://git.exim.org/exim.git">https://git.exim.org/exim.git</a></li>
		<li>Mirror at GitHub <a href="https://github.com/Exim/exim.git">https://github.com/Exim/exim.git</a></li>
	    </ul>
	    All releases get a signed Git tag.
	    </p>

	    </xsl:template>

</xsl:stylesheet>

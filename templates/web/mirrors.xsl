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


				<p>
					<xsl:text>Exim is available as a native package for a number of software distributions. The sources are available as
					a tarball and from our <a href="https://git.exim.org/exim.git">Git Repo</a>, which is mirrored on <a href="https://github.com/Exim/exim">Github</a>.
					Further information on the binary and OS distributions can be found in the </xsl:text>
					<a href="https://wiki.exim.org/ObtainingExim">Exim Wiki.</a>

					<xsl:text>If we published maintenance releases you can find the tarballs
					in the </xsl:text>
					<a href="https://downloads.exim.org/exim4/fixes/">fixes</a><xsl:text> directory</xsl:text>
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

	    <h3>Exim Git Repositories</h3>

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

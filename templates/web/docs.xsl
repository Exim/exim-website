<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- WRAPPER -->
		<xsl:import href="../wrapper.xsl"/>
		<xsl:template match="/"> <xsl:apply-imports/> </xsl:template>

		<xsl:variable name="docroot" select="'.'"/>

	<!-- Title -->
		<xsl:variable name="html.head.title" select="'Documentation for Exim'"/>


	<xsl:variable name="html.head.append">

		<!-- Canonical -->
			<link rel="canonical" href="https://www.exim.org/docs.html"/>

		<!-- CSS -->
			<link rel="stylesheet" type="text/css" href="docs.css"/>
	</xsl:variable>

	<!-- JavaScript -->
		<xsl:variable name="html.body.append">
			<script type="text/javascript" src="docs.js"/>
		</xsl:variable>

	<!-- CONTENT -->
		<xsl:template name="content">

			<!-- Title -->
				<h2>
					<xsl:value-of select="$html.head.title"/>
				</h2>

			<!-- General Doc Info -->
				<p>Exim has a set of documentation released with it. A text file of the main documentation is released as part of the Exim tar archive. Additionally, postscript and texinfo forms of the documentation are available in separate tar archives on the ftp sites. There is also a <a href="https://www.uit.co.uk/all-books/the-exim-smtp-mail-server.html">book</a>.</p>

				<p>User supported documentation, FAQs and hints can be found in the <a href="https://wiki.exim.org/">wiki</a>.</p>

				<p>There are 3 main sets of documentation for Exim, all of which are also available below in html form.</p>

				<p>The main user and configuration manual is the specification document</p>

				<p class="manual_info">
					<a href="{$docroot}/exim-html-current/doc/html/spec_html/index.html">
						<xsl:text>The Exim Specification - Version </xsl:text>
						<xsl:value-of select="/content/current_version"/>
						<xsl:text> (HTML)</xsl:text>
					</a>
					<xsl:text> </xsl:text>
					<a href="{$docroot}/exim-pdf-current/doc/spec.pdf">(PDF)</a>

					<xsl:text> - The master documentation for Exim containing all required detail to install, configure and use Exim. </xsl:text>
					<span class="changed">Changes to the documentation (normally reflecting changes to the functionality of Exim) are shown on a green background like this segment.</span>
					<br/><select name="spec_old_version">
						<option value="">View Older Versions</option>
						<xsl:for-each select="/content/old_versions">
							<option value="{text()}"><xsl:value-of select="text()"/></option>
						</xsl:for-each>
					</select>
				</p>

				<p class="manual_info">
					<a href="{$docroot}/exim-html-current/doc/html/spec_html/filter.html">
						<xsl:text>The Exim Filter Specification - Version </xsl:text>
						<xsl:value-of select="/content/current_version"/>
						<xsl:text> (HTML)</xsl:text>
					</a>
					<xsl:text> </xsl:text>
					<a href="{$docroot}/exim-pdf-current/doc/filter.pdf">(PDF)</a>
					<xsl:text> - Additional information on the Exim filter language.</xsl:text>
					<br/><select name="filter_old_version">
						<option value="">View Older Versions</option>
						<xsl:for-each select="/content/old_versions">
							<option value="{text()}"><xsl:value-of select="text()"/></option>
						</xsl:for-each>
					</select>
				</p>

			<!-- HOWTOs -->
				<h3>HOWTO Documentation</h3>
				<ul id="howto_list">
					<li>
						<a href="{$docroot}/howto/rbl.html">Using DNS Block Lists</a>
					</li>
					<li>
						<a href="{$docroot}/howto/mailman21.html">Using mailman 2.1 lists with Exim4</a>
					</li>
				</ul>

			<!-- FAQS -->
				<h3>Frequently Asked Questions - FAQ</h3>
				<p>
					<xsl:text>The wikified </xsl:text>
					<a href="http://wiki.exim.org/FAQ">FAQ for Exim 4</a>
					<xsl:text> can be found </xsl:text>
					<a href="http://wiki.exim.org/FAQ">here</a>
					<xsl:text>. The FAQ for the obsolete Exim 3 releases can be found on the </xsl:text>
					<a href="{$docroot}/ftp/exim3/">FTP site</a>
					<xsl:text> - see the </xsl:text>
					<a href="{$docroot}/download.html">download</a>
					<xsl:text> pages.</xsl:text>
				</p>

			<!-- Copies -->
				<h3>Copies of Documentation</h3>
				<p>Copies of the main Exim documentation in HTML format as used on this site in a compressed tar file are available from the main download site.(see file exim-html-*).</p>

		</xsl:template>

</xsl:stylesheet>

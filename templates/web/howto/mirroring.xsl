<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <!-- WRAPPER -->
   <xsl:import href="../../wrapper.xsl"/>
   <xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
   
   <xsl:variable name="docroot" select="'..'"/>

   <!-- Title -->
   <xsl:variable name="html.head.title" select="'HOWTO - Mirroring The Exim Website'"/>

   <!-- Canonical -->
   <xsl:variable name="html.head.append">
      <link rel="canonical" href="http://www.exim.org/howto/mirroring.html"/>
   </xsl:variable>
 
   <!-- CONTENT -->
   <xsl:template name="content">

      <h2>
         <xsl:value-of select="$html.head.title"/>
      </h2>
      
      <h3>Mirroring the content</h3>

      <p>All of the exim web site content is available through
      rsync, and this is the recommended means for mirroring the
      web site content. </p>

      <p>The rsync URL is <a href="rsync://ftp.exim.org/www">rsync://ftp.exim.org/www</a></p>

      <p>However the more normal means to quote the rsync path is
      <tt>ftp.exim.org::www</tt></p>

      <p>The rsync path for the ftp area is <tt>ftp.exim.org::ftp</tt></p>

      <h3>Configuring your httpd</h3>

      <p>Your httpd obviously needs to see the mirrored content.
      There are also some other tweaks - Apache aliases - which are
      needed. The paths that need aliasing are currently only the
      <tt>/ftp></tt> path which either needs pointing to your ftp
      mirror, or redirecting to a reasonable mirror of the exim ftp
      site.</p>

      <p>If and when the mailing list archives are put on line,
      these may also need handling in a special way.</p>

      <h3>Branding your site</h3>

      <p>In some small recognition of the ISPs and other
      organisations who donate the web site space, bandwidth and
      management, the web site has a brandable component -
      specifically the section of the main window imports the
      <tt>branding/branding.html</tt> file. By aliasing this path
      you can tailor this to put a sponsors logo in place.</p>

      <h3>Tell people about it</h3>

      <p><a href="http://bugs.exim.org/enter_bug.cgi?product=Infrastructure&amp;component=Mirrors&amp;bug_severity=wishlist">Register
      a bug</a> in the Exim Bugzilla under
      Infrastructure/Mirrors so that the mirmon information can be
      updated.  Join the <a href="http://www.exim.org/mailman/listinfo/exim-mirrors">exim-mirrors</a>
      list so we can tell you of any changes to mirroring practice.</p>

   </xsl:template>

</xsl:stylesheet>

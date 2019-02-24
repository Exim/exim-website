<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <!-- Define display/content information -->
      <xsl:output indent="yes"/>
      <xsl:output encoding="UTF-8"/>
      <xsl:output media-type="text/html"/>
      <xsl:output omit-xml-declaration="yes"/>
      <xsl:output doctype-public="XSLT-compat"/>

   <!-- Define some variables -->
      <xsl:variable name="docroot"/>
      <xsl:variable name="html.head.title"/>
      <xsl:variable name="html.head.description" select="'Exim is a message transfer agent (MTA) developed at the University of Cambridge for use on Unix systems connected to the Internet.'"/>
      <xsl:variable name="html.head.keywords" select="'exim,smtp,mta,email'"/>
      <xsl:variable name="html.head.robots" select="'noodp,noydir,index,follow'"/>
      <xsl:variable name="html.head.append"/>
      <xsl:variable name="html.body.append"/>
      <xsl:variable name="html.body.outer.append"/>

   <!-- The main template code -->
      <xsl:template match="/">
         <html lang="en-GB">
            <head>
               <link rel="stylesheet" type="text/css" href="{$staticroot}/css/common.css"/>

               <meta name="author"      content="The Exim Project. &lt;https://www.exim.org/&gt;"/>
               <meta name="copyright"   content="Copyright ©1995-2012 The Exim Project. All rights reserved"/>
               <meta name="description" content="{$html.head.description}"/>
               <meta name="keywords"    content="{$html.head.keywords}"/>
               <meta name="robots"      content="{$html.head.robots}"/>

               <!-- Mobile Safari (iPhone) - Reduce viewport to physical size of device -->
                  <meta name="viewport" content="width=device-width"/>

               <title>
                  <xsl:value-of select="$html.head.title"/>
               </title>
            
               <xsl:copy-of select="$html.head.append"/>
            </head>
	    <body class="no-js">
                <!-- Changed body classname from "no-js" to "with-js" for styling purposes -->

                   <script type="text/javascript"><![CDATA[document.body.className=(' '+document.body.className+' ').replace('no-js','with-js');]]></script>

                <!-- Header -->

                   <h1 id="header">
                      <a href="{$docroot}">Exim Internet Mailer</a>
                   </h1>

                <!-- Outer Container -->

                   <div id="outer">

                      <!-- Navigation -->

                         <ul id="nav_flow" class="nav">
                            <li> <a href="{$docroot}/index.html">Home</a> </li>
                            <li> <a href="{$docroot}/mirrors.html">Download</a> </li>
                            <li> <a href="{$docroot}/docs.html">Documentation</a> </li>
                            <li> <a href="{$docroot}/maillist.html">Mailing Lists</a> </li>
                            <li> <a href="http://wiki.exim.org/">Wiki</a> </li>
                            <li> <a href="https://bugs.exim.org/">Bugs</a> </li>
                            <li> <a href="{$docroot}/static/doc/security">Security</a> </li>
                            <li> <a href="{$docroot}/credits.html">Credits</a> </li>

                            <!-- Search Field -->

                               <li class="search">
                                  <form action="https://encrypted.google.com/search" method="get">
                                     <span class="search_field_container">
                                        <input type="search" name="q" placeholder="Search Docs" class="search_field"/>
                                     </span>
                                     <input type="hidden" name="hl" value="en"/>
                                     <input type="hidden" name="ie" value="UTF-8"/>
                                     <input type="hidden" name="as_qdr" value="all"/>
                                     <input type="hidden" name="q" value="site:www.exim.org"/>
                                     <input type="hidden" name="q" value="inurl:exim-html-current"/>
                                  </form>
                               </li>
                         </ul>

                      <!-- MAIN CONTENT. This is the div that wraps around the other stylesheets -->
                         <div id="inner">
                            <div id="content">
                              <xsl:call-template name="content"/>
                           </div>
                         </div>

                      <!-- Branding -->
                         <iframe id="branding" name="branding" src="{$docroot}/branding/branding.html" height="0" frameborder="no" scrolling="no"/>

                      <!-- Footer -->

                         <div id="footer">
                            <xsl:text>Website design by </xsl:text>
                            <a href="https://www.grepular.com/">Mike Cardwell</a>
                            <xsl:text>.</xsl:text>
                         </div>

                      <!-- Side Bars -->
                         <div class="left_bar"/>
                         <div class="right_bar"/>

                      <!-- Append anything to the outer container? -->
                         <xsl:copy-of select="$html.body.outer.append"/>
                   </div>

                <!-- Load latest version of jQuery 1.6 from the Google CDN -->
                   <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6/jquery.min.js"></script>

                <!-- Local JavaScript -->
                   <script type="text/javascript" src="{$staticroot}/js/common.js"></script>
                   
                   <xsl:copy-of select="$html.body.append"/>

             </body>

         </html>
      </xsl:template>

   <!-- Quote Element -->
      <xsl:template match="quote">
         <xsl:text>&#8220;</xsl:text><xsl:apply-templates match="*"/><xsl:text>&#8221;</xsl:text>
      </xsl:template>

   <!-- Random Docbook Elements -->
      <xsl:template match="filename | emphasis | option | command | function">
         <span class="docbook_{name()}"> <xsl:apply-templates/> </span>
      </xsl:template>

   <!-- Literal Element -->
      <xsl:template match="literal">
         <code class="docbook_literal"> <xsl:apply-templates/> </code>
      </xsl:template>
      <xsl:template match="literallayout">
         <div class="docbook_literallayout"> <pre> <xsl:apply-templates/> </pre> </div>
      </xsl:template>

   <!-- ULink Element -->
      <xsl:template match="ulink">
         <a href="{text()}"> <xsl:value-of select="text()"/> </a>
      </xsl:template>

   <!-- XREF (Fixed up in the Perl) -->
      <xsl:template match="xref">
         <a href="{@url}" title="{@chapter_id}. {@chapter_title}">
            <xsl:choose>
               <xsl:when test="@section_id">
                  <xsl:choose>
                     <xsl:when test="@longref">
                        <xsl:value-of select="@chapter_title"/>
                        <small>
                           <xsl:value-of select="concat(' [',@section_title,']')"/>
                        </small>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="concat(@chapter_id,'.',@section_id)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when test="@longref">
                        <xsl:value-of select="@chapter_title"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@chapter_id"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </a>
      </xsl:template>

   <!-- Para -->
      <xsl:template match="para">
         <p>
            <xsl:if test="@revisionflag!=''"><xsl:attribute name="class">changed</xsl:attribute></xsl:if>
            <xsl:apply-templates/>
         </p>
      </xsl:template>

   <!-- Lists -->
      <xsl:template match="itemizedlist">                        <ul> <xsl:apply-templates/> </ul> </xsl:template>
      <xsl:template match="itemizedlist/listitem">               <li> <xsl:apply-templates/> </li> </xsl:template>
      <xsl:template match="orderedlist">                         <ol> <xsl:apply-templates/> </ol> </xsl:template>
      <xsl:template match="orderedlist/listitem">                <li> <xsl:apply-templates/> </li> </xsl:template>
      <xsl:template match="variablelist">                        <dl> <xsl:apply-templates/> </dl> </xsl:template>
      <xsl:template match="variablelist/varlistentry/term">      <dt> <xsl:apply-templates/> </dt> </xsl:template>
      <xsl:template match="variablelist/varlistentry/listitem">  <dd> <xsl:apply-templates/> </dd> </xsl:template>

   <!-- Table -->
      <xsl:template match="informaltable"> <table> <xsl:apply-templates/> </table> </xsl:template>
      <xsl:template match="tbody/row">     <tr>    <xsl:apply-templates/> </tr>    </xsl:template>
      <xsl:template match="row/entry">     <td>    <xsl:apply-templates/> </td>    </xsl:template>
      <xsl:template match="tgroup|tbody"> <xsl:apply-templates/> </xsl:template>

   <!-- Ignore -->
      <xsl:template match="indexterm|title|titleabbrev|current_version"/>

</xsl:stylesheet>

#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;
use File::Find;
use File::Spec;
use XML::LibXML;
use XML::LibXSLT;

my $canonical_url = 'http://www.exim.org/';

## Parse arguments
  my %opt = parse_arguments();

## Generate the pages
  do_doc( 'spec',   $_ ) foreach @{$opt{spec}||[]};
  do_doc( 'filter', $_ ) foreach @{$opt{filter}||[]};
  do_web(              ) if exists $opt{web};

## Add the exim-html-current symlink
  print "Symlinking exim-html-current to exim-html-$opt{latest}\n";
  symlink( "$opt{docroot}/exim-html-$opt{latest}", "$opt{docroot}/exim-html-current" );

## Generate the website files
  sub do_web {

     ## Make sure the template web directory exists
       die "No such directory: $opt{tmpl}/web\n" unless -d "$opt{tmpl}/web";

     ## Scan the web templates
       find(sub{
          my( $path ) = substr( $File::Find::name, length("$opt{tmpl}/web"), length($File::Find::name) ) =~ m#^/*(.*)$#;

          if( -d "$opt{tmpl}/web/$path" ){

             ## Create the directory in the doc root if it doesn't exist
               if( ! -d "$opt{docroot}/$path" ){
                  mkdir( "$opt{docroot}/$path" ) or die "Unable to make $opt{docroot}/$path: $!\n";
               }

          } else {

             ## Build HTML from XSL files and simply copy static files which have changed
               if( $path =~ /(.+)\.xsl$/ ){
                  print "Generating  : docroot:/$1.html\n";
                  transform( undef, "$opt{tmpl}/web/$path", "$opt{docroot}/$1.html" );
               } elsif( -f "$opt{tmpl}/web/$path" ){

                  ## Skip if the file hasn't changed (mtime based)
                    return if -f "$opt{docroot}/$path" && (stat("$opt{tmpl}/web/$path"))[9] == (stat("$opt{docroot}/$path"))[9];

                  ## Copy
                    print "Copying to  : docroot:/$path\n";
                    copy( "$opt{tmpl}/web/$path", "$opt{docroot}/$path" ) or die "$path: $!";

                  ## Set mtime
                    utime( time, (stat("$opt{tmpl}/web/$path"))[9], "$opt{docroot}/$path" );
               }
          }

       }, "$opt{tmpl}/web");
  }

## Generate index/chapter files for a doc
  sub do_doc {
     my( $type, $xml_path ) = @_;

     ## Read and validate the XML file
       my $xml = XML::LibXML->new()->parse_file( $xml_path ) or die $!;

     ## Get the version number
       my $version = $xml->findvalue('/book/bookinfo/revhistory/revision/revnumber');
       die "Unable to get version number\n" unless defined $version && $version =~ /^\d+(\.\d+)*$/;

     ## Prepend chapter filenames?
       my $prepend_chapter = $type eq 'filter' ? 'filter_' : '';

     ## Add the canonical url for this document
       $xml->documentElement()->appendTextChild('canonical_url',"${canonical_url}exim-html-current/doc/html/spec_html/".($type eq 'spec'?'index':'filter').".html");

     ## Fixup the XML
       xref_fixup( $xml, $prepend_chapter );

     ## Generate the front page
       {
          my $path = "exim-html-$version/doc/html/spec_html/".($type eq 'filter'?$type:'index').".html";
          print "Generating  : docroot:/$path\n";
          transform( $xml,
             "$opt{tmpl}/doc/index.xsl",
             "$opt{docroot}/$path",
          );
       }

     ## Generate a Table of Contents XML file
       {
          my $path = "exim-html-$version/doc/html/spec_html/".($type eq 'filter'?'filter_toc':'index_toc').".xml";
          print "Generating  : docroot:/$path\n";
          transform( $xml,
             "$opt{tmpl}/doc/toc.xsl",
             "$opt{docroot}/$path",
          );
       }

     ## Generate the chapters
       my $counter = 0;
       foreach my $chapter ( map {$_->cloneNode(1)} $xml->findnodes('/book/chapter') ){

          ## Add a <chapter_id>N</chapter_id> node for the stylesheet to use
            $chapter->appendTextChild( 'chapter_id', ++$counter );

          ## Add previous/next/canonical urls for nav
            {
               $chapter->appendTextChild( 'prev_url',
                  $counter == 1
                    ? $type eq 'filter'
                      ? 'filter.html'
                      : 'index.html'
                    : sprintf('%sch%02d.html',$prepend_chapter,$counter-1)
               );
               $chapter->appendTextChild( 'next_url',      sprintf('%sch%02d.html',$prepend_chapter,$counter+1) );
               $chapter->appendTextChild( 'canonical_url', sprintf('http://www.exim.org/exim-html-current/doc/html/spec_html/%sch%02d.html',$prepend_chapter,$counter) );
            }

          ## Create an XML document from the chapter
            my $doc = XML::LibXML::Document->createDocument( '1.0', 'UTF-8' );
            $doc->setDocumentElement( $chapter );

          ## Transform the chapter into html
            {
               my $path = sprintf('exim-html-%s/doc/html/spec_html/%sch%02d.html', $version, $prepend_chapter, $counter );
               print "Generating  : docroot:/$path\n";
               transform( $doc,
                  "$opt{tmpl}/doc/chapter.xsl",
                  "$opt{docroot}/$path",
               );
            }
       }
  }

## Fixup xref tags
  sub xref_fixup {
     my( $xml, $prepend_chapter ) = @_;

     my %index = ();

     ## Add the "prepend_chapter" info
       ($xml->findnodes('/book'))[0]->appendTextChild( 'prepend_chapter', $prepend_chapter );

     ## Iterate over each chapter
       my $chapter_counter = 0;
       foreach my $chapter ( $xml->findnodes('/book/chapter') ){
          ++$chapter_counter;

          my $chapter_id    = $chapter->getAttribute('id');
          my $chapter_title = $chapter->findvalue('title');

          $index{$chapter_id} = { chapter_id => $chapter_counter, chapter_title => $chapter_title };

          ## Iterate over each section
            my $section_counter = 0;
            foreach my $section ( $chapter->findnodes('section') ){
               ++$section_counter;

               my $section_id      = $section->getAttribute('id');
               my $section_title   = $section->findvalue('title');

               $index{$section_id} = { chapter_id => $chapter_counter, chapter_title => $chapter_title, section_id => $section_counter };
            }
       }

    ## Replace all of the xrefs in the XML
      foreach my $xref ( $xml->findnodes('//xref') ){
         my $linkend = $xref->getAttribute('linkend');
         if( exists $index{$linkend} ){
             $xref->setAttribute( 'chapter_id',    $index{$linkend}{'chapter_id'}    );
             $xref->setAttribute( 'chapter_title', $index{$linkend}{'chapter_title'} );
             $xref->setAttribute( 'section_id',    $index{$linkend}{'section_id'}    ) if $index{$linkend}{'section_id'};
             $xref->setAttribute( 'url', sprintf('%sch%02d.html',$prepend_chapter, $index{$linkend}{'chapter_id'}).($index{$linkend}{'section_id'}?'#'.$linkend:'') );
          }
       }
  }

## Handle the transformation
  sub transform {
     my( $xml, $xsl_path, $out_path ) = @_;

     ## Build an empty XML structure if an undefined $xml was passed
       unless( defined $xml ){
          $xml = XML::LibXML::Document->createDocument( '1.0', 'UTF-8' );
          $xml->setDocumentElement( $xml->createElement('content') );
       }

     ## Add the current version of Exim to the XML
       $xml->documentElement()->appendTextChild( 'current_version', $opt{latest} );

     ## Parse the ".xsl" file as XML
       my $xsl = XML::LibXML->new()->parse_file( $xsl_path ) or die $!;

     ## Generate a stylesheet from the ".xsl" XML.
       my $stylesheet = XML::LibXSLT->new()->parse_stylesheet( $xsl );

     ## Generate a doc from the XML transformed with the XSL
       my $doc = $stylesheet->transform( $xml );

     ## Make the containing directory if it doesn't exist
       mkdirp( ($out_path =~ /^(.+)\/.+$/)[0] );

     ## Write out the document
       open my $out, '>', $out_path or die $!;
       print $out $stylesheet->output_as_bytes( $doc );
       close $out;
  }

## "mkdir -p "
  sub mkdirp {
     my $path = shift;

     my @parts = ();
     foreach( split(/\//, $path) ){
        push @parts, $_;
        my $make = join('/',@parts);
        next unless length($make);
        next if -d $make;
        mkdir( $make ) or die "Unable to mkdir $make: $!\n";
     }
  }

## Parse arguments
  sub parse_arguments {
     my %opt = ();

     ## --help
       help(0) if int(@ARGV) == 0 || grep(/^--help|-h$/,@ARGV);

     my @collection = @ARGV;
     while( @collection ){
        my $key = shift @collection;

        if( $key eq '--web' ){

           ## --web
             $opt{web} = 1;
        } elsif( $key =~ /^--(spec|filter)$/ ){

           ## --spec and --filter
             my $continue = 1;
             while( $continue && @collection ){
                my $value = shift @collection;

                if( $value =~ /^--/ ){
                   unshift @collection, $value;
                   $continue = 0;
                } else {
                   $value = File::Spec->rel2abs( $value );
                   help( 1, 'No such file: '.$value   ) unless -f $value;
                   push @{$opt{$1}}, $value unless grep( $_ eq $value, @{$opt{$1}} );
                }
             }
             help( 1, 'Missing value for '.$key ) unless exists $opt{$1};
        } elsif( $key eq '--latest' ){

           ## --latest
             my $value = shift @collection;
             help( 1, 'Missing value for '.$key ) unless defined $value;
             help( 1, 'Invalid value for '.$key ) unless $value =~ /^\d+(?:\.\d+)*$/;
             $opt{latest} = $value;
        } elsif( $key =~ /^--(tmpl|docroot)$/ ){

           ## --tmpl and --docroot
             my $value = shift @collection;
             help( 1, 'Missing value for '.$key    ) unless defined $value;
             $value = File::Spec->rel2abs( $value );
             help( 1, 'No such directory: '.$value ) unless -d $value;
             $opt{$1} = $value;
             $opt{$1} =~ s#/+$##;
        } else {
           help( 1, 'Bad argument: '.$key );
        }
     }

     help( 1, 'Must include at least one of --web, --spec or --filter' ) unless exists $opt{web} || exists $opt{spec} || exists $opt{filter};
     foreach(qw( latest tmpl docroot )){
        help( 1, 'Missing argument: --'.$_ ) unless exists $opt{$_};
     }

     return %opt;
  }

## Help information
  sub help {
     my( $exit_code, $msg ) = @_;

     print "$msg\n\n" if defined $msg;

     print << "END_HELP";
Options:
   --help or -h  : Print this help information and then exit

   --web         : Generate the general website pages
   --spec PATH   : Generate the spec pages. PATH is the path to the spec.xml
   --filter PATH : Generate the filter pages. PATH is the path to the filter.xml

   One or more of the above three options are required. --spec and --filter can
   take multiple values to generate different sets of documentation for
   different versions at the same time.

   --latest VERSION : Required. Specify the latest stable version of Exim.
   --tmpl PATH      : Required. Path to the templates directory
   --docroot PATH   : Required. Path to the website document root

   If CSS::Minifier::XS is installed, then CSS will be minified.
   If JavaScript::Minifier::XS is installed, then JavaScript will be minified.

Example:

   ./gen.pl --latest 4.72
            --web
            --spec spec.xml 4.71/spec.xml
            --filter filter.xml 4.71/filter.xml
            --tmpl ~/www/templates
            --docroot ~/www/docroot
END_HELP

     exit( $exit_code );
  }

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <!-- WRAPPER -->
      <xsl:import href="../../wrapper.xsl"/>
      <xsl:template match="/"> <xsl:apply-imports/> </xsl:template>
      
      <xsl:variable name="docroot" select="'..'"/>

   <!-- Title -->
      <xsl:variable name="html.head.title" select="'HOWTO - Using Exim 4 and Mailman 2.1 together'"/>

   <xsl:variable name="html.head.append">

      <!-- CSS -->
         <link rel="stylesheet" type="text/css" href="mailman21.css"/>

      <!-- Canonical -->
         <link rel="canonical" href="https://www.exim.org/howto/mailman21.html"/>

   </xsl:variable>
 
   <!-- CONTENT -->
      <xsl:template name="content">

         <h2>
            <xsl:value-of select="$html.head.title"/>
         </h2>

         <p>Mailman is a list manager with web front end and built in archiving functions.  Details can be found at <a href="http://www.list.org/">http://www.list.org/</a>. This documentation describes the configuration of Exim (version 4) to work with Mailman version 2.1</p>

         <h3 id="index">Index</h3>

         <ul>
            <li><a href="#scope">Scope of this document</a></li>
            <li><a href="#basic">Basic Configuration</a></li>

            <li class="sublist">
               <ul>
                  <li><a href="#mmconf">Mailman configuration</a></li>
                  <li><a href="#exconf">Exim configuration</a></li>
                  <li><a href="#maconf">Main configuration settings</a></li>
                  <li><a href="#roconf">Exim Router</a></li>
                  <li><a href="#taconf">Exim Transport</a></li>
               </ul>
            </li>

            <li><a href="#batune">Basic mailing list MTA tuning</a></li>

            <li class="sublist">
               <ul>
                  <li><a href="#retune">Receiver verification</a></li>
                  <li><a href="#rctune">Tuning of numbers of recipients</a></li>
                  <li><a href="#smtune">SMTP callback</a></li>
               </ul>
            </li>

            <li><a href="#verpin">Doing VERP and personalisation with exim and Mailman</a></li>

            <li class="sublist">
               <ul>
                  <li><a href="#verpmm">VERP within Mailman</a></li>
                  <li><a href="#persmm">Mailing list personalisation by Mailman</a></li>
                  <li><a href="#verpex">VERP expansion by Exim rather than Mailman</a></li>
               </ul>
            </li>

            <li><a href="#virdom">Virtual domains</a></li>
            <li><a href="#lispol">List policy management</a></li>

            <li class="sublist">
               <ul>
                  <li><a href="#conpol">Content scanning</a></li>
                  <li><a href="#incpol">Incoming message checks</a></li>
                  <li><a href="#mmapol">Mailman specific ACL checks</a></li>
               </ul>
            </li>

            <li><a href="#lisver">List verification</a></li>
            <li><a href="#problem">Possible Problems</a></li>
            <li><a href="#dochis">Document History</a></li>
            <li><a href="#doccha">Document Changes</a></li>
            <li><a href="#docfin">Final Word</a></li>
         </ul>

         <h4><a href="#index" id="scope">Scope of this document</a></h4>

         <p>This document describes how to set up a basic working configuration using Exim 4 as an MTA for the Mailman MLM.  The assumption is made that the receiving MTA, Mailman and the list distribution MTA are all on the same machine, and that Mailman talks to Exim using SMTP to address 127.0.0.1</p>
         
         <p>It also describes ways of using VERP delivery, both conventionally (doing VERP from Mailman), and an alternative more efficient technique where VERP expansion is done within exim.</p>

         <p>Tuning and setting appropriate mailing list protection policies is also covered in passing.</p>

         <p>General installation, use, running and administration of either Mailman or exim is not covered here - the documentation for the programs concerned should be read for this information.</p>

         <h3><a href="#index" id="basic">Basic Configuration</a></h3>

         <h4><a href="#index" id="mmconf">Mailman configuration</a></h4>

         <p>For basic operation there is no Mailman configuration needed other than the standard options detailed in the Mailman install documentation.  The user/group settings for Mailman must match those in the config fragments given below, and you need to have at least configured DEFAULT_URL_HOST and DEFAULT_EMAIL_HOST within Mailman, for example by editing ~mailman/Mailman/mm_cfg.py and setting the following (substituting in your own domains):-</p>

         <pre># The host part of the URL used for your mailman install
DEFAULT_URL_HOST = 'www.example.com'
#
# The email domain of your lists
DEFAULT_EMAIL_HOST = 'list.example.com'
#
# Let Mailman know that the MTA needs no aliases setting
MTA = None</pre>

         <p>The final setting above informs Mailman that it does not need to prompt you to add aliases when creating a list (like Sendmail), or modify other settings (like Postfix).  Not setting this will mean that Mailman nags you to do things that aren't necessary in an Exim configuration.</p>

         <p>After making a change to the Mailman configuration file you need to restart the Mailman queue runners.</p>

         <pre>~mailman/bin/mailmanctl restart</pre>

         <p>Mailman should also be set to deliver to the MTA using SMTP - this is done by having DELIVERY_MODULE = 'SMTPDirect' in the config file (which is the default mode of operation)</p>

         <h4><a href="#index" id="exconf">Exim configuration</a></h4>

         <p>The Exim configuration is built so that a list created within Mailman automatically appears to Exim without the need for defining any additional aliases (however Mailman may helpfully show or email you a list of required aliases when you create a list - you can just ignore those - if you have set the MTA parameter it will stop doing this).</p>

         <p>The drawback of this configuration is that it will work poorly on systems supporting lists in several different mail domains. While Mailman handles virtual domains, it does not yet support having two distinct lists with the same name in different virtual domains, using the same Mailman installation.  This will eventually change.  (But see below for a variation on this scheme that should accommodate virtual domains better.)</p>

         <p>The configuration file excerpts below are for use in an already functional Exim configuration.  You also need to have an alias for mailman within the mm_domains, this picks up mail sent to the site list (or basically just sent in error), and should forward to the Mailman Administrator.  It appears that a couple of Mailman messages mention the mailman-admin address (this appears to be an error in Mailman or maybe a packaging error), so I would suggest that mailman-admin is aliased also to the Mailman Administrator.</p>

         <p><i>[Note: the instructions in this document will work only with Exim 4.  It may be possible to adapt them for Exim 3, but frankly it is not worth the trouble]</i></p>

         <p>You will need to add some macros to the main section of your Exim config file.  You will also need to define one new transport and add new routers.  Additional ACLs may be used to handle policy enforcement.  Remember that the exim daemon needs restarting before it sees configuration changes.</p>

         <h4><a href="#index" id="maconf">Main configuration settings</a></h4>

         <p>First, you need to add some macros to the top of your Exim config file.  These just make the routers and transport below a bit cleaner.  Obviously, you'll need to edit these based on how you configured and installed Mailman.</p>

         <pre># Home dir for your Mailman installation -- aka Mailman's prefix
# directory.
# By default this is set to "/usr/local/mailman"
# On a Red Hat/Fedora system using the RPM use "/var/mailman"
# On Debian using the deb package use "/var/lib/mailman"
# This is normally the same as ~mailman
MM_HOME=/var/mailman
#
# User and group for Mailman, should match your --with-mail-gid
# switch to Mailman's configure script.
# Value is normally "mailman"
MM_UID=mailman
MM_GID=mailman
#
# Domains that your lists are in - colon separated list
# you may wish to add these into local_domains as well
domainlist mm_domains=list.example.com
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#
# These values are derived from the ones above and should not need
# editing unless you have munged your mailman installation
#
# The path of the Mailman mail wrapper script
MM_WRAP=MM_HOME/mail/mailman
#
# The path of the list config file (used as a required file when
# verifying list addresses).  The option used takes a list
# which is list-split before string-expansion, so we change the
# default list-separator.
MM_LISTCHK=&lt;, MM_HOME/lists/${lc:$local_part}/config.pck</pre>

         <h4><a href="#index" id="roconf">Exim Router</a></h4>

         <p>This router picks up all the addresses going to the Mailman lists.  Initially it selects only the domains that have may have lists in, then selects where local_part matches a list name (ie you can see a list config file).  The suffixes pick up all the Mailman admin addresses</p>

         <p>The router should be placed in the router section (ie somewhere after the "begin routers" line of your config file). Normally you would place it just after the aliases router (since that will pick up the mailman master contact address).</p>

         <pre>mailman_router:
  driver            = accept
  domains           = +mm_domains
  local_parts       = dsearch,filter=dir;MM_HOME/lists
  require_files     = MM_LISTCHK
  local_part_suffix_optional
  local_part_suffix = -admin     : \
         -bounces   : -bounces+* : \
         -confirm   : -confirm+* : \
         -join      : -leave     : \
         -owner     : -request   : \
         -subscribe : -unsubscribe
  transport         = mailman_transport</pre>

         <h4><a href="#index" id="taconf">Exim Transport</a></h4>

         <p>The transport for Exim 4 can be placed anywhere where under the begin transports line of your Exim config file.</p>

         <p>The if def:local_part_suffix section selects whether the suffix is used as the mailman command, or whether there is no suffix and so post is passed as a command.</p>

         <p>The sg phrase strips the VERP information (if any) from the suffix,</p>

         <pre>mailman_transport:
  driver  = pipe
  command = MM_WRAP \
          '${if def:local_part_suffix \
                {${sg{$local_part_suffix}{-(\\w+)(\\+.*)?}{\$1}}} \
                {post}}' \
          $local_part_data
  current_directory = MM_HOME
  home_directory    = MM_HOME
  user              = MM_UID
  group             = MM_GID</pre>


         <h4><a href="#index" id="batune">Basic mailing list MTA tuning</a></h4>

         <p>Exim has a lot configurability, especially where the ACL (Access Control Lists) used during SMTP reception are concerned. MTA policy needs to be tuned so that list traffic is not affected by ACLs intended for qualifying traffic coming in from outside. Later in this document some suggestions are made regarding filtering traffic that is going into the mailing list, however</p>

         <h4><a href="#index" id="retune">Receiver verification</a></h4>

         <p>Exim's receiver verification feature is very useful -- it lets Exim reject unrouteable addresses at SMTP time.  However, this is most useful for externally-originating mail that is addresses to mail in one of your local domains.  For Mailman list traffic, mail originates on your server, and is addressed to random external domains that are not under your control.  Furthermore, each message is addressed to many recipients -- up to 500 if you use Mailman's default configuration, and don't tweak SMTP_MAX_RCPTS.</p>

         <p>Doing receiver verification on Mailman list traffic is a recipe for trouble.  In particular, Exim will attempt to route every recipient addresses in outgoing Mailman list posts.  Even though this requires nothing more than a few DNS lookups for each address, it can still introduce significant delays (because these verifications have to be done serially as you attempt handoff to exim).  Therefore, you should disable recipient verification for Mailman traffic.</p>

         <p>Under Exim 4, this is probably already taken care of for you by the default recipient verification ACL statement (in the "RCPT TO"
ACL):</p>

         <pre>accept  domains = +local_domains
        endpass
        message = unknown user
        verify  = recipient</pre>

         <p>which only does recipient verification on addresses in your domain.  (That's not exactly the same as doing recipient verification only on messages coming from non-127.0.0.1 hosts, but it should do the trick for Mailman).  Obviously if the next ACL does verification on non-local addresses you will need to deal with that.</p>

         <p>Alternatively you can add an early get-out in the "RCPT TO" ACL), which <i>trusts</i> all traffic coming from the loopback IP address:</p>

         <pre>accept hosts = 127.0.0.1</pre>

         <h4><a href="#index" id="rctune">Tuning of numbers of recipients</a></h4>

         <p>By default Mailman will send up to 500 recipients on each message it injects into exim.  However this is not necessarily a good configuration for exim since it will route all those recipients before starting deliveries to any of them. Additionally some ACL configurations have tests on the maximum number of recipients (which is a good reason for having a get out ACL for list traffic as described above)</p>

         <p>I would suggest setting Mailman to send a maximum of 5 to 50 recipients on a single mail (setting it lower decreases list latency, but increases the work that Mailman and exim have to do), and change it to send a maximum of 30 messages per SMTP connection.  To reflect this you should also change the exim parameter smtp_accept_queue_per_connection to be 30 as well.</p>

         <p>For example, add the following lines to ~mailman/Mailman/mm_cfg.py:</p>

         <pre># Max recipients for each message
SMTP_MAX_RCPTS = 15
# Max messages sent in each SMTP connection
SMTP_MAX_SESSIONS_PER_CONNECTION = 30</pre>

         <p>Tuning a mailing list system is very much a black art, and depends on the type of lists you host, their throughput, size and the bandwidth available.  In general, tuning is only a significant issue if you are pushing your system near its operational limits.</p>

         <h3><a href="#index" id="verpin">Doing VERP and personalisation with exim and Mailman</a></h3>

         <h4><a href="#index" id="verpmm">VERP within Mailman</a></h4>

         <p><a href="https://cr.yp.to/proto/verp.txt">VERP</a> (Variable Envelope Return Paths) encodes the (original) receipient address in the sender address.  The reason for doing this is that it means bounces are sent to an address which has the original recipient address encoded in it - meaning you know which recipient address caused the bounce.  This makes automatic bounce handling very effective - the normal method of parsing the bouncing address out of the bounce message is very prone to failure, especially in the case of foreign MTAs which use different addressing standards, or where mail forwarding is involved.</p>

         <p>VERP will send one email, with a separate envelope sender (return path), for each of your subscribers - this means that it will generate more traffic since you cannot bundle up deliveries together.  An <a href="https://wiki.list.org/display/DOC/So+what+is+this+VERP+stuff">analysis of the costs of VERP</a> can be found in the <a href="https://wiki.list.org/">Mailman WIKI</a>.</p>

         <p>VERP settings within Mailman are done on a per-installation basis - ie they affect all the lists within the installation. To configure VERP within Mailman read the information in ~mailman/Mailman/Default.py for the options that start with VERP.  In a nutshell, all you need to do to enable VERP with Exim is to add these lines to ~mailman/Mailman/mm_cfg.py:</p>

         <pre>VERP_PASSWORD_REMINDERS      = 1
VERP_PERSONALIZED_DELIVERIES = 1
VERP_CONFIRMATIONS           = 1
VERP_DELIVERY_INTERVAL       = 1</pre>

         <p>(The router and ACLs above are smart enough to deal with VERP bounces.)</p>

         <p>This configuration on its own will make the monthly password reminders, confirmations and all list postings be sent out using VERP</p>

         <p>If you wish to have the advantages of VERP with a lower bandwidth cost, you can enable VERP on occasional list postings rather than on every posting.  Mailman will still VERP on all password reminders and confirmations (these are already inherently single recipient mailings), but only on occasional list postings. To make Mailman use VERP on every twentieth list posting (using bulk delivery for the other 19), change:-</p>

         <pre>VERP_DELIVERY_INTERVAL = 20</pre>

         <p>The downside to doing this is that Mailman may fail to notice a bouncing address if it does not receive at least one bounce per day, so ideally this approach should only be taken if the lists have more than 20 message per day throughput.</p>

         <h4><a href="#index" id="persmm">Mailing list personalisation by Mailman</a></h4>

         <p>Mailman can also personalise each message it sends out on a list.  This allows, for example, the recipient's own address to appear as the To: header, or information specific to them to be placed in the mail footer (although at present personalisation can only be done for normal mail delivery - not for digest subscribers).  This personalisation comes at a cost of an individual message per recipient (ie same bandwidth requirements as full VERP) and some processing costs for Mailman.</p>

         <p>To enable personalisation, add the following configuration item to ~mailman/Mailman/mm_cfg.py (you should also set the VERP settings from above since you have already incurred the costs of VERP):-</p>

         <pre>OWNERS_CAN_ENABLE_PERSONALIZATION = 1</pre>

         <p>You will then find that in the list administration web interface a new set of options has appeared in the <i>Non-digest options</i> section.</p>

         <h4><a href="#index" id="verpex">VERP expansion by exim rather than Mailman</a></h4>

         <p>One drawback of VERP is that as well as increasing the bandwidth outgoing mail requires, it also causes Mailman to send one separate message per recipient from Mailman to exim - causing exim to have many many more queue entries and consequently more queue disk space.  For example a 20,000 recipient list would require 400MB minimum temporary queue storage for each 20KB message sent to the list.  There are also issues of increasing disk traffic/throughput and losing some disk caching advantages.</p>

         <p>These local load problems can be overcome by doing the VERP expansion as the message is sent out from the MTA over network SMTP rather than as the message is injected into the MTA.  It will come as no surprise that exim can be configured to do just this.</p>

         <p>Firstly we need to pick up outgoing Mailman mail and send it to a specialised VERP transport.  This is done using a router which should be placed just before your normal dnslookup router for remote addresses:-</p>

         <pre><![CDATA[# Pick up on messages from our local mailman and route them via our
# special VERP-enabled transport
#
mailman_verp_router:
driver = dnslookup
# we only consider messages sent in through loopback
condition = ${if or{{eq{$sender_host_address}{127.0.0.1}} \
                    {eq{$sender_host_address}{::1}}}{yes}{no}}
# we do not do this for traffic going to the local machine
domains = !+local_domains:!+mm_domains
ignore_target_hosts = <; 0.0.0.0; \
                         64.94.110.11; \
                         127.0.0.0/8; \
                         ::1/128;fe80::/10;fe \
                         c0::/10;ff00::/8
# only the un-VERPed bounce addresses are handled
senders = "*-bounces@*"
transport = mailman_verp_smtp]]></pre>

         <p>Addresses selected by this router should then be passed on to an SMTP transport that does VERP expansion.  This should be placed anywhere within the transport section:-</p>

         <pre># Mailman VERP envelope sender address formatting.  This seems not to use
# quoted-printable encoding of the address, but instead just replaces the
# '@' in the recipient address with '='.
#
mailman_verp_smtp:
  driver = smtp
# put recipient address into return_path
  return_path = \
    ${local_part:$return_path}+$local_part=$domain@${domain:$return_path}
# must restrict to one recipient at a time
  max_rcpt = 1
# Errors-To: may carry old return_path
  headers_remove = Errors-To
  headers_add = Errors-To: ${return_path}</pre>

         <p>Once this has been configured, Mailman can be set to not do VERP expansion on normal list deliveries - the VERP configuration should now look like:-</p>

         <pre>VERP_PASSWORD_REMINDERS      = 1
VERP_PERSONALIZED_DELIVERIES = 1
VERP_CONFIRMATIONS           = 1
VERP_DELIVERY_INTERVAL       = 0</pre>

         <p>If you have set personalisation on any list, this will still be handled, and VERPed, by Mailman.</p>

         <h3><a href="#index" id="virdom">Virtual domains</a></h3>

         <p>One approach to handling virtual domains is to use a separate Mailman installation for each virtual domain.  (Currently, this is the only way to have lists with the same name in different virtual domains handled by the same machine.)</p>

         <p>In this case, you must change the MM_HOME macro to something like this:-</p>

         <pre>MM_HOME=/virtual/${lc:$domain_data}/mailman</pre>

         <p>and modify the mm_domains domain list appropriately.</p>

         <h3><a href="#index" id="lispol">List policy management</a></h3>

         <p>Most list policy handling is done within Mailman using the Web GUI.  However some issues may be better handled by the MTA, especially matters of overall site policy (not just mailing list policy).  For example you may wish to do virus or spam scanning on incoming messages.</p>

         <p>In general you exclude outgoing list mail from any policy controls.  This is because outgoing list mail has already been through the policy controls on the way into the system. Additionally spam scanning (for example) is a machine intensive operation, and scanning a message that has already been scanned, and then replicated to many recipients, is going to be very expensive as well as ineffective.  For this reason you will normally have an accept clause early on in your ACLs that causes Mailman generated traffic to bypass the machine intensive checks.</p>

         <h4><a href="#index" id="conpol">Content scanning</a></h4>

         <p>I would recommend that mailing lists now scan for both spam and viruses on incoming mail - this is due to the potential for a compromised windows machine belonging to a subscriber managing to distribute unwanted content via the list.  This causes problems not only to the list reputation, but also to the list manager who will get many many bounces from subscribers who do content scanning on their own incoming mail.</p>

         <p>The best way to do this is using the <a href="https://duncanthrax.net/exiscan-acl/">exiscan</a> extension along with a virus scanner such as <a href="https://duncanthrax.net/exiscan-acl/">clam-av</a> and a spam content scanner such as <a href="https://spamassassin.apache.org/">SpamAssassin</a>. Configuring these is beyond the scope of this document, however Tim Jackson has a very good set of <a href="http://www.timj.co.uk/linux/Exim-SpamAndVirusScanning.pdf">PDF documentation</a> on integrating these.</p>

         <p>One thing to note is that if you add full SpamAssassin headers onto list messages this bulks up the messages significantly. These headers are also available to list subscribers, which might make it easier for someone malicious to work out how to evade your spam scanning strategy.  I would suggest that Spam headers are not added for Mailman incoming mail, or minimal (short) headers added, or that they are stripped somewhere.  However having minimal headers on means that you can, for example, moderate all messages which have a given spam rating (as well as bouncing messages with a very high rating).</p>

         <h4><a href="#index" id="incpol">Incoming message checks</a></h4>

         <p>You may wish to apply various checks to incoming messages to ensure that they are sane.  These may include:-</p>

         <ul>
            <li>DNSBL checks</li>
            <li>Header checks</li>
            <li>Sender callback verification</li>
         </ul>

         <p>However all of these do have some degree of false positive ratings.  You need to be aware of how much of your user base you may alienate by imposing too strict a set of controls, and balance that against the reduced amount of unwanted bulk mail.</p>

         <h4><a href="#index" id="mmapol">Mailman specific ACL checks</a></h4>

         <p>Lists should never receive bounce messages to the posting address unless the bounced message is either a forgery using the list address as the sender address, or the bouncing MTA is terminally broken.  In either of these cases we really are not interested in receiving the messages and can reject them at SMTP time with a clear conscience.  The ACL to do this (as part of the RCPT ACL) is:-</p>

         <pre># Reject bounce (null sender) messages to the list
deny message   = "Recipient never sends mail so cannot cause bounces"
     senders   = :
     domains   = +mm_domains
     condition = ${if exists{MM_LISTCHK} {yes}{no}}</pre>

         <p>Additionally other mailman addresses do not generate mail (as the envelope sender, although they may be mentioned in the header addresses.  The ACL is split into 2 so that it can be written without the local_part condition wrapping.</p>

         <pre># Reject bounce (null sender) messages to the list
deny message     = "Recipient never sends mail so cannot cause bounces"
     senders     = :
     domains     = +mm_domains
     local_parts = \N^.*-(admin|join|leave|owner|request)$\N
deny message     = "Recipient never sends mail so cannot cause bounces"
     senders     = :
     domains     = +mm_domains
     local_parts = \N^.*-(subscribe|unsubscribe)$\N</pre>

         <h4><a href="#index" id="smtune">SMTP callbacks</a></h4>

         <p>Exim's SMTP callback feature is an even more powerful way to detect bogus sender addresses than normal sender verification. They are specially useful for checking envelope sender addresses at RCPT time within SMTP, and have been to date the most effective single anti-SPAM measure (however it should be noted that CBV is hated vehemently by some mail admins, and does increase both latency and traffic, as well as theoretically being a means to set up a DDOS situation).</p>

         <p>It is recommended that SMTP Sender CBV is not carried out on messages to the Mailman bounce handlers, so that broken remote MTAs (specifcally ones which send bounces with something other than a null sender address) do not get excluded from being taken off mailing lists</p>

         <pre># Do callback verification unless Mailman incoming bounce
deny !local_parts = *-bounces : *-bounces+*
     !verify = sender/callout=30s,defer_ok</pre>

         <p>Callback verification can also be done on header addresses, but care should be taken not to reject messages unnecessarily, especially when the message is going to Mailman's bounce processor</p>

         <h3><a href="#index" id="lisver">List verification</a></h3>

         <p>This is how a set of address tests for the Exim lists look on a working system.  The list in question is testlist@list.example.com, and these commands were run on the list.example.com mail server ("% "indicates the Unix shell prompt):</p>

         <pre>% exim -bt testlist@list.example.com
testlist@list.example.com
router = mailman_router, transport = mailman_transport

% exim -bt testlist-request@list.example.com
testlist-request@list.example.com
router = mailman_router, transport = mailman_transport

% exim -bt testlist-bounces@list.example.com
testlist-bounces@list.example.com
router = mailman_router, transport = mailman_transport

% exim -bt testlist-bounces+luser=example.com@list.example.com
testlist-bounces+luser=example.com@list.example.com
router = mailman_router, transport = mailman_transport</pre>

         <p>If your "exim -bt" output looks something like this, that's a start: at least it means Exim will pass the right messages to the right Mailman commands.  It by no means guarantees that your Exim/Mailman installation is functioning perfectly, though!</p>

         <h3><a href="#index" id="problem">Possible Problems</a></h3>

         <ul>
            <li> Mailman will send as many MAIL FROM/RCPT TO as it needs. It may result in more than 10 or 100 messages sent in one connection, which will exceed the default value of Exim's smtp_accept_queue_per_connection This is bad because it will cause Exim to switch into queue mode and severely delay delivery of your list messages.  The way to fix this is to set mailman's SMTP_MAX_SESSIONS_PER_CONNECTION (in ~mailman/Mailman/mm_cfg.py) to a smaller value than Exim's smtp_accept_queue_per_connection</li>

            <li>Mailman should ignore Exim delay warning messages, even though Exim should never send this to list messages.  Mailman 2.1's general bounce detection and VERP support should greatly improve the bounce detector's hit rates.</li>

            <li>List existence is determined by the existence of a config.pck file for a list.  If you delete lists by foul means, be aware of this.</li>

            <li>If you are getting Exim or Mailman complaining about user ids when you send mail to a list, check that the MM_UID and MM_GID match those of Mailman itself (i.e. what were used in the configure script). Also make sure you do not have aliases in the main alias file for the list.</li>

         </ul>

         <h3><a href="#index" id="dochis">Document History</a></h3>

         <ul>
            <li>Originally written by Nigel Metheringham.</li>
            <li>Updated by Marc Merlin for Mailman 2.1, Exim 4</li>
            <li>Overhauled/reformatted/clarified/simplified by Greg Ward.</li>
            <li>Rehashed again by Nigel Metheringham</li>
         </ul>

         <h4><a href="#index" id="doccha">Document Changes</a></h4>

         <ul>
            <li><b>14 June 2004</b> Originally written by Nigel Metheringham.</li>

            <li><b>28 June 2004</b> Fixed a problem with the Exim VERP transport which caused locally aliased recipient addresses to have incorrect VERP extensions added.  Followed posting to exim-users list by Arkadiusz Miskiewicz -- <i>Nigel Metheringham</i>.</li>
            <li><b>19 November 2004</b> Fixed previously unnoticed brainstorm where reject had been used as a ACL verb rather than deny.  Fixes to the VERP router/transport pair. -- <i>Nigel Metheringham</i></li>

         </ul>


         <h3><a href="#index" id="docfin">Final Word</a></h3>

         <p>Like many documents of this type, it has evolved and taken on contributions by many many helpful folks, mainly those on the Mailman and exim mailing lists.  To all of you, who have made contributions yet had their names shamefully lost by me, <i>Thank You</i>.</p>

      </xsl:template>
</xsl:stylesheet>

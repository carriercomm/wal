#!/usr/bin/perl
#
# snort2modsec2.pl
# based on original snort2modsec.pl code by Ivan Ristic <ivanr@webkreator.com>
#
# Updated code for modsec v2.0 rule language - Brian Rectanus and Ryan Barnett
# $Id: snort2modsec2.pl,v 1 2009/02/22 rcbarnett Exp $
#
# This script will convert Snort rules into the ModSecurity v2.0 
# rule format. Supply a list of files on the command line and
# it will write mod_security rules to the standard output.
#
# See http://www.modsecurity.org/documentation/converted-snort-rules.html
# for more information
use strict;

my $DEFAULT_ACTION = "phase:2,block,t:none,t:urlDecodeUni,t:htmlEntityDecode,t:normalisePathWin,capture,nolog,auditlog,logdata:'%{TX.0}'";

die("Usage: snort2modsec2.pl <snort rule files>\n") unless(@ARGV);

my $PM_DATA = "snort2modsec2_static.data";
my $DEBUG = $ENV{DEBUG} ? 1 : 0;

print "SecRule REQUEST_FILENAME \"!\@pmFromFile $PM_DATA\" \"phase:2,nolog,pass,t:none,t:urlDecodeUni,t:htmlEntityDecode,t:normalisePathWin,skipAfter:END_SNORT_RULES\"\n\n";
open(SNORT_DATA, ">$PM_DATA") or die("Failed to open $PM_DATA for writing");

for my $file (@ARGV) {

    open(RULES, $file) or die( "Cannot open file: $file\n" );
    my %snort_uris = ();

    my $line;
    LOOP: while($line = <RULES>) {
        next if ($line =~ /^\s*$/);
        next if ($line =~ /^#/);
        next unless ($line =~ /->\s+\$HTTP_SERVERS\s+\$HTTP_PORTS/);
        $line =~ s/\x0d?\x0a$//;

        print "# $line\n# \n" if ($DEBUG);

        if ($line =~ /\((.*)\)/) {
            my $action = $1;
            my $uricontent = "";
            my $msg = "";
            my $classtype = "";
            my $reference = "";
            my $sid = "";
            my $arg = "";
            my $rev = "";
            my @rawuricontent = ();
            my @uricontent = ();
            my @content = ();
            my @pcre = ();

            # ENH: What if ";\s+" is in quotes???
            for my $rule (split(/;\s+/, $action)) {

                print "# $rule\n" if ($DEBUG);

                # URI filename and arg
                if ($rule =~ /^uricontent:\s*"(.*)\?(.*)="/) {
                    $uricontent = $1;
                    $arg = $2;
                }
                # URI filename with args, but args ignored
                elsif ($rule =~ /^uricontent:\s*"(.*)\?"/) {
                    $uricontent = $1;
                }
                # URI arg only
                elsif ($rule =~ /^uricontent:\s*"(.*)="/) {
                    $arg = $1;
                }
                # URI filename extension
                elsif ($rule =~ /^uricontent:\s*"(.*\.\w{3,4})"/) {
                    $uricontent = $1;
                }
                # URI content
                elsif ($rule =~ /^uricontent:\s*"(.*)"/) {
                    push @rawuricontent, $1;
                }
                # MSG
                elsif ($rule =~ /^msg:\s*"(.*)"/) {
                    $msg = $1;
                }
                # CLASSTYPE
                elsif ($rule =~ /^classtype:\s*(.*)/) {
                    $classtype = $1;
                }
                # SID
                elsif ($rule =~ /^sid:\s*(\d+)/) {
                    $sid = $1;
                }
                # REFERENCE
                elsif ($rule =~ /^reference:(.*)/) {
                    $reference = $1;
                }
                # REV
                elsif ($rule =~ /^rev:\s*(\d+)/) {
                    $rev = $1;
                }
                # PCRE
                elsif ($rule =~ /^pcre:\s*"\/(.*)\/[UiRGmB]{0,4}"/) {
                    my $re = $1;

                    # Escape double quotes
                    $re =~ s/\\?"/\\x22/g;

                    push @pcre, $re;
                }
                # CONTENT used where uricontent should have been used
                elsif ($rule =~ /^content:\s*"((?:GET|HEAD|POST|PUT|OPTIONS|DELETE|TRACE|CONNECT) .*)"/) {
                    push @rawuricontent, $1;
                }
                # CONTENT
                elsif ($rule =~ /^content:\s*\"(.*)\"/) {
                    push @content, $1;
                }
            }

        
            # decode URL decoding
            decode_url2c(\$uricontent);
            if ($uricontent ne "") {
                $snort_uris{$uricontent}++;
            }
            decode_hex(\$uricontent);

            # Do a quick check to see if this uricontent may be a prequalifier
            # TODO: Make this a prequalifier in modsec rule as well?
            for my $uc (@rawuricontent) {
                decode_url2c(\$uc);
                if (grep /\b\Q$uc\E\b/, @pcre) {
                    if ($DEBUG) {
                        print "# uricontent='$uc' - ignoring pcre prequalifier\n";
                    }
                }
                else {
                    push @uricontent, $uc;
#                    if ($DEBUG) {
#                        print "# uricontent='$uc' - prepending to content check\n";
#                    }
#                    unshift @content, $uc;
                }
            }
    
            for (@content) {
                decode_url2c(\$_);
                decode_hex(\$_);
            }

            if ($DEBUG) {
                print "# \n# uricontent=$uricontent\n# arg=$arg\n".
                "# uricontent={".
                (@uricontent?"'".join("','",@uricontent)."'":"").
                "}\n".
                "# content={".
                (@content?"'".join("','",@content)."'":"").
                "}\n".
                "# pcre={".
                (@pcre?"'".join("','",@pcre)."'":"").
                "}\n".
                "# \n";
            }
            print "# (sid $sid) $msg";
            #if ($reference ne "") {
            #    print ", $reference";
            #}
            print "\n";


            my $joint = "";
            my $action = $DEFAULT_ACTION;
            my $finalaction = "ctl:auditLogParts=+E";
            my $meta = "";
            if (!($sid eq "")) {
                $meta = "id:sid$sid";
                if (!($rev eq "")) {
                    $meta .= ",rev:$rev";
                }
            }
            if ($msg ne "") {
                $msg = escape_msg(\$msg);
                $meta .= ",msg:'$msg'";
            }
            if ($classtype ne "") {
                $meta .= ",tag:'$classtype'";
            }
            if ($reference ne "") {
                $meta .= ",tag:'$reference'";
            }
            if ($classtype eq "web-application-activity") {
                $action = "phase:2,pass,t:none,t:urlDecodeUni,t:htmlEntityDecode,t:normalisePathWin,capture,nolog,auditlog,logdata:'%{TX.0}'";
            }
            if ($meta ne "") {
                $joint = "$action,$meta";
                $finalaction = ($finalaction ne "" ? "$finalaction," : "") . "setvar:'tx.msg=$msg',setvar:tx.anomaly_score=+20,setvar:'tx.%{rule.id}-WEB_ATTACK-%{matched_var_name}=%{matched_var}'";
            }

            my @items = ();

            if ($uricontent ne "") {
                push @items, "SecRule REQUEST_URI_RAW \"(?i:\Q$uricontent\E)\"";
            }

            if ($arg ne "" and !((!@content and @pcre) or (@content and !@pcre))) {
                # Unsure if the arg has a content/pcre
                push @items, "SecRule ARGS_NAMES \"(?i:\Q$arg\E)\"";
            }

            if (@uricontent) {
                # Use @contains if there is no escaped bytes
                push @items, map { "SecRule REQUEST_URI_RAW \"".(/\\x[0-9a-fA-F]{2}/?"(?i:$_)":"\@contains $_")."\"" } @uricontent;
            }

            if (@content and !@pcre and $arg ne "") {
                # The content probably goes against the arg
                push @items, map { "SecRule ARGS:$arg \"".(/\\x[0-9a-fA-F]{2}/?"(?i:\Q$_\E)":"\@contains $_")."\"" } @content;
            }
            elsif (@content) {
                push @items, map { "SecRule QUERY_STRING|REQUEST_BODY \"".(/\\x[0-9a-fA-F]{2}/?"(?i:\Q$_\E)":"\@contains $_")."\"" } @content;
            }

            if (!@content and @pcre and $arg ne "") {
                # The pcre probably goes against the arg
                push @items, map { "SecRule ARGS:$arg \"(?i:$_)\"" } @pcre;
		#push @items, map { "SecRule \&TX:\'\/WEB_ATTACK.*ARGS:$arg\/\' \"\@gt 0\"" } @pcre;
            }
            elsif (@pcre) {
                push @items, map { "SecRule QUERY_STRING|REQUEST_BODY \"(?i:$_)\"" } @pcre;
            }

            my $first = shift @items;
            if ($first) {
                if (@items) {
                    print "$first \"".(@items?"chain,":"")."$joint\"\n";
                }
                else {
                    print "$first \"".(@items?"chain,":"")."$joint,$finalaction\"\n";
                }
            }
            else {
                print "# Unable to parse rule\n";
            }

            if(@items) {
                print join(" \"chain\"\n", @items)." \"$finalaction\"\n";
            }

            print "\n\n";
       }
    }

    # Write out all the static URI data
    print SNORT_DATA join("\n", sort keys %snort_uris);
}

close(RULES);
close(SNORT_DATA);

print "SecMarker END_SNORT_RULES\n";

sub escape_msg {
    my $ref = shift;
    # escape quotes
    $$ref =~ s/\\?['"]/\\'/g;
    # unescape others
    $$ref =~ s/\\[:]/:/g;
    return $$ref;
}

sub decode_hex {
    my $ref = shift;
    $$ref =~ s/(\\?)\|(([0-9a-fA-F]{2})(\s+[0-9a-fA-F]{2})*)\1\|/join('', map { "\\x$_" } split(\/\s+\/, $2))/ge;
    return $$ref;
}

sub decode_url2c {
    my $ref = shift;
    $$ref =~ s/%([0-9a-fA-F]{2})/\\x$1/sg;
    return $$ref;
}


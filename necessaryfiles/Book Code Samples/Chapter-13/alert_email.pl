#!/usr/bin/perl
use String::ShellQuote qw(shell_quote);

my $DATE = `/bin/date`;
chomp($DATE);
my $HOSTNAME = `/bin/hostname`;
chomp($HOSTNAME);
my $TO = 'YOUREMAIL@ADDRESS.COM';
my $FROM = '"ModSecurity Alert" <www@'.$HOSTNAME.'>';
my $SUBJECT = "[ModSecurity Alert] Attack From: 
" .esc_subj($ENV{msg})." for \"" .esc_subj($ENV{REQUEST_LINE})."\"";

  open(MAIL, "|-", "/usr/sbin/sendmail", "-t", "-oi");
    print MAIL "To: $TO\n";
    print MAIL "From: $FROM\n";
    print MAIL "Subject: $SUBJECT\n";
    print MAIL "\n";
  print MAIL "______________________________________________________\n";
  foreach $var (sort(keys(%ENV))) {
    $val = $ENV{$var};
    $val =~ s|\n|\\n|g;
    $val =~ s|"|\\"|g;
    print MAIL "${var}=\"${val}\"\n";
}

  print MAIL "_______________________________________________________\n";
  close(MAIL);
  print "0";


sub esc_subj {
    my @bytes = split //, "@_";
    my $n = 0;
    my $str = "";

    for my $b (@bytes) {
        $b =~ s/(\t)/\\t/sg;
        $b =~ s/(\x0d)/\\r/sg;
        $b =~ s/(\x0a)/\\n/sg;
        $b =~ s/([^[:print:]])/sprintf("\\x%02x", ord($1))/sge;
        $str .= $b;
        if (length($str) >= 50) {
            last;
        }
    }

    return $str;
}


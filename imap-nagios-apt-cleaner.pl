#!/usr/bin/env perl
use warnings;
use strict;
use Term::ReadKey;
use Net::IMAP::Client;
use List::Util "first";


my $srv = 'imap.gmail.com';
my $user = 'erdnaxeli';
my $passwd = ''; # if blank, the password will be asked

my $nagiosMail = 'nagios@iiens.net';

my @critical;
my @ok;

if (!$passwd) {
	print 'passwd for '.$user.'@'.$srv.': ';
	ReadMode 'noecho';
	$passwd = <stdin>;
	ReadMode 'restore';
	chomp $passwd;
    print "\n";
}

my $imap = Net::IMAP::Client->new(
		server => $srv,
		user   => $user,
		pass   => $passwd,
		ssl    => 1,
		port   => 993
	) or die "Could not connect to IMAP server";

$imap->login or
	die('Login failed: ' . $imap->last_error);

$imap->select('INBOX');
my $msgsID = $imap->search('FROM "'.$nagiosMail.'" UNSEEN');
my $msgs = $imap->get_summaries($msgsID);

foreach (@{$msgs}) {
    if ($_->subject =~ m#PROBLEM alert . - (.*)/APT is CRITICAL#) {
        push (@critical, {'host' => $1, 'id' => $_->uid});
    }
    elsif ($_->subject =~ m#RECOVERY alert . - (.*)/APT is OK#) {
        push (@ok, {'host' => $1, 'id' => $_->uid});
    }
}


my $offset = 0;

foreach my $i (0..$#ok) {
    $i -= $offset;
    last if ($i < 0);

    my $j = 0;
    $j++ until ($j > $#critical || $critical[$j]->{'host'} eq $ok[$i]->{'host'});

    if ($j <= $#critical) {
        $imap->store($ok[$i]->{'id'}, '\\Seen');
        $imap->store($critical[$j]->{'id'}, '\\Seen');

        splice(@ok, $i, 1);
        splice(@critical, $j, 1);
        $offset++;
    }

}

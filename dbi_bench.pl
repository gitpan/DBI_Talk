#!perl -w
use strict;
use DBI;
use Benchmark qw(cmpthese);

my @values = (1..500);

my $dbh = DBI->connect('dbi:ODBC:dbi_talk_demo', '', '', { RaiseError => 1 });

my $del = $dbh->prepare("DELETE FROM prices WHERE prod_id >= 'ZZZ'");

sub literal_do_test {
    foreach my $v (@values) {
        $dbh->do("INSERT INTO prices (prod_id, price) VALUES ('ZZZ$v', 0)");
    }
}

sub placeholder_prepare_test {
    my $sth = $dbh->prepare("INSERT INTO prices (prod_id, price) VALUES (?, 0)");
    foreach my $v (@values) {
        $sth->execute("ZZZ$v");
    }
}


cmpthese( 4, {
  str_do	=> sub { $del->execute; literal_do_test()		},
  ph_prep	=> sub { $del->execute; placeholder_prepare_test()	},
});

$del->execute;
$dbh->disconnect;







# print "\nDone. Press return to exit.\n"; <>;



# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use ExtUtils::testlib;

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use WWW::Search::Excite;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $iTest = 2;

my $sEngine = 'Deja';
my $oSearch = new WWW::Search($sEngine);
print ref($oSearch) ? '' : 'not ';
print "ok $iTest\n";
# $oSearch->{debug} = 9;

use WWW::Search::Test;

# Now test the groups- and date-limited search:
$oSearch->native_query('learning+five',
                       {
                        'fromdate' => 'Jan+1+1999',
                        'todate' => 'Feb+1+1999',
                        'groups' => 'rec.juggling',
                        'defaultOp' => 'AND',
                       }
                      );
@aoResults = $oSearch->results();
# First just make sure we got the right results:
$iTest++;
$iResults = scalar(@aoResults);
# print STDERR " $iResults juggling results\n";
if ((0 < $iResults) && ($iResults < 10))
  {
  print "ok $iTest\n";
  }
else
  {
  print "not ok $iTest\n";
  }
# Now make sure we got titles:
$iTest++;
$iOK = 1;
foreach my $oResult (@aoResults)
  {
  $iOK = 0 unless $oResult->title ne '';
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n";
# Now make sure we got forums & authors:
$iTest++;
$iOK = 1;
foreach my $oResult (@aoResults)
  {
  $iOK = 0 unless $oResult->description ne '';
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n";
# Now make sure we got dates:
$iTest++;
$iOK = 1;
foreach my $oResult (@aoResults)
  {
  $iOK = 0 unless $oResult->change_date ne '';
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n";

# This test returns no results (but we should not get an HTTP error):
$iTest++;
$oSearch->native_query($WWW::Search::Test::bogus_query);
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if (0 < $iResults)
  {
  print "not ok $iTest\n";
  }
else
  {
  print "ok $iTest\n";
  }

# This query returns 1 page of results:
$iTest++;
$oSearch->native_query('irov'.'er');
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if ((2 <= $iResults) && ($iResults <= 99))
  {
  print "ok $iTest\n";
  }
else
  {
  print "not ok $iTest\n";
  }

# This query returns 2 pages of results:
$iTest++;
$oSearch->native_query('L'.'ili AND Le'.'dy');
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if ((101 <= $iResults) && ($iResults <= 199))
  {
  print "ok $iTest\n";
  }
else
  {
  print "not ok $iTest\n";
  }

# This query returns 3 pages of results:
$iTest++;
$oSearch->native_query('Jabb'.'a');
$oSearch->maximum_to_retrieve(209);
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if (201 <= $iResults)
  {
  print "ok $iTest\n";
  }
else
  {
  print "not ok $iTest\n";
  }


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use ExtUtils::testlib;

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use WWW::Search::Deja;
use WWW::Search::Dejanews;
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
print "ok $iTest\n"; # 2
# $oSearch->{debug} = 9;

use WWW::Search::Test;

my $iDebug = 0;

# Now test the groups- and date-limited search:
my $sQuery = 'learning five';
$oSearch->native_query(WWW::Search::escape_query($sQuery),
                       {
                        'fromdate' => 'Apr+1+2000',
                        'todate' => 'May+1+2000',
                        'groups' => 'rec.juggling',
                        'defaultOp' => 'AND',
                        'search_debug' => $iDebug,
                       }
                      );
@aoResults = $oSearch->results();
# First just make sure we got the right results:
$iTest++;
$iResults = scalar(@aoResults);
# print STDERR " $iResults juggling results\n";
if ((10 < $iResults) && ($iResults < 20))
  {
  print "ok $iTest\n"; # 3
  }
else
  {
  print "not ok $iTest\n";
  print STDERR " --- got $iResults results for $sQuery with date-range, expected 11..19\n";
  }
# Now make sure we got titles:
$iTest++;
$iOK = 0;
foreach my $oResult (@aoResults)
  {
  $iOK = 1 if $oResult->title ne '';
  if ($iDebug)
    {
    my $sDesc = $oResult->description || '';
    my $sTitle = $oResult->title || '';
    my $sCompany = $oResult->company || '';
    my $sLocation = $oResult->location || '';
    my $sSource = $oResult->source || '';
    printf " + %0.3d. %s\n", $i++, $oResult->url;
    printf "        upd=%s, len=%s, sco=%s\n", $oResult->change_date, $oResult->size, $oResult->score;
    print "        ttl=$sTitle\n";
    print "        dsc=$sDesc\n";
    print "        co.=$sCompany\n" if $sCompany ne '';
    print "        loc=$sLocation\n" if $sLocation ne '';
    print "        src=$sSource\n" if $sSource ne '';
    } # if
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n"; # 4
# Now make sure we got forums & authors:
$iTest++;
$iOK = 0;
foreach my $oResult (@aoResults)
  {
  $iOK = 1 if $oResult->description ne '';
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n"; # 5
# Now make sure we got dates:
$iTest++;
$iOK = 0;
foreach my $oResult (@aoResults)
  {
  $iOK = 1 if $oResult->change_date ne '';
  } # foreach
print $iOK ? "ok $iTest\n" : "not ok $iTest\n"; # 6

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
  print "ok $iTest\n"; # 7
  }

# This query returns 1 page of results:
$iTest++;
my $sQuery = 'irover';
$oSearch->native_query(WWW::Search::escape_query($sQuery),
                       # { 'search_debug' => 2, },
                      );
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if ((2 <= $iResults) && ($iResults <= 99))
  {
  print "ok $iTest\n"; # 8
  }
else
  {
  print "not ok $iTest\n";
  print STDERR " --- got $iResults results for $sQuery, expected 2..99\n";
  }

# This query returns 2 pages of results:
$iTest++;
# print STDERR <<"ENDNOTE";
# NOTE: As of 2000-05-20, the following test is known to fail
# because www.deja.com has a portion of their database off-line.
# ENDNOTE
# print "skip $iTest\n";
my $sQuery = 'L'.'ili AND Le'.'dy';
$oSearch->native_query(WWW::Search::escape_query($sQuery),
                      );
@aoResults = $oSearch->results();
$iResults = scalar(@aoResults);
if ((101 <= $iResults) && ($iResults <= 199))
  {
  print "ok $iTest\n"; # 9
  }
else
  {
  print "not ok $iTest\n";
  print STDERR " --- got $iResults results for $sQuery, expected 101..199\n";
  }

# This query returns 3 pages of results:
$iTest++;
my $sQuery = 'Jabba';
$oSearch->native_query(WWW::Search::escape_query($sQuery),
                      );
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
  print STDERR " --- got $iResults results for $sQuery, expected 201..\n";
  }


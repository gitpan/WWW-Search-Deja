use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
              'NAME'	=> 'WWW::Search::Deja',
              'VERSION_FROM' => 'lib/WWW/Search/Dejanews.pm', # finds $VERSION
              'PREREQ_PM' => {
                              'WWW::Search' => 2.09,
                             },
             );


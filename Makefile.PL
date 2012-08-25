use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'AvatarsIO',
    AUTHOR              => q{Jiin <jiin@queeply.com>},
    VERSION_FROM        => 'lib/AvatarsIO.pm',
    ABSTRACT_FROM       => 'lib/AvatarsIO.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'AvatarsIO-*' },
);

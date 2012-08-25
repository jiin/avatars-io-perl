#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'AvatarsIO' ) || print "Bail out!\n";
}

diag( "Testing AvatarsIO $AvatarsIO::VERSION, Perl $], $^X" );

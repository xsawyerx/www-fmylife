#!perl

# testing members functionality
# currently testing initializer-level, without mocking LWP

use strict;
use warnings;

use Test::More tests => 7;
use WWW::FMyLife;

# TODO: mock LWP in order to check this
my $fml = WWW::FMyLife->new( {
    username => 'haim',
    password => 'moshe',
} );

ok( $fml->token(), 'We got a token on initialize' );
$fml->token('');
is( $fml->token(), '', 'Clearing token' );
# placeholder for checking runtime-level
# (perhaps using an attribute trigger)
$fml = WWW::FMyLife->new();
$fml->username('user');
$fml->password('pass');
ok( $fml->token(), 'We got a token on runtime' );
$fml->token('');
is( $fml->token(), '', 'Clearing token' );

# checking runtime credentials
$fml = WWW::FMyLife->new();
$fml->credentials( 'foo', 'bar' );
is( $user, 'foo', 'Credentials for user set' );
is( $pass, 'bar', 'Credentials for pass set' );
ok( $fml->token(), 'Clearing token' );


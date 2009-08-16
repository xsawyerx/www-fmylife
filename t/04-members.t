#!perl

# testing members functionality
# currently testing initializer-level, without mocking LWP
# TODO:
# - IO::Prompt should return terminal correctly once timeout is reached
# - IO::Prompt should not show password entered
# - need to implement connect() method
# - finish trying out this test script

use strict;
use warnings;
use WWW::FMyLife;
use IO::Prompt;
use English '-no_match_vars';

use Test::More tests => 8;

SKIP: {
    my ( $username, $password );
    eval {
        local $SIG{'ALRM'} = sub { die "input failed\n"; };

        alarm 10;

        print STDERR "\nFor this test, we need a username and password.\n" .
                     "(timeout is 10 seconds or just press enter twice)\n";

        $username = prompt 'Username: ';
        $password = prompt 'Password: ';

        alarm 0;
    };

    chomp $username, $password;
    if ( ( $EVAL_ERROR eq "input failed\n" ) ||
         ( !$username && !$password ) ) {
        skip "Alright, nevermind...\n", 8;
    }

    # TODO: mock LWP in order to check this
    my $fml = WWW::FMyLife->new( {
        username => $username->{'value'},
        password => $password->{'value'},
    } );

    ok( $fml->token(), 'We got a token on initialize' );

    $fml->token('');
    is( $fml->token(), '', 'Clearing token' );

    # placeholder for checking runtime-level
    # (perhaps using an attribute trigger)
    $fml = WWW::FMyLife->new();
    $fml->username( $username->{'value'} );
    $fml->password( $password->{'value'} );
    ok( $fml->connect(), 'Connecting successfully' );
    ok( $fml->token(), 'We got a token on runtime' );

    $fml->token('');
    is( $fml->token(), '', 'Clearing token' );

    # checking runtime credentials
    $fml = WWW::FMyLife->new();
    $fml->credentials( 'foo', 'bar' );
    is( $fml->username, 'foo', 'Credentials for user set' );
    is( $fml->password, 'bar', 'Credentials for pass set' );
    ok( $fml->token(), 'Got token after setting credentials' );
}


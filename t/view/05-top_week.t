#!perl

# checking usage of 'top_week' method

use strict;
use warnings;
use WWW::FMyLife;

use Test::More tests => 122;

SKIP: {
    eval 'use Net::Ping';
    $@ && skip 'Net::Ping required for this test' => 122;

    my $p = Net::Ping->new('syn', 2);

    if ( ( ! $p->ping('google.com') ) && ( ! $p->ping('yahoo.com') ) ) {
        $p->close;
        skip q{Both Google and Yahoo down? most likely you're offline} => 122;
    }

    $p->close;
    my $fml      = WWW::FMyLife->new();
    my @top_week = $fml->top_week();

    cmp_ok( scalar @top_week, '==', 15, 'Got top_week 15 items' );
    foreach my $top (@top_week) {
        isa_ok( $top, 'WWW::FMyLife::Item', 'Item is an object' );
    }

    # checking one of the items
    my $item       = shift @top_week;
    my @attributes = qw(
        author category date agree deserved text
    );

    isa_ok( $item, 'WWW::FMyLife::Item' );

    foreach my $attribute (@attributes) {
        ok( $item->$attribute, "Item has $attribute" );
    }

    if ( $item->comments_flag ) {
        ok( $item->comments, 'Item has comments' );
    } else {
        ok( ! $item->comments, 'Item does not have comments' );
    }

    # types of getting the items
    my @format_types = ( qw( text object data ) );

    my %format_types = (
        text   => sub {
            is( ref \shift, 'SCALAR', 'Item (as flat) is a string of text' )
        },
        object => sub {
            isa_ok( shift, 'WWW::FMyLife::Item', 'Item is an object' )
        },
        data   => sub {
            is( ref shift, 'HASH', 'Item is a hashref' );
        },
    );

    while ( my ( $format, $type_check ) = each %format_types ) {
        my %check_types = (
            'Testing with formating only'     => { as => $format            },
            'Testing with formating and page' => { as => $format, page => 2 },
        );

        foreach my $check_type ( keys %check_types ) {
            diag("$check_type :: $format");

            @top_week = $fml->top_week( $check_types{$check_type} );
            cmp_ok( scalar @top_week, '==', 15, 'Got top 15 items' );

            foreach my $top (@top_week) {
                $type_check->($top);
            }
        }
    }


    SKIP: {
        eval 'use Test::MockObject::Extends';
        $@ && skip 'Test::MockObject required for this test', 2;

        my $agent    = $fml->agent();
        my $mock_obj = Test::MockObject::Extends->new( $fml->agent() );

        $mock_obj->mock( 'is_success', sub { 1 } );
        $mock_obj->mock(
            'decoded_content',
            sub {
                '<root><pages>2</pages></root>'
            }
        );

        $mock_obj->mock(
            'post',
            sub {
                my $asked_url  = $_[1];
                my $needed_url = 'http://api.betacie.com/view/top/3';
                is( $asked_url, $needed_url, 'Asking for pages correctly' );
                return $mock_obj;
        } );

        $fml->top_week(3);
        $fml->top_week( { page => 3 } );
    }
}


#!perl

# checking usage of 'top_day' method
# top_day does not have the page parameter

use strict;
use warnings;
use WWW::FMyLife;

use Test::More tests => 64;

SKIP: {
    eval 'use Net::Ping';
    $@ && skip 'Net::Ping required for this test' => 64;

    my $p = Net::Ping->new('syn', 2);

    if ( ( ! $p->ping('google.com') ) && ( ! $p->ping('yahoo.com') ) ) {
        $p->close;
        skip q{Both Google and Yahoo down? most likely you're offline} => 122;
    }

    $p->close;
    my $fml     = WWW::FMyLife->new();
    my @top_day = $fml->top_day();

    cmp_ok( scalar @top_day, '==', 15, 'Got top_day 15 items' );
    foreach my $top (@top_day) {
        isa_ok( $top, 'WWW::FMyLife::Item', 'Item is an object' );
    }

    # checking one of the items
    my $item       = shift @top_day;
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
        @top_day = $fml->top_day( { as => $format } );
        cmp_ok( scalar @top_day, '==', 15, 'Got top 15 items' );

        foreach my $top (@top_day) {
            $type_check->($top);
        }
    }
}


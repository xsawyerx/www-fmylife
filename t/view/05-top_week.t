#!perl

# checking usage of 'top_week' method
# top_week does not have the page parameter

use strict;
use warnings;
use WWW::FMyLife;

use Test::More;

SKIP: {
    eval 'use Net::Ping';
    $@ && plan skip_all => 'Net::Ping required for this test';

    my $p = Net::Ping->new('syn', 2);

    if ( ( ! $p->ping('google.com') ) && ( ! $p->ping('yahoo.com') ) ) {
        $p->close;
        plan skip_all =>
            q{Both Google and Yahoo down? most likely you're offline};
    }

    $p->close;
    my $fml     = WWW::FMyLife->new();
    my @top_week = $fml->top_week();

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
        @top_week = $fml->top_week( { as => $format } );

        foreach my $top (@top_week) {
            $type_check->($top);
        }
    }
}

done_testing();

#!perl

# checking usage of 'random' method

use strict;
use warnings;
use WWW::FMyLife;

use Test::More tests => 8;

SKIP: {
    eval 'use Net::Ping';
    $@ && skip 'Net::Ping required for this test' => 8;

    my $p = Net::Ping->new('syn', 2);

    if ( ( ! $p->ping('google.com') ) && ( ! $p->ping('yahoo.com') ) ) {
        $p->close;
        skip q{Both Google and Yahoo down? most likely you're offline} => 122;
    }

    $p->close;
    my $fml  = WWW::FMyLife->new();
    my $item = $fml->random();

    isa_ok( $item, 'WWW::FMyLife::Item', 'Item is an object' );

    # checking the item
    my @attributes = qw(
        author category date agree deserved text
    );

    foreach my $attribute (@attributes) {
        ok( $item->$attribute, "Item has $attribute" );
    }

    if ( $item->comments_flag ) {
        ok( $item->comments, 'Item has comments' );
    } else {
        ok( ! $item->comments, 'Item does not have comments' );
    }

}


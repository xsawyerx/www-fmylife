#!perl

# checking usage of 'last' method

use strict;
use warnings;
use WWW::FMyLife;

use Test::More tests => 43;

my $fml  = WWW::FMyLife->new();
my @last = $fml->last();

cmp_ok( scalar @last, '==', 15, 'Got last 15 items' );

# checking one of the items
my $item       = shift @last;
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

# types of getting the items

# flat array of items' text
@last = $fml->last( { as => 'text' } );
foreach my $last (@last) {
    # hoping this scalar is a string and not a number
    is( ref $last, 'SCALAR', 'Item (as flat) is a string of text' );
    # XXX: possible add test to check if it's a string? or minimum length?
}

# array of objects of items
@last = $fml->last( { as => 'object' } );
foreach my $last (@last) {
    isa_ok( $last, 'WWW::FMyLife::Item', 'Item is an object' );
}

# array of hashes of items
@last = $fml->last( { as => 'data' } );
foreach my $last (@last) {
    is( ref $last, 'HASH', 'Item is a hashref' );
}


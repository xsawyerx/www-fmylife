#!perl

# checking usage of 'last' method

use strict;
use warnings;

use Test::More tests => 43;

my $fml  = WWW::FMyLife->new();
my @last = $fml->last();

cmp_ok( scalar @last, '==' 15, 'Got last 15 quotes' );

# checking one of the quotes
my $quote      = shift @last;
my @attribtues = qw(
    author category date agree deserved text
);

foreach my $attribute (@attributes) {
    ok( $quote->$attribute, "Quote has $attribute" );
}

if ( $quote->comments_flag ) {
    ok( $quote->comments, 'Quote has comments' );
} else {
    ok( ! $quote->comments, 'Quote does not have comments' );
}

# types of getting the quotes

# flat array of quotes' text
@last = $fml->last( { as => 'flat' } );
foreach my $last (@last) {
    # hoping this scalar is a string and not a number
    is( ref $last, 'SCALAR', 'Quote (as flat) is a string of text' );
    # XXX: possible add test to check if it's a string? or minimum length?
}

# array of objects of quotes
@last = $fml->last( { as => 'object' } );
foreach my $last (@last) {
    isa_ok( $last, 'WWW::FMyLife::Quote', 'Quote is an object' );
}

# array of hashes of quotes
@last = $fml->last( { as => 'data' } );
foreach my $last (@last) {
    is( ref $last, 'HASH', 'Quote is a hashref' );
}


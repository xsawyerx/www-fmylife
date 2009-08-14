#!perl

# checking usage of 'last' method

use strict;
use warnings;

use Test::More tests => 8;

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


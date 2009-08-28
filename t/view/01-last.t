#!perl

# checking usage of 'last' method

use strict;
use warnings;
use WWW::FMyLife;

use Test::More tests => 122;

my $fml  = WWW::FMyLife->new();
my @last = $fml->last();

cmp_ok( scalar @last, '==', 15, 'Got last 15 items' );
foreach my $last (@last) {
    isa_ok( $last, 'WWW::FMyLife::Item', 'Item is an object' );
}

# checking one of the items
my $item       = shift @last;
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

while ( my ( $format_type, $type_check ) = each %format_types ) {
    my %check_types = (
        'Testing with formating only'     => { as => $format_type            },
        'Testing with formating and page' => { as => $format_type, page => 2 },
    );

    foreach my $check_type ( keys %check_types ) {
        diag("$check_type :: $format_type");

        @last = $fml->last( $check_types{$check_type} );
        cmp_ok( scalar @last, '==', 15, 'Got last 15 items' );

        foreach my $last (@last) {
            $type_check->($last);
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
            my $requested_url = $_[1];
            my $expected_url  = 'http://api.betacie.com/view/last/3';
            is( $requested_url, $expected_url, 'Asking for pages correctly' );
            return $mock_obj;
    } );

    TODO: {
        local $TODO = 'Pages not implemented yet';
        #'Testing with page as hash only'  => { page => 2                },
        #'Testing with page only'          => 3,
        $fml->last(3);
        $fml->last( { page => 3 } );
    }
}


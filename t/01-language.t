#!perl

use strict;
use warnings;

use Test::More tests => 5;

use_ok( 'WWW::FMyLife', 'Using WWW::FMyLife' );

my $fml = WWW::FMyLife->new();
is( $fml->language, 'en', 'default language is English' );

$fml->language('fr');
is( $fml->langauge, 'fr', 'can change language to French' );

$fml = WWW::FMyLife->new( { language => 'en' } );
is( $fml->language, 'en', 'Can set language on initialize to English' );

$fml = WWW::FMyLife->new( { language => 'fr' } );
is( $fml->language, 'en', 'Can set language on initialize to French' );


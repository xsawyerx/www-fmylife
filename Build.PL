use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name          => 'WWW::FMyLife',
    license              => 'perl',
    dist_author          => [
        q{Sawyer X <xsawyerx@cpan.org>},
        q{Tamir Lousky <tlousky@cpan.org>},
    ],
    dist_version_from    => 'lib/WWW/FMyLife.pm',
    build_requires       => {
        'Moose'          => 0.86,
        'Test::More'     => 0,
        'LWP::UserAgent' => 0,
    },
    recursive_test_files => 1,
    add_to_cleanup       => [ 'WWW-FMyLife-*' ],
    create_makefile_pl   => 'traditional',
    meta_add             => {
        bugtracker => 'http://github.com/xsawyerx/www-fmylife/tree/master',
        keywords   => [ 'fml', 'fmylife' ],
    },
);

$builder->create_build_script();

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::FMyLife',
    license             => 'perl',
    dist_author         => q{Sawyer X <xsawyerx@cpan.org>},
    dist_version_from   => 'lib/WWW/FMyLife.pm',
    build_requires => {
        'Test::More'     => 0,
        'LWP::UserAgent' => 0,
    },
    add_to_cleanup      => [ 'WWW-FMyLife-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

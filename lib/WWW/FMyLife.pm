package WWW::FMyLife;

use Moose;
use LWP::UserAgent;

our $VERSION = '0.01';

has 'username' => ( is => 'rw', isa => 'Str' );
has 'password' => ( is => 'rw', isa => 'Str' );
has 'language' => ( is => 'rw', isa => 'Str', default => 'en' );
has 'token'    => ( is => 'rw', isa => 'Str' );
has 'key'      => ( is => 'rw', isa => 'Str', default => 'readonly' );

has 'api_url' => (
    is      => 'rw',
    isa     => 'Str', # TODO type of uri
    default => 'http://api.betacie.com',
);

has 'agent' => (
    is      => 'rw',
    isa     => 'Object',
    default => sub { LWP::UserAgent->new(); },
);

# Credentials sub: sets username and password as an array
sub credentials {
    my ( $self, $user, $pass ) = @_;
    $self->username ( $user );
    $self->password ( $pass );
}

1;

__END__

=head1 NAME

WWW::FMyLife - Obtain FMyLife.com anectodes via API

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module fetches FMyLife.com (FML) anecdotes, comments, votes and more via API, comfortably.

    use WWW::FMyLife;

    my $fml    = WWW::FMyLife->new();
    print map { "Items: $_\n" } $fml->items();

    my @items = $fml->items( { as => 'objects' } );
    foreach my $item (@items) {
        my $i_id      = $item->id;
        my $i_content = $item->content;
        print "[$i_id] $i_content\n";
    }
    ...

=head1 EXPORT

This module exports nothing.

=head1 METHODS

=head2 credentials( $username, $password )

Sets credentials for members.

    $fml->credentials( 'foo', 'bar' );

    # the same as:
    $fml->username('foo');
    $fml->password('bar');

=head1 AUTHORS

Sawyer X (XSAWYERX), C<< <xsawyerx at cpan.org> >>
Tamir Lousky (TLOUSKY), C<< <tlousky at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-fmylife at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-FMyLife>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::FMyLife

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-FMyLife>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-FMyLife>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-FMyLife>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-FMyLife/>

=back


=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, Tamir Lousky.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


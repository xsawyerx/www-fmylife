package WWW::FMyLife;

use Moose;
use XML::Simple;
use LWP::UserAgent;
#use MooseX::Types::URI qw( Uri ); # this doesn't work for some reason
use WWW::FMyLife::Item;

our $VERSION = '0.02';

has 'username' => ( is => 'rw', isa => 'Str' );
has 'password' => ( is => 'rw', isa => 'Str' );

has 'language' => ( is => 'rw', isa => 'Str', default => 'en'       );
has 'token'    => ( is => 'rw', isa => 'Str', default => q{}        );
has 'key'      => ( is => 'rw', isa => 'Str', default => 'readonly' );

has 'pages'    => ( is => 'rw', isa => 'Int' );

has 'api_url'  => (
    is      => 'rw',
    isa     => 'Str', # suppose to be 'Uri' but doesn't work for some reason
    default => 'http://api.betacie.com',
);

has 'module_error' => (
    is      => 'rw',
    isa     => 'Str',
    clearer => 'clear_module_error',
);

has 'fml_errors'   => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    clearer => 'clear_fml_errors',
);

has 'error'        => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has 'agent'    => (
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

sub last {
    my ( $self, $opts ) = @_;
    my ( $as,   $page );

    if ( ref $opts eq 'HASH' ) {
        $as   = $opts->{'as'};
        $page = $opts->{'page'};
    } else {
        $page = $opts;
    }

    $as   ||= 'object';
    $page ||= 1;

    my %types = (
        object => sub { return $self->_parse_items_as_object(@_) },
        text   => sub { return $self->_parse_items_as_text  (@_) },
        data   => sub { return $self->_parse_items_as_data  (@_) },
    );

    my $res = $self->agent->post(
        $self->api_url . "/view/last/$page", {
            key      => $self->key,
            language => $self->language,
        },
    );

    $self->error(0);
    $self->clear_fml_errors;
    $self->clear_module_error;

    if ( ! $res->is_success ) {
        $self->error(1);
        $self->module_error( $res->status_line );
        return undef;
    }

    my $xml = XMLin( $res->decoded_content );

    if ( my $raw_errors = $xml->{'errors'}->{'error'} ) {
        my $array_errors =
            ref $raw_errors eq 'ARRAY' ? $raw_errors : [ $raw_errors ];

        $self->error(1);
        $self->fml_errors($array_errors);
        return undef;
    }

    $self->pages( $xml->{'pages'} );

    # return parsed last quotes
    my @items = $types{$as}->($xml);

    return @items;
}

sub _parse_items_as_object {
    my ( $self, $xml ) = @_;
    my @items;

    while ( my ( $id, $item_data ) = each %{ $xml->{'items'}{'item'} } ) {
        my $item = WWW::FMyLife::Item->new(
            id => $id,
        );

        foreach my $attr ( keys %{$item_data} ) {
            $item->$attr( $item_data->{$attr} );
        }

        push @items, $item;
    }

    return @items;
}

sub _parse_items_as_text {
    my ( $self, $xml ) = @_;
    my @items = map { $_->{'text'} } values %{ $xml->{'items'}{'item'} };
    return @items;
}

sub _parse_items_as_data {
    my ( $self, $xml ) = @_;
    my $itemsref       = $xml->{'items'}{'item'};
    my @items          = map +{ $_ => $itemsref->{$_} }, keys %{$itemsref};
    return @items;
}

1;

__END__

=head1 NAME

WWW::FMyLife - Obtain FMyLife.com anectodes via API

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

THIS MODULE IS STILL UNDER INITIAL DEVELOPMENT! BE WARNED!

This module fetches FMyLife.com (FML) anecdotes, comments, votes and more via API, comfortably.

    use WWW::FMyLife;

    my $fml    = WWW::FMyLife->new();
    print map { "Items: $_\n" } $fml->last();

    my @items = $fml->last();
    foreach my $item (@items) {
        my $item_id      = $item->id;
        my $item_content = $item->content;
        print "[$item_id] $item_content\n";
    }

    my @text_items = $fml->last( { as => 'text' } );
    print "Items:\n", join "\n", @text_items;
    ...


=head1 EXPORT

This module exports nothing.

=head1 METHODS

=head2 Working

Right now the only thing working and tested properly is the last() method

=head2 last()

Fetches the last quotes. Can accept a hashref that indicates the formatting:

    # returns an array of WWW::FMyLife::Item objects
    $fml->last();

    # or, more explicitly
    $fml->last( { as => 'object' } ); # same
    $fml->last( { as => 'text'   } ); # returns the anecdotes as array
    $fml->last( { as => 'data'   } ); # returns hashes with the data as array

You can only specify which page you want:

    # return 1st page
    my @last = fml->last();

    # return 5th page
    my @last = $fml->last(5);

    # same
    my @last = $fml->last( { page => 5 } );

And options can be mixed:

    my @not_so_last = $fml->last( { as => 'text', page => 50 } );

=head2 credentials( $username, $password ) (NOT YET FULLY IMPLEMENTED)

WARNING: THIS HAS NOT YET BEEN IMPLEMENTED.

THE TESTS HAVE BEEN DISABLED FOR NOW, PLEASE WAIT FOR A MORE ADVANCED VERSION.

Sets credentials for members.

    $fml->credentials( 'foo', 'bar' );

    # same thing
    $fml->username('foo');
    $fml->password('bar');

=head1 AUTHORS

Sawyer X (XSAWYERX), C<< <xsawyerx at cpan.org> >>
Tamir Lousky (TLOUSKY), C<< <tlousky at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-fmylife at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-FMyLife>.

You can also use the Issues Tracker on Github @ L<http://github.com/xsawyerx/www-fmylife/issues>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::FMyLife

You can also look for information at:

=over 4

=item * Our Github!

L<http://github.com/xsawyerx/www-fmylife/tree/master>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-FMyLife>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-FMyLife>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-FMyLife>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-FMyLife/>

=item * FML (FMyLife)

L<http://www.fmylife.com>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, Tamir Lousky.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


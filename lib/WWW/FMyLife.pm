package WWW::FMyLife;

use Moose;

our $VERSION = '0.01';

# Language attribute
has 'language' => ( is => 'rw', isa => 'Str', default => 'en' );

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
    print map { "Quote: $_\n" } $fml->quotes();

    my @quotes = $fml->quotes( { as => 'objects' } );
    foreach my $quote (@quotes) {
        my $q_id      = $quote->id;
        my $q_content = $quote->content;
        print "[$q_id] $q_content\n";
    }
    ...

=head1 EXPORT

This module exports nothing.

=head1 METHODS

=head2 quotes

Fetch all quotes, with possible hashref to indicate the format they return in.

=head2 top

Fetch all the top quotes.

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


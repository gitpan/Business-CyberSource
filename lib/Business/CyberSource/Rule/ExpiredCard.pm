package Business::CyberSource::Rule::ExpiredCard;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006003'; # VERSION

use Moose;
extends 'Business::CyberSource::Rule';

sub run {
	my ( $self, $request ) = @_;

	# if the request can card it's required so no need to check has
	return unless $request->can('card')
		&& blessed $request->card
		&& $request->card->can('is_expired')
		&& $request->card->is_expired
		;

	$self->debug if $self->client->debug;

	return { result => {
		merchantReferenceCode => $request->reference_code,
		decision              => 'REJECT',
		reasonCode            => '202',
		requestID             => 0,
		requestToken          => 0,
	}};
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Expired Card


__END__
=pod

=head1 NAME

Business::CyberSource::Rule::ExpiredCard - Expired Card

=head1 VERSION

version 0.006003

=head1 METHODS

=head2 run

returns a REJECT 202 if card is expired.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


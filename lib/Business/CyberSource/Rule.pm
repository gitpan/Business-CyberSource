package Business::CyberSource::Rule;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006004'; # VERSION

use Moose;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

use Class::Load qw( load_class );

requires 'run';


sub debug {
	my ( $self, $message ) = shift;

	load_class 'Carp';
	our @CARP_NOT = ( __PACKAGE__, blessed( $self->client ) );

	$message //= blessed( $self ) . ' matched';

	Carp::carp( $message );

	return 1;
}

has client => (
	isa      => 'Business::CyberSource::Client',
	is       => 'ro',
	required => 1,
	weak_ref => 1,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Rule Base


__END__
=pod

=head1 NAME

Business::CyberSource::Rule - Abstract Rule Base

=head1 VERSION

version 0.006004

=head1 METHODS

=head2 run

required by subclasses but not provided. Is executed to check your rule and
returns a suitable mock answer. C<request_id> should be set to 0 in the answer.

	return { result => {
		merchantReferenceCode => $request->reference_code,
		decision              => 'REJECT',
		reasonCode            => '202',
		requestID             => 0,
		requestToken          => 0,
	}

=head2 debug

carps out the rule that matched if client has debug set.

=head1 ATTRIBUTES

=head2 client

a weakened reference to the client, to check the clients debug state.

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


package Business::CyberSource::RequestPart::Service::Tax;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006003'; # VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

has nexus => (
	isa        => 'ArrayRef[Str]',
	is         => 'ro',
	traits     => ['Array'],
	serializer => sub {
		my ( $attr, $instance ) = @_;
		return join ' ', @{ $attr->get_value( $instance ) };
	},
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Tax Service

__END__
=pod

=head1 NAME

Business::CyberSource::RequestPart::Service::Tax - Tax Service

=head1 VERSION

version 0.006003

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


package Business::CyberSource::ResponsePart::DCCReply;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007002'; # TRIAL VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
);

use MooseX::Types::CyberSource qw( DCCSupported );

has dcc_supported => (
	isa         => DCCSupported,
	remote_name => 'dccSupported',
	is          => 'ro',
	coerce      => 1,
	required    => 1,
	predicate   => 'has_dcc_supported',
);

has margin_rate_percentage => (
	isa         => 'Num',
	remote_name => 'marginRatePercentage',
	is          => 'ro',
	required    => 1,
	predicate   => 'has_margin_rate_percentage',
);

has valid_hours => (
	isa         => 'Int',
	remote_name => 'validHours',
	is          => 'ro',
	required    => 1,
	predicate   => 'has_valid_hours',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Reply section for DCC

__END__

=pod

=head1 NAME

Business::CyberSource::ResponsePart::DCCReply - Reply section for DCC

=head1 VERSION

version 0.007002

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head2 WITH

=over

=item L<Business::CyberSource::Response::Role::ReasonCode>

=back

=head1 ATTRIBUTES

=head2 dcc_supported

B<Type:> C<Bool>

=head2 margin_rate_percentage

B<Type:> C<Num>

=head2 valid_hours

B<Type:> C<Int>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by HostGator.com.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

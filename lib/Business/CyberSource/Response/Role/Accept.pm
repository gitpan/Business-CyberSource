package Business::CyberSource::Response::Role::Accept;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::MerchantReferenceCode
);

use MooseX::Types::Moose         qw( Num Int );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C );


has amount => (
	required => 0,
	is       => 'ro',
	isa      => Num,
);

has datetime => (
	required => 0,
	is       => 'ro',
	isa      => DateTimeW3C,
);

has request_specific_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

1;

# ABSTRACT: role for handling accepted transactions


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Accept - role for handling accepted transactions

=head1 VERSION

version 0.004006

=head1 DESCRIPTION

If the transaction has a C<decision> of C<ACCEPT> then this Role is applied.

=head2 composes

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::MerchantReferenceCode>

=back

=head1 ATTRIBUTES

=head2 amount

=head2 datetime

=head2 request_specific_reason_code

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


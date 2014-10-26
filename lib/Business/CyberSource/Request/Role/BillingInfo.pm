package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;
use Carp;

our $VERSION = 'v0.2.5'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::Types::Varchar         qw( Varchar       );
use MooseX::Types::Email           qw( EmailAddress  );
use MooseX::Types::Locale::Country qw( Alpha2Country );
use MooseX::Types::NetAddr::IP     qw( NetAddrIPv4   );

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Customer\'s first name.The value should be the same as '
		. 'the one that is on the card.',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Customer\'s last name. The value should be the same as '
		. 'the one that is on the card.'
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	alias    => 'street1',
	documentation => 'First line of the billing street address as it '
		. 'appears on the credit card issuer\'s records. alias: C<street1>',
);

has street2 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Second line of the billing street address.',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
	documentation => 'City of the billing address.',
);

has state => (
	required => 0,
	alias    => 'province',
	is       => 'ro',
	isa      => Varchar[2],
	documentation => 'State or province of the billing address. '
		. 'Use the two-character codes. alias: C<province>',
);

has country => (
	required => 1,
	coerce   => 1,
	is       => 'ro',
	isa      => Alpha2Country,
	documentation => 'ISO 2 character country code '
		. '(as it would apply to a credit card billing statement)',
);

has zip => (
	required => 0,
	alias    => 'postal_code',
	is       => 'ro',
	isa      => Varchar[10],
	documentation => 'Postal code for the billing address. '
		. 'The postal code must consist of 5 to 9 digits. '
		. 'alias: C<postal_code>',
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => EmailAddress,
	documentation => 'Customer\'s email address, including the full domain '
		. 'name',
);

has ip => (
	required => 0,
	alias    => 'ip_address',
	coerce   => 1,
	is       => 'ro',
	isa      => NetAddrIPv4,
	documentation => 'Customer\'s IP address. alias: C<ip_address>',
);

sub _billing_info {
	my $self = shift;

	my $i = {
		firstName  => $self->first_name,
		lastName   => $self->last_name,
		street1    => $self->street1,
		street2    => $self->street2,
		city       => $self->city,
		country    => $self->country,
		email      => $self->email,
	};

	if ( $self->ip ) {
		$i->{ipAddress} = $self->ip->addr;
	}

	if ( $self->state ) {
		$i->{state} = $self->state;
	}

	if ( $self->zip ) {
		$i->{postalCode} = $self->zip,
	}

	return $i;
}

1;

# ABSTRACT: Role for requests that require "bill to" information

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BillingInfo - Role for requests that require "bill to" information

=head1 VERSION

version v0.2.5

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


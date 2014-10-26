package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004008'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::SetOnce 0.200001;


use MooseX::Types::Moose      qw( Int HashRef );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );
use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode _VarcharSixty );

use Moose::Util::TypeConstraints;

use Business::CreditCard qw( cardtype );

has credit_card => (
	required => 1,
	alias    => 'account_number',
	is       => 'ro',
	isa      => CreditCard,
	coerce   => 1,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{accountNumber} = $self->credit_card;
		$self->_request_data->{card}{cardType}      = $self->card_type;
	},
);

has card_type => (
	lazy      => 1,
	predicate => 'has_card_type',
	is        => 'ro',
	isa       => CardTypeCode,
	builder   => '_build_card_type',
);

has cc_exp_month => (
	required => 1,
	is       => 'ro',
	isa      => subtype( Int, where { length("$_") <= 2 }),
	alias    => [ qw( exp_month expiration_month ) ],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{expirationMonth} = $self->cc_exp_month;
	},
);

has cc_exp_year => (
	required => 1,
	is       => 'ro',
	isa      => subtype( Int, where { length("$_") <= 4 }),
	alias    => [ qw( exp_year expiration_year ) ],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{expirationYear} = $self->cc_exp_year;
	},
);

has cv_indicator => (
	init_arg => undef,
	lazy     => 1,
	is       => 'ro',
	isa      => CvIndicator,
	default  => sub {
		my $self = shift;
		if ( $self->has_cvn ) {
			return 1;
		} else {
			return 0;
		}
	},
);

has cvn => (
	isa       => CardSecurityCode,
	traits    => [ 'SetOnce' ],
	alias     => [ qw( cvv cvv2  cvc2 cid ) ],
	predicate => 'has_cvn',
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{card}{cvNumber} = $self->cvn;
		$self->_request_data->{card}{cvIndicator} = $self->cv_indicator;
	},
);

has full_name => (
	isa      => _VarcharSixty,
	traits   => [ 'SetOnce' ],
	is       => 'rw',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{fullName} = $self->full_name;
	},
);

sub _build_card_type {
	my $self = shift;

	my $ct = cardtype( $self->credit_card );

	my $code
		= $ct =~ /visa             /ixms ? '001'
		: $ct =~ /mastercard       /ixms ? '002'
		: $ct =~ /discover         /ixms ? '004'
		: $ct =~ /jcb              /ixms ? '007'
		: $ct =~ /enroute          /ixms ? '014'
		: $ct =~ /laser            /ixms ? '035'
		: $ct =~ /american\ express/ixms ? '003'
		:                                  undef
		;

	confess $ct . ' card_type was unable to be detected please define it manually'
		unless $code;

	return $code;
}

1;

# ABSTRACT: credit card info role


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::CreditCardInfo - credit card info role

=head1 VERSION

version 0.004008

=head1 ATTRIBUTES

=head2 card_type

Type of card to authorize, e.g. Visa, MasterCard

=head2 credit_card

Customer's credit card number

=head2 cvn

B<alias:> cvv cvv2  cvc2 cid

Card Verification Numbers

=head2 full_name

Full Name on the Credit Card

=head2 cc_exp_month

Two-digit month that the credit card expires in. Format: MM

=head2 cc_exp_year

Four-digit year that the credit card expires in. Format: YYYY

=head2 cv_indicator

Flag that indicates whether a CVN code was sent

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


package Business::CyberSource::Response;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load 'load';

our $VERSION = '0.009002'; # VERSION

use Moose;
extends 'Business::CyberSource::Message';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
);

use MooseX::Types::Common::String 0.001005 qw( NonEmptySimpleStr );
use MooseX::Types::CyberSource qw(
	Decision
	RequestID
	ResPurchaseTotals
	AuthReply
	Reply
	TaxReply
	DCCReply
);

use Moose::Util::TypeConstraints;

has '+reference_code' => ( required => 0 );

## common
has request_id => (
	isa         => RequestID,
	remote_name => 'requestID',
	is          => 'ro',
	predicate   => 'has_request_id',
	required    => 1,
);

has decision => (
	isa         => Decision,
	remote_name => 'decision',
	is          => 'ro',
	required    => 1,
);

has request_token => (
	isa         => subtype( NonEmptySimpleStr, where { length $_ <= 256 }),
	remote_name => 'requestToken',
	required    => 1,
	is          => 'ro',
);

has purchase_totals => (
	isa         => ResPurchaseTotals,
	remote_name => 'purchaseTotals',
	is          => 'ro',
	predicate   => 'has_purchase_totals',
	coerce      => 1,
	handles     => [ qw( currency ) ],
);


has auth => (
	isa         => AuthReply,
	remote_name => 'ccAuthReply',
	is          => 'ro',
	predicate   => 'has_auth',
	coerce      => 1,
);

has capture => (
	isa         => Reply,
	remote_name => 'ccCaptureReply',
	is          => 'ro',
	predicate   => 'has_capture',
	coerce      => 1,
);

has credit => (
	isa         => Reply,
	remote_name => 'ccCreditReply',
	is          => 'ro',
	predicate   => 'has_credit',
	coerce      => 1,
);

has auth_reversal=> (
	isa         => Reply,
	remote_name => 'ccAuthReversalReply',
	is          => 'ro',
	predicate   => 'has_auth_reversal',
	coerce      => 1,
);

has dcc => (
	isa         => DCCReply,
	remote_name => 'ccDCCReply',
	is          => 'ro',
	predicate   => 'has_dcc',
	coerce      => 1,
);

has tax => (
	isa         => TaxReply,
	remote_name => 'taxReply',
	is          => 'ro',
	predicate   => 'has_tax',
	coerce      => 1,
);

## built
has reason_text => (
	isa      => 'Str',
	required => 1,
	lazy     => 1,
	is       => 'ro',
	builder  => '_build_reason_text',
);

has is_accept => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'ACCEPT' ? 1 : 0;
	},
);

has is_reject => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'REJECT' ? 1 : 0;
	},
);

has is_error => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'ERROR' ? 1 : 0;
	}
);

sub _build_reason_text {
	my ( $self, $reason_code ) = @_;
	$reason_code //= $self->reason_code;

	my %reason = (
		100 => 'Successful transaction',
		101 => 'The request is missing one or more required fields',
		102 => 'One or more fields in the request contains invalid data',
		110 => 'Only a partial amount was approved',
		150 => 'General system failure',
		151 => 'The request was received but there was a server timeout.',
		152 => 'The request was received, but a service did not finish '
			. 'running in time'
			,
		200 => 'The authorization request was approved by the issuing bank '
			. 'but declined by CyberSource because it did not pass the '
			. 'Address Verification Service (AVS) check'
			,
		201 => 'The issuing bank has questions about the request. You do not '
			. 'receive an authorization code programmatically, but you might '
			. 'receive one verbally by calling the processor'
			,
		202 => 'Expired card. You might also receive this if the expiration '
			. 'date you provided does not match the date the issuing bank '
			. 'has on file'
			,
		203 => 'General decline of the card. No other information provided '
			. 'by the issuing bank'
			,
		204 => 'Insufficient funds in the account',
		205 => 'Stolen or lost card',
		207 => 'Issuing bank unavailable',
		208 => 'Inactive card or card not authorized for card-not-present '
			. 'transactions'
			,
		209 => 'American Express Card Identification Digits (CID) did not '
			. 'match'
			,
		210 => 'The card has reached the credit limit',
		211 => 'Invalid CVN',
		221 => 'The customer matched an entry on the processor\'s negative '
			. 'file'
			,
		230 => 'The authorization request was approved by the issuing bank '
			. 'but declined by CyberSource because it did not pass the CVN '
			. 'check'
			,
		231 => 'Invalid account number',
		232 => 'The card type is not accepted by the payment processor',
		233 => 'General decline by the processor',
		234 => 'There is a problem with your CyberSource merchant '
			. 'configuration'
			,
		235 => 'The requested amount exceeds the originally authorized '
			. 'amount'
			,
		236 => 'Processor failure',
		237 => 'The authorization has already been reversed',
		238 => 'The authorization has already been captured',
		239 => 'The requested transaction amount must match the previous '
			. 'transaction amount'
			,
		240 => 'The card type sent is invalid or does not correlate with '
			. 'the credit card number'
			,
		241 => 'The request ID is invalid',
		242 => 'You requested a capture, but there is no corresponding, '
			. 'unused authorization record'
			,
		243 => 'The transaction has already been settled or reversed',
		246 => 'The capture or credit is not voidable because the capture or '
			. 'credit information has already been submitted to your '
			. 'processor. Or, you requested a void for a type of '
			. 'transaction that cannot be voided'
			,
		247 => 'You requested a credit for a capture that was previously '
			. 'voided'
			,
		250 => 'The request was received, but there was a timeout at the '
			. 'payment processor'
			,
		600 => 'Address verification failed',
	);

	return $reason{$reason_code};
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Response Object

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::CyberSource::Response - Response Object

=head1 VERSION

version 0.009002

=head1 SYNOPSIS

	use Try::Tiny;

	my $response
		= try {
			$client->run_transaction( $request )
		}
		catch {
			if ( blessed $_
				&& $_->isa('Business::CyberSource::Response::Exception')
			) {
				if ( $_->is_error ) {
					# probably a temporary error on cybersources problem retry
				}
			}
			else {
				# log it and investigate
			}
		};

	if ( $response->is_accept ) {
		if ( $response->has_auth ) {
			# pass to next request or store
			$response->request_id;
			$response->reference_code;
		}
	}
	elsif ( $response->is_reject ) {
		# log it
		$response->request_id;
		$response->reason_text;
	}
	else {
		# throw exception
	}

=head1 DESCRIPTION

This response can be used to determine the success of a transaction,
as well as receive a follow up C<request_id> in case you need to do further
actions with this.

=head1 EXTENDS

L<Business::CyberSource::Message>

=head1 WITH

=over

=item L<Business::CyberSource::Role::RequestID>

=back

=head1 ATTRIBUTES

=head2 is_accept

boolean way of determining whether the transaction was accepted

=head2 is_reject

boolean way of determining whether the transaction was rejected

=head2 is_error

boolean way of determining whether the transaction was error. Note this is used
internally as a response that is an error will throw an exception.

=head2 decision

Summarizes the result of the overall request. This is the text, you can check
L<is_accept|/"is_accept">, L<is_reject|/"is_reject"> for a more boolean way.

=head2 reason_code

Numeric value corresponding to the result of the credit card authorization
request.

=head2 reason_text

official description of returned reason code.

I<warning:> reason codes are returned by CyberSource and occasionally do not
reflect the real reason for the error please inspect the
L<trace|Business::Cybersource::Message/"trace"> request/response for issues

=head2 request_token

Request token data created by CyberSource for each reply. The field is an
encoded string that contains no confidential information, such as an account
or card verification number. The string can contain up to 256 characters.

=head2 reference_code

B<Type:> Varying character 50

The merchant reference code originally sent

=head2 auth

	$response->auth if $response->has_auth;

B<Type:> L<Business::CyberSource::ResponsePart::AuthReply>

=head2 purchase_totals

	$response->purchase_totals if $response->has_purchase_totals;

B<Type:> L<Business::CyberSource::ResponsePart::PurchaseTotals>

=head2 capture

	$response->capture if $response->has_capture;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=head2 credit

	$response->credit if $response->has_credit;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=head2 auth_reversal

	$response->auth_reversal if $response->has_auth_reversal;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=head2 dcc

	$response->dcc if $response->has_dcc;

B<Type:> L<Business::CyberSource::ResponsePart::DCCReply>

=head2 tax

	$response->tax if $response->has_tax;

B<Type:> L<Business::CyberSource::ResponsePart::TaxReply>

=for test_synopsis my ( $request, $client );

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/business-cybersource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing <xenoterracide@gmail.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

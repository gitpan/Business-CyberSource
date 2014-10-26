package Business::CyberSource::Request::Credit;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.1.10'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	MooseX::Traits
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

has request_id => (
	is  => 'ro',
	isa => 'Str',
);

sub submit {
	my $self = shift;

	my $ret = $self->_build_soap_request;

	my $decision    = $ret->valueof('decision'  );
	my $request_id  = $ret->valueof('requestID' );
	my $reason_code = $ret->valueof('reasonCode');

	croak 'no decision from CyberSource' unless $decision;

	my $res;
	if ( $decision eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Credit
			})
			->new({
				request_id     => $request_id,
				decision       => $decision,
				reason_code    => $reason_code,
				reference_code => $ret->valueof('merchantReferenceCode'  ),
				request_token  => $ret->valueof('requestToken'           ),
				currency       => $ret->valueof('purchaseTotals/currency'),
				amount         => $ret->valueof('ccCreditReply/amount'     ),
				datetime       => $ret->valueof('ccCreditReply/requestDateTime'),
				credit_reason_code => $ret->valueof('ccCreditReply/reasonCode'),
				reconciliation_id  => $ret->valueof('ccCreditReply/reconciliationID'),
			})
			;
	}
	elsif ( $decision eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
				decision      => $decision,
				request_id    => $request_id,
				reason_code   => $reason_code,
				request_token => $ret->valueof('requestToken'),
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $decision;
	}

	return $res;
}

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;

	unless ( $self->request_id ) { # should probably introspec
		$sb = $self->_build_bill_to_info    ( $sb );
	}

	$sb = $self->_build_purchase_info   ( $sb );

	unless ( $self->request_id ) { # should probably introspec
		$sb = $self->_build_credit_card_info( $sb );
	}

	my $value = $self->request_id ? undef : ' ';

	my $credit = $sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccCreditService',
		value      => $value, # hack to prevent cs side unparseable xml
	);

	if ( $self->request_id ) {
		$sb->add_elem(
			name   => 'captureRequestID',
			value  => $self->request_id,
			parent => $credit,
		)
	}

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Credit - CyberSource Credit Request Object

=head1 VERSION

version v0.1.10

=head1 SYNOPSIS

	use Business::CyberSource::Request::Credit;

	my $req = Business::CyberSource::Request::Credit
		->with_traits(qw{
			BillingInfo
			CreditCardInfo
		})
		->new({
			username       => 'merchantID',
			password       => 'transaction key',
			production     => 0,
			reference_code => 'merchant reference code',
			first_name     => 'Caleb',
			last_name      => 'Cushing',
			street         => 'somewhere',
			city           => 'Houston',
			state          => 'TX',
			zip            => '77064',
			country        => 'US',
			email          => 'xenoterracide@gmail.com',
			total          => 5.00,
			currency       => 'USD',
			credit_card    => '4111-1111-1111-1111',
			cc_exp_month   => '09',
			cc_exp_year    => '2025',
		});

	my $res = $req->submit;

=head1 DESCRIPTION

This object allows you to create a request for a credit. Their are two types
of credits, a standalone credit, and a follow on credit.

=head1 METHODS

=head2 with_traits

For standalone credit requests requests you need to apply C<BillingInfo> and
C<CreditCardInfo> roles. This is not necessary for follow on credits. Follow
on credits require that you specify a C<request_id> in order to work.

=head2 new

Instantiates a credit request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 password

Reader: password

Type: Str

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 server

Reader: server

Type: MooseX::Types::URI::Uri

This attribute is required.

=head2 request_id

Reader: request_id

Type: Str

=head2 total

Reader: total

Type: Num

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

This attribute is required.

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

=head2 client_name

Reader: client_name

Type: Str

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 client_version

Reader: client_version

Type: Str

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

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


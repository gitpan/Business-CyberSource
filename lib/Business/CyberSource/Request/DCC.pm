package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.5'; # VERSION
}
use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response;

use SOAP::Lite; # +trace => [ 'debug' ] ;

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
			})
			->new({
				request_id     => $request_id,
				decision       => $decision,
				reason_code    => $reason_code,
				currency       => $ret->valueof('purchaseTotals/currency'),
				datetime       => $ret->valueof('ccCaptureReply/requestDateTime'),
				amount         => $ret->valueof('ccCaptureReply/amount'  ),
				reference_code => $ret->valueof('merchantReferenceCode'  ),
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

	$sb = $self->_build_purchase_info   ( $sb );
	$sb = $self->_build_credit_card_info( $sb );

	$sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccDCCService',
		value      => ' ',
	);

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object

__END__
=pod

=head1 NAME

Business::CyberSource::Request::DCC - CyberSource DCC Request Object

=head1 VERSION

version v0.1.5

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

This attribute is required.

=head2 currency

Reader: currency

Type: Str

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

=head2 cvn

Reader: cvn

Type: Int

=head2 total

Reader: total

Type: Num

=head2 cc_exp_month

Reader: cc_exp_month

Type: Int

This attribute is required.

=head2 username

Reader: username

Type: Str

This attribute is required.

Additional documentation: your merchantID

=head2 cc_exp_year

Reader: cc_exp_year

Type: Int

This attribute is required.

=head2 credit_card

Reader: credit_card

Type: Str

This attribute is required.

=head2 reference_code

Reader: reference_code

Type: Str

This attribute is required.

=head2 client_name

Reader: client_name

Type: Str

This attribute is required.

=head2 foreign_currency

Reader: foreign_currency

Type: Str

=head2 client_version

Reader: client_version

Type: Str

This attribute is required.

=head1 METHODS

=head2 client_env

Method originates in Business::CyberSource::Request::DCC.

=head2 password

Method originates in Business::CyberSource::Request::DCC.

=head2 server

Method originates in Business::CyberSource::Request::DCC.

=head2 new

Method originates in Business::CyberSource::Request::DCC.

=head2 cvn

Method originates in Business::CyberSource::Request::DCC.

=head2 cc_exp_month

Method originates in Business::CyberSource::Request::DCC.

=head2 total

Method originates in Business::CyberSource::Request::DCC.

=head2 username

Method originates in Business::CyberSource::Request::DCC.

=head2 credit_card

Method originates in Business::CyberSource::Request::DCC.

=head2 cid

Method originates in Business::CyberSource::Request::DCC.

=head2 reference_code

Method originates in Business::CyberSource::Request::DCC.

=head2 submit

Method originates in Business::CyberSource::Request::DCC.

=head2 currency

Method originates in Business::CyberSource::Request::DCC.

=head2 cvc2

Method originates in Business::CyberSource::Request::DCC.

=head2 production

Method originates in Business::CyberSource::Request::DCC.

=head2 cvv2

Method originates in Business::CyberSource::Request::DCC.

=head2 cc_exp_year

Method originates in Business::CyberSource::Request::DCC.

=head2 client_name

Method originates in Business::CyberSource::Request::DCC.

=head2 foreign_currency

Method originates in Business::CyberSource::Request::DCC.

=head2 client_version

Method originates in Business::CyberSource::Request::DCC.

=head2 cvv

Method originates in Business::CyberSource::Request::DCC.

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


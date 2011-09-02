package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.2.0'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response;

use XML::Compile::SOAP::WSS 0.12;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub submit {
	my $self = shift;

    my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

    my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
    $wsdl->importDefinitions( $self->cybs_xsd->stringify );

    my $call = $wsdl->compileClient('runTransaction');

    my $security = $wss->wsseBasicAuth( $self->username, $self->password );

	my $payload = {
		merchantID            => $self->username,
		merchantReferenceCode => $self->reference_code,
		clientEnvironment     => $self->client_env,
		clientLibrary         => $self->client_name,
		clientLibraryVersion  => $self->client_version,
		purchaseTotals => {
			currency         => $self->currency,
			foreignCurrency  => $self->foreign_currency,
			grandTotalAmount => $self->total,
		},
		card => $self->_cc_info,
		ccDCCService => {
			run => 'true',
		},
	};

	my ( $answer, $trace ) = $call->(
		wsse_Security         => $security,
		%{ $payload },
	);

	$self->trace( $trace );

	if ( $answer->{Fault} ) {
		croak 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	my $r = $answer->{result};

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Credit
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccCaptureReply}->{requestDateTime},
				amount         => $r->{ccCaptureReply}->{amount},
			})
			;
	}
	elsif ( $r->{decision} eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
				decision      => $r->{decision},
				request_id    => $r->{requestID},
				reason_code   => "$r->{reasonCode}",
				request_token => $r->{requestToken},
			})
			;
	}
	else {
		carp 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::DCC - CyberSource DCC Request Object

=head1 VERSION

version v0.2.0

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=head1 METHODS

=head2 new

Instantiates a DCC request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

=head2 cybs_wsdl

Reader: cybs_wsdl

Type: MooseX::Types::Path::Class::File

=head2 cv_indicator

Reader: cv_indicator

Type: MooseX::Types::Varchar::Varchar[1]

Additional documentation: Flag that indicates whether a CVN code was sent

=head2 trace

Reader: trace

Writer: trace

Type: XML::Compile::SOAP::Trace

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 cybs_api_version

Reader: cybs_api_version

Type: Str

=head2 cvn

Reader: cvn

Type: MooseX::Types::CreditCard::CardSecurityCode

=head2 total

Reader: total

Type: Num

=head2 cc_exp_month

Reader: cc_exp_month

Type: Int

This attribute is required.

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

This attribute is required.

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

=head2 cc_exp_year

Reader: cc_exp_year

Type: Int

This attribute is required.

=head2 credit_card

Reader: credit_card

Type: MooseX::Types::CreditCard::CreditCard

This attribute is required.

=head2 card_type

Reader: card_type

Type: MooseX::Types::Varchar::Varchar[3]

=head2 cybs_xsd

Reader: cybs_xsd

Type: MooseX::Types::Path::Class::File

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 client_name

Reader: client_name

Type: Str

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

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


package Business::CyberSource::Request::AuthReversal;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004004'; # VERSION

use Moose;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::FollowUp
);

before serialize => sub {
	my $self = shift;

	$self->_request_data->{ccAuthReversalService}{run} = 'true';
	$self->_request_data->{ccAuthReversalService}{authRequestID}
		= $self->request_id
		;
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::AuthReversal - CyberSource Reverse Authorization request object

=head1 VERSION

version 0.004004

=head1 SYNOPSIS

	my $req = Business::CyberSource::Request::AuthReversal->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'orignal authorization merchant reference code',
		request_id     => 'request id returned in original authorization response',
		total          => 5.00, # same as original authorization amount
		currency       => 'USD', # same as original currency
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=head1 ATTRIBUTES

=head2 foreign_amount

Reader: foreign_amount

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 comments

Reader: comments

Type: Str

=head2 trace

Reader: trace

Writer: _trace

Type: XML::Compile::SOAP::Trace

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

=head2 production

Reader: production

Type: Bool

=head2 request_id

Reader: request_id

Type: __ANON__

This attribute is required.

=head2 exchange_rate

Reader: exchange_rate

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 exchange_rate_timestamp

Reader: exchange_rate_timestamp

Type: Str

=head2 total

Reader: total

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

Additional documentation: Grand total for the order. You must include either this field or item_#_unitPrice in your request

=head2 username

Reader: username

Type: __ANON__

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

Additional documentation: Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::CyberSource::_VarcharFifty

This attribute is required.

=head2 items

Reader: items

Type: ArrayRef[MooseX::Types::CyberSource::Item]

=head1 METHODS

=head2 new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

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


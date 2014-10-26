package Business::CyberSource::ResponseFactory;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004008'; # VERSION

use Moose;
use MooseX::StrictConstructor;

use Module::Runtime qw( use_module );

use Exception::Base (
	'Business::CyberSource::Exception' => {
		has               => [ qw( decision reason_text response_text ) ],
		string_attributes => [ qw( decision reason_text response_text ) ],
	},
	verbosity      => 4,
	ignore_package => [ __PACKAGE__, 'Business::CyberSource::Client' ],
);


sub create {
	my ( $self, $answer, $dto )  = @_;

	my $result = $answer->{result};

	my @traits;
	my $e = { };
	my $exception;

	if ( $result->{decision} eq 'ACCEPT' or $result->{decision} eq 'REJECT' ) {
		my $prefix      = 'Business::CyberSource::';
		my $req_prefix  = $prefix . 'Request::';
		my $res_prefix  = $prefix . 'Response::';
		my $role_prefix = $res_prefix . 'Role::';

		if ( $result->{decision} eq 'ACCEPT' ) {
			push( @traits, $role_prefix .'Accept' );

			$e->{currency} = $result->{purchaseTotals}{currency};
			$e->{reference_code} = $result->{merchantReferenceCode};

			given ( $dto ) {
				when ( $_->isa( $req_prefix . 'Authorization') ) {
					$e->{amount        } = $result->{ccAuthReply}->{amount};
					$e->{datetime      } = $result->{ccAuthReply}{authorizedDateTime};
					$e->{request_specific_reason_code}
						= "$result->{ccAuthReply}->{reasonCode}";
					continue;
				}
				when ( $_->isa( $req_prefix . 'Capture')
					or $_->isa( $req_prefix . 'Sale' )
					) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $result->{ccCaptureReply}->{requestDateTime};
					$e->{amount}   = $result->{ccCaptureReply}->{amount};
					$e->{reconciliation_id}
						= $result->{ccCaptureReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$result->{ccCaptureReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'Credit') ) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $result->{ccCreditReply}->{requestDateTime};
					$e->{amount}   = $result->{ccCreditReply}->{amount};
					$e->{reconciliation_id} = $result->{ccCreditReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$result->{ccCreditReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'DCC') ) {
					push ( @traits, $role_prefix . 'DCC' );
					$e->{exchange_rate} = $result->{purchaseTotals}{exchangeRate};
					$e->{exchange_rate_timestamp}
						= $result->{purchaseTotals}{exchangeRateTimeStamp};
					$e->{foreign_currency}
						= $result->{purchaseTotals}{foreignCurrency};
					$e->{foreign_amount} = $result->{purchaseTotals}{foreignAmount};
					$e->{dcc_supported}
						= $result->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0;
					$e->{valid_hours} = $result->{ccDCCReply}{validHours};
					$e->{margin_rate_percentage}
						= $result->{ccDCCReply}{marginRatePercentage};
					$e->{request_specific_reason_code}
						= "$result->{ccDCCReply}{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'AuthReversal' ) ) {
					push ( @traits, $role_prefix . 'ProcessorResponse' );

					$e->{datetime} = $result->{ccAuthReversalReply}->{requestDateTime};
					$e->{amount}   = $result->{ccAuthReversalReply}->{amount};

					$e->{request_specific_reason_code}
						= "$result->{ccAuthReversalReply}->{reasonCode}";
					$e->{processor_response}
						= $result->{ccAuthReversalReply}->{processorResponse};
				}
			}
		}

		if ( $dto->isa( $req_prefix . 'Authorization') ) {
				push( @traits, $role_prefix . 'Authorization' );
					if ( $result->{ccAuthReply} ) {

						$e->{auth_code}
							=  $result->{ccAuthReply}{authorizationCode }
							if $result->{ccAuthReply}{authorizationCode }
							;


						if ( $result->{ccAuthReply}{cvCode}
							&& $result->{ccAuthReply}{cvCodeRaw}
							) {
							$e->{cv_code}     = $result->{ccAuthReply}{cvCode};
							$e->{cv_code_raw} = $result->{ccAuthReply}{cvCodeRaw};
						}

						if ( $result->{ccAuthReply}{avsCode}
							&& $result->{ccAuthReply}{avsCodeRaw}
							) {
							$e->{avs_code}     = $result->{ccAuthReply}{avsCode};
							$e->{avs_code_raw} = $result->{ccAuthReply}{avsCodeRaw};
						}

						if ( $result->{ccAuthReply}{processorResponse} ) {
							$e->{processor_response}
								= $result->{ccAuthReply}{processorResponse}
								;
						}

						if ( $result->{ccAuthReply}->{authRecord} ) {
							$e->{auth_record} = $result->{ccAuthReply}->{authRecord};
						}
					}
		}

	}
	elsif ( $result->{decision} eq 'ERROR' ) {
		$exception = 1;
	}
	else {
		confess 'decision defined, but not handled: ' . $result->{decision};
	}

	my $response = use_module('Business::CyberSource::Response')
		->with_traits( @traits )
		->new({
			request_id     => $result->{requestID},
			decision       => $result->{decision},
			# quote reason_code to stringify from BigInt
			reason_code    => "$result->{reasonCode}",
			request_token  => $result->{requestToken},
			%{$e},
		});

	$response->_trace( $dto->trace ) if $dto->has_trace;

	Business::CyberSource::Exception->throw(
		decision    => $response->decision,
		reason_text => $response->reason_text,
		value       => $response->reason_code,
		response_text
			=> $response->has_trace ? $response->trace->response->as_string : ''
	) if $exception;

	return $response;
}

1;

# ABSTRACT: A Response Factory


__END__
=pod

=head1 NAME

Business::CyberSource::ResponseFactory - A Response Factory

=head1 VERSION

version 0.004008

=head1 METHODS

=head2 create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

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


package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007002'; # TRIAL VERSION

use Moose;
extends 'Business::CyberSource::Factory';

use Class::Load  qw( load_class );
use Module::Load qw( load       );
use Try::Tiny;

use Exception::Base (
	'Business::CyberSource::Exception' => {
		has => [ qw( answer ) ],
	},
	'Business::CyberSource::Response::Exception' => {
		isa => 'Business::CyberSource::Exception',
		has => [qw(
			decision
			reason_text
			reason_code
			request_id
			request_token
			trace
			is_error
			is_accept
			is_reject
		)],
		string_attributes => [ qw( message decision reason_text ) ],
	},
	verbosity      => 4,
	ignore_package => [ __PACKAGE__, 'Business::CyberSource::Client' ],
);

sub create {
	my ( $self, $result , $request ) = @_;

	if ( $self->_has_client && $self->debug ) {
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

		Carp::carp( 'RESPONSE HASH: ' . Dumper( $result ) );
	}

	my $response
		= try {
			load_class('Business::CyberSource::Response')->new( $result );
		}
		catch {
			my %exception = (
				message       => 'BUG! please report: ' . $_,
				reason_code   => $result->{reasonCode},
				value         => $result->{reasonCode},
				decision      => $result->{decision},
				request_id    => $result->{requestID},
				request_token => $result->{requestToken},
			);

			$exception{reason_text}
				= load_class('Business::CyberSource::Response')
				->_build_reason_text( $result->{reasonCode} )
				;

			$exception{trace} = $request->trace
				if defined $request
				&& blessed $request
				&& $request->can('has_trace')
				&& $request->can('trace')
				&& $request->has_trace
				;

			Business::CyberSource::Response::Exception->throw( %exception );
		};

	if ( blessed $response && $response->is_error ) {
		my %exception = (
			message       => 'message from CyberSource\'s API',
			reason_text   => $response->reason_text,
			reason_code   => $response->reason_code,
			value         => $response->reason_code,
			decision      => $response->decision,
			request_id    => $response->request_id,
			request_token => $response->request_token,
			is_error      => $response->is_error,
			is_accept     => $response->is_accept,
			is_reject     => $response->is_reject,
		);
		$exception{trace} = $response->trace if $response->has_trace;

		Business::CyberSource::Response::Exception->throw( %exception );
	}

	return $response;
}

has _client => (
	isa       => 'Business::CyberSource::Client',
	is        => 'bare',
	weak_ref  => 1,
	handles   => [qw( debug _dumper_package )],
	predicate => '_has_client',
);

1;

# ABSTRACT: A Response Factory

__END__

=pod

=head1 NAME

Business::CyberSource::Factory::Response - A Response Factory

=head1 VERSION

version 0.007002

=head1 METHODS

=head2 create

	my $response = $factory->create( $answer->{result}, $request );

Pass the C<answer->{result}> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object. Passing a L<Business::CyberSource::Request> is now optional.

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

package Business::CyberSource;
use 5.006;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004003'; # VERSION

use Moose::Role;

use MooseX::Types::Moose qw( Str );
use MooseX::Types::Path::Class qw( File Dir );
use Path::Class;
use File::ShareDir qw( dist_file );
use Config;

has client_version => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		my $version
			= $Business::CyberSource::VERSION ? $Business::CyberSource::VERSION
			                                  : 'v0.0.0'
			;
		return $version;
	},
);

has client_name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub { return __PACKAGE__ },
	documentation => 'provided by the library',
);

has client_env => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
	documentation => 'provided by the library',
);

has cybs_api_version => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	default  => '1.62',
	documentation => 'provided by the library',
);

has cybs_wsdl => (
	required  => 0,
	lazy      => 1,
	is        => 'ro',
	isa       => File,
	builder   => '_build_cybs_wsdl',
	documentation => 'provided by the library',
);

has cybs_xsd => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => File,
	builder  => '_build_cybs_xsd',
	documentation => 'provided by the library',
);

sub _build_cybs_wsdl {
		my $self = shift;

		my $dir = $self->production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.wsdl'
				)
			);

		return $file;
}

sub _build_cybs_xsd {
		my $self = shift;

		my $dir = $self->production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.xsd'
				)
			);

		return $file;
}

1;

# ABSTRACT: Perl interface to the CyberSource Simple Order SOAP API


__END__
=pod

=head1 NAME

Business::CyberSource - Perl interface to the CyberSource Simple Order SOAP API

=head1 VERSION

version 0.004003

=head1 DESCRIPTION

This library is a Perl interface to the CyberSource Simple Order SOAP API built
on L<Moose> and L<XML::Compile::SOAP> technologies. This library aims to
eventually provide a full interface the SOAPI.

You may wish to read the Official CyberSource Documentation on L<Credit Card
Services for the Simpler Order
API|http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_SO_API/html/>
as it will provide further information on why what some things are and the
general workflow.

To get started you will want to read the documentation in
L<Business::CyberSource::Request>. If you find any documentation unclear or
outright missing, please file a bug.

If there are features that are part of CyberSource's API but are not
documented, or are missing here, please file a bug. I'll be happy to add them,
but due to the size of the upstream API, I have not had time to cover all the features
and some are currently undocumented.

=head1 ACKNOWLEDGEMENTS

=over

=item * Mark Overmeer

for the help with getting L<XML::Compile::SOAP::WSS> working.

=back

=head1 SEE ALSO

=over

=item * L<Checkout::CyberSource::SOAP>

=item * L<Business::OnlinePayment::CyberSource>

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


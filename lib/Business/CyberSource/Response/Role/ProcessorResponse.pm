package Business::CyberSource::Response::Role::ProcessorResponse;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007001'; # TRIAL VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( _VarcharTen );

has processor_response => (
	isa         => _VarcharTen,
	remote_name => 'processorResponse',
	predicate   => 'has_processor_response',
	is          => 'ro',
);

1;

# ABSTRACT: Processor Response attribute

__END__

=pod

=head1 NAME

Business::CyberSource::Response::Role::ProcessorResponse - Processor Response attribute

=head1 VERSION

version 0.007001

=head1 ATTRIBUTES

=head2 processor_response

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

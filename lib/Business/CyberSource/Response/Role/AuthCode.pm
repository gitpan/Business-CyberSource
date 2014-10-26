package Business::CyberSource::Response::Role::AuthCode;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.010000'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( _VarcharSeven );

has auth_code => (
	isa         => _VarcharSeven,
	remote_name => 'authorizationCode',
	predicate   => 'has_auth_code',
	is          => 'ro',
);

1;
# ABSTRACT: Authorization Code

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::CyberSource::Response::Role::AuthCode - Authorization Code

=head1 VERSION

version 0.010000

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/business-cybersource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Caleb Cushing <xenoterracide@gmail.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

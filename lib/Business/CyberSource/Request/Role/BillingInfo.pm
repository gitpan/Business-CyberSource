package Business::CyberSource::Request::Role::BillingInfo;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007011'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( BillTo );

has bill_to => (
	isa         => BillTo,
	remote_name => 'billTo',
	alias       => ['billing_info'],
	is          => 'ro',
	required    => 1,
	coerce      => 1,
);

1;

# ABSTRACT: Role for requests that require "bill to" information

__END__

=pod

=head1 NAME

Business::CyberSource::Request::Role::BillingInfo - Role for requests that require "bill to" information

=head1 VERSION

version 0.007011

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/business-cybersource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

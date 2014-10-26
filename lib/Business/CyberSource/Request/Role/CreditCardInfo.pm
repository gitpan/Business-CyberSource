package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007007'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;

use MooseX::Types::CyberSource qw( Card);

has card => (
	isa         => Card,
	remote_name => 'card',
	required    => 1,
	is          => 'ro',
	coerce      => 1,
);

1;

# ABSTRACT: credit card info role

__END__

=pod

=head1 NAME

Business::CyberSource::Request::Role::CreditCardInfo - credit card info role

=head1 VERSION

version 0.007007

=head1 ATTRIBUTES

=head2 card

L<Business::CyberSource::RequestPart::Card>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/hostgator/business-cybersource/issues or by email to
development@hostgator.com.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

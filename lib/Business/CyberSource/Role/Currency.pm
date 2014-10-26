package Business::CyberSource::Role::Currency;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.8'; # VERSION

use Moose::Role;
use MooseX::Types::Locale::Currency qw( CurrencyCode );

has currency => (
	required => 1,
	is       => 'ro',
	isa      => CurrencyCode,
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency

__END__
=pod

=head1 NAME

Business::CyberSource::Role::Currency - Role to apply to requests and responses that require currency

=head1 VERSION

version v0.3.8

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


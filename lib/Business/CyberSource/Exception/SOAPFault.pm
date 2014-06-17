package Business::CyberSource::Exception::SOAPFault;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.010000'; # VERSION

use Moose;
use MooseX::RemoteHelper;
extends 'Business::CyberSource::Exception';

sub _build_message {
	my $self = shift;
	return $self->faultstring;
}

has $_ => (
	remote_name => $_,
	isa         => 'Str',
	is          => 'ro',
	required    => 1,
) foreach qw( faultstring faultcode );

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Card number is not a valid credit card

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::CyberSource::Exception::SOAPFault - Card number is not a valid credit card

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

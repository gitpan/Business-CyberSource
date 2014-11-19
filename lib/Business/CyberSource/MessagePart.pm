package Business::CyberSource::MessagePart;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.010004'; # VERSION

use Moose;
extends 'MooseY::RemoteHelper::MessagePart';
use MooseX::SetOnce 0.200001;

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Things that all portions of a message have in common

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::CyberSource::MessagePart - Things that all portions of a message have in common

=head1 VERSION

version 0.010004

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

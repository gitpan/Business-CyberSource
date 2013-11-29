package Business::CyberSource::Factory;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.009001'; # VERSION

use Moose;
use MooseX::StrictConstructor;

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Factory Base Class

__END__

=pod

=head1 NAME

Business::CyberSource::Factory - Factory Base Class

=head1 VERSION

version 0.009001

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/business-cybersource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing <xenoterracide@gmail.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

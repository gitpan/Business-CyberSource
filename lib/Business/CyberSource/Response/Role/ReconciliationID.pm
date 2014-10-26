package Business::CyberSource::Response::Role::ReconciliationID;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007008'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has reconciliation_id => (
	isa         => 'Str',
	remote_name => 'reconciliationID',
	is          => 'ro',
	predicate   => 'has_reconciliation_id',
);

1;

# ABSTRACT: Reconciliation Identifier

__END__

=pod

=head1 NAME

Business::CyberSource::Response::Role::ReconciliationID - Reconciliation Identifier

=head1 VERSION

version 0.007008

=head1 ATTRIBUTES

=head2 reconciliation_id

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

package Business::CyberSource::Request::FollowOnCredit;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006005'; # VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';

sub BUILD { ## no critic ( Subroutines::RequireFinalReturn )
	my $self = shift;
	confess 'a Follow On Credit should set a request_id'
		unless $self->service->has_request_id
		;
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::FollowOnCredit - CyberSource Credit Request Object

=head1 VERSION

version 0.006005

=head1 SYNOPSIS

	use Business::CyberSource::Request::FollowOnCredit;

	my $credit = Business::CyberSource::Request::FollowOnCredit->new({
			reference_code => 'merchant reference code',
			purchase_totals => {
				total    => 5.00,
				currency => 'USD',
			},
			service => {
				request_id => 'capture request_id',
			},
		});

=head1 DESCRIPTION

Follow-On credit Data Transfer Object.

=head2 EXTENDS

L<Business::CyberSource::Request::Credit>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


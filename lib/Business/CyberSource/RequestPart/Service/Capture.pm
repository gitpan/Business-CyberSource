package Business::CyberSource::RequestPart::Service::Capture;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006008'; # VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

use MooseX::Types::CyberSource qw( RequestID );

has request_id => (
	isa         => RequestID,
	remote_name => 'authRequestID',
	predicate   => 'has_request_id',
	is          => 'rw',
	required    => 1,
	traits      => ['SetOnce'],
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Capture Service

__END__

=pod

=head1 NAME

Business::CyberSource::RequestPart::Service::Capture - Capture Service

=head1 VERSION

version 0.006008

=head1 ATTRIBUTES

=head2 request_id

Value of L<request_id|Business::CyberSource::Response/"request_id"> returned from
a previous L<Authorization Reply|Business::CyberSource::Request::Authorization>.

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

package Business::CyberSource::Request::StandAloneCredit;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004007'; # VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::StandAloneCredit - CyberSource Credit Request Object

=head1 VERSION

version 0.004007

=head1 SYNOPSIS

	use Business::CyberSource::Request::StandAloneCredit;

	my $req = Business::CyberSource::Request::StandAloneCredit->new({
		reference_code => 'merchant reference code',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

=head1 DESCRIPTION

This object allows you to create a request for a standalone credit.

=head2 inherits

L<Business::CyberSource::Request::Credit>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::BillingInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=back

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


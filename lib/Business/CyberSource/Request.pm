package Business::CyberSource::Request;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007009'; # VERSION

use Moose;
extends 'Business::CyberSource::Message';
with qw(
	MooseX::RemoteHelper::CompositeSerialization
);

use MooseX::ABC;

use MooseX::Types::Moose       qw( ArrayRef );
use MooseX::Types::CyberSource qw( PurchaseTotals Service Items );

use Class::Load 0.20 qw( load_class );

our @CARP_NOT = ( 'Class::MOP::Method::Wrapped', __PACKAGE__ );

before serialize => sub { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( ! $self->has_total && ( ! $self->has_items || $self->items_is_empty ) ) {
		confess 'you must define either items or total';
	}
};

sub add_item {
	my ( $self, $args ) = @_;

	my $item;
	unless ( blessed $args
			&& $args->isa( 'Business::CyberSource::RequestPart::Item' )
		) {
		$item
			= load_class('Business::CyberSource::RequestPart::Item')
			->new( $args )
			;
	}
	else {
		$item = $args;
	}
	$self->items( [ ] ) if ! $self->has_items;

	return $self->_push_item( $item );
}

sub _build_service {
	return load_class('Business::CyberSource::RequestPart::Service')->new;
}

has comments => (
	remote_name => 'comments',
	isa         => 'Str',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has service => (
	isa        => Service,
	is         => 'ro',
	lazy_build => 1,
	required   => 1,
	coerce     => 1,
	reader     => undef,
);

has purchase_totals => (
	isa         => PurchaseTotals,
	remote_name => 'purchaseTotals',
	is          => 'ro',
	required    => 1,
	coerce      => 1,
	handles     => [qw( total has_total )],
);

has items => (
	isa         => Items,
	remote_name => 'item',
	predicate   => 'has_items',
	is          => 'rw',
	traits      => ['Array'],
	coerce      => 1,
	handles     => {
		items_is_empty => 'is_empty',
		next_item      => [ natatime => 1 ],
		list_items     => 'elements',
		_push_item     => 'push',
	},
	serializer => sub {
		my ( $attr, $instance ) = @_;

		my $items = $attr->get_value( $instance );

		my $i = 0;
		my @serialized
			= map { ## no critic ( BuiltinFunctions::ProhibitComplexMappings )
				my $item = $_->serialize;
				$item->{id} = $i;
				$i++;
				$item
			} @{ $items };

		return \@serialized;
	},
);

has '+trace' => (
	is        => 'rw',
	init_arg  => undef
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Request Class

__END__

=pod

=head1 NAME

Business::CyberSource::Request - Abstract Request Class

=head1 VERSION

version 0.007009

=head1 DESCRIPTION

extends L<Business::CyberSource::Message>

Here are the provided Request subclasses.

=over

=item * L<Authorization|Business::CyberSource::Request::Authorization>

=item * L<AuthReversal|Business::CyberSource::Request::AuthReversal>

=item * L<Capture|Business::CyberSource::Request::Capture>

=item * L<Follow-On Credit|Business::CyberSource::Request::FollowOnCredit>

=item * L<Stand Alone Credit|Business::CyberSource::Request::StandAloneCredit>

=item * L<DCC|Business::CyberSource::Request::DCC>

=item * L<Sale|Business::CyberSource::Request::Sale>

=back

I<note:> You can use the L<Business:CyberSource::Request::Credit> class but,
it requires traits to be applied depending on the type of request you need,
and thus does not currently work with the factory.

=head1 EXTENDS

L<Business::CyberSource::Message>

=head1 WITH

=over

=item L<MooseX::RemoteHelper::CompositeSerialization>

=back

=head1 METHODS

=head2 serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=head2 add_item

Add an L<Item|Business::CyberSource::RequestPart::Item> to L<items|/"items">.
Accepts an item object or a hashref to construct an item object.

an array of L<Items|MooseX::Types::CyberSource/"Items">

=head1 ATTRIBUTES

=head2 reference_code

Merchant-generated order reference or tracking number.  CyberSource recommends
that you send a unique value for each transaction so that you can perform
meaningful searches for the transaction.

=head2 service

L<Business::CyberSource::RequestPart::Service>

=head2 purchase_totals

L<Business::CyberSource::RequestPart::PurchaseTotals>

=head2 items

An array of L<Business::CyberSource::RequestPart::Item>

=head2 comments

Comment Field

=for Pod::Coverage BUILD

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

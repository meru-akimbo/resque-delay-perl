package Resque::Plugin::Delay::Job;
use 5.008001;
use strict;
use warnings;

use Moose::Role;

has start_time  => (
    is       => 'rw',
);

has payload => (
    is   => 'ro',
    isa  => 'HashRef',
    coerce => 1,
    lazy => 1,
    builder => '_build_payload',
    trigger => sub {
        my ( $self, $hr ) = @_;
        $self->_trigger_payload($hr);
    },
);


# XXX It is difficult to extend payload with multiple plugins by overwriting payload using Moose's default or trigger as it is.
# This plugin transfer to a dedicated method and take the form of "around" it.
# pull request may be sent to the resque.
sub _trigger_payload {
    my ( $self, $hr ) = @_;
    $self->class( $hr->{class} );
    $self->args( $hr->{args} ) if $hr->{args};
}

sub _build_payload {
    my ($self,) = @_;

    return +{
        class => $self->class,
        args  => $self->args,
    };
}

around _trigger_payload => sub {
    my ($orig, $self, $hr) = @_;

    $orig->($self, $hr);
    $self->start_time( $hr->{start_time} ) if $hr->{start_time};
};

around _build_payload => sub {
    my ($orig, $self) = @_;

    my $payload = $orig->($self);
    $payload->{start_time} = $self->start_time,

    return $payload;
};

1;


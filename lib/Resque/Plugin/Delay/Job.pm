package Resque::Plugin::Delay::Job;
use 5.008001;
use strict;
use warnings;

use Moose::Role;

has working_time  => (
    is       => 'rw',
    default  => sub { time },
);

has payload => (
    is   => 'ro',
    isa  => 'HashRef',
    coerce => 1,
    lazy => 1,
    default => sub {{
        class => $_[0]->class,
        args  => $_[0]->args,
        working_time => $_[0]->working_time,
    }},
    trigger => sub {
        my ( $self, $hr ) = @_;
        $self->class( $hr->{class} );
        $self->args( $hr->{args} ) if $hr->{args};
        $self->working_time( $hr->{working_time} ) if $hr->{working_time};
    }
);

1;


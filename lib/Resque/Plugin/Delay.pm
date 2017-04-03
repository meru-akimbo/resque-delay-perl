package Resque::Plugin::Delay;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Mouse::Role;
use Time::Moment;
use Time::Strptime qw/strptime/;

around pop => sub {
    my ( $self, $queue ) = @_;
    my $payload = $self->redis->lpop($self->key( queue => $queue ));
    return unless $payload;

    if (defined $payload->[0]->{delay_at}) {
        my ($epoch,) = strptime($payload->[0]->{delay_at});
        return if Time::Moment->from_epoch($epoch) < Time::Moment->now;
    }

    $self->new_job({
        payload => $payload,
        queue   => $queue
    });
};

no Mouse;
1;
__END__

=encoding utf-8

=head1 NAME

resque::delay::perl - It's new $module

=head1 SYNOPSIS

    use resque::delay::perl;

=head1 DESCRIPTION

resque::delay::perl is ...

=head1 LICENSE

Copyright (C) meru_akimbo.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

meru_akimbo E<lt>merukatoruayu0@gmail.comE<gt>

=cut


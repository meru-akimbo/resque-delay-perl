package Resque::Plugin::Delay::Pop;
use 5.008001;
use strict;
use warnings;

use Moose::Role;

use Time::Moment;
use Time::Strptime qw/strptime/;
use JSON::XS qw/decode_json/;

around pop => sub {
    my ( $orig, $self, $queue ) = @_;
    my $payload = $self->redis->lpop($self->key( queue => $queue ));
    return unless $payload;
    $payload = decode_json($payload);

    my $job = $self->new_job({
        payload => $payload,
        queue   => $queue
    });

    if (defined $payload->{args}->[0]->{delay_at}) {
        my ($epoch,) = strptime('%Y-%m-%d %H:%M:%S', $payload->{args}->[0]->{delay_at});
        if (Time::Moment->from_epoch($epoch) > Time::Moment->now) {
            $self->push($queue, $job);
            return;
        }
    }

    return $job;
};

1;


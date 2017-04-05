package Resque::Plugin::Delay::Dequeue;
use 5.008001;
use strict;
use warnings;

use Moose::Role;
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

    # "resque_working_time" is a redundant name but uses a name that is difficult to duplicate with the user defined key
    if (defined $payload->{args}->[0]->{resque_working_time}) {
        my ($epoch,) = $payload->{args}->[0]->{resque_working_time};
        if ($epoch > time) {
            $self->push($queue, $job);
            return;
        }
    }

    return $job;
};

1;


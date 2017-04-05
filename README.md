# NAME

Resque::Plugin::Delay - Delay the execution of job

# SYNOPSIS

    use Resque;

    my $working_time = time + 100;

    my $resque = Resque->new(redis => $redis_server, plugins => ['Delay']);
    $resque->push('test-job' => +{
            class => 'Hoge',
            args  => [+{ cat => 'nyaaaa', resque_working_time => $working_time }, +{ dog => 'bow' }]
        }
    );

# DESCRIPTION

Passing epoch to the first element of payload makes it impossible to execute work until that time.

# LICENSE

Copyright (C) meru\_akimbo.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

meru\_akimbo <merukatoruayu0@gmail.com>

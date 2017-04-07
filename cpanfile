requires 'perl', '5.008001';
requires 'Moose';
requires 'Resque';
requires 'JSON::XS';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::RedisServer';
    requires 'Test::MockTime';
    requires 'Time::Strptime';
    requires 'Redis';
};


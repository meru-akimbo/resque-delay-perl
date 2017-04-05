requires 'perl', '5.008001';
requires 'Moose';
requires 'Resque';
requires 'Time::Moment';
requires 'Time::Strptime';
requires 'JSON::XS';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::RedisServer';
    requires 'Test::MockTime';
    requires 'Redis';
    requires 'Scope::Guard';
};


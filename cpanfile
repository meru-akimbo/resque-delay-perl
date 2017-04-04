requires 'perl', '5.008001';
requires 'Moose';
requires 'Resque';
requires 'Time::Moment';
requires 'Time::Strptime';

on 'test' => sub {
    requires 'Test::More', '0.98';
};


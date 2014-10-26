use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $factory = new_ok( use_module('Business::CyberSource::Factory::Response') );

can_ok( $factory, 'create' );

my $answer = {
	result => {
		decision     => 'ERROR',
		requestID    => '3367880563740176056428',
		reasonCode   => '150',
		requestToken => 'AhhRbwSRbSV2sdn3CQDYD6QQqAAaSZV0ekrReBEA5lFa',
	},
};

my $exception
	= exception {
		$factory->create(
			$t->resolve( service => '/request/authorization' ),
			$answer,
		)
	};

isa_ok( $exception, 'Business::CyberSource::Exception' )
	or diag "$exception"
	;

like(  "$exception",         qr/error/i, 'stringify'   );
is  (   $exception->decision,'ERROR',    'decision'    );
is  (   $exception+0,        150,        'numerify'    );
is  (   $exception->value ,  150,        'value'       );

done_testing;

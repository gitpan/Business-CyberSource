use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object'    );

my $brc = use_module('Business::CyberSource::RequestPart::BusinessRules');

my $req0
	= $t->resolve(
		service    => '/request/authorization',
		parameters => {
			purchase_totals => $t->resolve(
				service    => '/helper/purchase_totals',
				parameters => { total => 9001.00 }, # magic REJECT
			),
			business_rules => $brc->new({ ignore_cv_result => 1 }),
		},
	);

my $ret0 = $client->run_transaction( $req0 );

isa_ok $ret0, 'Business::CyberSource::Response';

is( $ret0->decision,       'ACCEPT', 'check decision'       );
is( $ret0->reason_code,     100,     'check reason_code'    );
is( $ret0->currency,       'USD',    'check currency'       );
is( $ret0->amount,         '9001.00',    'check amount'     );
is( $ret0->avs_code,       'Y',       'check avs_code'      );
is( $ret0->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret0->processor_response, 'C2',  'check processor_response');
is( $ret0->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret0->auth_code, '831000',     'check auth_code exists');

ok( $ret0->request_id,    'check request_id exists'    );
ok( $ret0->request_token, 'check request_token exists' );
ok( $ret0->datetime,      'check datetime exists'      );
ok( $ret0->auth_record,   'check auth_record exists'   );

my $req1
	= $t->resolve(
		service    => '/request/authorization',
		parameters => {
			purchase_totals => $t->resolve(
				service    => '/helper/purchase_totals',
				parameters => { total => 5005.00 }, # magic REJECT
			),
			business_rules => $brc->new({ ignore_avs_result => 1 }),
		},
	);

my $ret1 = $client->run_transaction( $req1 );

isa_ok $ret1, 'Business::CyberSource::Response';

is( $ret1->decision,       'ACCEPT', 'check decision'       );
is( $ret1->reason_code,     100,     'check reason_code'    );
is( $ret1->currency,       'USD',    'check currency'       );
is( $ret1->amount,         '5005.00',    'check amount'     );
is( $ret1->avs_code,       'N',       'check avs_code'      );
is( $ret1->avs_code_raw,   'N',       'check avs_code_raw'  );
is( $ret1->processor_response, '00',  'check processor_response');
is( $ret1->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret1->auth_code, '831000',     'check auth_code exists');

ok( $ret1->request_id,    'check request_id exists'    );
ok( $ret1->request_token, 'check request_token exists' );
ok( $ret1->datetime,      'check datetime exists'      );
ok( $ret1->auth_record,   'check auth_record exists'   );

my $req2
	= $t->resolve(
		service    => '/request/authorization',
		parameters => {
			purchase_totals => $t->resolve(
				service    => '/helper/purchase_totals',
				parameters => { total => 5001.00 }, # magic ACCEPT
			),
			business_rules => $brc->new({
				decline_avs_flags => [ qw( Y N ) ]
			}),
		},
	);

my $ret2 = $client->run_transaction( $req2 );

isa_ok $ret2, 'Business::CyberSource::Response';

is( $ret2->decision,       'REJECT', 'check decision'       );
is( $ret2->reason_code,     200,     'check reason_code'    );
is( $ret2->avs_code,       'Y',       'check avs_code'      );
is( $ret2->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret2->processor_response, '00',  'check processor_response');
is( $ret2->auth_code, '831000',     'check auth_code exists');

ok( $ret2->request_id,    'check request_id exists'    );
ok( $ret2->request_token, 'check request_token exists' );
ok( $ret2->auth_record,   'check auth_record exists'   );

done_testing;

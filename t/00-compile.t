use strict;
use warnings;

# This test was generated via Dist::Zilla::Plugin::Test::Compile 2.011

use Test::More 0.88;



use Capture::Tiny qw{ capture };

my @module_files = qw(
lib/Business/CyberSource.pm
lib/Business/CyberSource/Client.pm
lib/Business/CyberSource/Factory.pm
lib/Business/CyberSource/Factory/Request.pm
lib/Business/CyberSource/Factory/Response.pm
lib/Business/CyberSource/Factory/Rule.pm
lib/Business/CyberSource/Message.pm
lib/Business/CyberSource/MessagePart.pm
lib/Business/CyberSource/Request.pm
lib/Business/CyberSource/Request/AuthReversal.pm
lib/Business/CyberSource/Request/Authorization.pm
lib/Business/CyberSource/Request/Capture.pm
lib/Business/CyberSource/Request/Credit.pm
lib/Business/CyberSource/Request/DCC.pm
lib/Business/CyberSource/Request/FollowOnCredit.pm
lib/Business/CyberSource/Request/Role/BillingInfo.pm
lib/Business/CyberSource/Request/Role/CreditCardInfo.pm
lib/Business/CyberSource/Request/Role/DCC.pm
lib/Business/CyberSource/Request/Role/TaxService.pm
lib/Business/CyberSource/Request/Sale.pm
lib/Business/CyberSource/Request/StandAloneCredit.pm
lib/Business/CyberSource/RequestPart/BillTo.pm
lib/Business/CyberSource/RequestPart/BusinessRules.pm
lib/Business/CyberSource/RequestPart/Card.pm
lib/Business/CyberSource/RequestPart/Item.pm
lib/Business/CyberSource/RequestPart/PurchaseTotals.pm
lib/Business/CyberSource/RequestPart/Service.pm
lib/Business/CyberSource/RequestPart/Service/AuthReversal.pm
lib/Business/CyberSource/RequestPart/Service/Capture.pm
lib/Business/CyberSource/RequestPart/Service/Credit.pm
lib/Business/CyberSource/RequestPart/Service/Tax.pm
lib/Business/CyberSource/Response.pm
lib/Business/CyberSource/Response/Role/Amount.pm
lib/Business/CyberSource/Response/Role/AuthCode.pm
lib/Business/CyberSource/Response/Role/DCC.pm
lib/Business/CyberSource/Response/Role/ProcessorResponse.pm
lib/Business/CyberSource/Response/Role/ReasonCode.pm
lib/Business/CyberSource/Response/Role/ReconciliationID.pm
lib/Business/CyberSource/Response/Role/RequestDateTime.pm
lib/Business/CyberSource/ResponsePart/AuthReply.pm
lib/Business/CyberSource/ResponsePart/DCCReply.pm
lib/Business/CyberSource/ResponsePart/PurchaseTotals.pm
lib/Business/CyberSource/ResponsePart/Reply.pm
lib/Business/CyberSource/ResponsePart/TaxReply.pm
lib/Business/CyberSource/ResponsePart/TaxReply/Item.pm
lib/Business/CyberSource/Role/Currency.pm
lib/Business/CyberSource/Role/ForeignCurrency.pm
lib/Business/CyberSource/Role/MerchantReferenceCode.pm
lib/Business/CyberSource/Rule.pm
lib/Business/CyberSource/Rule/ExpiredCard.pm
lib/Business/CyberSource/Rule/RequestIDisZero.pm
lib/MooseX/Types/CyberSource.pm
);

my @scripts = qw(

);

# no fake home requested

my @warnings;
for my $lib (@module_files)
{
    my ($stdout, $stderr, $exit) = capture {
        system($^X, '-Mblib', '-e', qq{require qq[$lib]});
    };
    is($?, 0, "$lib loaded ok");
    warn $stderr if $stderr;
    push @warnings, $stderr if $stderr;
}

is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};





done_testing;

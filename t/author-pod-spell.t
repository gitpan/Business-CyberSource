
BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}

use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.006000
eval "use Test::Spelling 0.12; use Pod::Wordlist::hanekomu; 1" or die $@;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib  ) );
__DATA__
CyberSource's
Num
Str
datetime
merchantID
ip
cid
CVN
cvc
cvv
login
SOAPI
Bleue
Carta
Carte
Dankort
JAL
Santander
UATP
YYYY
timestamp
Overmeer
AVS
MerchantReferenceCode
env
WSDL
XSD
subclasses
auth
dcc
GüdTech
HostGator
Caleb
Cushing
xenoterracide
lib
Business
CyberSource
Factory
Response
MessagePart
MooseX
Types
Request
Capture
Role
RequestDateTime
RequestPart
Service
BusinessRules
Tax
ResponsePart
TaxReply
ForeignCurrency
Currency
PurchaseTotals
Credit
AuthReply
Rule
ExpiredCard
ProcessorResponse
Message
DCC
BillingInfo
TaxService
Sale
BillTo
ReasonCode
StandAloneCredit
DCCReply
Amount
Card
AuthCode
AuthReversal
ReconciliationID
CreditCardInfo
Item
FollowOnCredit
Authorization
Client
RequestIDisZero
Reply

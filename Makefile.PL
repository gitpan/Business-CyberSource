
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "Perl interface to the CyberSource Simple Order SOAP API",
  "AUTHOR" => "Caleb Cushing <xenoterracide\@gmail.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "Business-CyberSource",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "Business::CyberSource",
  "PREREQ_PM" => {
    "Business::CreditCard" => 0,
    "Class::Load" => "0.20",
    "DateTime::Format::W3CDTF" => "0.06",
    "Exception::Base" => 0,
    "File::ShareDir::ProjectDistDir" => 0,
    "LWP::Protocol::https" => 0,
    "Module::Load" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::AbstractFactory" => 0,
    "MooseX::Aliases" => 0,
    "MooseX::RemoteHelper" => 0,
    "MooseX::RemoteHelper::CompositeSerialization" => 0,
    "MooseX::RemoteHelper::Types" => 0,
    "MooseX::SetOnce" => "0.200001",
    "MooseX::StrictConstructor" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::Common::Numeric" => "0.001003",
    "MooseX::Types::Common::String" => "0.001005",
    "MooseX::Types::CreditCard" => "0.002",
    "MooseX::Types::DateTime" => 0,
    "MooseX::Types::DateTime::W3C" => 0,
    "MooseX::Types::Email" => 0,
    "MooseX::Types::Locale::Country" => 0,
    "MooseX::Types::Locale::Currency" => 0,
    "MooseX::Types::Moose" => 0,
    "MooseX::Types::NetAddr::IP" => 0,
    "MooseX::Types::Path::Class" => 0,
    "MooseY::RemoteHelper::MessagePart" => 0,
    "MooseY::RemoteHelper::Role::Client" => 0,
    "Try::Tiny" => 0,
    "XML::Compile::SOAP11" => 0,
    "XML::Compile::SOAP::WSS" => "1.04",
    "XML::Compile::Transport::SOAPHTTP" => 0,
    "XML::Compile::WSDL11" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Business::CreditCard" => "0.32",
    "Capture::Tiny" => 0,
    "DateTime" => 0,
    "FindBin" => 0,
    "Test::Fatal" => 0,
    "Test::Method" => 0,
    "Test::Moose" => 0,
    "Test::More" => "0.88",
    "Test::Requires" => 0,
    "Test::Requires::Env" => 0,
    "lib" => 0
  },
  "VERSION" => "0.009000",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}



use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.09\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.010';
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Bread::Board','0.25') };
eval { $v .= pmver('Business::CreditCard','0.32') };
eval { $v .= pmver('Capture::Tiny','any version') };
eval { $v .= pmver('Class::Load','0.20') };
eval { $v .= pmver('DateTime','any version') };
eval { $v .= pmver('DateTime::Format::W3CDTF','0.06') };
eval { $v .= pmver('Exception::Base','any version') };
eval { $v .= pmver('ExtUtils::MakeMaker','6.30') };
eval { $v .= pmver('File::ShareDir::Install','0.03') };
eval { $v .= pmver('File::ShareDir::ProjectDistDir','any version') };
eval { $v .= pmver('FindBin','any version') };
eval { $v .= pmver('LWP::Protocol::https','any version') };
eval { $v .= pmver('Module::Load','any version') };
eval { $v .= pmver('Moose','any version') };
eval { $v .= pmver('Moose::Role','any version') };
eval { $v .= pmver('Moose::Util::TypeConstraints','any version') };
eval { $v .= pmver('MooseX::AbstractFactory','any version') };
eval { $v .= pmver('MooseX::Aliases','any version') };
eval { $v .= pmver('MooseX::RemoteHelper','any version') };
eval { $v .= pmver('MooseX::RemoteHelper::CompositeSerialization','any version') };
eval { $v .= pmver('MooseX::RemoteHelper::Types','any version') };
eval { $v .= pmver('MooseX::SetOnce','0.200001') };
eval { $v .= pmver('MooseX::StrictConstructor','any version') };
eval { $v .= pmver('MooseX::Types','any version') };
eval { $v .= pmver('MooseX::Types::Common::Numeric','0.001003') };
eval { $v .= pmver('MooseX::Types::Common::String','0.001005') };
eval { $v .= pmver('MooseX::Types::CreditCard','0.002') };
eval { $v .= pmver('MooseX::Types::DateTime','any version') };
eval { $v .= pmver('MooseX::Types::DateTime::W3C','any version') };
eval { $v .= pmver('MooseX::Types::Email','any version') };
eval { $v .= pmver('MooseX::Types::Locale::Country','any version') };
eval { $v .= pmver('MooseX::Types::Locale::Currency','any version') };
eval { $v .= pmver('MooseX::Types::Moose','any version') };
eval { $v .= pmver('MooseX::Types::NetAddr::IP','any version') };
eval { $v .= pmver('MooseX::Types::Path::Class','any version') };
eval { $v .= pmver('MooseY::RemoteHelper::MessagePart','any version') };
eval { $v .= pmver('MooseY::RemoteHelper::Role::Client','any version') };
eval { $v .= pmver('Pod::Coverage::TrustPod','any version') };
eval { $v .= pmver('Test::CPAN::Changes','0.19') };
eval { $v .= pmver('Test::CPAN::Meta','any version') };
eval { $v .= pmver('Test::Fatal','any version') };
eval { $v .= pmver('Test::Method','any version') };
eval { $v .= pmver('Test::Moose','any version') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Test::Pod','1.41') };
eval { $v .= pmver('Test::Pod::Coverage','1.08') };
eval { $v .= pmver('Test::Requires','any version') };
eval { $v .= pmver('Test::Requires::Env','any version') };
eval { $v .= pmver('Try::Tiny','any version') };
eval { $v .= pmver('XML::Compile::SOAP11','any version') };
eval { $v .= pmver('XML::Compile::SOAP::WSS','1.04') };
eval { $v .= pmver('XML::Compile::Transport::SOAPHTTP','any version') };
eval { $v .= pmver('XML::Compile::WSDL11','any version') };
eval { $v .= pmver('lib','any version') };
eval { $v .= pmver('namespace::autoclean','any version') };
eval { $v .= pmver('strict','any version') };
eval { $v .= pmver('version','0.9901') };
eval { $v .= pmver('warnings','any version') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;

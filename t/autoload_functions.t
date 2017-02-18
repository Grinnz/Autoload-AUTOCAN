use strict;
use warnings;

package My::Package;
use Autoload::FromCAN 'functions';

sub can {
  my ($package, $function) = @_;
  return sub { $_[0] . $_[1] } if $function =~ m/cat/;
  return undef;
}

package main;
use Test::More;

my $res;
ok(eval { $res = My::Package::concatenate('foo', 'bar'); 1 }, 'concatenate function autoloaded') or diag $@;
is $res, 'foobar', 'right result';
ok(!eval { My::Package::join('foo', 'bar'); 1 }, 'join function not autoloaded');
like $@, qr/My::Package::join/, 'function in error message';

done_testing;

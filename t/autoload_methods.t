use strict;
use warnings;

package My::Class;
use Autoload::FromCAN;

my $amount = 0;

sub can {
  my ($class, $method) = @_;
  return sub { $amount += $_[1] } if $method eq 'add';
  return sub { $amount } if $method eq 'get';
  return undef;
}

package main;
use Test::More;

ok defined &My::Class::AUTOLOAD, 'autoload sub installed';

ok(eval { My::Class->add(5); 1 }, 'add method autoloaded') or diag $@;
my $check;
ok(eval { $check = My::Class->get; 1 }, 'get method autoloaded') or diag $@;
is $check, 5, 'right number';
ok(!eval { My::Class->subtract(5); 1 }, 'subtract method not autoloaded');
like $@, qr/My::Class/, 'class mentioned in error message';
like $@, qr/subtract/, 'method mentioned in error message';

done_testing;


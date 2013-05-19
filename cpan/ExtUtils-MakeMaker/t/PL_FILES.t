#!/usr/bin/perl -w

BEGIN {
    unshift @INC, 't/lib';
}
chdir 't';

use strict;
use Config;
use Test::More
    $ENV{PERL_CORE} && $Config{'usecrosscompile'}
    ? (skip_all => "no toolchain installed when cross-compiling")
    : (tests => 9);

use File::Spec;
use MakeMaker::Test::Setup::PL_FILES;
use MakeMaker::Test::Utils;

my $perl = which_perl();
my $make = make_run();
perl_lib();

setup;

END {
    ok( chdir File::Spec->updir );
    ok( teardown );
}

ok chdir('PL_FILES-Module');

run(qq{$perl Makefile.PL});
cmp_ok( $?, '==', 0 );

SKIP: {
    skip "make is not available", 5 if !$make;
my $make_out = run("$make");
is( $?, 0 ) || diag $make_out;

foreach my $file (qw(single.out 1.out 2.out blib/lib/PL/Bar.pm)) {
    ok( -e $file, "$file was created" );
}
}

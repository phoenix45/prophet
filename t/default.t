use warnings;
use strict;
use Test::More  tests => 7;
use File::Temp qw'tempdir';
use lib 't/lib';

use_ok('Prophet::CLI');
$ENV{'PROPHET_REPO'} = tempdir( CLEANUP => 0 ) . '/repo-' . $$;
my $cli = Prophet::CLI->new();
my $cxn = $cli->app_handle->handle;
isa_ok($cxn, 'Prophet::Replica');

use_ok('TestApp::Bug');

my $record = TestApp::Bug->new( handle => $cxn );

isa_ok( $record, 'TestApp::Bug' );
isa_ok( $record, 'Prophet::Record' );

my $uuid = $record->create( props => { name => 'Jesse', email => 'JeSsE@bestPractical.com' } );
ok($uuid);
is( $record->prop('status'), 'new', "default status" );

use strict;

use Test::More tests => 4;
use Test::Exception;
use Test::Deep;


my $test_api_key = '8ee2a50541944fb9bcedded5165f09d9';
my $test_address = '1370 Willow Road, 2nd Floor, Menlo Park, CA 94025 USA';

BEGIN {
	use_ok( 'Geo::Coder::Cloudmade' );
};


dies_ok { Geo::Coder::Cloudmade->new() } 'can not create object without arguments';

my $geocoder = Geo::Coder::Cloudmade->new( apikey => $test_api_key );

isa_ok( $geocoder, 'Geo::Coder::Cloudmade' );

my $expected =
{
	lat	=> 32.22646,
	long => -110.99009
};

my $got = $geocoder->geocode( { location => $test_address } );

cmp_deeply( $got, $expected, 'correct location geocoded' );


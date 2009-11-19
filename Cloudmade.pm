package Geo::Coder::Cloudmade;

our $VERSION = '0.1';

use strict;

use Carp;
use Encode;
use JSON::Syck;
use HTTP::Request;
use LWP::UserAgent;
use URI;

sub new {
    my $class = shift;
    my $args = shift;

    my $ua = $args->{ua} || LWP::UserAgent->new( agent => __PACKAGE__ . "/$VERSION" );
    my $host = $args->{host} || 'geocoding.cloudmade.com';

    my $self = {
        apikey  => $args->{apikey},
        ua      => $ua,
        host    => $host,
    };
    bless $self, $class;

    return( $self );
};


sub geocode {
    my $self = shift;
    my $location = shift;

    if( Encode::is_utf8($location) ) {
        $location = Encode::encode_utf8($location);
    };

    my $url_string = 'http://'. $self->{host} .'/'. $self->{apikey} .'/geocoding/v2/find.js';

    my $uri = URI->new( $url_string );
    $uri->query_form( query => $location );

    my $res = $self->{ua}->get( $uri );

    if ($res->is_error) {
        die "Cloudmade API returned error: " . $res->status_line;
    }

    local $JSON::Syck::ImplicitUnicode = 1;
    my $data = JSON::Syck::Load( $res->content );

    my $results = [];

    foreach my $point ( @{$data->{features}} ) {
        my $tmp = {
            lat     => $point->{centroid}->{coordinates}->[0],
            long    => $point->{centroid}->{coordinates}->[0],
        };
        push @{$results}, $tmp;
    };

    wantarray ? @{$results} : $results->[0];
}

1;

__END__


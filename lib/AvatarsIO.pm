package AvatarsIO;

use 5.006;
use strict;
use warnings;
use diagnostics;

use LWP::UserAgent;
use HTTP::Request::Common;

use Carp;

use JSON;
use Digest::MD5;

use vars qw{ $VERSION };

$VERSION = '0.1';

sub new {
	my $class = $_[0];
	my $self = {
		'client_id'    => undef,
		'access_token' => undef,
		'upload_image' => undef
	};

	bless $self, $class;
	return $self;
}

sub client_id {
	my( $self, $client_id ) = @_;

	$self->{'client_id'} = $client_id if defined( $client_id );
	return $self->{'client_id'};
}

sub access_token {
	my( $self, $access_token ) = @_;

	$self->{'access_token'} = $access_token if defined( $access_token );
	return $self->{'access_token'};
}

sub upload_image {
	my( $self, $upload_image, $path ) = @_;

	$self->{'upload_image'} = $upload_image if defined( $upload_image );
	$self->{'path'} 		= $path if defined( $path );

	$self->{'ua'} = LWP::UserAgent->new();
		
	open( FILE, $self->{'upload_image'} ) or croak("Couldn't open filehandle '$upload_image'\n");
	binmode( FILE );
		
	$self->{'checksum'} = Digest::MD5->new;
	
	
	$self->{'hash_to_json'} = {
		'data' => {
			'filename' => $self->{'upload_image'},
			'md5'      => $self->{'checksum'}->addfile( *FILE )->hexdigest,
			'size'     => -s $self->{'upload_image'},
			'path'     => $self->{'path'}
		}
	};
	
	close( FILE );

	$self->{'json'} = JSON->new->allow_nonref;

	$self->{'header'} = HTTP::Headers->new(
		'Content-Type' => 'application/json',
		'Authorization' => 'OAuth ' . $self->{'access_token'}
	);

	$self->{'header'}->header(':x-client_id' => $self->{'client_id'});

	$self->{'request'} = HTTP::Request->new( POST => 'http://avatars.io/v1/token', $self->{'header'} );

	$self->{'request'}->content( $self->{'json'}->encode( $self->{'hash_to_json'} ) );
	
	$self->{'resource'} = $self->{'ua'}->request( $self->{'request'} );
		
	$self->{'data_returned'} = $self->{'json'}->decode( $self->{'resource'}->content )->{'data'};
	
	if( $self->{'data_returned'}->{'upload_info'} ) {
	
		$self->{'header'} = HTTP::Headers->new(
			'Date' => $self->{'data_returned'}->{'upload_info'}->{'date'},
			'Content-Type' => $self->{'data_returned'}->{'upload_info'}->{'content_type'}
		);
	
		$self->{'header'}->header(':Authorization' => $self->{'data_returned'}->{'upload_info'}->{'signature'} );
		$self->{'header'}->header(':x-amz-acl' => 'public-read' );

		$self->{'request'} = HTTP::Request->new(
			PUT => $self->{'data_returned'}->{'upload_info'}->{'upload_url'},
			$self->{'header'}
		);
		
		open( FILE, $self->{'upload_image'} ) or croak( "Couldn't open filehandle '" . $self->{'upload_image'} . "'" );
		binmode( FILE );
		
		while( ( $self->{'tmp'} = read( FILE, $self->{'data_to_append'}, 4 ) ) != 0 ) {
			$self->{'result'} .= $self->{'data_to_append'};
		}

		$self->{'request'}->content( $self->{'result'} );

		$self->{'resource'} = $self->{'ua'}->request( $self->{'request'} );
		
		$self->{'header'} = HTTP::Headers->new(
			'Content-Type' => 'application/json',
			'Authorization' => 'OAuth ' . $self->{'access_token'},
		);

		$self->{'header'}->header(':x-client_id' => $self->{'client_id'});

		$self->{'request'} = HTTP::Request->new(
			POST => 'http://avatars.io/v1/token/' . $self->{'data_returned'}->{'id'} . '/complete',
			$self->{'header'}
		);
		
		$self->{'request'}->content('{}');

		$self->{'resource'} = $self->{'ua'}->request( $self->{'request'} );
		
		$self->{'image_url'} = $self->{'json'}->decode( $self->{'resource'}->content )->{'data'}->{'data'};
		return $self->{'image_url'};
	} else {
		return $self->{'data_returned'}->{'url'};
	}
}

sub avatar_url {
	my( $self, $service, $key ) = @_;
	return 'http://avatars.io/' . $service . '/' . $key;
}

sub auto_url {
	my( $self, $key, $service ) = @_;
	
	if( length( $service ) == 0 ) {
		return 'http://avatars.io/auto/' . $key;
	} else {
		return 'http://avatars.io/auto/' . $key . '?services=' . join( ',', @$service );
	}
}

sub resize_url {
	my( $self, $key, $size ) = @_;
	return 'http://avatars.io/' . $key . '?size=' . $size;
}

1; # End of AvatarsIO

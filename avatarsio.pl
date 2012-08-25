#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use AvatarsIO; # Include the module

my $avatarsio = new AvatarsIO; # Create the object

# Take these information from www.avatars.io

$avatarsio->client_id('50379f363f59d82ec0000002');
$avatarsio->access_token('e89258601f0dc851356490644d3eb6346120bdbbe268791abe4470be5fad3325');

# Upload avatar and return image link ( es. )

print $avatarsio->upload_image( 'path/to/image.jpg', '');

# Upload avatar with identifier and return image link ( es. )

print $avatarsio->upload_image( 'path/to/image.jpg', 'test');

# Getting links to avatar in social network

print $avatarsio->avatar_url('twitter', 'username');
print $avatarsio->avatar_url('instagram', 'username');
print $avatarsio->avatar_url('facebook', 'username');

# Getting automatic link to avatar in social network, the order is:
#	* Twitter
#	* Facebook
#	* Instagram
#	* Gravatar / Email

print $avatarsio->auto_url('jiin');

# Alternatively, you can specify the order:

print $avatarsio->auto_url('jiin', ['twitter', 'facebook']);

# You can also costumize the size of the image

print $avatarsio->resize_url('your avatatar shortcut', 'medium');
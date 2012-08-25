
Perl Module for Avatars.io API

# Installation

Run in terminal:

```bash
$ perl5 Makefile.PL
$ make
$ make test
$ make install
$ make clean
```

# Usage

```perl
use AvatarsIO; # Include the module

$avatarsio = new AvatarsIO; # Create the object

# Take these information from www.avatars.io

$avatarsio->client_id('your client id');
$avatarsio->access_token('your access token');

# Upload avatar and return image link ( es. )

print $avatarsio->upload_image( 'path/to/image.jpg', '');

# Upload avatar with identifier and return image link ( es. )

print $avatarsio->upload_image( 'path/to/image.jpg', 'test');

# Getting links to avatar in social network

print $avatarsio->avatar_url('twitter', 'username');
print $avatarsio->avatar_url('instagram', 'username');
print $avatarsio->avatar_url('facebook', 'username');

# Getting automatic link to avatar in social network, the order is:
#  * Twitter
#  * Facebook
#	* Instagram
#	* Gravatar / Email

print $avatarsio->auto_url('jiin');

# Alternatively, you can specify the order:

print $avatarsio->auto_url('jiin', ['twitter', 'facebook']);

# You can also costumize the size of the image

print $avatarsio->resize_url('your avatatar shortcut', 'medium');
```

# Author

Jiin < jiin@queeply.com >
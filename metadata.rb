name              'rsync'
maintainer        'Chef Software, Inc.'
maintainer_email  'chef@osuosl.org'
license           'Apache 2.0'
description       'Installs rsync'
version           '1.0.3'

recipe 'rsync::default', 'Installs rsync, Provides LWRP rsync_serve for serving paths via rsyncd'
recipe 'rsync::server', 'Installs rsync and starts a service to serve a directory'

%w(centos fedora redhat ubuntu debian).each do |os|
  supports os
end

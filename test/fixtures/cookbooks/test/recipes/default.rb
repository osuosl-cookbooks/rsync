apt_update 'update' if platform_family?('debian')

include_recipe 'rsync::default'

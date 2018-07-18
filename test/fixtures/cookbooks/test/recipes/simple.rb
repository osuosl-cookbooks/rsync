apt_update 'update' if platform_family?('debian')

include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path '/tmp'
end

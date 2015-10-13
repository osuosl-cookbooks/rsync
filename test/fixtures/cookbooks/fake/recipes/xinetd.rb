include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path '/tmp'
  restart_service false
end

rsync_serve 'var-tmp' do
  path '/var/tmp'
  restart_service false
end

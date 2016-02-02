namespace :memcached do
  desc 'Install latest stable release of redis'
  task :install, roles: :db do
    run "#{sudo} apt-get -y install memcached"
  end
  after 'deploy:install', 'memcached:install'

  desc 'Setup memcached configuration for this application'
  task :setup, roles: :db do
    template 'memcached.erb', '/tmp/memcached.conf'
    run "#{sudo} rm -f /etc/memcached.conf"
    run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
    restart
  end
  after 'deploy:setup', 'memcached:setup'

  %w(start stop restart).each do |command|
    desc "#{command} nginx"
    task command, roles: :db do
      run "#{sudo} service memcached #{command}"
    end
  end
end

namespace :redis do
  desc "Install latest stable release of redis"
  task :install, roles: :db do
    run "#{sudo} add-apt-repository -y ppa:chris-lea/redis-server"
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get -y install redis-server"
  end
  after "deploy:install", "redis:install"
end

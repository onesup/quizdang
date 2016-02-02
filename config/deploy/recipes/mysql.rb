namespace :mysql do
  desc "Install the latest stable release of mysql."
  task :install, roles: :db, only: {primary: true} do
    # capistrano task for installing mysql
    wget http://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb
    sudo dpkg -i mysql-apt-config_0.6.0-1_all.deb
    sudo apt-get update
    run "#{sudo} apt-get -y install mysql-client libmysqlclient-dev"

    run "#{sudo} apt-get -y install mysql-server" do |channel, stream, data|
      # prompts for mysql root password (when blue screen appears)
      channel.send_data("#{mysql_root_password}\n\r") if data =~ /password/
    end
  end
  after "deploy:install", "mysql:install"

  desc "Install the latest stable release of mysql client"
  task :client_install, roles: :app do
    run "#{sudo} add-apt-repository -y ppa:ondrej/mysql-5.6"
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get -y install mysql-client"
  end
  after "deploy:install", "mysql:client_install"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mysql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "mysql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"
end


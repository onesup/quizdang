namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install, roles: :app do
    run "#{sudo} curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -"
    run "#{sudo} apt-get -y install nodejs"
  end
  after "deploy:install", "nodejs:install"
end

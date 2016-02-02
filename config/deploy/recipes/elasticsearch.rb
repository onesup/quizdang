namespace :elasticsearch do
  desc 'Install latest stable release of elasticsearch'
  task :install, roles: :db do
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
    sudo apt-get update && sudo apt-get install elasticsearch
    sudo update-rc.d elasticsearch defaults 95 10
  end
  after 'deploy:install', 'elasticsearch:install'

  task :setup, roles: :db do
    restart
  end
  after 'deploy:setup', 'elasticsearch:setup'

  %w(start stop restart).each do |command|
    desc "#{command} elasticsearch"
    task command, roles: :web do
      run "#{sudo} service elasticsearch #{command}"
    end
  end
end

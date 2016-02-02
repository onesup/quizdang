def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
  end

  desc "Upgrade installed packages"
  task :upgrade do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y upgrade"
  end
end

namespace :base do
  desc "Install base package onto the server"
  task :install do
    # Manual bootstrap
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev"
    run "#{sudo} apt-get -y install libxml2-dev libxslt1-dev" # Nokogiri
    run "#{sudo} apt-get -y install imagemagick" # CarrierWave
    run "#{sudo} apt-get -y install libjpeg-turbo8 libjpeg-turbo8-dev" # jpegoptim
  end
  after "deploy:install", "base:install"
end

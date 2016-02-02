namespace :java do
  desc "Install latest stable release of java"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository -y ppa:webupd8team/java"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install oracle-java8-installer"
  end
  after "deploy:install", "java:install"
end

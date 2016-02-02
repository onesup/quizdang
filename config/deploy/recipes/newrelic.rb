namespace :newrelic do
  desc "Install newrelic server monitor"
  task :install, roles: :app do
    run "#{sudo} echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list"
    run "#{sudo} wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -"
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get -y install newrelic-sysmond"
    run "#{sudo} nrsysmond-config --set license_key=1ea84af6a562d25feac6c3e5ba49582e6d4bc1b7"
    run "#{sudo} /etc/init.d/newrelic-sysmond start"
  end
  after "deploy:install", "newrelic:install"
end

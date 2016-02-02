namespace :jpegoptim do
  desc 'Install jpegoptim'
  task :install, roles: :app do
    run 'wget http://www.kokkonen.net/tjko/src/jpegoptim-1.4.3.tar.gz'
    run 'tar zxvf jpegoptim-1.4.3.tar.gz'
    run 'cd jpegoptim-1.4.3'
    run './configure'
    run 'make'
    run "#{sudo} make install"
  end
  after 'deploy:install', 'jpegoptim:install'
end

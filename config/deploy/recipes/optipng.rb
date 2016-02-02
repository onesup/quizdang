namespace :optipng do
  desc "Install optipng"
  task :install, roles: :app do
    run "wget http://prdownloads.sourceforge.net/optipng/optipng-0.7.5.tar.gz"
    run "tar zxvf optipng-0.7.5.tar.gz"
    run "cd optipng-0.7.5"
    run "./configure"
    run "make"
    run "#{sudo} make install"
  end
  after "deploy:install", "optipng:install"
end

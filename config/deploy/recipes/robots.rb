namespace :robots do
  desc "Generate the robots.txt configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "robots.#{rails_env}.txt", "#{shared_path}/config/robots.txt"
  end
  after "deploy:setup", "robots:setup"

  desc "Symlink the robots.txt file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/robots.txt #{release_path}/public/robots.txt"
  end
  after "deploy:finalize_update", "robots:symlink"
end

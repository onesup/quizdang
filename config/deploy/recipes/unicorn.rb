set_default(:unicorn_pid) { "#{shared_path}/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_workers, 4)

namespace :unicorn do
  desc 'Setup Unicorn initializer and app configuration'
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/sockets"
    template 'unicorn.rb.erb', unicorn_config
    restart
  end
  after 'deploy:setup', 'unicorn:setup'

  desc 'Symlink the unicorn.rb file into latest release'
  task :symlink, roles: :app do
    run "ln -nfs #{unicorn_config} #{release_path}/config/unicorn.rb"
  end
  after 'deploy:finalize_update', 'unicorn:symlink'

  %w(start stop restart).each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "#{sudo} #{command} #{application}-web"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end

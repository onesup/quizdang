# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'quizdang'
set :repo_url, 'git@github.com:kimsuelim/quizdang.git'

# Default branch is :master
set :branch, 'master'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :user, 'deploy'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# rbenv
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.4'
# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# TODO: fix capistrano-sidekiq bundle: command not found
# set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w(foreman))
set :rbenv_map_bins, %w{rake gem bundle ruby railas foreman}
set :rbenv_roles, :all # default value

# unicorn_nginx
set :nginx_server_name, 'www.quizdang.com'
set :nginx_use_ssl, true
set :nginx_ssl_cert_local_path, '/Users/kimsuelim/Documents/dev/quizdang/www.quizdang.com.crt'
set :nginx_ssl_cert_key_local_path, '/Users/kimsuelim/Documents/dev/quizdang/www.quizdang.com.key'

# rollbar
set :rollbar_token, '1a213a2d9c584fd7a5697d376100367c'
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :seed do
  desc 'Upload seed file'
  task :upload do
    on roles(:app) do
      upload! StringIO.new(File.read('db/question_extra.yml')), "#{release_path}/db/question_extra.yml"
    end
  end
end
after 'deploy:updating', 'seed:upload'

namespace :dotenv do
  desc 'Upload dotenv file'
  task :upload do
    on roles(:app) do
      upload! StringIO.new(File.read(".env.#{fetch(:stage)}")), "#{release_path}/.env.#{fetch(:stage)}"
    end
  end
end
after 'deploy:updating', 'dotenv:upload'

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        execute :sudo, "$HOME/.rbenv/bin/rbenv exec foreman export upstart /etc/init -f Procfile.#{fetch(:stage)} -a #{fetch(:application)} -u #{fetch(:user)} -l #{current_path}/log"
      end
    end
  end

  %w(start stop restart).each do |command|
    desc "#{command} the application services"
    task command do
      on roles(:app) do
        execute :sudo, "#{command} #{fetch(:application)}"
      end
    end
  end
end

after 'deploy:reverted', 'foreman:export'
after 'deploy:publishing', 'foreman:export'
after 'deploy:publishing', 'foreman:restart'

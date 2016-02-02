namespace :rbenv do
  desc 'Install rbenv, Ruby, and the Bundler gem'
  task :install, roles: :app do
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL

    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL

    git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

    run "rbenv install #{fetch(:rbenv_ruby)}"
    run "rbenv global #{fetch(:rbenv_ruby)}"
    ruby -v
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc
    gem install bundler

    run 'gem install bundler --no-ri --no-rdoc'
    run 'gem install foreman --no-ri --no-rdoc'
    run 'gem install backup --no-ri --no-rdoc'
    run 'rbenv rehash'
  end
  after 'deploy:install', 'rbenv:install'
end

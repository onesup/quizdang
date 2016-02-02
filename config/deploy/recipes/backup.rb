namespace :backup do
  desc "backup db"
  task :db, roles: :app do
    run "cd #{current_path} && backup perform -t db_backup --config_file config/backup/config.rb"
  end

  desc "backup uploads"
  task :uploads, roles: :app do
    run "export RAILS_ENV=production"
    run "cd #{current_path} && backup perform -t file_backup --config_file config/backup/config.rb"
  end

  desc "backup all"
  task :all do
  end
  after "backup:all", "backup:uploads", "backup:db"
end

# Learn more: http://github.com/javan/whenever
# FIXME https://github.com/javan/whenever/issues/473
env :PATH, ENV['PATH']

set :output, "#{path}/log/cron.log"

every 10.minutes, roles: [:db] do
  rake 'app:questions:increment_views'
end

every 1.days, at: '12:00 am', roles: [:db] do
  rake 'app:questions:clear_tracked_questions'
end

every 1.days, at: '12:30 am', roles: [:app] do
  rake 'app:photos:download_unsplash_image'
end

# every 1.days, at: '1:30 am', roles: [:app] do
#   rake 'app:photos:download_pixabay_image'
# end

every 1.days, at: '4:30 am', roles: [:app] do
  runner 'CarrierWave.clean_cached_files!'
end

# job_type :backup, 'cd :path && :task :output'
# every 1.days, at: '1:30 am', roles: [:app] do
  # backup 'backup perform -t db_backup --config_file config/backup/config.rb'
  # backup 'backup perform -t file_backup --config_file config/backup/config.rb'
# end

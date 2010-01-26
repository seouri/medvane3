task :cron => :environment do
  if Time.now.hour == 4
    Rake::Task['mdvn:journals'].execute
  end
end
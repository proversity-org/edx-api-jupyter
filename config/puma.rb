workers 4
threads_count = 1
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)

preload_app!
 
rackup DefaultRackup
port ENV['PORT'] || 3334
environment ENV['RAILS_ENV'] || 'development'

on_worker_boot do
  require "active_record"
	#   ActiveRecord::Base.establish_connection
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[Rails.env])
end

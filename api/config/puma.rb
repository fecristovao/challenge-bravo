workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/tmp"

preload_app!

#rackup      DefaultRackup
port        ENV['PORT']     || 4567
rack_env = ENV['RACK_ENV']  || "development"
environment rack_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
#stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locions
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"

activate_control_app


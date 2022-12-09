RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

require 'sinatra/base'
require 'sinatra/reloader'

class Api < Sinatra::Base
  register Sinatra::Reloader if development?
  register Sinatra::Reloader if test?
end

Dir[File.expand_path(File.join(__dir__, '..', 'app', 'controllers', '*.rb'))].each { |f| require f }
Dir[File.expand_path(File.join(__dir__, '..', 'app', 'models', '*.rb'))].each { |f| require f }
Dir[File.expand_path(File.join(__dir__, '..', 'db', '*.rb'))].each { |f| require f }


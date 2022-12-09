require 'rack/test'
require 'sinatra'
require File.expand_path(File.join(__dir__, '..', 'config', 'app'))

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.filter_run_when_matching :focus
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

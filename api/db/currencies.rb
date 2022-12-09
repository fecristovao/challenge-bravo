require 'sequel'
require 'yaml'

config = YAML.load(ERB.new(File.read(File.expand_path(File.join(__dir__, '..', 'config/database.yml')))).result)

environment = ENV['RACK_ENV']
config = config[environment]

host = config['host']
database = config['database']
username = config['username']
password = config['password']

DB = Sequel.connect("postgres://#{host}/#{database}", user: username,
                                                      password: password)
unless DB.table_exists?(:currencies)
  DB.create_table :currencies do
    String :name
    Float :ratio
    primary_key [:name]
  end
end

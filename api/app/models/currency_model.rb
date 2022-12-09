require 'sequel'
require File.expand_path(File.join(__dir__, '..', '..', 'db/db.rb'))

class Currency < Sequel::Model; end
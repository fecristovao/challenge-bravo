require 'sequel'
require 'erb'
require File.expand_path(File.join(__dir__, '..', '..', 'db/db.rb'))

class Currency < Sequel::Model
  def save
    begin
      super
    rescue Sequel::UniqueConstraintViolation
      nil
    end
  end
end
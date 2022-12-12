require 'sequel'
require 'erb'
require File.expand_path(File.join(__dir__, '..', '..', 'db/db.rb'))

class Currency < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_operator(:>, 0, :ratio)
    errors.add(:name, 'cannot be USD') if @values[:name] == 'USD'
  end

  def self.save_and_cache(name, rate)
    new_currency = Currency.new
    new_currency.name = name
    new_currency.ratio = RedisStore.get(name)&.to_f 
    return new_currency unless new_currency.ratio.nil?

    begin
      new_currency.ratio = rate
      saved = new_currency.save
      RedisStore.setex(name, rate, ENV['CACHE_TIMEOUT']) if saved
    rescue Sequel::UniqueConstraintViolation
      new_currency = Currency.first(name: name)
      RedisStore.setex(name, new_currency.ratio, ENV['CACHE_TIMEOUT']) if new_currency
      new_currency
    end
  end

  def self.delete_and_cache(name)
    RedisStore.delete(name)
    Currency.first(name: name)&.delete
  end

  def self.find_and_cache(name)
    found = RedisStore.get(name)
    if found
      new_currency = Currency.new
      new_currency.name = name
      new_currency.ratio = found.to_f
      new_currency
    else
      currency = Currency.first(name: name)
      RedisStore.setex(name, currency.ratio, ENV['CACHE_TIMEOUT']) if currency
      currency
    end
  end
end

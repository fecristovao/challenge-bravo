Dir[File.expand_path(File.join(__dir__, '..', 'app', 'models', '*.rb'))].each { |f| require f }
require File.expand_path(File.join(__dir__, '..', 'lib', 'cache_redis.rb'))
require 'rest-client'
require 'json'

class Seed
  def self.populateSQL
    puts "populando"
    url = 'https://api.coinbase.com/v2/exchange-rates?currency=USD'
    request = RestClient.get(url)
    response = JSON.parse(request)

    return if response.nil?

    data = response['data']['rates']
    puts "Got #{data.size} currencises"
    data.each do |currency, rate|
      new_currency = Currency.find(name: currency) || Currency.new
      new_currency.name = currency
      new_currency.ratio = rate
      new_currency.is_virtual = false
      new_currency.save
    rescue StandardError
    end
  end

  def self.populateCache
    currency = Currency.limit(ENV['CACHE_PAGINATION'])
    currency.each { |item| RedisStore.setex(item.name, item.ratio, ENV['CACHE_TIMEOUT']) }
  end
end

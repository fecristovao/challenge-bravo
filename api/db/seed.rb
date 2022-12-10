Dir[File.expand_path(File.join(__dir__, '..', 'app', 'models', '*.rb'))].each { |f| require f }
require 'rest-client'
require 'json'

url = 'https://api.coinbase.com/v2/exchange-rates?currency=USD'
request = RestClient.get(url)
response = JSON.parse(request)

unless response.nil?
  
  data = response['data']['rates']
  puts "Got #{data.size} currencises"
  data.each do |currency, rate|
    new_currency = Currency.find(name: currency) || Currency.new
    new_currency.name = currency
    new_currency.ratio = rate
    new_currency.is_virtual = false
    new_currency.save
  end
end

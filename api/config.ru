require File.join(__dir__, 'config', 'app.rb')
map('/') { run ExchangeController }

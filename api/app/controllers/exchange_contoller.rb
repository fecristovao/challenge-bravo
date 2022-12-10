class ExchangeController < Api
  get '/' do
    initials_from = params[:from]
    initials_to = params[:to]
    amount = params[:amount]
    halt 400, json(data: 'Wrong Params') if initials_from.nil? || initials_to.nil? || amount.nil? || amount.to_f <= 0
    halt 400, json(data: 'Wrong Params') if initials_from == initials_to

    currency = exchange(initials_from, initials_to, amount)
    halt 200, json(data: { from: initials_from, to: initials_to, amount: amount.to_f, rate: currency }) unless currency.nil?
    halt 400, json(data: 'Wrong Params')
  end

  post '/add' do
    initials_currency = params['initials']
    ratio_currency = params['rate'].to_f

    halt 400 if initials_currency.nil?
    halt 400 if ratio_currency <= 0

    new_currency = Currency.new
    new_currency.name = initials_currency
    new_currency.ratio = ratio_currency
    new_currency.is_virtual = true
    new_currency = new_currency.save

    halt 200, json(data: { name: initials_currency, rate: ratio_currency })
  end

  delete '/delete/:initials' do
    initials_currency = params[:initials]
    halt 400 if initials_currency.nil?

    currency = Currency.find(name: initials_currency)
    currency&.delete

    halt 204
  end

  private

  def exchange(from_currency, to_currency, amount)
    amount = amount.to_f
    from_currency.upcase!
    to_currency.upcase!
    begin
      from_currency_data = Currency.find(name: from_currency)&.ratio
      to_currency_data   = Currency.find(name: to_currency)&.ratio
      return (amount / from_currency_data) if to_currency == 'USD'
      return (to_currency_data * amount) if from_currency == 'USD'

      (to_currency_data / from_currency_data) * amount
    rescue NoMethodError, TypeError => e
      logger.info("Error no exchange #{e}")
      nil
    end
  end
end

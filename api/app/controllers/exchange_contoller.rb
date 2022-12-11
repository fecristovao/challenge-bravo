class ExchangeController < Api
  get '/' do
    initials_from = params[:from]
    initials_to = params[:to]
    amount = params[:amount]
    halt 400, json(data: 'Wrong Params') if initials_from.nil? || initials_to.nil? || amount.nil? || amount.to_f <= 0
    halt 400, json(data: 'Wrong Params') if initials_from == initials_to

    currency = exchange(initials_from, initials_to, amount)
    unless currency.nil?
      halt 200,
           json(data: { from: initials_from, to: initials_to, amount: amount.to_f, rate: currency })
    end
    halt 400, json(data: 'Wrong Params')
  end

  post '/add' do
    initials_currency = params['initials']
    ratio_currency = params['rate'].to_f

    halt 400 if initials_currency.nil?
    halt 400 if ratio_currency <= 0

    Currency.save_and_cache(initials_currency, ratio_currency)

    halt 200, json(data: { name: initials_currency, rate: ratio_currency })
  end

  delete '/delete/:initials' do
    initials_currency = params[:initials]
    halt 400 if initials_currency.nil?

    Currency.delete_and_cache(initials_currency)

    halt 204
  end

  private

  def exchange(from_currency, to_currency, amount)
    amount = amount&.to_f
    from_currency.upcase!
    to_currency.upcase!
    begin
      from_currency_data = Currency.find_and_cache(from_currency)&.ratio
      to_currency_data   = Currency.find_and_cache(to_currency)&.ratio
      (amount / from_currency_data) if !from_currency_data.nil? && to_currency == 'USD'
      return (to_currency_data * amount) if !to_currency_data.nil? && from_currency == 'USD'

      (to_currency_data / from_currency_data) * amount unless from_currency_data.nil? && to_currency_data.nil?
    rescue NoMethodError, TypeError
      nil
    end
  end
  nil
end

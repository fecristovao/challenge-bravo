class ExchangeController < Api
  get '/' do
    initials_from = params[:from]
    initials_to = params[:to]
    amount = params[:amount]
    halt 400 if initials_from.nil? || initials_to.nil? || amount.nil?
  end
  post '/add' do
    initals_currency = params[:initials]
    halt 400 if initals_currency.nil?
    "Add Endpoint"
  end
  delete '/delete/:initials' do
    "Delete endpoint"
  end
end
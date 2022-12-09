require 'spec_helper'

def app
  ExchangeController.new
end

describe "Initial endpoints" do
  it 'GET Endpoint' do
    get '/'
    expect(last_response.status).to eq(400)
  end

  it 'POST Endpoint' do
    post '/add'
    expect(last_response.status).to eq(400)
  end

  it 'DELETE Endpoint' do
    delete '/delete'
    expect(last_response.status).to eq(404)
  end
end

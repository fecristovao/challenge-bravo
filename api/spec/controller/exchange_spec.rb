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

describe 'Benchmark tests' do
  it 'GET Endpoint' do
    expect { get '/' }.to perform_at_least(3000).within(1) 
  end

  it 'POST Endpoint' do
    expect { post '/add' }.to perform_at_least(3000).within(1) 
  end

  it 'DELETE Endpoint' do
    expect { delete '/delete' }.to perform_at_least(3000).within(1) 
  end
end
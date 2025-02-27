require 'spec_helper'

def app
  ExchangeController.new
end

describe 'Endpoints without params' do
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

describe 'GET Endpoint with wrong params' do
  it 'Wrong From Currency' do
    get '/?from=AGL&to=USD&amount=1'
    expect(last_response.status).to eq(400)
  end

  it 'Wrong To Currency' do
    get '/?from=BRL&to=AGR&amount=1'
    expect(last_response.status).to eq(400)
  end

  it 'Wrong Amount' do
    get '/?from=BRL&to=USD&amount=a'
    expect(last_response.status).to eq(400)
  end

  it 'Same Currencies' do
    get '/?from=BRL&to=BRL&amount=1'
    expect(last_response.status).to eq(400)
  end
end

describe 'DELETE Endpoint with wrong params' do
  it 'Inexistent currency' do
    delete '/delete/ABRO'
    expect(last_response.status).to eq(204)
  end
end

describe 'ADD Endpoint with wrong params' do
  it 'Negative rate' do
    post '/add', { initials: 'ABC', rate: -5.68 }
    expect(last_response.status).to eq(400)
  end
end

describe 'Endpoints with right params' do
  it 'GET Endpoint' do
    get '/?from=BRL&to=USD&amount=1'
    expect(last_response.status).to eq(200)
  end

  it 'ADD Endpoint' do
    post '/add', { initials: 'ABC', rate: 5.68 }
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({ data: { name: 'ABC', rate: 5.68 } }.to_json)
  end

  it 'DELETE Endpoint' do
    delete '/delete/ABC'
    expect(last_response.status).to eq(204)
  end
end

describe 'Cache Tests' do
  it 'Add Cache' do
    post '/add', { initials: 'ABC', rate: 5.68 }
    expect(RedisStore.get('ABC')).to eq('5.68')
  end

  it 'Delete Cache' do
    delete '/delete/ABC'
    expect(RedisStore.get('ABC')).to eq(nil)
  end

  it 'Get Cache' do
    get '/?from=BRL&to=BOB&amount=1'
    expect(RedisStore.get('BRL')).not_to eq(nil)
    expect(RedisStore.get('BOB')).not_to eq(nil)
  end
end

describe 'Benchmark tests' do
  it 'GET Endpoint' do
    expect { get '/' }.to perform_at_least(5000).within(1)
  end

  it 'POST Endpoint' do
    expect { post '/add' }.to perform_at_least(5000).within(1)
  end

  it 'DELETE Endpoint' do
    expect { delete '/delete' }.to perform_at_least(5000).within(1)
  end
end

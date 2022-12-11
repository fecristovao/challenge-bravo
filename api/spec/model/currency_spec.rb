require 'spec_helper'
require File.expand_path(File.join(__dir__, '..', '..', 'db', 'db.rb'))

RSpec.configure do |c|
  c.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end

describe 'Currency Model Test' do
  it 'Check forbidden currency' do
    expect do
      new_currency = Currency.new
      new_currency.name = 'USD'
      new_currency.ratio = 1.0
      new_currency.save
    end.to raise_error(Sequel::ValidationFailed)
  end

  it 'Check forbidden ratio' do
    expect do
      new_currency = Currency.new
      new_currency.name = 'ABCDEFGH'
      new_currency.ratio = -1.0
      new_currency.save
    end.to raise_error(Sequel::ValidationFailed)
  end

  it 'Check duplicated currency' do
    expect do
      new_currency = Currency.new
      new_currency.name = 'BRL'
      new_currency.ratio = 1.0
      new_currency.save
    end.to raise_error(Sequel::UniqueConstraintViolation)
  end

  it 'Check right currency' do
    new_currency = Currency.new
    new_currency.name = 'ABCDEFGH'
    new_currency.ratio = 1.0
    expect(new_currency.save).to be
  end
end

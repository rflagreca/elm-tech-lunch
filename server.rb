# frozen_string_literal: true

require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

set :bind, '0.0.0.0'
configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

options '*' do
  response.headers['Allow'] = 'GET'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end

get '/example' do
  content_type :json
  {
    stringExample: 'hello',
    numericExample: 300.45
  }.to_json
end

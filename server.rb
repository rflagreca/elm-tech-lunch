# frozen_string_literal: true

require 'sinatra'
require 'json'

get '/example.json' do
  content_type :json
  { key: 'value' }.to_json
end

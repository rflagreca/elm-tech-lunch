require 'test/unit'
require 'vcr'
require 'faraday'
require 'yaml'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :faraday
end

class FixtureGenerator < Test::Unit::TestCase
  def self.generate
    VCR.use_cassette('test_endpoint', record: :all) do
      Faraday.get 'http://localhost:4567/example'
    end
  end
end

FixtureGenerator.generate
cassette = YAML.safe_load(File.open('./fixtures/vcr_cassettes/test_endpoint.yml'))
json_response = cassette.fetch('http_interactions').first.dig('response', 'body', 'string')

elm_code = <<~FOO
  module ElmFixtures.TestEndpoint exposing (..)

  example : String
  example =
      """
      #{json_response}
      """
FOO

File.open('./fixtures/ElmFixtures/TestEndpoint.elm', 'w') do |file|
  file.write(elm_code)
end

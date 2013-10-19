require 'rubygems'
require 'bundler'
Bundler.require

require 'net/http'
require 'json'

API_KEY = ENV['OPEN_EXCHANGE_RATES_API_KEY']

desc 'Update rates'
task :update do
  # Get exchanges
  exchanges = JSON(File.open('data/exchanges.json').read)
  upload_file(exchanges.to_json, 'exchanges.json')
  puts 'Uploaded exchanges.json'

  # Get currencies
  currencies = JSON(File.open('data/currencies.json').read)
  rates = JSON(Net::HTTP.get('openexchangerates.org', "/api/latest.json?app_id=#{API_KEY}"))
  currencies['updated_at'] = rates['timestamp']
  currencies['currencies'].each do |key, currency|
    currency['rate'] = rates['rates'][key]
  end
  upload_file(currencies.to_json, 'currencies.json')
  puts 'Uploaded currencies.json'

  # Get library
  library = JSON(Net::HTTP.get('sharesapp.s3.amazonaws.com', '/artwork/iphone.json'))

  combined = {
    updated_at: [currencies['updated_at'], library['updated_at'], exchanges['updated_at']].max,
    currencies: currencies,
    library: {
      iphone: library
    },
    exchanges: exchanges
  }
  upload_file(combined.to_json, 'configuration.json')
  puts 'Uploaded configuration.json'
end

task :default => :update

def fog
  @fog_connection ||= Fog::Storage.new({
    provider: ENV['FOG_PROVIDER'],
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  })
end

def fog_directory
  @fog_directory ||= fog.directories.get(ENV['FOG_DIRECTORY'])
end

def upload_file(content, remote_path, mime_type = 'application/json')
  fog_directory.files.create(
    key: remote_path,
    body: content,
    mime_type: mime_type,
    public: true
  )
end

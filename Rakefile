require 'rubygems'
require 'bundler'
Bundler.require

require 'net/http'
require 'json'

desc 'Update rates'
task :update do
  # Get exchanges
  exchanges = JSON(File.open('data/exchanges.json').read)

  # Get currencies
  currencies = JSON(File.open('data/currencies.json').read)
  rates = JSON(Net::HTTP.get('openexchangerates.org', "/api/latest.json?app_id=#{ENV['OPEN_EXCHANGE_RATES_API_KEY']}"))
  currencies['updated_at'] = rates['timestamp']
  currencies['currencies'].each do |key, currency|
    currency['rate'] = rates['rates'][key]
  end

  # Get artwork
  artwork = JSON(File.open('data/artwork.json').read)

  combined = {
    updated_at: [currencies['updated_at'], artwork['updated_at'], exchanges['updated_at']].max,
    artwork: artwork,
    currencies: currencies,
    exchanges: exchanges
  }
  upload_file(combined.to_json, 'configuration.json')
  puts 'Uploaded configuration.json'
end

desc 'Deploy to Heroku and run jobs'
task :deploy do
  sh 'git push heroku master'
  sh 'heroku run rake update'
end

task :default => :deploy

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

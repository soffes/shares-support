require 'rubygems'
require 'bundler'
Bundler.require

# Dummy app so it will run on Heroku
app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
Rack::Handler::WEBrick.run(app, Port: ENV['PORT'])

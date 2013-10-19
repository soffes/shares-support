require 'rubygems'
require 'bundler'
Bundler.require

app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
Rack::Handler::WEBrick.run(app, Port: ENV['PORT'])

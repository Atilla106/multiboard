require 'sinatra'

require './lib/weather'

get '/' do
  @weather = Weather.new
  haml :index
end

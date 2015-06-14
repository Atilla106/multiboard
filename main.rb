require 'sinatra'

require './lib/weather'

get '/' do
  @weather = Weather.new
  @time = Time.now
  haml :index
end

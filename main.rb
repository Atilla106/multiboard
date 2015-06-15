require 'sinatra'

require './lib/train'
require './lib/weather'

set :public_folder, File.dirname(__FILE__) + '/content'

get '/' do
  @time = Time.now
  @trains = Train.from_sncf[0..11]
  @weather = Weather.new
  haml :index
end

require 'sinatra/base'
require 'tilt/haml'

require './lib/train'
require './lib/weather'

class Main < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/content'
  #Disable X-Frame-option for EisTV
  set :protection, :except => :frame_options

  get '/' do
    @time = Time.now
    @trains = Train.from_sncf[0..9]
    @weather = Weather.new
    haml :index
  end

  run! if __FILE__ == $0
end

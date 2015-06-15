require 'net/http'
require 'nokogiri'
require 'time'

require './lib/stations'

class Train
  attr_reader :station, :type, :time, :number, :mission, :terminus, :state

  def initialize(station, type, time, number, mission, terminus, state)
    @station, @type, @time, @number, @mission, @terminus, @state = [station, type, time, number, mission, terminus, state]
  end

  def to_s
    "#{@time} #{type} #{@terminus}"
  end

  def self.from_sncf
    root = Train.query_sncf(87381905)

    root.xpath("//train").map do |train|
      time = Time.strptime(train.search("date").first.text, "%d/%m/%Y %H:%M")
      number = train.search("num").first.text
      mission = train.search("miss").first.text
      terminus = STATIONS[train.search("term").first.text.to_i] || "???"
      type = number.match(/^[0-9]+$/).nil? ? "A" : "L"
      state = train.search("etat").first.text rescue nil

      Train.new(STATIONS[87381905], type, time, number, mission, terminus, state)
    end.sort_by(&:time)
  end

  private
  def self.query_sncf(station)
    login, password = File.read("sncf_token").split("\n")

    uri = URI("http://api.transilien.com/gare/#{station}/depart")

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(login, password)

      http.request(request)
    end

    Nokogiri::XML(response.body)
  end
end

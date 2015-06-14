require 'net/http'
require 'nokogiri'
require 'time'

require './lib/stations'

class Train
  attr_reader :station, :type, :time, :number, :mission, :terminus

  def initialize(station, type, time, number, mission, terminus)
    @station, @type, @time, @number, @mission, @terminus = [station, type, time, number, mission, terminus]
  end

  def to_s
    "#{@time} #{type} #{@terminus}"
  end

  def self.from_sncf
    root = Train.query_sncf(87381905)

    root.xpath("//train").map do |train|
      time = Time.strptime(train.children[0].text, "%d/%m/%Y %H:%M")
      number = train.children[2].text
      mission = train.children[4].text
      terminus = STATIONS[train.children[6].text.to_i] || "???"
      type = number.match(/^[0-9]+$/).nil? ? "A" : "L"

      Train.new(STATIONS[87381905], type, time, number, mission, terminus)
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

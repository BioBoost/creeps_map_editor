require_relative 'map_parser'

puts "Welcome to creeps map generator\r\n"

file = 'test1.map'
rooms = Array.new
connections = Array.new
parser = MapParser.new

parser.parseMap(file, rooms, connections)

puts "\r\n"
rooms.each { |r| puts r.to_s + "\r\n" }
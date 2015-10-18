require_relative 'map_parser'
require_relative 'cpp_generator'

puts "Welcome to creeps map generator\r\n"

file = 'test1.map'
rooms = Array.new
connections = Array.new
parser = MapParser.new

puts "Parsing input map\r\n"
parser.parseMap(file, rooms, connections)

puts "Generating cpp file\r\n"
cpp_gen = CppGenerator.new
cpp_gen.generate('test_map.cpp', rooms, connections)
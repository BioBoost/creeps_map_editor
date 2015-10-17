require_relative "room"
require_relative "connection"
require 'pry'

class MapParser

  def parseMap(file, rooms, connections)
    room_block = ""
    File.open(file, "r") do |f|
      f.each_line do |line|
        room_block += line
        if line.strip == "[/room]"
          # Parse block
          room = Room.new
          parseRoom(room_block, room, connections)
          rooms << room
          room_block = ""
        end
      end
    end
  end

  # [connection]
  #   description: Door in the corner standing wide open. It seems to lead to the cellar.
  #   instruction: door
  #   room: 1
  # [/connection]
  def parseConnection(string, connection)
    options = parseOptions(string, 'connection')

    # Sanity check
    if (!(options.has_key?('room') && options.has_key?('description') && options.has_key?('instruction')))
      raise "Missing options for connection: #{options.inspect}"
    end

    connection.setLeftOrRight(options['room'].to_i, options['description'], options['instruction'])
  end

  # [room]
  #   id: 1
  #   description: A dark wine cellar
  #   [connection]
  #     description: Door leading to the kitchen.
  #     instruction: door
  #     room: 0
  #   [/connection]
  #   [connection]
  #     description: Window just big enough to fit through.
  #     instruction: window
  #     room: 2
  #   [/connection]
  # [/room]
  #
  # connections is list of connections that already exist
  def parseRoom(string, room, connections)
    # First we extract the connections options if there are any
    connections_strings = string.scan(/(\[connection\].*?\[\/connection\])/m).flatten(1)

    if !connections_strings.nil?
      connections_options = connections_strings.map { |s| parseOptions(s, 'connection') }
    end

    # Then we remove the connections so we can parse the rest
    # Note how we use a non-greedy sub
    room_string = string.sub(/(\[connection\].*\[\/connection\])/m, "")

    # Now we can setup the room
    room_options = parseOptions(room_string, 'room')

    # Sanity check
    if (!(room_options.has_key?('id') && room_options.has_key?('description')))
      raise "Missing options for room: #{room_options.inspect}"
    end

    room.id = room_options['id'].to_i
    room.description = room_options['description']

    if !connections_strings.nil?
      # Now we need to check each new connection if it doesnt already exist
      connections_options.each do |co|
        # Sanity check
        if (!(co.has_key?('room') && co.has_key?('description') && co.has_key?('instruction')))
          raise "Missing options for connection: #{co.inspect}"
        end

        matches = connections.select do |c|
          # puts "#{c.left_id} == #{co['room'].to_i} && #{c.right_id} == #{room.id}"
          #(c.left_id == co['id'].to_i && c.right_id == room.id) || (c.left_id == room.id && c.right_id == co['id'].to_i)
          (c.left_id == co['room'].to_i) && (c.right_id == room.id)
        end

        # binding.pry

        # puts "Matches: " + matches.inspect

        if matches.size == 0
          # No matches found yet so the current connection doesnt exist yet
          connection = Connection.new

          connection.setLeft(room.id, co['description'], co['instruction'])
          connection.right_id = co['room'].to_i    # Set other id
          room.connections << connection

          # Add new connection to list of connections
          connections << connection

        elsif matches.size == 1
          connection = matches.first
          # puts 'Found match: ' + connection.inspect

          # Sanity check
          if (!connection.right_description.nil? || !connection.right_instruction.nil?)
            raise "Existing connection already has right side info set."
          end

          # Connection already exist, just need to set right params
          connection.setRight(room.id, co['description'], co['instruction'])

          # And add it to current room
          room.connections << connection
        else
          raise "Should not find multiple matches for existing connection"
        end
      end
    end

    return room
  end

  private

  # Parse an options block
  # Tag is excluding [], so just the string tag
  def parseOptions(string, tag)
    # Create array of the options between the open and close tags
    options = string.match(/\[#{tag}\](.*)\[\/#{tag}\]/m)[1].strip.split(/\r?\n/).map { |p| p.strip }

    # Create hash
    optionsToHash(options)
  end

  # Convert ["description: Door to back", "instruction: door", "room: 10"]
  # to { "description" => "Door to back", "instruction" => "door", "room" => "10" }
  def optionsToHash(options)
    # ex. ["description: Door to back", "instruction: door", "room: 10"]
    result = options.map do |o|
      key, value = o.split(':').map { |p| p.strip }
      { key => value }
    end

    # Now we have array of hashes, need to reduce to single hash
    result.reduce({}, :update)
  end


end
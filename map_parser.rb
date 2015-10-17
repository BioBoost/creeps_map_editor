require_relative "room"
require_relative "connection"

class MapParser

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
    # First we extract the connections if there are any
    connection_strings = string.match(/(\[connection\].*?\[\/connection\])/m)

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
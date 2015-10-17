require_relative "connection"

class MapParser

  # [connection]
  #   description: Door in the corner standing wide open. It seems to lead to the cellar.
  #   instruction: door
  #   room: 1
  # [/connection]
  def parseConnection(string, connection)
    # Create array of the options between the open and close tags
    options = string.match(/\[connection\](.*)\[\/connection\]/m)[1].strip.split(/\r?\n/).map { |p| p.strip }

    # ex. "instruction: door"
    options = options.map do |o|
      key, value = o.split(':').map { |p| p.strip }
      { key => value }
    end

    # Now we have array of hashes, need to reduce to single hash
    options = options.reduce({}, :update)

    # Sanity check
    if (!(options.has_key?('room') && options.has_key?('description') && options.has_key?('instruction')))
      raise "Missing options for connection: #{options.inspect}"
    end

    connection.setLeftOrRight(options['room'].to_i, options['description'], options['instruction'])
  end

  # [room]
  #   id: 2
  #   description: The backyard
  #   [connection]
  #     description: Window just big enough to fit through.
  #     instruction: window
  #     room: 1
  #   [/connection]
  # [/room]
  def parseRoom(string)
    
  end


end
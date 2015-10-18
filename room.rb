class Room
  attr_accessor :id, :description, :connections

  def initialize
    @id = -1
    @connections = Array.new
  end

  def to_s
    result = "[#{@id}] #{@description} \r\n"
    result += "It has following connections:\r\n#{connections.join}\r\n"
  end

  def to_cpp
    "Room room_#{@id}(\"#{@description}\");"
  end
end
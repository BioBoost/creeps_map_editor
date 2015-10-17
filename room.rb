class Room
  attr_accessor :id, :description, :connections

  def initialize
    @id = -1
    @connections = Array.new
  end

  def to_s
    result = "[#{@id}] #{@description} \r\n"
    result += "It has following connections: #{connections.join(' ')}\r\n"
  end
end
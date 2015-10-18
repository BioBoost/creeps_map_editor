class CppGenerator

  def generate(filename, rooms, connections)
    File.open(filename, 'w') do |file|

      # Output  all rooms
      rooms.each { |r| file.write(r.to_cpp + "\r\n") }

      file.write("\r\n")

      # Output  all connections
      connections.each { |c| file.write(c.to_cpp + "\r\n") }
    end
  end

end
class Connection
  attr_accessor :left_id, :right_id, :left_description, :right_description, :left_instruction, :right_instruction

  def initialize
    @left_id = -1
    @right_id = -1
  end

  def setLeftOrRight(id, description, instruction)
    if (@left_id == -1)
      setLeft(id, description, instruction)
    elsif (@right_id == -1)
      setRight(id, description, instruction)
    else
      raise "Connection already has both sides set"
    end
  end

  def setLeft(left_id, left_description, left_instruction)
    @left_id = left_id
    @left_description = left_description
    @left_instruction = left_instruction
  end

  def setRight(right_id, right_description, right_instruction)
    @right_id = right_id
    @right_description = right_description
    @right_instruction = right_instruction
  end

  def to_s
    result = "=====================================================================\r\n"
    result += "left: #{@left_id} => [#{@left_instruction}] #{@left_description}\r\n"
    result += "right: #{@right_id} => [#{@right_instruction}] #{@right_description}\r\n"
    result += "=====================================================================\r\n"
  end
end
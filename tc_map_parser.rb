require_relative "map_parser"
require "test/unit"
 
class TestMapParser < Test::Unit::TestCase
 
  def test_connection_parse_missing_options
    c = "[connection]
          description: Door in the corner standing wide open. It seems to lead to the cellar.
          room: 1
        [/connection]"

    conn = Connection.new
    parser = MapParser.new

    assert_raise(RuntimeError) { parser.parseConnection(c, conn) }
  end
 
  def test_connection_parse_left
    c = "[connection]
          description: Door in the corner standing wide open. It seems to lead to the cellar.
          instruction: door
          room: 1
        [/connection]"

    conn = Connection.new
    parser = MapParser.new

    parser.parseConnection(c, conn)

    assert_equal(1, conn.left_id)
    assert_equal('door', conn.left_instruction)
    assert_equal('Door in the corner standing wide open. It seems to lead to the cellar.', conn.left_description)
  end
 
  def test_connection_parse_right
    c = "[connection]
          description: Door in the corner standing wide open. It seems to lead to the cellar.
          instruction: door
          room: 1
        [/connection]"

    conn = Connection.new
    conn.setLeftOrRight(12, 'Window to the front yard', 'window')

    parser = MapParser.new

    parser.parseConnection(c, conn)

    assert_equal(12, conn.left_id)
    assert_equal('window', conn.left_instruction)
    assert_equal('Window to the front yard', conn.left_description)

    assert_equal(1, conn.right_id)
    assert_equal('door', conn.right_instruction)
    assert_equal('Door in the corner standing wide open. It seems to lead to the cellar.', conn.right_description)
  end
 
end
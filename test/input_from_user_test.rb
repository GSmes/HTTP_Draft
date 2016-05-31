require 'minitest/autorun'
require_relative '../lib/input_from_user'
require 'socket'

class InputFromUserTest < Minitest::Test

  def test_input_from_user_exists
    assert InputFromUser
  end

  def test_initializes_with_user_variable
    input = InputFromUser.new

    assert_equal :no_user, input.user
  end

  def test_initializes_with_empty_to_machine
    input = InputFromUser.new

    assert_equal [], input.to_machine
  end

  def test_initializes_with_user_server_input
    tcp_server = TCPServer.new(9292)
    input = InputFromUser.new(tcp_server)

    assert_equal tcp_server, input.user
  end

  def test_responds_to_read_request
    input = InputFromUser.new
    assert input.respond_to?(:read_request)
  end
end

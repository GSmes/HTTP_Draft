require 'minitest/autorun'
require_relative '../lib/output_to_user'
require 'socket'

class OutputToUserTest < Minitest::Test

  def test_input_from_user_exists
    assert OutputToUser
  end

  def test_initializes_with_no_user
    writer = OutputToUser.new

    assert_equal :no_user, writer.user
  end

  def test_responds_to_write_request
    output = OutputToUser.new
    assert output.respond_to?(:write_request_to_browser)
  end
end

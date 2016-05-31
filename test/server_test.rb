require 'minitest/autorun'
require_relative '../lib/server'
require 'socket'
require 'pry'

class ExecutableTest < Minitest::Test

  def input(path = "/", verb = "GET", guess = nil)
    ["#{verb} #{path} HTTP/1.1", "Host: 127.0.0.1:9292", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:41.0) Gecko/20100101 Firefox/41.0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language: en-US,en;q=0.5","Accept-Encoding: gzip, deflate", "Connection: keep-alive",guess]
  end

  def test_executable_class_exists
    assert Server
  end

  def test_updates_counter_when_update_called
    executor = Server.new(9292)
    parse = Parser.new(input)

    assert_equal 1, executor.counter

    executor.update_executable_variables(parse)

    assert_equal 2, executor.counter

    executor.tcp_server.close
  end

  def test_updates_hello_counter_when_update_called
    executor = Server.new(9292)
    parse = Parser.new(input("/hello"))

    assert_equal 1, executor.hello_counter

    executor.update_executable_variables(parse)

    assert_equal 2, executor.hello_counter

    executor.tcp_server.close
  end

  def test_doesnt_update_hello_counter_when_update_called_wrong_path
    executor = Server.new(9292)
    parse = Parser.new(input("/"))

    assert_equal 1, executor.hello_counter

    executor.update_executable_variables(parse)

    assert_equal 1, executor.hello_counter

    executor.tcp_server.close
  end

  def test_game_is_created_when_path_start_game
    executor = Server.new(9292)
    parse = Parser.new(input("/start_game","POST"))

    refute executor.game_running

    executor.update_executable_variables(parse)

    assert executor.game_running

    executor.tcp_server.close

  end

  def test_game_defines_number_unknown_to_player_when_started
    executor = Server.new(9292)
    parse = Parser.new(input("/start_game","POST"))

    refute executor.magic_number

    executor.update_executable_variables(parse)

    assert 0 < executor.magic_number && executor.magic_number < 100

    executor.tcp_server.close
  end

  def test_guess_is_stored
    executor = Server.new(9292)
    parse = Parser.new(input("/game","POST",46))

    executor.update_executable_variables(parse)

    assert_equal 46, executor.guess

    executor.tcp_server.close
  end
end

require 'minitest/autorun'
require_relative '../lib/machine'
require_relative '../lib/parser'
require 'socket'
require 'pry'

class MachineTest < Minitest::Test

  def input(path = "/", verb = "GET", guess = nil)
    ["#{verb} #{path} HTTP/1.1", "Host: 127.0.0.1:9292", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:41.0) Gecko/20100101 Firefox/41.0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language: en-US,en;q=0.5","Accept-Encoding: gzip, deflate", "Connection: keep-alive",guess]
  end

  def test_machine_exists
    assert Machine
  end

  def test_machine_initializes_with_parse_objects
    parse = Parser.new(input("/"))
    machine = Machine.new(parse)

    assert_equal parse, machine.parser
  end

  def test_machine_returns_iteration_1_with_empty_path
    parse = Parser.new(input("/"))
    machine = Machine.new(parse)
    expected = ["Verb: GET", "Path: /", "Protocol: HTTP/1.1", "Host: 127.0.0.1:9292", "Port: 9292", "Origin: 127.0.0.1", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]

    assert_equal expected, machine.process_request(3,4)
  end

  def test_machine_returns_iteration_0_with_hello_path
    parse = Parser.new(input("/hello"))
    machine = Machine.new(parse)
    expected = ["Hello", " World! (4)"]

    assert_equal expected, machine.process_request(3,4)
  end

  def test_machine_returns_iteration_0_with_hello_path_different_hello_counter
    parse = Parser.new(input("/hello"))
    machine = Machine.new(parse)
    expected = ["Hello", " World! (8)"]

    assert_equal expected, machine.process_request(5,8)
  end

  def test_machine_returns_datetime_with_datetime_path
    parse = Parser.new(input("/datetime"))
    machine = Machine.new(parse)
    expected = [Time.now.strftime("%l:%M %p on %A, %B %d, %Y")]
    assert_equal expected, machine.process_request(3,4)
  end

  def test_machine_returns_shut_down_output_with_shutdown_path
    parse = Parser.new(input("/shutdown"))
    machine = Machine.new(parse)
    expected = ["shutdown", "Total Requests: 3"]

    assert_equal expected, machine.process_request(3,4)
  end

  def test_machine_says_good_luck_when_path_start_game_and_verb_post
    parse = Parser.new(input("/start_game", "POST"))
    machine = Machine.new(parse)
    expected = ["Good Luck"]

    assert_equal expected, machine.process_request(8,7)
  end

  def test_machine_says_nothing_when_path_start_game_and_verb_not_post
    parse = Parser.new(input("/start_game", "GET"))
    machine = Machine.new(parse)
    expected = ["No game started"]

    assert_equal expected, machine.process_request(8,7)
  end

  def test_machine_starts_game_when_path_start_game_and_post
    parse = Parser.new(input("/start_game", "POST"))
    machine = Machine.new(parse)
    machine.process_request(8,8)

    assert_equal true, machine.game
  end

  def test_machine_does_not_start_game_when_path_is_not_start_game_and_post
    parse = Parser.new(input("/start_game", "GET"))
    machine = Machine.new(parse)
    machine.process_request(8,8)

    refute machine.game
  end

  def test_game_returns_too_low_when_guess_less_than_magic_number
    parse = Parser.new(input("/game", "POST",46))
    machine = Machine.new(parse)

    machine.magic_number = 50

    assert_equal 50, machine.magic_number
    assert_equal 46, machine.guess
    assert_equal "too low", machine.game_results[0]
  end

  def test_game_returns_too_high_when_guess_greater_than_magic_number
    parse = Parser.new(input("/game", "POST",46))
    machine = Machine.new(parse)

    machine.magic_number = 44

    assert_equal 44, machine.magic_number
    assert_equal 46, machine.guess
    assert_equal "too high", machine.game_results[0]
  end

  def test_game_returns_too_low_when_guess_less_than_magic_number
    parse = Parser.new(input("/game", "POST",46))
    machine = Machine.new(parse)

    machine.magic_number = 46

    assert_equal 46, machine.magic_number
    assert_equal 46, machine.guess
    assert_equal "correct", machine.game_results[0]
  end

  def test_machine_returns_results_to_guess
    parse = Parser.new(input("/game", "POST",46))
    machine = Machine.new(parse)

    machine.magic_number = 50
    machine.game_running = true

    assert_equal "too_low", machine.process_request(7,8)
  end
end

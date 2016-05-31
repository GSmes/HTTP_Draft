require 'minitest/autorun'
require_relative '../lib/parser'
require 'socket'

class ParserTest < Minitest::Test

  def input(path = "/", verb = "GET")
    ["#{verb} #{path} HTTP/1.1", "Host: 127.0.0.1:9292", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:41.0) Gecko/20100101 Firefox/41.0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language: en-US,en;q=0.5","Accept-Encoding: gzip, deflate", "Connection: keep-alive"]
  end

  def test_parser_exists
    assert Parser
  end

  def test_initializes_with_to_machine
    parse = Parser.new(input)

    assert_equal input, parse.to_machine
  end

  def test_can_return_path
    parse = Parser.new(input)

    assert_equal "/", parse.path
  end

  def test_can_return_path_when_param_passed
    parse = Parser.new(input("/word_search?word=piz"))

    assert_equal "/word_search", parse.path
  end

  def test_can_return_param_when_param_passed
    parse = Parser.new(input("/word_search?word=piz"))

    assert_equal "word", parse.word_param
  end

  def test_can_return_param_value_when_param_passed
    parse = Parser.new(input("/word_search?word=piz"))

    assert_equal "piz", parse.word_param_entry
  end

  def test_can_return_verb
    parse = Parser.new(input)

    assert_equal "GET", parse.verb
  end

  def test_can_return_post_verb
    parse = Parser.new(input("/","POST"))

    assert_equal "POST", parse.verb
  end

  def test_can_return_protocol
    parse = Parser.new(input)

    assert_equal "HTTP/1.1", parse.protocol
  end

  def test_can_return_host
    parse = Parser.new(input)

    assert_equal "127.0.0.1:9292", parse.host
  end

  def test_can_return_port
    parse = Parser.new(input)

    assert_equal "9292", parse.port
  end

  def test_can_return_origin
    parse = Parser.new(input)

    assert_equal "127.0.0.1", parse.origin
  end
end

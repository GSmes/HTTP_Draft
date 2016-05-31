require 'pry'
require_relative 'server'

class Machine

  def dictionary
    ["hello", "pizza", "tired"]
  end

  attr_reader :parser, :game, :guess_verdict, :guess
  attr_accessor :magic_number, :game_running

  def initialize(parse,magic_number = nil,game_running=false)
    @parser = parse
    @game_running = game_running
    @guess = parse.guess
    @magic_number = magic_number
  end

  def game_results
    verdict = @guess <=> @magic_number
    case verdict
    when -1
      ["too low"]
    when 0
      ["correct"]
    when 1
      ["too high"]
    end
  end

  def process_request(counter,hello_counter)
    case @parser.path
      when "/"
        ["Verb: #{parser.verb}"] + ["Path: #{parser.path}"] + ["Protocol: #{parser.protocol}"] + ["Host: #{parser.host}"] + ["Port: #{parser.port}"] + ["Origin: #{parser.origin}"] + ["#{parser.accept}"]
      when "/hello"
        ["Hello"] +[" World! (#{hello_counter})"]
      when "/datetime"
        [Time.now.strftime("%l:%M%p on %A, %B %d, %Y")]
      when "/shutdown"
        ["shutdown","Total Requests: #{counter}"]
      when "/word_search"
        if dictionary.include?(@parser.word_param_entry)
          ["word is a known word"]
        else
          ["word is not a known word"]
        end
      when "/start_game"
        if @parser.verb == "POST"
          @game = true
              # TO DO: define a number to measure against
          ["Good Luck"]
        else
          ["No game started"]
        end
      when "/game"
          if @parser.verb == "GET" && @game_running
            #  return results of counter
              # TO DO: create a counter
          elsif @parser.verb == "POST" && @game_running
            if @parser.guess == true
              game_results
            end
            # execute redirect back to get game
              # TO DO: define method for looping back to process_request with new input
          else
            ["Not in game!"]
          end
      else

    end
  end
end

# <pre>
# Verb: POST
# Path: /
# Protocol: HTTP/1.1
# Host: 127.0.0.1
# Port: 9292
# Origin: 127.0.0.1
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
# </pre>

# Verb: @input[0].split[0]
# Path: / @input[0].split[1]
# Protocol: HTTP/1.1    @input[0].split[2]
# Host: 127.0.0.1   @input[1].split(":")[1].strip
# Port: 9292 @input[1].split(":")[2].strip
# Origin: 127.0.0.1   @input[1].split(":")[1].strip
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8 @input[3]
# </pre>
#

# need 404 if unknown path entered

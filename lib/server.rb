require 'pry'
require 'socket'
require_relative 'input_from_user'
require_relative 'output_to_user'
require_relative 'machine'
require_relative 'parser'

class Server
  attr_accessor :user, :counter, :tcp_server, :hello_counter, :game_running, :guess, :guess_verdict, :magic_number

  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @counter = 1
    @hello_counter = 1
    @game_running = false
    @game_correct_answer = nil
    @game_guess = nil
    @game_guess_counter = 0
  end

  def accept_user
    @user = tcp_server.accept
  end

  def input_from_user
    user_input = InputFromUser.new(user)
    user_input.read_request
    user_input.to_machine
  end

  def output_response_to_user(output)
    user_friendly_output = OutputToUser.new(user)
    user_friendly_output.write_request_to_browser(output)
  end

  def update_executable_variables(parse)
    case parse.path

      when "/hello"
        @hello_counter += 1

      when "/start_game"
        if parse.verb == "POST"
          @game_running = true
          @magic_number = rand(100)
        end

      when "/game"
        if parse.verb == "POST"
          @guess = parse.guess
        # elsif parse.verb == "GET"
        #
        end
      end

    @counter += 1
  end

  # def guess_verdict
  #   verdict = @guess <=> @magic_number
  # end

  def process_many_requests
    loop do
      input = input_from_user

      parsed_input = Parser.new(input)
      machine = Machine.new(parsed_input,@magic_number,@game_running)
      output = machine.process_request(counter,hello_counter)
      output_response_to_user(output)

      update_executable_variables(parsed_input)

      if parsed_input.path == "/shutdown"
        break
      end
    end
    user.close
  end

end

if __FILE__ == $0
  executor = Server.new(9292)
  executor.accept_user
  executor.process_many_requests
end


# class Server
#   def initialize
#     @count = 0
#   end
#
#   def server_start #we read request from user
#     tcp_server = TCPServer.new(9292)
#     user = tcp_server.accept
#     loop do
#       request(user)
#     end
#   end
#     #when the program runs, it'll hang on that gets method call waiting for a request to come in. When it arrives it'll get read and stored into request_lines
#     def request(user)   #store all request lines in array
#     puts "Ready for a request"
#     request_lines = []
#     while line = user.gets and !line.chomp.empty?
#       request_lines << line.chomp
#     end
# # binding.pry
#     response(request_lines, user)
#
#   end
#
#   def response(request_lines, user)
#     @count +=1
#     puts "Got this request:"
#     puts request_lines.inspect
#     #print response
#     puts "Sending response."
#     response = "<pre>" + ("\n") + "Hello, World!(#{@count})" + "</pre>"
#     output = "<html><head></head><body>#{response}</body></html>"
#     # headers =
#     headers = ["http/1.1 200 ok",
#               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
#               "server: ruby",
#               "content-type: text/html; charset=iso-8859-1",
#               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
#     user.puts headers
#     user.puts output
#     #close server
#     puts ["Wrote this response:", headers, output].join("\n")
#     # user.close
#     # puts "\nResponse complete, exiting."
#   end
# end
#
# s = Server.new
# s.server_start

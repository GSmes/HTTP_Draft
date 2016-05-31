require_relative 'server.rb'

class OutputToUser

  attr_accessor :user

  def initialize(user = :no_user)
    @user = user
  end

  def write_request_to_browser(from_machine)
    if from_machine.nil?
      ["some stuff"]
    else
      response = "<pre>" + from_machine.join("\n") + "</pre>"
    end
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    user.puts headers
    user.puts output
  end
end

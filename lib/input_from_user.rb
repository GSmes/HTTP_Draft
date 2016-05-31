require 'pry'

class InputFromUser
  attr_accessor :user, :to_machine

  def initialize(user=:no_user, to_machine = [])
    @user = user
    @to_machine = to_machine
  end

  def read_request
    while line = user.gets and !line.chomp.empty?
      @to_machine << line.chomp
    end
  end
end

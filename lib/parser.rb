require_relative 'server'
require 'pry'

class Parser
  attr_reader :to_machine

  def initialize(to_machine)
    @to_machine = to_machine
  end

  def path
    to_machine[0].split[1].split("?")[0]
  end

  def word_param
    to_machine[0].split[1].split("?")[1].split("=")[0]
  end

  def word_param_entry
    to_machine[0].split[1].split("?")[1].split("=")[1]
  end

  def guess?
    word_param == "guess"
  end

  def guess
    to_machine[7]
  end

  def verb
    to_machine[0].split[0]
  end

  def protocol
    to_machine[0].split[2]
  end

  def host
    to_machine[1].split(":")[1].strip + ":" + to_machine[1].split(":")[2].strip
  end

  def port
    to_machine[1].split(":")[2].strip
  end

  def origin
    to_machine[1].split(":")[1].strip
  end

  def accept
    to_machine[3]
  end
end

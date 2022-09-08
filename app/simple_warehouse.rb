# frozen_string_literal: true

require_relative './command'

class SimpleWarehouse
  def run
    puts 'Type `help` for instructions on usage'
    while Command.live
      print '> '
      command = gets.chomp
      Command.execute(command)
    end
  end
end

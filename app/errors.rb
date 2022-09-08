# frozen_string_literal: true

module Errors
  class ValidationError < StandardError
    def message
      puts('The command is used incorrectly. Type `help` for instructions')
    end
  end

  class NoWarehouseError < StandardError
    def message
      puts('Please create a warehouse. Type `help` for instructions')
    end
  end

  class NoCrateError < StandardError
    def message
      puts('Crate with given code does not exist')
    end
  end

  class CrateAlreadyExistsError < StandardError
    def message
      puts('Crate with given code already exists. Please choose another code')
    end
  end

  class ArgumentError < StandardError
    def message
      puts('Coordinates should we higher than 0')
    end
  end

  class CapacityError < StandardError
    def message
      puts('Not enough space in warehouse')
    end
  end
end

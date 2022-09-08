# frozen_string_literal: true

require_relative './models/warehouse'
require_relative './models/crate'
require_relative 'regex'
require_relative 'errors'

class Command
  @warehouse = nil
  @live = true

  class << self
    attr_reader :warehouse, :live
  end

  def self.init_warehouse(command)
    matchdata = validate_input(command, Regex::INIT)
    width, height = matchdata.captures.map(&:to_i)
    @warehouse = Warehouse.new(width, height)
  end

  def self.store(command)
    check_warehouse_exists
    matchdata = validate_input(command, Regex::STORE)
    x, y, width, height = matchdata[1..4].to_a.map(&:to_i)
    product_code = matchdata[:pcode]
    check_crate_is_duplicate(product_code)
    new_crate = Crate.new(x, y, width, height, product_code)
    @warehouse.store_and_update(new_crate)
  end

  def self.locate(command)
    check_warehouse_exists
    matchdata = validate_input(command, Regex::LOCATE)
    check_crate_exists(matchdata[:pcode])
    coords = @warehouse.get_crate_coordinates(matchdata[:pcode])
    p("List of locations occupied by Product: #{matchdata[:pcode]}", coords)
  end

  def self.remove(command)
    check_warehouse_exists
    matchdata = validate_input(command, Regex::REMOVE)
    x, y = matchdata.captures.map(&:to_i)
    @warehouse.delete_crate(x, y)
  end

  def self.view(_command)
    check_warehouse_exists
    @warehouse.view
  end

  def self.show_unrecognized_message(_)
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def self.show_help_message(_)
    puts <<~HELP
      help             Shows this help message
      init W H         (Re)Initialises the application as an empty W x H warehouse.
      store X Y W H P  Stores a crate of product code P and of size W x H at position (X,Y).
      locate P         Show a list of all locations occupied by product code P.
      remove X Y       Remove the entire crate occupying the location (X,Y).
      view             Output a visual representation of the current state of the grid.
      exit             Exits the application.
    HELP
  end

  def self.exit(_)
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

  def self.check_warehouse_exists
    raise Errors::NoWarehouseError if @warehouse.nil?
  end

  def self.check_crate_exists(product_code)
    raise Errors::NoCrateError if @warehouse.directory[product_code].nil?
  end

  def self.check_crate_is_duplicate(product_code)
    raise Errors::CrateAlreadyExistsError if @warehouse.directory[product_code]
  end

  def self.execute(command)
    x = COMMAND_MAP.select { |k| command.include?(k) }.values[0]
    x.call(command)
  rescue *COMMON_EXCEPTIONS => e
    e.message
  end

  def self.validate_input(command, regex)
    matchdata = command.match(regex)
    matchdata.nil? ? (raise Errors::ValidationError) : matchdata
  end

  COMMAND_MAP = {
    'init' => method(:init_warehouse),
    'store' => method(:store),
    'locate' => method(:locate),
    'remove' => method(:remove),
    'view' => method(:view),
    'help' => method(:show_help_message),
    'exit' => method(:exit),
    '' => method(:show_unrecognized_message)
  }.freeze

  COMMON_EXCEPTIONS = [
    Errors::ValidationError,
    Errors::NoWarehouseError,
    Errors::NoCrateError,
    Errors::ArgumentError,
    Errors::CapacityError,
    Errors::CrateAlreadyExistsError
  ].freeze
end

# frozen_string_literal: true

require_relative '../errors'

class Warehouse
  attr_reader :warehouse_matrix, :directory, :width, :height

  def initialize(width, height)
    validate_input(width, height)
    @width = width
    @height = height
    @warehouse_matrix = Array.new(@height) { Array.new(@width) { 0 } }
    @coordinates = coordinates
    @directory = { 'unoccupied' => unoccupied }
  end

  def coordinates
    @warehouse_matrix
      .first.each_index.to_a.map { |x| x + 1 }
      .product(@warehouse_matrix.each_index.to_a.map { |x| x + 1 })
  end

  def unoccupied
    @coordinates.find_all { |x, y| (@warehouse_matrix[y - 1][x - 1]) == 0 }
  end

  def get_crate_coordinates(product_code)
    @directory[product_code]
  end

  def store_and_update(crate)
    raise Errors::CapacityError unless available_space?(crate)

    populate_warehouse_matrix(crate)
    @directory[crate.product_code] = crate.coordinates
    @directory['unoccupied'] = @directory['unoccupied'] - @directory[crate.product_code]
  end

  def delete_crate(x, y)
    product_code = get_product_code(x, y)
    raise Errors::NoCrateError if product_code == 0

    released_coordinates = release_crate_space(product_code)
    populate_warehouse_matrix(released_coordinates)
    update_directory(product_code)
  end

  def view
    counter = @height
    @warehouse_matrix.reverse_each do |x|
      print(counter, ' ')
      puts x.join(' ')
      counter -= 1
    end
    (0..@width).each do |x|
      print(x, ' ')
    end
    puts(' ')
  end

  private

  def validate_input(width, height)
    raise Errors::ArgumentError if [width, height].any? { |x| x <= 0 }
  end

  def update_directory(product_code)
    @directory['unoccupied'] = unoccupied
    @directory = @directory.reject! { |k| k == product_code }
  end

  def release_crate_space(product_code)
    coords = get_crate_coordinates(product_code)
    x, y = coords[0]
    width, height = coords[-1] - [x - 1, y - 1]
    Crate.new(x, y, width, height, 0)
  end

  def get_product_code(x, y)
    raise Errors::CapacityError if x > @width || y > @height

    @warehouse_matrix[y - 1][x - 1]
  end

  def available_space?(crate)
    (crate.coordinates & @directory['unoccupied']) == crate.coordinates
  end

  def populate_warehouse_matrix(crate)
    x_start, y_start = [crate.x, crate.y].map { |n| n - 1 }
    x_end, y_end = [x_start + crate.width, y_start + crate.height].map { |n| n - 1 }

    (y_start..y_end).each do |i|
      @warehouse_matrix[i][x_start..x_end] = [crate.product_code] * crate.width
    end
    @warehouse_matrix
  end
end

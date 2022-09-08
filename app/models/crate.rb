# frozen_string_literal: true

require_relative '../errors'

class Crate
  attr_reader :x, :y, :width, :height, :product_code

  def initialize(x, y, width, height, product_code)
    @x = x
    @y = y
    @width = width
    @height = height
    @product_code = product_code
    @coordinates = coordinates
  end

  def coordinates
    crate_matrix = Array.new(@height) { Array.new(@width) { 0 } }
    crate_matrix.first.each_index.to_a.map { |a| a + @x }.product(crate_matrix.each_index.to_a.map { |b| b + @y })
  end
end

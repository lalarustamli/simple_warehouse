# frozen_string_literal: true

require_relative '../spec_helper'

describe Warehouse do
  let(:width) { 10 }
  let(:height) { 10 }
  let(:warehouse) { Warehouse.new(width, height) }
  let(:crate) { Crate.new(1, 1, 2, 3, 'a') }

  describe '.init' do
    context 'when initialized with arguments' do
      it 'creates a warehouse' do
        expect([warehouse.width, warehouse.height]).to eq([width, height])
        expect(warehouse.warehouse_matrix).to eq(Array.new(height) { Array.new(width) { 0 } })
        expect(warehouse.coordinates.length).to eq(width * height)
        expect(warehouse.directory['unoccupied']).to eq(warehouse.coordinates)
      end
    end
  end

  describe '.store_and_update' do
    context 'given a crate to store in warehouse' do
      it 'stores crate and updates the directory' do
        expect(warehouse).to receive(:populate_warehouse_matrix)
        warehouse.store_and_update(crate)
        assert_crate_exists('a')
        expect(warehouse.directory['a']).to eq(crate.coordinates)
      end
    end
  end

  describe '.delete' do
    context 'given X Y coordinates to discharge' do
      it 'removes the whole crate existing in X Y' do
        warehouse.store_and_update(crate)
        expect(warehouse.directory['a']).not_to eq(nil)
        warehouse.delete_crate(1, 1)
        expect(warehouse.directory['a']).to eq(nil)
        expect(warehouse.directory['unoccupied']).to eq(warehouse.coordinates)
      end
    end

    context 'when multiple crates exist in warehouse' do
      it 'only removes the crate existing in X Y' do
        crate2 = Crate.new(3, 4, 2, 3, 'b')
        warehouse.store_and_update(crate)
        warehouse.store_and_update(crate2)
        assert_crate_exists('a')
        assert_crate_exists('b')
        warehouse.delete_crate(1, 1)
        assert_crate_is_removed('a')
        assert_crate_exists('b')
        expect(warehouse.directory['unoccupied']).to eq(warehouse.unoccupied)
      end
    end
  end

  def assert_crate_exists(product_code)
    expect(warehouse.directory[product_code]).not_to eq(nil)
  end

  def assert_crate_is_removed(product_code)
    expect(warehouse.directory[product_code]).to eq(nil)
  end
end

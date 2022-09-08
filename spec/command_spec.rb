# frozen_string_literal: true

require 'spec_helper'

describe Command do
  shared_examples_for 'ValidationError' do
    it 'raises ValidationError' do
      expect { command }.to raise_error(Errors::ValidationError)
    end
  end

  shared_examples_for 'NoWarehouseError' do
    it 'raises NoWarehouseError' do
      expect { command }.to raise_error(Errors::NoWarehouseError)
    end
  end

  shared_examples_for 'NoCrateError' do
    it 'raises NoCrateError' do
      expect { command }.to raise_error(Errors::NoCrateError)
    end
  end

  before do
    allow($stdout).to receive(:write)
  end

  context 'when warehouse is not initiated' do
    describe '.store' do
      let(:command) { Command.store(args) }
      let(:args) { 'store 1 1 3 4 a' }
      it_behaves_like 'NoWarehouseError'
    end

    describe '.locate' do
      let(:command) { Command.locate(args) }
      let(:args) { 'locate a' }
      it_behaves_like 'NoWarehouseError'
    end

    describe '.remove' do
      let(:command) { Command.remove(args) }
      let(:args) { 'remove 1 1' }
      it_behaves_like 'NoWarehouseError'
    end

    describe '.view' do
      let(:command) { Command.view(args) }
      let(:args) { 'view' }
      it_behaves_like 'NoWarehouseError'
    end
  end

  describe '.init_warehouse' do
    let(:command) { Command.init_warehouse(args) }
    let(:warehouse) { command }

    context 'given correct arguments' do
      let(:args) { 'init 3 5' }
      it 'creates a warehouse with given size' do
        expect(warehouse).to be_instance_of(Warehouse)
        expect(warehouse.width).to eq(3)
        expect(warehouse.height).to eq(5)
      end
    end

    context 'given incorrect arguments' do
      let(:args) { 'init 3' }
      it_behaves_like 'ValidationError'
    end
  end

  context 'when warehouse has been initiated' do
    before do
      Command.init_warehouse('init 3 4')
    end
    describe '.store' do
      let(:command) { Command.store(args) }

      context 'given correct arguments' do
        let(:args) { 'store 1 1 3 4 a' }
        it 'create and stores crate in warehouse' do
          expect(Command.warehouse).to receive(:store_and_update)
          expect { command }.not_to raise_error
        end
      end

      context 'given incorrect arguments' do
        let(:args) { 'store 3' }
        it_behaves_like 'ValidationError'
      end
    end

    describe '.locate' do
      let(:command) { Command.locate(args) }

      context 'without storing the crate' do
        let(:args) { 'locate a' }
        it_behaves_like 'NoCrateError'
      end

      context 'when crate has been stored' do
        let(:args) { 'locate a' }
        it 'retrieves all coordinates' do
          Command.store('store 1 1 3 4 a')
          expect(Command.warehouse.get_crate_coordinates('a')).to eq(Command.warehouse.directory['a'])
          expect { command }.not_to raise_error
        end
      end
    end

    describe '.remove' do
      let(:command) { Command.remove(args) }

      context 'given correct arguments' do
        let(:args) { 'remove 1 1' }
        it 'removes crate in given location' do
          Command.store('store 1 1 3 4 a')
          expect(Command.warehouse).to receive(:delete_crate)
          expect { command }.not_to raise_error
        end
      end
    end

    describe '.view' do
      let(:command) { Command.view(args) }

      context 'given correct arguments' do
        let(:args) { 'view' }
        it 'returns a matrix representation of warehouse' do
          expect(Command.warehouse).to receive(:view)
          expect { command }.not_to raise_error
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../spec_helper'

describe Crate do
  let(:x) { 1 }
  let(:y) { 2 }
  let(:width) { 3 }
  let(:height) { 4 }
  let(:product_code) { 'a' }
  let(:crate) { Crate.new(x, y, width, height, product_code) }

  describe '.init' do
    context 'when initialized with arguments' do
      it 'creates a crate' do
        expect([crate.x, crate.y, crate.width, crate.height,
                crate.product_code]).to eq([x, y, width, height, product_code])
      end
    end
  end

  describe '.coordinates' do
    context 'given crate is created' do
      it 'returns all locations occupied by crate' do
        expect(crate.coordinates).to be_instance_of(Array)
        expect(crate.coordinates.length).to eq(width * height)
      end
    end
  end
end

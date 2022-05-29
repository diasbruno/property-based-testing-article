# frozen_string_literal: true

require 'pry'
require 'rantly/rspec_extensions'

class Recipient
  attr_accessor :capacity, :quantity

  def self.filled(capacity, quantity)
    new(capacity, quantity)
  end

  def self.empty(capacity)
    filled(capacity, 0)
  end

  def initialize(capacity, quantity)
    @capacity = capacity
    @quantity = quantity
  end
end

class Bucket < Recipient
  def fill(cup)
    @quantity += cup.quantity
    self
  end

  def full?
    @quantity == @capacity
  end
end

class Cup < Recipient; end

RSpec.describe Cup do
  describe 'instantiation' do
    it 'initialize with quantity' do
      expect do
        described_class.filled(1, 1)
      end.not_to raise_exception
    end

    it 'initialize empty' do
      expect do
        described_class.empty(1)
      end.not_to raise_exception
    end
  end
end

RSpec.describe Bucket do
  describe 'instantiation' do
    it 'initialize with quantity' do
      expect do
        described_class.filled(1, 1)
      end.not_to raise_exception
    end

    it 'initialize empty' do
      expect do
        described_class.empty(1)
      end.not_to raise_exception
    end
  end

  describe 'filling the bucket' do
    it 'should not overflow' do
      # args are (capacity, quantity)
      b = described_class.filled(rand, rand)
      c = Cup.filled(rand, rand)

      expect(b.fill(c).quantity).to be <= b.capacity
    end
  end
end

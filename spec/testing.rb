# frozen_string_literal: true

require 'pry'
require 'rantly/rspec_extensions'

def assert(bool, msg)
  raise StandardError, msg unless bool
end

CAPACITY_GREATER_THAN_ZERO = 'CAPACITY_GREATER_THAN_ZERO'
QUATITY_BETWEEN_ZERO_AND_CAPACITY = 'QUATITY_BETWEEN_ZERO_AND_CAPACITY'

class Recipient
  def self.validate(capacity, quantity)
    assert(capacity > 0, CAPACITY_GREATER_THAN_ZERO)
    assert(quantity >= 0 && quantity <= capacity, QUATITY_BETWEEN_ZERO_AND_CAPACITY)

    true
  end

  def self.filled(capacity, quantity)
    validate(capacity, quantity)
    new(capacity, quantity)
  end

  def self.empty(capacity)
    filled(capacity, 0)
  end

  attr_accessor :capacity, :quantity

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

RSpec.describe Recipient do
  describe 'instantiate' do
    it 'must fail for every case' do
      p = property_of do
        capacity = integer
        quantity = integer
        guard(capacity < 0 || quantity < 0 || quantity > capacity)
        [capacity, quantity]
      end
      p.check do |opts|
        capacity, quantity = opts
        expect {
          Recipient.filled(capacity, quantity)
        }.to raise_error(StandardError)
      end
    end
  end
end

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

      # if the cup is not empty, bucket must not be full
      # there is the case where the cup is empty
      if c.quantity > 0
        expect(b.quantity).to be < b.capacity
      else
        expect(b.quantity).to be <= b.capacity
      end
      # cup must not overflow
      expect(c.quantity).to be <= c.capacity
      # filling the bucket must not overflow
      expect(b.fill(c).quantity).to be <= b.capacity
    end
  end
end

# frozen_string_literal: true

require 'pry'
require 'rantly/rspec_extensions'

class Recipient; end

class Bucket < Recipient; end

class Cup < Recipient; end

RSpec.describe Bucket do
  describe 'instantiation' do
    it 'classes' do
      expect(described_class.new.nil? || Cup.new.nil?).to be(false)
    end
  end
end

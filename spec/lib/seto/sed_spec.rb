require 'spec_helper'

module Seto
  describe Sed do
    let(:sed) { Sed.new }

    it 'has the following methods' do
      m = sed.methods
      m.should include(:address)
      m.should include(:d)
      m.should include(:s)
    end
  end
end

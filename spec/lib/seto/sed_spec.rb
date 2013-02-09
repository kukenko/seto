require 'spec_helper'

module Seto
  describe Sed do
    it 'has the following methods' do
      m = Sed.new(File.open(__FILE__).each).methods
      m.should include(:load)
      m.should include(:run)
      m.should include(:address)
      m.should include(:d)
      m.should include(:s)
    end

    describe '#s(pattern, replacement)' do
      it "substitutes 'replacement' for 'pattern'" do
        sed = Sed.new(File.open('./spec/files/seto_is.txt').each)
        sed.load do
          s /is/, 'no'
          s /a place name/, 'Hanayome'
          s /pseudo sed/, 'Hanayome'
        end
        sed.run.should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
      end
    end
  end
end

require 'spec_helper'

module Seto
  describe Sed do
    it 'has the following methods' do
      m = Sed.new(File.open(__FILE__).each).methods
      m.should include(:edit)
      m.should include(:address)
      m.should include(:d)
      m.should include(:s)
    end

    describe '#s(pattern, replacement)' do
      it "substitutes 'replacement' for 'pattern'" do
        sed = Sed.new(File.open('./spec/files/seto_is.txt').each)
        sed.edit do
          s /is/, 'no'
          s /a place name/, 'Hanayome'
          s /pseudo sed/, 'Hanayome'
        end
        .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
      end
    end

    describe '#d' do
      it 'deletes current line' do
        sed = Sed.new(File.open(__FILE__).each)
        sed.edit { d }.should be_empty
      end
    end
  end
end

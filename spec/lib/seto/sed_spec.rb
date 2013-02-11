require 'spec_helper'

module Seto
  describe Sed do
    SIMPLE = './spec/files/simple.txt'
    SETOIS = './spec/files/seto_is.txt'

    let(:simple) { Sed.new(File.open(SIMPLE).each.with_index(1)) }
    let(:setois) { Sed.new(File.open(SETOIS).each.with_index(1)) }

    it 'has the following methods' do
      m = Sed.new(File.open(__FILE__).each).methods
      m.should include(:edit)
      m.should include(:address)
      m.should include(:a)
      m.should include(:d)
      m.should include(:i)
      m.should include(:s)
    end

    describe '#a' do
      it 'appends text to current line' do
        simple.edit { a 'by ruby.'}
        .should eql(["Seto is pseudo sed.\nby ruby."])
      end
    end

    describe '#d' do
      it 'deletes current line' do
        simple.edit { d }.should be_empty
      end
    end

    describe '#i' do
      it 'inserts text before current line' do
        simple.edit { i 'by ruby.' }
        .should eql(["by ruby.Seto is pseudo sed.\n"])
      end
    end

    describe '#s(pattern, replacement)' do
      it "substitutes 'replacement' for 'pattern'" do
        setois.edit do
          s /is/, 'no'
          s /a place name/, 'Hanayome'
          s /pseudo sed/, 'Hanayome'
        end
        .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
      end
    end
  end
end

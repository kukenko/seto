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

    describe '#address' do
      it 'selects the rows that apply commands' do
        setois.edit do
          s /is/, 'no' if address(2)
          s /a place name/, 'Hanayome' if address(2)
        end
        .should eql(["Seto is pseudo sed.\n", "Seto no Hanayome.\n"])
      end

      context 'with block' do
        it 'selects the rows that apply commands' do
          setois.edit do
            address(2) {
              s /is/, 'no'
              s /a place name/, 'Hanayome'
            }
          end
          .should eql(["Seto is pseudo sed.\n", "Seto no Hanayome.\n"])
        end
      end
    end

    describe '#a' do
      it 'appends text to current line' do
        simple.edit { a 'by ruby.'}
        .should eql(["Seto is pseudo sed.\nby ruby."])
      end
    end

    describe '#c' do
      it 'changes the current line with text' do
        simple.edit { c 'This line has been censored.'}
        .should eql(["This line has been censored."])
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

    describe '#s' do
      it 'changes occurrence of the regular expression into a new value' do
        setois.edit do
          s /is/, 'no'
          s /a place name/, 'Hanayome'
          s /pseudo sed/, 'Hanayome'
        end
        .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
      end
      context 'with g flag' do
        it 'changes all occurrence of the regular expression into a new value' do
          simple.edit { s /s/, 'S', :g }
          .should eql(["Seto iS pSeudo Sed.\n"])
        end
      end
    end

    describe '#y' do
      it 'transforms characters into the other charaters' do
        simple.edit { y 'a-z', 'A-Z' }
        .should eql(["SETO IS PSEUDO SED.\n"])
      end
    end
  end
end

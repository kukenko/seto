require 'spec_helper'

describe String do
  let(:string) { File.open('./spec/files/seto_is.txt').read }

  describe '#sed' do
    it 'executes Seto::Sed commands' do
      string.sed do
        s /is/, 'no'
        s /a place name/, 'Hanayome'
        s /pseudo sed/, 'Hanayome'
      end
      .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
    end

    it 'executes Seto::Sed commands with address block' do
      string.sed do
        s /is/, 'no'
        address(2) { s /a place name/, 'Hanayome' }
        s /pseudo sed/, 'Hanayome'
      end
      .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
    end
  end
end

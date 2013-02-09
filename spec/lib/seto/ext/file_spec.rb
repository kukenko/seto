require 'spec_helper'

describe File do
  let(:file) { File.open('./spec/files/seto_is.txt') }

  describe '#sed' do
    it 'executes Seto::Sed commands' do
      file.sed do
        s /is/, 'no'
        s /a place name/, 'Hanayome'
        s /pseudo sed/, 'Hanayome'        
      end
      .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
    end
  end
end

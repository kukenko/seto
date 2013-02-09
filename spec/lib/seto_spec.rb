require 'spec_helper'

describe Seto do
  it 'extends the String class' do
    ''.methods.should include(:sed)
  end

  it 'extends the File class' do
    File.open(__FILE__).methods.should include(:sed)
  end
end

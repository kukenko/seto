require 'spec_helper'

describe Seto do
  it 'extends the String class' do
    ''.methods.should include(:sed)
  end

  it 'extends the IO class' do
    IO.new(0).methods.should include(:sed)
  end
end

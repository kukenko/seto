class String
  def sed(&block)
    Seto::Sed.new(self.each_line.with_index(1)).edit &block
  end
end

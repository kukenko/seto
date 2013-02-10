require 'seto/sed'

class File
  def sed(&block)
    Seto::Sed.new(self.each.with_index(1)).edit &block
  end
end

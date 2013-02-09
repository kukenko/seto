require 'seto/sed'

class File
  def sed(&block)
    Seto::Sed.new(self.each).edit &block
  end
end

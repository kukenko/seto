require 'seto/sed'

class File
  def sed(&block)
    sed = Seto::Sed.new(self.each)
    sed.load &block
    sed.run
  end
end

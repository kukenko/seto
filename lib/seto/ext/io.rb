# require 'seto/editor'

class IO
  def sed(&block)
    # Seto::Sed.new(self.each.with_index(1)).edit &block
    Seto::Editor.new(self.each.with_index(1)).edit &block
  end
end

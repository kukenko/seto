require 'seto'
require 'seto/editor'
require 'stringio'

def capture
  begin
    $stdout = StringIO.new
    yield
    out = $stdout.string
  ensure
    $stdout = STDOUT
  end
  out
end

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'seto'

DATA.sed {
  address(/<html>/) {
    n
    i <<-EOS
  <head>
    <title>hello world</title>
  </head>
EOS
  }
  p
}

__END__
<html>
  <body>
    Hello Seto World.
  </body>
</html>

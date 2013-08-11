$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'seto'

DATA.sed {
  s /<b>/, '<strong>'
  s %r!</b>!, '</strong>'
  p
}

__END__
<html>
  <body>
    Hello <b>Seto</b> World.
  </body>
</html>

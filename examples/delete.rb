$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'seto'

DATA.sed {
  d if address(/<!--/, /-->/)
}.each { |l| puts l }

__END__
<html>
  <body>
    <!--
      This is a comment.
    -->
    Hello Seto World.
    <!--
      This is a comment too.
    -->
  </body>
</html>

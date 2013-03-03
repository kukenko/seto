# Seto

[![Build Status](https://travis-ci.org/kukenko/seto.png)](https://travis-ci.org/kukenko/seto)

Seto is pseudo sed.

## Installation

TODO: Write installation here

## Examples
### substitute the replacement
    require 'seto'

    DATA.sed {
      s /<b>/, '<strong>'
      s %r!</b>!, '</strong>'
    }.each { |l| puts l }

    __END__
    <html>
      <body>
        Hello <b>Seto</b> World.
      </body>
    </html>

### delete the lines
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

and other commands.

## To-dos

* implement b, G, H, l, N, P, t commands
* support $ (the last line of input)
# -*- coding: utf-8; mode: ruby; -*-
require File.expand_path('../lib/seto/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kukenko"]
  gem.email         = ["m.kukenko@gmail.com"]
  s.summary         = %q{Seto is pseudo sed}
  s.description     = s.summary
  gem.homepage      = "https://github.com/kukenko/seto"

  gem.files         = `git ls-files`.split($\)
  gem.name          = "seto"
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Seto::VERSION
end

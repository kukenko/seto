# -*- coding: utf-8; mode: ruby; -*-
source 'https://rubygems.org'

def darwin?
  RUBY_PLATFORM =~ /darwin/i
end

group :test do
  gem 'growl', :require => darwin?
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1', :require => darwin?
  gem 'rspec'
end

gemspec

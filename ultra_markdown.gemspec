# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ultra_markdown/version'

Gem::Specification.new do |spec|
  spec.name          = "ultra_markdown"
  spec.version       = UltraMarkdown::VERSION
  spec.authors       = ["tonilin","xdite"]
  spec.email         = ["tonilin@gmail.com", "xuite.joke@gmail.com"]
  spec.description   = %q{Markdown Parser for various purposes}
  spec.summary       = %q{Markdown Parser for various purposes}
  spec.homepage      = "https://github.com/rocodev/ultra_markdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'


  spec.add_dependency 'rouge'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'airbrake'
  spec.add_dependency 'rails_autolink'
  spec.add_dependency 'sanitize'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

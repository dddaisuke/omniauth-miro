# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-miro/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-miro"
  s.version     = OmniAuth::Miro::VERSION
  s.authors     = ["Daisuke Yamashita"]
  s.email       = ["dddaisuke@gmail.com"]
  s.homepage    = "https://github.com/dddaisuke/omniauth-miro"
  s.description = %q{OmniAuth strategy for Miro}
  s.summary     = s.description
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new('>= 1.9.3')
  s.add_dependency 'omniauth-oauth', '~> 1.1'
  s.add_dependency 'rack'
  s.add_development_dependency 'bundler', '~> 2.1.4'
end

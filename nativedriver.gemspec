# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nativedriver/version"

Gem::Specification.new do |s|
  s.name        = "nativedriver"
  s.version     = NativeDriver::VERSION
  s.authors     = ["Jari Bakken"]
  s.email       = ["jari.bakken@gmail.com"]
  s.homepage    = "http://code.google.com/p/nativedriver/"
  s.summary     = %q{Native mobile application GUI automation}
  s.description = %q{Ruby bindings for NativeDriver}

  s.rubyforge_project = "nativedriver"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

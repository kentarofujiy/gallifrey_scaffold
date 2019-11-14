# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "gallifrey_scaffold"
  s.version     = "1.0.1"
  s.platform    = Gem::Platform::RUBY  
  s.summary     = "Begin Galiffrey 3"
  s.email       = "kentaro@manacadigital.com.br"
  s.homepage    = "http://manacadigital.com.br"
  s.description = "Begin generator"
  s.authors     = ['Kentaro Fujiy']
  s.files       = `git ls-files`.split("\n")
  s.licenses    = ['MIT']

  s.rubyforge_project = "gallifrey_scaffold"

  s.require_paths = ["lib","lib/generators","test/*"]
end

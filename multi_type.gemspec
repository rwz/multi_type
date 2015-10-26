require File.expand_path("../lib/multi_type/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name     = "multi_type"
  spec.version  = MultiType::VERSION
  spec.authors  = ["Pavel Pravosud"]
  spec.email    = ["pavel@pravosud.com"]
  spec.summary  = "Multi-type support for Ruby"
  spec.homepage = "https://github.com/rwz/multi_type"
  spec.license  = "MIT"
  spec.files    = Dir["README.md", "LICENSE.txt", "lib/**/*"]
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "mandrill-template-manager"
  spec.version       = "0.2.1"
  spec.authors       = ["sawanoboly"]
  spec.email         = ["sawanoboriyu@higanworks.com"]

  spec.summary       = %q{Manage Mandrill Template CLI}
  spec.description   = %q{Manage Mandrill Template CLI}
  spec.homepage      = "https://github.com/higanworks/mandrill-template-manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables = %w[mandrilltemplate]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "mandrill-api"
  spec.add_dependency "formatador"
  spec.add_dependency "unicode"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
end

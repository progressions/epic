# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{epic}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Coleman"]
  s.date = %q{2010-01-31}
  s.default_executable = %q{epic}
  s.description = %q{Epic validator, wraps validation for HTML, JavaScript and CSS.}
  s.email = %q{progressions@gmail.com}
  s.executables = ["epic"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "History.txt",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/epic",
     "epic.gemspec",
     "features/closure_compressor.feature",
     "features/data/html/invalid.html",
     "features/data/html/valid.html",
     "features/data/javascripts/invalid.js",
     "features/data/javascripts/invalid_uncompressed.js",
     "features/data/javascripts/pre_compressed.js",
     "features/data/javascripts/pre_compressed.js.min",
     "features/data/javascripts/valid.js",
     "features/data/javascripts/valid_uncompressed.js",
     "features/data/stylesheets/valid.css",
     "features/step_definitions/compressor_steps.rb",
     "features/step_definitions/file_steps.rb",
     "features/step_definitions/validator_steps.rb",
     "features/support/env.rb",
     "features/validator.feature",
     "features/yui_compressor.feature",
     "lib/epic.rb",
     "lib/epic/base.rb",
     "lib/epic/compressor.rb",
     "lib/epic/compressor/base.rb",
     "lib/epic/compressor/closure.rb",
     "lib/epic/compressor/yui.rb",
     "lib/epic/errors.rb",
     "lib/epic/validator.rb",
     "lib/epic/validator/base.rb",
     "lib/epic/validator/html.rb",
     "lib/epic/validator/javascript.rb",
     "lib/epic/validator/json.rb",
     "lib/epic/validator/stylesheet.rb",
     "spec/compressor_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/stubs.rb",
     "spec/validator_spec.rb",
     "vendor/ext/compiler.jar",
     "vendor/ext/js.jar",
     "vendor/ext/jslint.js",
     "vendor/ext/yuicompressor-2.4.2.jar"
  ]
  s.homepage = %q{http://github.com/progressions/epic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Epic validation of HTML, JavaScript and CSS}
  s.test_files = [
    "spec/compressor_spec.rb",
     "spec/spec_helper.rb",
     "spec/stubs.rb",
     "spec/validator_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_runtime_dependency(%q<w3c_validators>, [">= 0"])
      s.add_runtime_dependency(%q<progressions-g>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_dependency(%q<w3c_validators>, [">= 0"])
      s.add_dependency(%q<progressions-g>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.6"])
    s.add_dependency(%q<w3c_validators>, [">= 0"])
    s.add_dependency(%q<progressions-g>, [">= 0"])
  end
end


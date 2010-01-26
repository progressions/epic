# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{epic}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Coleman"]
  s.date = %q{2010-01-25}
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
     "lib/epic.rb",
     "lib/file.rb",
     "spec/epic_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/stubs.rb",
     "vendor/ext/js.jar",
     "vendor/ext/jslint.js"
  ]
  s.homepage = %q{http://github.com/progressions/epic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Epic validation of HTML, JavaScript and CSS}
  s.test_files = [
    "spec/epic_spec.rb",
     "spec/spec_helper.rb",
     "spec/stubs.rb"
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


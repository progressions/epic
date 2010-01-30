require 'vendor/gems/environment'
Bundler.require_env :cucumber

require 'spec/expectations'
require 'spec/mocks'

require 'lib/epic'

require 'spec/stubs'

Before do
  unless defined?(BASE_PATH)
    BASE_PATH = File.expand_path("./features/data")
  end

  @exceptions = []
  @files = []

  $rspec_mocks ||= Spec::Mocks::Space.new  
  
  stub_growl
end

After do
  @files.each do |file|
    system "rm #{file}"
  end
  
  system "rm -rf #{BASE_PATH}/tmp"
  system "mkdir #{BASE_PATH}/tmp"
end

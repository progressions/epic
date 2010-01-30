Given %r{I configure Epic::Base to compile with (.+)} do |compressor|
  Epic::Base.configure do |config|
    config.base_path = "#{BASE_PATH}"
    config.compressor = compressor.downcase.to_sym
  end
end

Given %r{I compress the file "([^\"]*)"} do |filename|
  path = "#{BASE_PATH}/#{filename}"
  
  begin
    Epic::Compressor.new(path).compress
  rescue StandardError => e
    puts e.message
    @exceptions << e.message
  end
end
Given %r{I compress the file "([^\"]*)"} do |filename|
  path = "#{BASE_PATH}/#{filename}"
  
  begin
    Epic::Compressor.new(path).compress
  rescue StandardError => e
    @exceptions << e.message
  end
end
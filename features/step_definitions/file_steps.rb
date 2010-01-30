Given %r{the file "([^\"]*)" exists with "([^\"]*)"} do |filename, content|
  content.gsub!("\\n", "\n")
  File.open("#{BASE_PATH}/#{filename}", "w") do |f|
    content.split("\n").each do |line|
      f.puts line
    end
  end
  @files << "#{BASE_PATH}/#{filename}"
end

And %r{I remove the file "([^\"]*)"} do |filename|
  system "rm #{BASE_PATH}/#{filename}"
end

When %r{I open the file "([^\"]*)"} do |filename|
  @current_file = File.read("#{BASE_PATH}/#{filename}")
end

Then %r{I should see "([^\"]*)"} do |content|
  @current_file.should match(Regexp.new(content))
end

Then %r{I should not see "([^\"]*)"} do |content|
  @current_file.should_not match(Regexp.new(content))
end
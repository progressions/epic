Given %r{I configure Epic::Base} do
  Epic::Base.configure do |config|
    config.base_path = "#{BASE_PATH}"
  end
end

Given %r{the file "([^\"]*)" should be valid} do |filename|
  if filename =~ /\.html$/
    @validator = Epic::Validator::HTML.new
  elsif filename =~ /\.js$/
    @validator = Epic::Validator::JavaScript.new
  end
  @validator.validate("#{BASE_PATH}/#{filename}").should be_true
end

Given %r{the file "([^\"]*)" should not be valid} do |filename|
  if filename =~ /\.html$/
    @validator = Epic::Validator::HTML.new
    @validator.validate("#{BASE_PATH}/#{filename}").should be_false
  elsif filename =~ /\.js$/
    @validator = Epic::Validator::JavaScript.new
    # lambda {
      @validator.validate("#{BASE_PATH}/#{filename}").should be_false
    # }.should raise_error("JavaScript Errors embedded in /javascripts/invalid.js")
  end
end


Given %r{the file "([^\"]*)" exists with "([^\"]*)"} do |filename, content|
  content.gsub!("\\n", "\n")
  File.open("#{BASE_PATH}/#{filename}", "w") do |f|
    content.split("\n").each do |line|
      f.puts line
    end
  end
  @files << "#{BASE_PATH}/#{filename}"
end

Then /^an exception should have been raised with the message "([^\"]*)"$/ do |message|
  @exception.should == message
end

Then %r{no exceptions should have been raised} do
  @exception.should be_nil
end

And %r{I remove the file "([^\"]*)"} do |filename|
  system "rm #{BASE_PATH}/#{filename}"
end


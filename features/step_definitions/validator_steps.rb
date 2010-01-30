Given %r{I configure Epic::Base$} do
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
    @validator.validate("#{BASE_PATH}/#{filename}").should be_false
  end
end

Then /^an exception should have been raised with the message "([^\"]*)"$/ do |message|
  found_exception = false
  @exceptions.each do |exception|
    found_exception ||= exception =~ Regexp.new(message)
  end
  found_exception.should be_true
end

Then %r{no exceptions should have been raised} do
  @exceptions.should be_empty
end


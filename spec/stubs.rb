def stub_io
  stub_screen_io
  stub_file_io
  stub_file_utils
  stub_growl
end

def stub_screen_io
  $stdout.stub!(:puts)
  $stdout.stub!(:print)    
end

def stub_file_io(unprocessed_file="")
  @file ||= mock('file').as_null_object
  @file.stub!(:read).and_return(unprocessed_file)
  @file.stub!(:write)
  @file.stub!(:puts)
  
  File.stub!(:new).and_return(@file)
  File.stub!(:exists?).and_return(false)
  File.stub!(:open).and_yield(@file) 
  File.stub!(:read).and_return(unprocessed_file)
  File.stub!(:readlines).and_return(["first\n", "second\n"])
end

def stub_file_utils
  FileUtils.stub!(:rm)
  FileUtils.stub!(:rm_rf)
  FileUtils.stub!(:cp_r)
  FileUtils.stub!(:mkdir_p)
  F.stub!(:concat_files)
  F.stub!(:get_line_from_file).and_return("")
  F.stub!(:save_to_file)
  F.stub!(:save_to_tmp_file)
  F.stub!(:execute).and_return("")
end

def stub_growl
  @g = Object.new
  Growl.stub(:new).and_return(@g)
  @g.stub(:notify).as_null_object  
end

def reset_constant(constant, value)
  begin
    Object.send(:remove_const, constant)
  rescue
  end
  Object.const_set(constant, value)
end

def stub_config
  @config = mock('config')
  @config.stub!(:[]).with("doctype").and_return("HTML 4.0 Transitional")
  @config.stub!(:validate_html?).and_return(false)
  @config.stub!(:compress_embedded_js?).and_return(false)
  @config.stub!(:verbose?).and_return(false)
  reset_constant(:CONFIG, @config)
end
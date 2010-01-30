require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Compressor" do
  before(:each) do
    stub_io
    File.stub!(:exists?).with(/yuicompressor/).and_return(true)
    File.stub!(:exists?).with("file.js").and_return(true)
  end
  
  describe "Base" do
    it "should use the compressed file if it already exists" do
      File.stub!(:exists?).with(/file.js/).and_return(true)
      @file = "compressed file"
      File.stub(:read).and_return(@file)
      Epic::Compressor.new("file.js").compress.should == @file
    end
    
    describe "generate a compressed file if one doesn't exist" do
      before(:each) do
        File.stub!(:exists?).with(/file.js.min/).and_return(false, true)
        File.stub!(:exists?).with(/file.css.min/).and_return(false, true)
      end
      
      it "should log what it's doing" do
        $stdout.should_receive(:print).with(/file.js  compressing . . ./)
        Epic::Compressor.new("file.js").compress
      end
      
      it "should run the compressor" do
        F.should_receive(:execute).with(/yuicompressor/, :return => true).and_return("")
        Epic::Compressor.new("file.js").compress
      end
      
      describe "options" do
        it "should set nomunge" do
          F.should_receive(:execute).with(/nomunge/, :return => true).and_return("")
          Epic::Compressor.new("file.js").compress("obfuscate" => true)
        end
      
        it "should not set nomunge" do
          F.stub!(:execute).with(/yuicompressor/, :return => true).and_return("")
          F.should_not_receive(:execute).with(/nomunge/, :return => true).and_return("")
          Epic::Compressor.new("file.js").compress("obfuscate" => false)
        end
      
        it "should set verbose" do
          F.should_receive(:execute).with(/verbose/, :return => true).and_return("")
          Epic::Compressor.new("file.js").compress("verbose" => true)
        end
      
        it "should not set verbose" do
          F.stub!(:execute).with(/yuicompressor/, :return => true).and_return("")
          F.should_not_receive(:execute).with(/verbose/, :return => true).and_return("")
          Epic::Compressor.new("file.js").compress("verbose" => false)
        end
      
        it "should set preserve-semi on javascript" do
          F.should_receive(:execute).with(/preserve-semi/, :return => true).and_return("")
          Epic::Compressor.new("file.js").compress
        end
      
        it "should not set preserve-semi on css" do
          File.stub!(:exists?).with(/file.css/).and_return(true)
          F.stub!(:execute).with(/yuicompressor/, :return => true).and_return("")
          F.should_not_receive(:execute).with(/preserve-semi/, :return => true).and_return("")
          Epic::Compressor.new("file.css").compress
        end
      end
      
      describe "on errors" do
        before(:each) do
          F.stub!(:execute).with(/yuicompressor/, :return => true).and_return("[ERROR] 12:13: Too much fruzzlegump")
        end
        
        it "should raise an exception" do
          lambda {
            Epic::Compressor.new("file.js").compress
          }.should raise_error(/JavaScript errors/)
        end
        
        it "should show the source code" do
          F.should_receive(:get_line_from_file).with("file.js", 12).and_return("")
          lambda {
            Epic::Compressor.new("file.js").compress
          }.should raise_error(/JavaScript errors/)
        end
      end
      
      it "should report OK" do
        $stdout.should_receive(:puts).with("OK")
        Epic::Compressor.new("file.js").compress
      end
    end
  end
end
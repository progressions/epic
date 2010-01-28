require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Validator" do
  before(:each) do
    stub_io
    stub_config
    File.stub!(:exists?).with(/jslint.js/).and_return(true)
    File.stub!(:exists?).with(/js.jar/).and_return(true)
  end
  
  describe "HTML" do
    before(:each) do
      class ResultsMock
        def errors
          []
        end
      end
      
      class ValidatorMock
        def validate_file(path)
          ResultsMock.new
        end
        
        def set_doctype!(doctype)
          
        end
      end
      
      @validator = ValidatorMock.new
      W3CValidators::MarkupValidator.stub!(:new).and_return(@validator)
    end
    
    it "should call validator" do
      W3CValidators::MarkupValidator.should_receive(:new).and_return(@validator)
      Epic::Validator::HTML.new.validate("path")
    end
    
    it "should print OK" do
      $stdout.should_receive(:puts).with(/OK/)
      Epic::Validator::HTML.new.validate("path")
    end
    
    describe "new syntax" do
      it "should call validator" do
        W3CValidators::MarkupValidator.should_receive(:new).and_return(@validator)
        Epic::Validator::HTML.new("path").validate
      end
    
      it "should print OK" do
        $stdout.should_receive(:puts).with(/OK/)
        Epic::Validator::HTML.new("path").validate
      end
    end
    
    describe "errors" do
      before(:each) do
        class ResultsMock
          def errors
            ["HTML Error 1", "HTML Error 2"]
          end
        end
      
        class ValidatorMock
          def validate_file(path)
            ResultsMock.new
          end
        
          def set_doctype!(doctype)
          
          end
        end
      
        @validator = ValidatorMock.new
        W3CValidators::MarkupValidator.stub!(:new).and_return(@validator)
      end
      
      it "should be false" do
        Epic::Validator::HTML.new.validate("path").should be_false
      end
      
      it "should output a message" do
        $stdout.should_receive(:puts).with("validation errors")
        Epic::Validator::HTML.new.validate("path")
      end
      
      describe "new syntax" do
        it "should be false" do
          Epic::Validator::HTML.new("path").validate.should be_false
        end
      
        it "should output a message" do
          $stdout.should_receive(:puts).with("validation errors")
          Epic::Validator::HTML.new("path").validate
        end
      end
    end
  end
  
  describe "JavaScript" do
    describe "jslint" do
      before(:each) do
        @jslint_settings = "/* These are JSLint settings %/"
        F.stub!(:execute).with(/java/, :return => true).and_return("jslint: No problems found")  
      end
      
      it "should set jslint settings" do
        Epic::Base.configure do |config|
          config.jslint_settings = @jslint_settings
        end
        Epic::Validator::JavaScript.new.jslint_settings.should == @jslint_settings
      end
      
      it "should put jslint settings in the file" do
        @file.should_receive(:puts).with(@jslint_settings)
        Epic::Validator::JavaScript.new.validate("path")
      end
      
      describe "new syntax" do
        it "should set jslint settings" do
          Epic::Base.configure do |config|
            config.jslint_settings = @jslint_settings
          end
          Epic::Validator::JavaScript.new("path").jslint_settings.should == @jslint_settings
        end
      
        it "should put jslint settings in the file" do
          @file.should_receive(:puts).with(@jslint_settings)
          Epic::Validator::JavaScript.new("path").validate
        end
      end
    end
    
    describe "valid" do
      before(:each) do
        F.stub!(:execute).with(/java/, :return => true).and_return("jslint: No problems found")
      end
      
      it "should output 'OK'" do
        $stdout.should_receive(:puts).with(/OK/)
        Epic::Validator::JavaScript.new.validate("path")
      end
    end
    
    describe "invalid" do
      before(:each) do
        @lines_with_errors = [
          "line 3 character 2: Unnecessary semicolon",
          "line 8 character 3: Unknown thingamajig"
        ].join("\n")
        F.stub!(:execute).with(/java/, :return => true).and_return(@lines_with_errors)
        F.stub!(:get_line_from_file).with(anything, 1)
        F.stub!(:get_line_from_file).with(anything, 5)
      end
      
      it "should output errors" do
        $stdout.should_receive(:puts).with(/Unnecessary semicolon/)
        $stdout.should_receive(:puts).with(/Unknown thingamajig/)
        Epic::Validator::JavaScript.new.validate("path").should be_false
      end
      
      it "should be false" do
        Epic::Validator::JavaScript.new.validate("path").should be_false
      end
    end
  end
  
  describe "JSON" do
    describe "valid" do
      before(:each) do
        F.stub!(:execute).with(/java/, :return => true).and_return("jslint: No problems found")
      end
      
      it "should output 'OK'" do
        $stdout.should_receive(:puts).with(/OK/)
        Epic::Validator::JSON.new.validate("path")
      end
    end
    
    describe "invalid" do
      before(:each) do
        @lines_with_errors = [
          "line 3 character 2: Unnecessary semicolon",
          "line 8 character 3: Unknown thingamajig"
        ].join("\n")
        F.stub!(:execute).with(/java/, :return => true).and_return(@lines_with_errors)
        F.stub!(:get_line_from_file).with(anything, 1)
        F.stub!(:get_line_from_file).with(anything, 5)
      end
      
      it "should output errors" do
        $stdout.should_receive(:puts).with(/Unnecessary semicolon/)
        $stdout.should_receive(:puts).with(/Unknown thingamajig/)
        Epic::Validator::JSON.new.validate("path").should be_false
      end
      
      it "should return false" do
        Epic::Validator::JSON.new.validate("path").should be_false
      end
    end
    
    describe "Stylesheet" do
      it "should validate" do
        Epic::Validator::Stylesheet.new.validate("path")
      end
    end
  end
end
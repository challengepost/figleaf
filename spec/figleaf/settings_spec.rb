require 'spec_helper'

describe Figleaf::Settings do

  describe "self.load_file" do
    before do
      @fixture_path = File.expand_path("../../fixtures/service.yml", __FILE__)
    end

    it "converts file settings from given env" do
      settings = described_class.load_file(@fixture_path, "test")
      settings.foo.should == "bar"
    end

    it "allows env to be optional" do
      settings = described_class.load_file(@fixture_path)
      settings.test.foo.should == "bar"
    end

    it "returns nil for missing env" do
      settings = described_class.load_file(@fixture_path, "foo")
      settings.should be_nil
    end
  end

  describe "self.load_settings" do
    before do
      @fixtures_path = File.expand_path("../../fixtures/*.yml", __FILE__)

      described_class.load_settings(@fixtures_path, "test")
    end

    it "should load some service" do
      described_class.service["foo"].should == "bar"
    end

    it "should load indifferently the key names" do
      described_class.service["foo"].should == "bar"
      described_class.service[:foo].should == "bar"
    end

    it "should create foo as a method" do
      described_class.service.foo.should == "bar"
    end

    it "should create bool_true? and return true" do
      described_class.service.bool_true?.should be_true
    end

    it "should create bool_false? and return false" do
      described_class.service.bool_false?.should be_false
    end

    it "should work for array as well" do
      described_class.load_settings
      described_class.array.should == [1, 2]
    end

    it "and for plain string" do
      described_class.load_settings
      described_class.string.should == "Hello, World!"
    end

    it "and for boolean (true)" do
      described_class.load_settings
      described_class.boolean.should be_true
    end

    it "and for boolean (false)" do
      described_class.load_settings(@fixtures_path, "alt")
      described_class.load_settings
      described_class.service.should be_false
    end

    it "should raise exception when loading an undefined value" do
      YAML.stub(:load_file).and_return({ "test" => {} })
      described_class.load_settings
      expect { described_class.service.blah }.to raise_error NoMethodError
    end

  end
end
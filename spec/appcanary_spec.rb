require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class AppCanaryManifest < Moonshine::Manifest
  include Moonshine::Manifest::Rails::Rails
  include Moonshine::AppCanary

  configure :appcanary => { :api_key => 'Y-Y-Z' }
end

describe "A manifest with the AppCanary plugin" do
  before do
    @manifest = AppCanaryManifest.new
  end

  subject { @manifest }

  context "with api key configured" do
    before do
      @manifest.appcanary :api_key => 'Y-Y-Z'
    end

    it "should be executable" do
      @manifest.should be_executable
    end

    it { should have_package('appcanary') }
  end

  context "without api key configured" do
    before do
      @manifest.appcanary
    end

    it "should be executable" do
      @manifest.should be_executable
    end

    it { should_not have_package('appcanary') }
  end
end

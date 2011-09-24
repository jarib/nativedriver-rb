require File.expand_path('../../spec_helper', __FILE__)

describe NativeDriver do
  context "iOS" do
    # See http://code.google.com/p/nativedriver/wiki/GettingStartedIOS

    let(:driver) { NativeDriver.for :ios }

    before(:all) do
      driver.manage.timeouts.implicit_wait = 10
    end

    after(:all) { driver.quit }

    context "Views" do
      it "sets text" do
        username = driver.find_element(:placeholder => "User Name")
        username.clear
        username.send_keys "NativeDriver"
        password = driver.find_element(:placeholder => "Password")
        password.clear
        password.send_keys "abcdefgh"
      end

      it "taps button" do
        driver.find_element(:text => "Sign in").click
      end

      it "gets title" do
        driver.title.should == "NativeDriver"
      end
    end

    context "WebViews" do
      it "sets text and submits" do
        element = driver.find_element(:name => 'q')
        element.send_keys 'NativeDriver'
        element.submit
      end

      it "taps button" do
        driver.find_element(:partial_link_text => 'GUI Automation').click
      end

      it "gets text" do
        driver.find_element(:id => 'pname').text.should == 'nativedriver'
      end
    end
  end
end
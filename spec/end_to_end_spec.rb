require 'spec_helper'

describe NativeDriver do
  context "Android" do
    before(:all) do
      # see http://code.google.com/p/nativedriver/wiki/GettingStartedAndroid
      #
      # TODO: clean up + possibly automate device creation?

      sh "adb -e wait-for-device"
      sh "adb -e logcat -c" # clear logs
      sh "adb -e install -r #{apk}"
      sh "adb -e shell am instrument com.google.android.testing.nativedriver.simplelayouts/com.google.android.testing.nativedriver.server.ServerInstrumentation"
      sh "adb -e forward tcp:54129 tcp:54129"

      Selenium::WebDriver::Wait.new(:timeout => 5, :message => "waiting for Jetty to start").until do
        `adb logcat -d`.include? "Jetty started"
      end
    end

    after(:all) { driver.quit }

    let(:driver) { NativeDriver.for :android }
    let(:apk)    { File.expand_path '../apks/simplelayouts.apk', __FILE__ }

    context "text value activity" do
      before {
        driver.start_activity "com.google.android.testing.nativedriver.simplelayouts.TextValueActivity"
      }

      it "gets and sets text" do
        text_view = driver.find_element(:id => "TextView01")
        text_view.text.should == "Hello, Android NativeDriver!"

        text_edit_view = driver.find_element(:id => "EditText01")
        text_edit_view.clear
        text_edit_view.send_keys "cheese"

        text_edit_view.text.should == "cheese"
      end
    end

    context "spinners activity" do
      before {
        driver.start_activity "com.google.android.testing.nativedriver.simplelayouts.SpinnersActivity"
      }

      it "finds elements by text" do
        star_spinner = driver.find_element(:id => "star_spinner")
        star_spinner.click

        driver.find_element(:text => "Wolf 359").click
        star_spinner.find_elements(:text => "Wolf 359").size.should == 1
      end
    end

    context "list view activity" do
      before {
        driver.start_activity "com.google.android.testing.nativedriver.simplelayouts.ListViewActivity"
      }

      it "finds list view elements" do
        %w[
          Alabama
          Alaska
          Arizona
          Arkansas
          California
          Colorado
          Connecticut
          Delaware
          Florida
          Georgia
          Hawaii
          Idaho
          ].each { |state| driver.find_element(:text => state) }
      end
    end
  end

  context "iOS" do
    before(:all) do
      driver.manage.timeouts.implicit_wait = 10
    end

    after(:all) { driver.quit }

    let(:driver) { NativeDriver.for :ios }

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

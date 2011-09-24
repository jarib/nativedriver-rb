require File.expand_path('../../spec_helper', __FILE__)

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
end

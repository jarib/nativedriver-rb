require 'spec_helper'

describe NativeDriver do
  context "Android" do
    before(:all) do
      # see http://code.google.com/p/nativedriver/wiki/GettingStartedAndroid
      ensure_device_running
      clear_logs
      install_simplelayouts
      instrument
      tcp_forward 54129, 54129
      wait_for_jetty
    end

    let(:driver) { NativeDriver.for :android }
    after(:all) { driver.quit }

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
module NativeDriver
  module IOS
    class Bridge < Selenium::WebDriver::Remote::Bridge

      DEFAULT_URL = "http://#{Selenium::WebDriver::Platform.localhost}:3001/hub"

      def initialize(opts = {})
        caps = Selenium::WebDriver::Remote::Capabilities.iphone(
          :browser_name => "iphone native",
          :version => opts[:version] || "4.3"
        )

        super(
          :url => opts[:url] || DEFAULT_URL,
          :desired_capabilities => caps
        )
      end

      def driver_extensions
        [
          Selenium::WebDriver::DriverExtensions::Rotatable,
          Selenium::WebDriver::DriverExtensions::TakesScreenshot,
          IOS::DriverExtension
        ]
      end
    end # Bridge

    module DriverExtension
      #
      # Represents element types on iOS devices.
      #
      module ClassNames
        BUTTON = 'UIButton'
        LABEL = 'UILabel'
        SWITCH = 'UISwitch'
        TEXT_FIELD = 'UITextField'
        TEXT_VIEW = 'UITextView'
        WEB_VIEW = 'UIWebView'
      end # ClassNames
    end # DriverExtension

    # HACK: should only work on iOS - fix in DriverExtension instead
    Selenium::WebDriver::SearchContext::FINDERS.merge!(
      :placeholder  => "placeholder",
      :text         => "text",
      :partial_text => "partial text"
    )

  end # IOS
end # NativeDriver

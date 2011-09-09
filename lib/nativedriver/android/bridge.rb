module NativeDriver
  module Android
    class Bridge < Selenium::WebDriver::Remote::Bridge

      DEFAULT_URL = "http://#{Selenium::WebDriver::Platform.localhost}:54129/hub"

      def initialize(opts = {})
        caps = Selenium::WebDriver::Remote::Capabilities.android(
          :browser_name => "android native",
          :version => opts[:version] || "2.2"
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
          Android::DriverExtension
        ]
      end
    end # Bridge

    module DriverExtension
      def start_activity(activity_class)
        get "and-activity://#{activity_class}"
      end
    end

    # HACK: should only work on android - fix in DriverExtension instead
    Selenium::WebDriver::SearchContext::FINDERS.merge!(
      :text         => "text",
      :partial_text => "partial text"
    )

    # HACK: should only work on android - fix in DriverExtension instead
    Selenium::WebDriver::Keys::KEYS.merge!(

    # TODO: add these - shared with webdriver

    # ALT_LEFT(Keys.ALT, KeyEvent.KEYCODE_ALT_LEFT),
    #  DEL(Keys.DELETE, KeyEvent.KEYCODE_DEL),
    #  DPAD_DOWN(Keys.ARROW_DOWN, KeyEvent.KEYCODE_DPAD_DOWN),
    #  DPAD_LEFT(Keys.ARROW_LEFT, KeyEvent.KEYCODE_DPAD_LEFT),
    #  DPAD_RIGHT(Keys.ARROW_RIGHT, KeyEvent.KEYCODE_DPAD_RIGHT),
    #  DPAD_UP(Keys.ARROW_UP, KeyEvent.KEYCODE_DPAD_UP),
    #  ENTER(Keys.ENTER, KeyEvent.KEYCODE_ENTER),
    #  SHIFT_LEFT(Keys.SHIFT, KeyEvent.KEYCODE_SHIFT_LEFT),

      :back        => "\xEE\x84\x80",
      :home        => "\xEE\x84\x81",
      :menu        => "\xEE\x84\x82",
      :search      => "\xEE\x84\x83",
      :sym         => "\xEE\x84\x84",
      :alt_right   => "\xEE\x84\x85",
      :shift_right => "\xEE\x84\x86"
    )
  end
end
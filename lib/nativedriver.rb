require 'selenium/webdriver'

require 'nativedriver/version'
require 'nativedriver/android'

module NativeDriver
  def self.for(sym, opts = {})
    bridge = case sym.to_sym
             when :android
               NativeDriver::Android::Bridge.new(opts)
             else
               raise ArgumentError, sym.to_s
             end

    Selenium::WebDriver::Driver.new(bridge)
  end
end

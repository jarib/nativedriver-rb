$:.unshift File.expand_path("../../lib", __FILE__)
require 'nativedriver'

module NativeDriverSpecHelper
  def sh(*args)
    puts "executing #{args.join ' '}"
    system(*args)
    unless $?.success?
      raise "command failed with code #{$?.exitstatus}: #{args.join ' '}"
    end
  end


end

RSpec.configure do |c|
  c.include NativeDriverSpecHelper
end

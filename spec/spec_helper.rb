$:.unshift File.expand_path("../../lib", __FILE__)
require 'nativedriver'
require 'tempfile'
require 'logger'
require 'delegate'

module NativeDriverSpecHelper
  EXIT_TIMEOUT = 60 # installing apks can take a long time.

  def device_name
    "nativedriver-specs"
  end

  def target_version
    'android-12'
  end

  def log
    @log ||= Logger.new(STDOUT)
  end

  def sh(*args)
    opts = args.last.kind_of?(Hash) ? args.pop : {}

    log.info "executing #{args.join(' ').inspect}"

    cp = ChildProcess.new(*args)

    cp.io.stdout = stdout = Tempfile.new('nativedriver-stdout')
    cp.io.stderr = stderr = Tempfile.new('nativedriver-stderr')

    cp.start

    timed_out = false

    begin
      cp.poll_for_exit(opts[:timeout] || EXIT_TIMEOUT)
    rescue ChildProcess::TimeoutError
      timed_out = true
    end

    stdout.rewind
    stderr.rewind

    out = stdout.read
    err = stderr.read

    if timed_out
      raise "command timed out: #{args.join ' '}\nstdout: #{out}\nstderr: #{err}"
    end

    if cp.crashed?
      raise "command failed: #{args.join ' '}\nstdout: #{out}\nstderr: #{err}"
    end

    [out, err]
  end

  def adb(*args)
    # TODO: windows - adb.exe ?
    sh("adb", *args)
  end

  def android(*args)
    # TODO: windows - android.exe ?
    sh("android", *args)
  end

  def emulator(*args)
    log.info "starting emulator: #{args.inspect}"
    emulator = ChildProcess.new("emulator", *args)
    emulator.io.inherit!

    emulator.detach = true
    emulator.start
    # TODO: stop at_exit
  end

  def simplelayouts_apk
    File.expand_path '../apks/simplelayouts.apk', __FILE__
  end

  def install_simplelayouts
    ok = false

    until ok
      out, err = adb "-e", "install", "-r", simplelayouts_apk
      ok = out.include? "Success"

      log.info "waiting for emulator" unless ok
    end
  end

  def wait_for_jetty
    wait_for_log "Jetty started"
  end

  def wait_for_boot
    # not sure how robust this is.
    wait_for_log "Boot is finished", 300
  end

  def wait_for_log(str, timeout = 10)
    Selenium::WebDriver::Wait.new(:timeout => timeout).until do
      log.info "waiting for #{str.inspect}"

      out, err = adb "-e", "logcat", "-d"
      out.include? str
    end
  end

  def ensure_device_running
    unless has_device?
      create_device
    end

    unless device_running?
      launch_device
    end

    clear_logs
    wait_for_boot
  end

  def clear_logs
    adb "-e", "logcat", "-c"
  end

  def create_device
    # unfortunately the "create avd" command is potentially interactive, so
    # need sh for the echo
    #
    # TODO: windows.
    sh "sh", "-c", "echo no | android create avd -n #{device_name} -t #{target_version} --force"

    unless has_device?
      raise "unable to create device #{device_name.inspect}"
    end
  end

  def tcp_forward(from, to)
    adb "-e", "forward", "tcp:#{from}", "tcp:#{to}"
  end

  def instrument
    adb(*%w[-e shell am instrument com.google.android.testing.nativedriver.simplelayouts/com.google.android.testing.nativedriver.server.ServerInstrumentation])
  end

  def launch_device
    emulator "-avd", device_name
    adb "-e", "wait-for-device"
  end

  def device_running?
    out, err = adb "-e", "get-state"
    out.include? "device"
  end

  def has_device?
    out, err = android('list', 'avd', '-c')
    out.split("\n").include?(device_name)
  end

end

RSpec.configure do |c|
  c.include NativeDriverSpecHelper
end

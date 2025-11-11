require 'capybara/cuprite'

REMOTE_CHROME_URL = ENV.fetch('CHROME_URL', nil)
REMOTE_CHROME_HOST, REMOTE_CHROME_PORT =
  if REMOTE_CHROME_URL
    URI.parse(REMOTE_CHROME_URL).then do |uri|
      [uri.host, uri.port]
    end
  end

remote_chrome =
  begin
    if REMOTE_CHROME_URL.nil?
      false
    else
      Socket.tcp(REMOTE_CHROME_HOST, REMOTE_CHROME_PORT, connect_timeout: 1).close
      true
    end
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
    false
  end

remote_options = remote_chrome ? { url: REMOTE_CHROME_URL } : {}

Capybara.register_driver(:better_cuprite) do |app|
  options = {
    window_size: [1200, 800],
    browser_options: remote_chrome ? { 'no-sandbox' => nil } : {},
    flatten: false,
    **remote_options
  }

  # Use chromium-browser in CI environment
  # options[:browser_path] = '/usr/bin/chromium-browser' if ENV['CI']

  # Use TEST_BROWSER_PATH if available (Background Agent environment)
  if ENV['TEST_BROWSER_PATH']
    options[:browser_path] = ENV['TEST_BROWSER_PATH']
    options[:browser_options] = { 'no-sandbox' => nil, 'disable-gpu' => nil }
  end

  Capybara::Cuprite::Driver.new(app, options)
end

Capybara.default_driver = Capybara.javascript_driver = :better_cuprite

module CupriteHelpers
  def pause
    page.driver.pause
  end

  def debug(binding = nil)
    $stdout.puts '🔎 Open Chrome inspector at http://localhost:3311'
    return binding.break if binding

    page.driver.pause
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system
end

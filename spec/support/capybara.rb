Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1280,2000 no-sandbox --remote-debugging-port=9222] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

if ENV['browser.headless'].eql?('true')
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :headless_chrome
    end
  end

  Capybara.javascript_driver = :headless_chrome
end

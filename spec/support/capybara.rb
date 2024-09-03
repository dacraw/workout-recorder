## Headless!
# Using :selenium_chrome_headless was preventing specs from working when :selenium_headless (firefox) was passing; 
# I'm using this config from https://groups.google.com/g/rspec/c/O5nIYBfcbic as a workaround
Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
  
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--test-type')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-extensions')
    options.add_argument('--enable-automation')
    options.add_argument('--window-size=1920,1080')
    options.add_argument("--start-maximized")

  
    Capybara::Selenium::Driver.new app, browser: :chrome, options: options
  end

if ENV['CI']
    Capybara.javascript_driver = :headless_chrome
else
    Capybara.javascript_driver = :selenium_chrome
end


require "bundler/setup"
require "calil_api"

require 'webmock/rspec'

Dir[File.expand_path(File.join(__dir__, "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec

  config.before :suite do
    WebMock.disable_net_connect!(allow: "codeclimate.com")
  end

  config.after :each do
    WebMock.reset!
  end
end

require "bundler/setup"
require "pry"
require "vinkit"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  # declare an exclusion filter
  config.filter_run_excluding network: true # makes network call - e.g. slow and external dependency
end

require 'simplecov'

module SimpleCovEnv
  module_function

  def start!
    configure_profile
    SimpleCov.start
  end

  def configure_profile
    formatters = [SimpleCov::Formatter::HTMLFormatter]
    SimpleCov.configure do
      formatter SimpleCov::Formatter::MultiFormatter.new(formatters)

      # Don't run coverage on the spec folder.
      add_filter 'spec'

      at_exit { SimpleCov.result }
    end
  end
end

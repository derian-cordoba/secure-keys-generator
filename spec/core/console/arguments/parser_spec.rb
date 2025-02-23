require 'core/console/arguments/parser'
require 'version'

describe(SecureKeys::Core::Console::Argument::Parser) do
  it('should be the current version from terminal output') do
    # given
    expected_version = "secure-keys version: v#{SecureKeys::VERSION}"

    # when
    output = `./bin/secure-keys --version`.strip

    # then
    expect(output).to(eq(expected_version))
  end

  it('should be the help information from terminal output') do
    # given
    expected_help = [
      'Usage: secure-keys [--options]',
      '',
      '-h, --help                       Use the provided commands to select the params',
      '-d, --delimiter DELIMITER        The delimiter to use for the key access (default: ",")',
      '-i, --identifier IDENTIFIER      The identifier to use for the key access (default: "secure-keys")',
      '-v, --version                    Show the secure-keys version'
    ]

    # when
    output_lines = `./bin/secure-keys --help`.split("\n").map(&:strip)

    # then
    expect(output_lines).to(eq(expected_help))
  end
end

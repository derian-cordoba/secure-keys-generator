require 'core/globals/globals'
require 'core/console/arguments/handler'

describe(SecureKeys::Globals) do
  before(:each) do
    # Reset the argument handler
    SecureKeys::Core::Console::Argument::Handler.reset

    # Reset the environment variables
    ENV['SECURE_KEYS_IDENTIFIER'] = nil
    ENV['SECURE_KEYS_DELIMITER'] = nil
    ENV['SECURE_KEYS_VERBOSE'] = nil
    ENV['VERBOSE'] = nil
  end

  it('should be the default access key value') do
    # given
    expected_access_key = SecureKeys::Globals.default_key_access_identifier

    # when / then
    expect(SecureKeys::Globals.key_access_identifier).to(eq(expected_access_key))
  end

  it('should be the default delimiter value') do
    # given
    expected_delimiter = SecureKeys::Globals.default_key_delimiter

    # when / then
    expect(SecureKeys::Globals.key_delimiter).to(eq(expected_delimiter))
  end

  it('should be the access key from the environment') do
    # given
    expected_access_key = 'test-access-key'

    # when
    ENV['SECURE_KEYS_IDENTIFIER'] = expected_access_key

    # then
    expect(SecureKeys::Globals.key_access_identifier).to(eq(expected_access_key))
  end

  it("should't be the access key from the environment") do
    # given
    expected_access_key = SecureKeys::Globals.default_key_access_identifier

    # when
    ENV['SECURE_KEYS_IDENTIFIER'] = nil

    # then
    expect(SecureKeys::Globals.key_access_identifier).to(eq(expected_access_key))

    # when
    ENV['SECURE_KEYS_IDENTIFIER'] = 'my-test-access-key'

    # then
    expect(SecureKeys::Globals.key_access_identifier).not_to(eq(expected_access_key))
  end

  it('should be the delimiter from the environment') do
    # given
    expected_delimiter = 'test-delimiter'

    # when
    ENV['SECURE_KEYS_DELIMITER'] = expected_delimiter

    # then
    expect(SecureKeys::Globals.key_delimiter).to(eq(expected_delimiter))
  end

  it("should't be the delimiter from the environment") do
    # given
    expected_delimiter = SecureKeys::Globals.default_key_delimiter

    # when
    ENV['SECURE_KEYS_DELIMITER'] = nil

    # then
    expect(SecureKeys::Globals.key_delimiter).to(eq(expected_delimiter))

    # when
    ENV['SECURE_KEYS_DELIMITER'] = 'my-test-delimiter'

    # then
    expect(SecureKeys::Globals.key_delimiter).not_to(eq(expected_delimiter))
  end

  it('should be the default access key value from argument handler') do
    # given
    expected_access_key = 'argument-access-key'

    # when
    SecureKeys::Core::Console::Argument::Handler.set(key: :identifier,
                                                     value: expected_access_key)

    # then
    expect(SecureKeys::Globals.key_access_identifier).to(eq(expected_access_key))
  end

  it('should be the default delimiter value from argument handler') do
    # given
    expected_delimiter = 'argument-delimiter'

    # when
    SecureKeys::Core::Console::Argument::Handler.set(key: :delimiter,
                                                     value: expected_delimiter)

    # then
    expect(SecureKeys::Globals.key_delimiter).to(eq(expected_delimiter))
  end

  it('should be disabled the verbose mode from environment (SECURE_KEYS_VERBOSE)') do
    # given
    expected_verbose = false

    # when
    ENV['SECURE_KEYS_VERBOSE'] = expected_verbose.to_s

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end

  it('should be enabled the verbose mode from environment (SECURE_KEYS_VERBOSE)') do
    # given
    expected_verbose = true

    # when
    ENV['SECURE_KEYS_VERBOSE'] = expected_verbose.to_s

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end

  it('should be disabled the verbose mode from environment (VERBOSE)') do
    # given
    expected_verbose = false

    # when
    ENV['VERBOSE'] = expected_verbose.to_s

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end

  it('should be enabled the verbose mode from environment (VERBOSE)') do
    # given
    expected_verbose = true

    # when
    ENV['VERBOSE'] = expected_verbose.to_s

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end

  it('should be disabled the verbose mode from argument handler') do
    # given
    expected_verbose = false

    # when
    SecureKeys::Core::Console::Argument::Handler.set(key: :verbose,
                                                     value: expected_verbose)

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end

  it('should be enabled the verbose mode from argument handler') do
    # given
    expected_verbose = true

    # when
    SecureKeys::Core::Console::Argument::Handler.set(key: :verbose,
                                                     value: expected_verbose)

    # then
    expect(SecureKeys::Globals.verbose?).to(eq(expected_verbose))
  end
end

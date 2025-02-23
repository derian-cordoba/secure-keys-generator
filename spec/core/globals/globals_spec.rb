require 'core/globals/globals'
require 'core/console/arguments/handler'

describe(SecureKeys::Globals) do
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
end

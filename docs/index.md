---
title: Secure Keys Generator
---

<div style="display: flex; gap: 10px; padding-bottom: 20px;">
  <img src="https://img.shields.io/badge/version-1.0.0-cyan" alt="Keys Version 1.0.0">

  <img src="https://img.shields.io/badge/iOS-^13.0-blue" alt="iOS version 13.0">

  <img src="https://img.shields.io/badge/Ruby-^3.3.6-red" alt="Ruby version 3.3.6">

</div>

# Secure Key Generator for iOS projects

Utility to generate a `xcframework` for handling secure keys in iOS projects.

### Prerequisites

- Ruby 3.3.6 or higher
- iOS 13.0 or higher

### Installation

You can install the `Keys` utility using Homebrew using the following command:

```bash
brew tap DerianCordobaPerez/tap https://github.com/DerianCordobaPerez/secure-keys-generator

brew install DerianCordobaPerez/tap/secure_keys
```

Another way, you can install the `Keys` utility using `gem` command:

```bash
gem install secure-keys
```

If you using `bundler` you can add the `secure-keys` gem to the `Gemfile`:

```ruby
gem 'secure-keys'
```

Then, you can install the gem using:

```bash
bundle install
```

## Usage

As first step, you need to determine the keys that you want to use in your iOS project. You can define the keys from Keychain or env variables.

The source is determined by the current platform **local or CI / cloud** using the `CI` environment variable.

If the `CI` environment variable is set to `true`, the keys are read from the environment variables. Otherwise, the keys are read from the Keychain.

You can configure your keys like this:

### From Keychain

1. You need to define the `secure-keys` record in the Keychain with the key name and the key value.

The value for this key should be all the key names separated by a comma.

```bash
security add-generic-password -a "secure-keys" -s "secure-keys" -w "githubToken,apiKey"
```

If you want to use another keychain identifier, you can define an env variable named `SECURE_KEYS_IDENTIFIER` to set the keychain identifier.

```bash
export SECURE_KEYS_IDENTIFIER="your-keychain-identifier"

security add-generic-password -a "$SECURE_KEYS_IDENTIFIER" -s "$SECURE_KEYS_IDENTIFIER" -w "githubToken,apiKey"
```

2. You can add new keys using the `security` command.

```bash
security add-generic-password -a "secure-keys" -s "apiKey" -w "your-api-key"
```

Using custom keychain identifier:

```bash
security add-generic-password -a "$SECURE_KEYS_IDENTIFIER" -s "apiKey" -w "your-api-key"
```

### Environment variables

1. You can define the keys in the `.env` file or export the keys as environment variables.

```bash
export SECURE_KEYS_IDENTIFIER="github-token,api_key,firebaseToken"

export GITHUB_TOKEN="your-github-token"
export API_KEY="your-api-key"
export FIREBASETOKEN="your-firebase-token"
```

> The key names are formatted in uppercase and replace the `-` with `_`.

> [!IMPORTANT]
> If you want to use another demiliter, you can define an env variable named `SECURE_KEYS_DELIMITER` to set the delimiter.

```bash
export SECURE_KEYS_DELIMITER="|"

export SECURE_KEYS_IDENTIFIER="github-token|api_key|firebaseToken"
```

### Ruby script

To generate the `Keys.xcframework` use the `secure-keys` command in the iOS project root directory.

Using global gem:

```bash
secure-keys
```

Using bundler:

```bash
bundle exec secure-keys
```

### iOS project

Within the iOS project, you can use the `Keys` target dependency like:

```swift
import Keys

// Using key directly in the code
let apiKey = Keys.apiKey.decryptedValue

// Using key from `Key` enum
let someKey: String = key(for: .someKey)

// Alternative way to use key from `Key` enum
let someKey: String = key(.someKey)

// Using raw value from `Key` enum
let apiKey: Keys = "apiKey".secretKey

// Using raw value from `Key` enum with decrypted value
let apiKey: String = "apiKey".secretKey.decryptedValue

// Using `key` method to get the key
let apiKey: String = .key(for: .apiKey)
```

## How to install the `Keys.xcframework` in the iOS project

1. From the iOS project, click on the project target, select the `General` tab, and scroll down to the `Frameworks, Libraries, and Embedded Content` section.

![Project Target](/docs/assets/add-xcframework-to-ios-project/first-step.png)

2. Click on the `Add Other...` button and click on the `Add Files...` option.

![Add Files](/docs/assets/add-xcframework-to-ios-project/second-step.png)

3. Navigate to the `keys` directory and select the `Keys.xcframework` folder.

![Select Keys.xcframework](/docs/assets/add-xcframework-to-ios-project/third-step.png)

> Now the `Keys.xcframework` is added to the iOS project.

![Select Keys.xcframework](/docs/assets/add-xcframework-to-ios-project/third-step-result.png)

4. Click on the `Build settings` tab and search for the `Search Paths` section.

![Search Paths](/docs/assets/add-xcframework-to-ios-project/fourth-step.png)

> Add the path to the `Keys.xcframework` in the `Framework Search Paths` section.

```bash
$(inherited)
$(SRCROOT)/.keys
```

## How it works

The process when the script is executed is:

1. Create a `.keys` directory.
2. Create a temporary `Swift Package` in the `.keys` directory.
3. Copy the `Keys` source code to the temporary `Swift Package`.

    ```swift
    public enum Keys {

        // MARK: - Cases

        case apiKey
        case someKey
        case unknown

        // MARK: - Properties

        /// The decrypted value of the key
        public var decryptedValue: String {
            switch self {
                case .apiKey: [1, 2, 4].decrypt(key: [248, 53, 26], iv: [148, 55, 47], tag: [119, 81])
                case .someKey: [1, 2, 4].decrypt(key: [248, 53, 26], iv: [148, 55, 47], tag: [119, 81])
                case .unknown: fatalError("Unknown key \(rawValue)")
            }
        }
    }
    ```
4. Generate the `Keys.xcframework` using the temporary `Swift Package`.
5. Remove the temporary `Swift Package`.

## License

This project is licensed under the MIT [License](LICENSE).

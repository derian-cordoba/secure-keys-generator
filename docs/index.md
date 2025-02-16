# Secure Key Generator for iOS Projects

A utility to securely generate and manage keys for iOS projects using `xcframework`. This tool helps to safely store and retrieve sensitive keys such as API tokens and access credentials in your iOS app, with support for both local and CI environments.

## Prerequisites

Before you begin, ensure that your development environment meets the following prerequisites:

- **Ruby 3.3.6 or higher**
- **iOS 13.0 or higher**

## Installation

There are multiple ways to install the `Keys` utility:

### Option 1: Install via Homebrew

You can install the `Keys` utility using [Homebrew](https://brew.sh/) with the following commands:

```bash
brew tap DerianCordobaPerez/tap https://github.com/DerianCordobaPerez/secure-keys-generator

brew install DerianCordobaPerez/tap/secure_keys
```

### Option 2: Install via RubyGems

Alternatively, you can install the utility using RubyGems:

```bash
gem install secure-keys
```

### Option 3: Install via Bundler

If you're using Bundler to manage your Ruby dependencies, add the gem to your `Gemfile`:

```bash
gem 'secure-keys'
```

Then, run:

```bash
bundle install
```

## Usage

### Step 1: Define Your Keys

First, determine the keys you want to use in your iOS project. The keys can be sourced either from your Keychain or environment variables. The source of keys is determined by the `CI` environment variable.

- If `CI=true`, keys will be read from environment variables.
- If `CI=false` or not set, keys will be read from the Keychain.

You can configure your keys as follows:

#### From Keychain

1. Define the secure-keys record in your Keychain with the key names and values. The value should be a comma-separated list of keys.

```bash
security add-generic-password -a "secure-keys" -s "secure-keys" -w "githubToken,apiKey"
```

If you need to use a custom Keychain identifier, set the `SECURE_KEYS_IDENTIFIER` environment variable:

```bash
export SECURE_KEYS_IDENTIFIER="your-keychain-identifier"

security add-generic-password -a "$SECURE_KEYS_IDENTIFIER" -s "$SECURE_KEYS_IDENTIFIER" -w "githubToken,apiKey"
```

2. Add new keys to the Keychain as needed:

```bash
security add-generic-password -a "secure-keys" -s "apiKey" -w "your-api-key"
```

Or with a custom Keychain identifier:

```bash
security add-generic-password -a "$SECURE_KEYS_IDENTIFIER" -s "apiKey" -w "your-api-key"
```

#### From Environment Variables

You can export them directly as environment variables.

```bash
export SECURE_KEYS_IDENTIFIER="github-token,api_key,firebaseToken"
export GITHUB_TOKEN="your-github-token"
export API_KEY="your-api-key"
export FIREBASETOKEN="your-firebase-token"
```

> Important: Key names should be formatted in uppercase with `-` replaced by `_` (e.g., `github-token` becomes `GITHUB_TOKEN`).

##### Custom Delimiter

If you prefer a delimiter other than the default comma, you can set a custom delimiter using the `SECURE_KEYS_DELIMITER` environment variable:

```bash
export SECURE_KEYS_DELIMITER="|"
export SECURE_KEYS_IDENTIFIER="github-token|api_key|firebaseToken"
```

### Step 2: Generate the Keys.xcframework

After configuring your keys, generate the `Keys.xcframework` by running the following command in your iOS project root directory:

```bash
secure-keys
```

Using Bundler:

```bash
bundle exec secure-keys
```

### Step 3: Integrate Keys.xcframework into Your iOS Project

1. From the iOS project, click on the project target, select the `General` tab, and scroll down to the `Frameworks, Libraries, and Embedded Content` section.

![Project Target](https://deriancordobaperez.github.io/secure-keys-generator/assets/add-xcframework-to-ios-project/first-step.png)

2. Click on the `Add Other...` button and click on the `Add Files...` option.

![Add Files](https://deriancordobaperez.github.io/secure-keys-generator/assets/add-xcframework-to-ios-project/second-step.png)

3. Navigate to the `keys` directory and select the `Keys.xcframework` folder.

![Select Keys.xcframework](https://deriancordobaperez.github.io/secure-keys-generator/assets/add-xcframework-to-ios-project/third-step.png)

> Now the `Keys.xcframework` is added to the iOS project.

![Select Keys.xcframework](https://deriancordobaperez.github.io/secure-keys-generator/assets/add-xcframework-to-ios-project/third-step-result.png)

4. Click on the `Build settings` tab and search for the `Search Paths` section.

![Search Paths](https://deriancordobaperez.github.io/secure-keys-generator/assets/add-xcframework-to-ios-project/fourth-step.png)

> Add the path to the `Keys.xcframework` in the `Framework Search Paths` section.

```bash
$(inherited)
$(SRCROOT)/.keys
```

### Step 4: Use the Keys in Your Code

In your iOS code, you can now use the Keys framework to securely retrieve your keys:

```swift
import Keys

// Using the key directly
let apiKey = Keys.apiKey.decryptedValue

// Accessing a key by enum case
let someKey: String = key(for: .someKey)

// Another way to access the key
let someKey: String = key(.someKey)

// Using the raw value to access the key
let apiKey: Keys = "apiKey".secretKey

// Accessing decrypted value from the raw key
let apiKey: String = "apiKey".secretKey.decryptedValue

// Using the `key` method to retrieve the key
let apiKey: String = .key(for: .apiKey)
```

## How It Works

When the script is executed, it follows these steps:

1. A `.keys` directory is created.
2. A temporary Swift Package is generated within the `.keys` directory.
3. The Keys source code is copied into the temporary Swift Package.
4. The `Keys.xcframework` is generated using the temporary Swift Package.
5. The temporary Swift Package is removed.

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
            case .apiKey: return [1, 2, 4].decrypt(key: [248, 53, 26], iv: [148, 55, 47], tag: [119, 81])
            case .someKey: return [1, 2, 4].decrypt(key: [248, 53, 26], iv: [148, 55, 47], tag: [119, 81])
            case .unknown: fatalError("Unknown key \(rawValue)")
        }
    }
}
```

## License

This project is licensed under the MIT License. See the [License](LICENSE) file for more information.

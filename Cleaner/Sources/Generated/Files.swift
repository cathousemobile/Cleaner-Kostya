// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Files {
  /// onboarding animations/
  internal enum OnboardingAnimations {
    /// folder onb 3.json
    internal static let folderOnb3 = File(name: "folder onb 3", ext: "json", relativePath: "", mimeType: "application/json")
    /// password onb 2.json
    internal static let passwordOnb2 = File(name: "password onb 2", ext: "json", relativePath: "", mimeType: "application/json")
    /// stars onb 1.json
    internal static let starsOnb1 = File(name: "stars onb 1", ext: "json", relativePath: "", mimeType: "application/json")
  }
  /// paywall animations/
  internal enum PaywallAnimations {
    /// Broom paywall.json
    internal static let broomPaywall = File(name: "Broom paywall", ext: "json", relativePath: "", mimeType: "application/json")
    /// crown paywall.json
    internal static let crownPaywall = File(name: "crown paywall", ext: "json", relativePath: "", mimeType: "application/json")
    /// paywallTrial.json
    internal static let paywallTrial = File(name: "paywallTrial", ext: "json", relativePath: "", mimeType: "application/json")
  }
  /// secret folder animations/
  internal enum SecretFolderAnimations {
    /// authentication dark.json
    internal static let authenticationDark = File(name: "authentication dark", ext: "json", relativePath: "", mimeType: "application/json")
    /// authentication light.json
    internal static let authenticationLight = File(name: "authentication light", ext: "json", relativePath: "", mimeType: "application/json")
    /// lock dark.json
    internal static let lockDark = File(name: "lock dark", ext: "json", relativePath: "", mimeType: "application/json")
    /// lock light.json
    internal static let lockLight = File(name: "lock light", ext: "json", relativePath: "", mimeType: "application/json")
  }
  /// speed test animations/
  internal enum SpeedTestAnimations {
    /// speed test blue dark.json
    internal static let speedTestBlueDark = File(name: "speed test blue dark", ext: "json", relativePath: "", mimeType: "application/json")
    /// speed test blue light.json
    internal static let speedTestBlueLight = File(name: "speed test blue light", ext: "json", relativePath: "", mimeType: "application/json")
    /// speed test orange dark.json
    internal static let speedTestOrangeDark = File(name: "speed test orange dark", ext: "json", relativePath: "", mimeType: "application/json")
    /// speed test orange light.json
    internal static let speedTestOrangeLight = File(name: "speed test orange light", ext: "json", relativePath: "", mimeType: "application/json")
  }
}
// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

internal struct File {
  internal let name: String
  internal let ext: String?
  internal let relativePath: String
  internal let mimeType: String

  internal var url: URL {
    return url(locale: nil)
  }

  internal func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier
    )
    guard let result = url else {
      let file = name + (ext.flatMap { ".\($0)" } ?? "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  internal var path: String {
    return path(locale: nil)
  }

  internal func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
}

// swiftlint:disable convenience_type explicit_type_interface
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type explicit_type_interface

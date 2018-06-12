// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {
  /// Something went wrong...
  internal static let loadingError = L10n.tr("Localizable", "loading_error")
  /// Try again
  internal static let retryButtonText = L10n.tr("Localizable", "retry_button_text")

  internal enum MainScreen {
    /// Departure station
    internal static let departureCaption = L10n.tr("Localizable", "main_screen.departure_caption")
    /// Departure station
    internal static let departurePlaceholder = L10n.tr("Localizable", "main_screen.departure_placeholder")
    /// Show timetable
    internal static let searchButton = L10n.tr("Localizable", "main_screen.search_button")
  }

  internal enum StationSearch {
    /// Start typing station name
    internal static let placeholder = L10n.tr("Localizable", "station_search.placeholder")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

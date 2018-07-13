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
    /// Show timetable
    internal static let searchButton = L10n.tr("Localizable", "main_screen.search_button")
    /// Station
    internal static let stationCaption = L10n.tr("Localizable", "main_screen.station_caption")
    /// Select station
    internal static let stationPlaceholder = L10n.tr("Localizable", "main_screen.station_placeholder")
  }

  internal enum StationSearch {
    /// Start typing station name
    internal static let placeholder = L10n.tr("Localizable", "station_search.placeholder")
  }

  internal enum Timetable {
    /// platform
    internal static let platformCaption = L10n.tr("Localizable", "timetable.platform_caption")
    /// Timetable
    internal static let title = L10n.tr("Localizable", "timetable.title")
    /// towards:
    internal static let towards = L10n.tr("Localizable", "timetable.towards")
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

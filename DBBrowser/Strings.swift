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
    /// Date and time
    internal static let dateCaption = L10n.tr("Localizable", "main_screen.date_caption")
    /// Show timetable
    internal static let searchButton = L10n.tr("Localizable", "main_screen.search_button")
    /// Station
    internal static let stationCaption = L10n.tr("Localizable", "main_screen.station_caption")
    /// Select a station
    internal static let stationPlaceholder = L10n.tr("Localizable", "main_screen.station_placeholder")
  }

  internal enum StationSearch {
    /// Start typing station name
    internal static let placeholder = L10n.tr("Localizable", "station_search.placeholder")
  }

  internal enum Timetable {
    /// from:
    internal static let from = L10n.tr("Localizable", "timetable.from")
    /// Load more
    internal static let loadMore = L10n.tr("Localizable", "timetable.load_more")
    /// platform
    internal static let platformCaption = L10n.tr("Localizable", "timetable.platform_caption")
    /// towards:
    internal static let towards = L10n.tr("Localizable", "timetable.towards")

    internal enum SegmentedControl {
      /// Arrivals
      internal static let arrivals = L10n.tr("Localizable", "timetable.segmented_control.arrivals")
      /// Departures
      internal static let departures = L10n.tr("Localizable", "timetable.segmented_control.departures")
    }
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

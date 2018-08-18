// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {
  /// Cancel
  internal static let cancelButtonText = L10n.tr("Localizable", "cancel_button_text")
  /// Something went wrong...
  internal static let loadingError = L10n.tr("Localizable", "loading_error")
  /// Try again
  internal static let retryButtonText = L10n.tr("Localizable", "retry_button_text")

  internal enum DatePicker {
    /// Timetable is available only for the next %d hours
    internal static func availablility(_ p1: Int) -> String {
      return L10n.tr("Localizable", "date_picker.availablility", p1)
    }
    /// Done
    internal static let doneButtonLabel = L10n.tr("Localizable", "date_picker.done_button_label")
    /// Select time and date
    internal static let topLabel = L10n.tr("Localizable", "date_picker.top_label")
  }

  internal enum MainScreen {
    /// Corresponding station
    internal static let corrStationCaption = L10n.tr("Localizable", "main_screen.corr_station_caption")
    /// Select a station
    internal static let corrStationPlaceholder = L10n.tr("Localizable", "main_screen.corr_station_placeholder")
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
    /// through:
    internal static let through = L10n.tr("Localizable", "timetable.through")
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

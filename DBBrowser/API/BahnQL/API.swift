//  This file was automatically generated and should not be edited.

import Apollo

public final class SearchStationQuery: GraphQLQuery {
  public static let operationString =
    "query searchStation($namePart: String!) {\n  search(searchTerm: $namePart) {\n    __typename\n    stations {\n      __typename\n      name\n      primaryEvaId\n    }\n  }\n}"

  public var namePart: String

  public init(namePart: String) {
    self.namePart = namePart
  }

  public var variables: GraphQLMap? {
    return ["namePart": namePart]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["searchTerm": GraphQLVariable("namePart")], type: .nonNull(.object(Search.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(search: Search) {
      self.init(snapshot: ["__typename": "Query", "search": search.snapshot])
    }

    public var search: Search {
      get {
        return Search(snapshot: snapshot["search"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes = ["Searchable"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("stations", type: .nonNull(.list(.nonNull(.object(Station.selections))))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(stations: [Station]) {
        self.init(snapshot: ["__typename": "Searchable", "stations": stations.map { (value: Station) -> Snapshot in value.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var stations: [Station] {
        get {
          return (snapshot["stations"] as! [Snapshot]).map { (value: Snapshot) -> Station in Station(snapshot: value) }
        }
        set {
          snapshot.updateValue(newValue.map { (value: Station) -> Snapshot in value.snapshot }, forKey: "stations")
        }
      }

      public struct Station: GraphQLSelectionSet {
        public static let possibleTypes = ["Station"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("primaryEvaId", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(name: String, primaryEvaId: Int? = nil) {
          self.init(snapshot: ["__typename": "Station", "name": name, "primaryEvaId": primaryEvaId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var primaryEvaId: Int? {
          get {
            return snapshot["primaryEvaId"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryEvaId")
          }
        }
      }
    }
  }
}
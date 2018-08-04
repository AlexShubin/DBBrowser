//
//  Station.swift
//  DBBrowser
//
//  Created by Alex Shubin on 13/05/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct Station: Equatable {
    var name: String
    var evaId: Int
}

// Sometimes DB web-site shows results for different eva ids.
// For example 8011160 `Berlin Hbf` shows results for 8098160 `Berlin Hbf (tief)`.
// I dunno where I can find these ids and connections between them, so let it be hardcoded for now.
extension Station {
    var additionalEvaId: Int? {
        switch evaId {
        case 8011160: // Berlin Hbf
            return 8098160 // Berlin Hbf (tief)
        default:
            return nil
        }
    }
}

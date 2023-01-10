//
//  AppConstants.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 27.12.2022.
//

import Foundation

struct AppConstants {
    struct Identifiers {
        struct Segues {
            static let segueIdentifier = "goToConfiguration"
        }
        struct Cells {
            static let collectionView = "settingsCollectionViewCell"
            static let tableView = "settingsTableViewCell"
        }
        struct Nibs {
            static let tableViewCellNib = "SettingsTableViewCell"
            static let collectionViewCellNib = "SettingsCollectionViewCell"
            static let uiViewNib = "SettingsView"
        }
    }
}

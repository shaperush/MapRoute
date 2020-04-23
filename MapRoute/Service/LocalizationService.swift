//
//  LocalizationService.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation



extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

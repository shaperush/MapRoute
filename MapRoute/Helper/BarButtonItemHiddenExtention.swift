//
//  BarButtonItemHiddenExtention.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 22.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    func hidden(_ isHidden: Bool) {
        if isHidden {
            self.tintColor = . clear
            self.isEnabled = false
        } else {
            self.tintColor = .gray
            self.isEnabled = true
        }
    }
    
}

//
//  String + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}

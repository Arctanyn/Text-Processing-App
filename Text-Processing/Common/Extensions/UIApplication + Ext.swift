//
//  UIApplication + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 08.06.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

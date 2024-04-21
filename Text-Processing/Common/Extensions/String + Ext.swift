//
//  String + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

extension String {
    var numberOfWords: Int {
        var count = 0
        let range = startIndex..<endIndex
        
        enumerateSubstrings(
            in: range,
            options: [.byWords, .substringNotRequired, .localized], { _, _, _, _ in
                count += 1
            }
        )
        
        return count
    }
}

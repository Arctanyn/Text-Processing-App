//
//  String + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import Foundation

extension String {
    
    subscript(range: Range<Int>) -> Self? {
        let stringCount = count
        
        if stringCount < range.upperBound || stringCount < range.lowerBound {
            return nil
        }
        
        let startIndex = index(startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        
        return String(self[startIndex..<endIndex])
    }
    
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

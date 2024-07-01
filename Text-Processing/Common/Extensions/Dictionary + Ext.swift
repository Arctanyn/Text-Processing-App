//
//  Dictionary + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 15.06.2024.
//

extension Dictionary where Value: Hashable {
    
    var inverted: Dictionary<Value, Key> {
        var inverted: [Value: Key] = [:]
        inverted.reserveCapacity(count)
        
        for (key, value) in self {
            inverted[value] = key
        }
        
        return inverted
    }
}

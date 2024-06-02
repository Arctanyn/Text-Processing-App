//
//  Math.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import Accelerate
import CoreML

enum Math {
    
    /// Returns the index and value of the largest element in the array.
    /// - Parameters:
    ///   - ptr: Pointer to the first element in memory.
    ///   - count: Pointer to the first element in memory.
    ///   - stride: How many elements to look at.
    /// - Returns: The distance between two elements in memory.
    static func argmax(_ ptr: UnsafePointer<Float>, count: Int, stride: Int = 1) -> (Int, Float) {
        var maxValue: Float = 0
        var maxIndex: vDSP_Length = 0
        vDSP_maxvi(ptr, vDSP_Stride(stride), &maxValue, &maxIndex, vDSP_Length(count))
        return (Int(maxIndex), maxValue)
    }
    
    /// Returns the index and value of the largest element in the array.
    /// - Parameters:
    ///   - ptr: Pointer to the first element in memory.
    ///   - count: Pointer to the first element in memory.
    ///   - stride: How many elements to look at.
    /// - Returns: The distance between two elements in memory.
    static func argmax(_ ptr: UnsafePointer<Double>, count: Int, stride: Int = 1) -> (Int, Double) {
        var maxValue: Double = 0
        var maxIndex: vDSP_Length = 0
        vDSP_maxviD(ptr, vDSP_Stride(stride), &maxValue, &maxIndex, vDSP_Length(count))
        return (Int(maxIndex), maxValue)
    }
    
    /// MLMultiArray helper.
    /// Works in our specific use case.
    static func argmax(_ multiArray: MLMultiArray) -> (Int, Double) {
        assert(multiArray.dataType == .double)
        let ptr = UnsafeMutablePointer<Double>(OpaquePointer(multiArray.dataPointer))
        return Math.argmax(ptr, count: multiArray.count)
    }
    
    /// MLMultiArray helper.
    /// Works in our specific use case.
    static func argmax32(_ multiArray: MLMultiArray) -> (Int, Float) {
        assert(multiArray.dataType == .float32)
        let ptr = UnsafeMutablePointer<Float32>(OpaquePointer(multiArray.dataPointer))
        let count = multiArray.count
        var maxValue: Float = 0
        var maxIndex: vDSP_Length = 0
        vDSP_maxvi(ptr, vDSP_Stride(1), &maxValue, &maxIndex, vDSP_Length(count))
        return (Int(maxIndex), maxValue)
    }
}

//
//  ByteConverter.swift
//  Created at 09.12.2022.
//

import Foundation


public struct SFByteFormatter {
    
    public let bytes: Int64
    
    public var kilobytes: Double {
        return Double(bytes) / 1_000
    }
    
    public var megabytes: Double {
        return kilobytes / 1_000
    }
    
    public var gigabytes: Double {
        return megabytes / 1_000
    }
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    
    /// Получить количество байтов в читабельном формате
    /// - Parameter allowedUnits: разрешенные единицы измерения (по умолчанию стоит `.useAll`, что означает автоматический выбор, наиболее подходящей единицы измерения)
    /// - Returns: размер в указанном формате
    public func prettyFormat(allowedUnits: ByteCountFormatter.Units = .useAll) -> SFPrettySize {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.includesUnit = true
        formatter.isAdaptive = true
        let formatted = formatter.string(fromByteCount: bytes)
        
        formatter.includesUnit = false
        let count = formatter.string(fromByteCount: bytes)
        
        formatter.includesUnit = true
        formatter.includesCount = false
        let unit = formatter.string(fromByteCount: bytes)
        
        return SFPrettySize(count: count, unit: unit, formatted: formatted)
    }
    
    public struct SFPrettySize {
        
        /// Число, отдельно от единицы измерения
        let count: String
        
        /// Единица измерения, отдельно числа
        let unit: String
        
        /// Единица измерения и число вместе, локализованное
        let formatted: String
    }
}

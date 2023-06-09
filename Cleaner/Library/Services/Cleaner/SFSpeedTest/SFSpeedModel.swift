import Foundation

public struct SFSpeedModel: CustomStringConvertible {
    private static let bitsInBytes: Double = 8
    private static let upUnit: Double = 1000

    public enum Units: Int {
        case Kbps, Mbps, Gbps

        var description: String {
            switch self {
            case .Kbps: return "Kbps"
            case .Mbps: return "Mbps"
            case .Gbps: return "Gbps"
            }
        }
    }

    public let value: Double
    public let units: Units

    public var speedInMbps: Double {
        switch units {
        case .Kbps:
            return value / SFSpeedModel.upUnit
        case .Mbps:
            return value
        case .Gbps:
            return value * SFSpeedModel.upUnit
        }
    }

    public var pretty: SFSpeedModel {
        return [Units.Kbps, .Mbps, .Gbps]
            .filter { units in
                units.rawValue >= self.units.rawValue
            }.reduce(self) { (result, nextUnits) in
                guard result.value > SFSpeedModel.upUnit else {
                    return result
                }
                return SFSpeedModel(value: result.value / SFSpeedModel.upUnit, units: nextUnits)
            }
    }

    public var description: String {
        return String(format: "%.1f", value) + " " + units.description
    }
}

public extension SFSpeedModel {
    init(bytes: Int64, seconds: TimeInterval) {
        let speedInB = Double(bytes) * SFSpeedModel.bitsInBytes / seconds
        self.value = speedInB
        self.units = .Kbps
    }
}

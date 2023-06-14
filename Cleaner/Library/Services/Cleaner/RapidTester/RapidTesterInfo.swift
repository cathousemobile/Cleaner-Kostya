import Foundation

public struct RapidTesterInfo: CustomStringConvertible {
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
            return value / RapidTesterInfo.upUnit
        case .Mbps:
            return value
        case .Gbps:
            return value * RapidTesterInfo.upUnit
        }
    }

    public var pretty: RapidTesterInfo {
        return [Units.Kbps, .Mbps, .Gbps]
            .filter { units in
                units.rawValue >= self.units.rawValue
            }.reduce(self) { (result, nextUnits) in
                guard result.value > RapidTesterInfo.upUnit else {
                    return result
                }
                return RapidTesterInfo(value: result.value / RapidTesterInfo.upUnit, units: nextUnits)
            }
    }

    public var description: String {
        return String(format: "%.1f", value) + " " + units.description
    }
}

public extension RapidTesterInfo {
    init(bytes: Int64, seconds: TimeInterval) {
        let speedInB = Double(bytes) * RapidTesterInfo.bitsInBytes / seconds
        self.value = speedInB
        self.units = .Kbps
    }
}

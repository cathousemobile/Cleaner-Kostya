
import Foundation

public extension BinaryFloatingPoint {
    func roundedToNearest(toMultipleOf m: Self) -> Self {
        return self - self.remainder(dividingBy: m)
    }
    func roundedTowardZero(toMultipleOf m: Self) -> Self {
        return self - self.truncatingRemainder(dividingBy: m)
    }
    func roundedAwayFromZero(toMultipleOf m: Self) -> Self {
        let s = self >= 0 ? (self + m).nextDown : (self - m).nextUp
        return s - s.truncatingRemainder(dividingBy: m)
    }
    func roundedDown(toMultipleOf m: Self) -> Self {
        return (self < 0) ? self.roundedAwayFromZero(toMultipleOf: m)
            : self.roundedTowardZero(toMultipleOf: m)
    }
    func roundedUp(toMultipleOf m: Self) -> Self {
        return (self > 0) ? self.roundedAwayFromZero(toMultipleOf: m)
            : self.roundedTowardZero(toMultipleOf: m)
    }
}

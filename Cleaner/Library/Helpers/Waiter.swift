//
//  Waiter.swift
//

import Foundation

public enum Waiter {
    public static func wait(_ time: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            completion()
        }
    }
}

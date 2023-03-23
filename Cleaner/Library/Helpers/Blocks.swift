//
//  Blocks.swift
//  Cleaner
//

import Foundation

typealias EmptyBlock = (() -> Void)
typealias Block<T> = ((T) -> Void)

typealias Block2<T1, T2> = ((T1, T2) -> Void)

typealias ResultEmptyBlock<R> = (() -> R)
typealias ResultBlock<T, R> = ((T) -> R)


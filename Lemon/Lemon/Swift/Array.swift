//
//  Array.swift
//  Lemon
//
//  Created by Andre Pham on 7/7/2023.
//

import Foundation

extension Array where Element: Hashable {
    
    func filterDuplicates() -> [Element] {
        var uniqueElements = Set<Element>()
        return filter { uniqueElements.insert($0).inserted }
    }
    
    func mostCommonElement() -> Element? {
        let counts = reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
}

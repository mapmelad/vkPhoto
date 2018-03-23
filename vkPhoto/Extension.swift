//
//  Extension.swift
//  vkPhoto
//
//  Created by Semyon on 22.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

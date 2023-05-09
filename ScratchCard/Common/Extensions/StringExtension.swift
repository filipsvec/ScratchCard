//
//  StringExtension.swift
//  ScratchCard
//
//  Created by Filip Svec on 09/05/2023.
//

import Foundation

extension String {
    
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        compare(otherVersion, options: .numeric)
    }
}

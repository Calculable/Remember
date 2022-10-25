//
//  String+LocalizedError.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

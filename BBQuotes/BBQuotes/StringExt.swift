//
//  StringExt.swift
//  BBQuotes
//
//  Created by Muharrem Efe Çayırbahçe on 28.12.2024.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpaces() -> String {
        return self.removeSpaces().lowercased()
    }
}

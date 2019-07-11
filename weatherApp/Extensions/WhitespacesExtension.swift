//
//  WhitespacesExtension.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/10/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation

extension String {
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

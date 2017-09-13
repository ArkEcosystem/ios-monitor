//
//  ArkColors.swift
//  ArkMonitor
//
//  Created by Andrew on 2017-09-11.
//  Copyright © 2017 vrlc92. All rights reserved.
//

import UIKit

let isDarkMode = false


public struct ArkColors {
    
    // 9E9E9E
    static public let gray = UIColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1.0)
    
    // F1F8E9
    static public let lightGreen = UIColor(red: 241/255, green: 248/255, blue: 233/255, alpha: 1.0)
    
    // 1e73be
    static public let blue = UIColor(red: 30/255, green: 115/255, blue: 190/255, alpha: 1.0)
    
    // 4c4c4c
    static public let darkGray = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
}

public struct ArkPalette {
    
    static public var backgroundColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 255, g: 255, b: 255)
        } else {
            return UIColor(r: 14, g: 14, b: 14)
        }
    }
    
    static public var secondaryBackgroundColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 246, g: 245, b: 242)
        } else {
            return UIColor(r: 26, g: 26, b: 26)
        }
    }
    
    static public var tertiaryBackgroundColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 193, g: 193, b: 190)
        } else {
            return UIColor(r: 66, g: 66, b: 64)
        }
    }
    
    static public var textColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 147, g: 147, b: 146)
        } else {
            return UIColor(r: 107, g: 107, b: 107)
        }
    }
    
    static public var highlightedTextColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 26, g: 26, b: 26)
        } else {
            return UIColor(r: 174, g: 174, b: 174)
        }
    }
    
    static public var accentColor: UIColor {
        if isDarkMode == false {
            return UIColor(r: 0, g: 209, b: 172)
        } else {
            return UIColor(r: 0, g: 100, b: 209)
        }
    }
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}

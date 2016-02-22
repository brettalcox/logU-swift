//
//  Theme.swift
//  logU
//
//  Created by Brett Alcox on 2/12/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme: Int {
    case Dark, Graphical
    
    var mainColor: UIColor {
        switch self {
        case .Dark:
            return UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Dark:
            return .Black
        default:
            return .Black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .Dark ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .Dark ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Dark:
            return UIColor(white: 0.8, alpha: 1.0)
        default:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Dark:
            return UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        }
    }
    
}

struct ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue {
            return Theme(rawValue: 0)!
        } else {
            return .Dark
        }
    }
    
    static func applyTheme(theme: Theme) {
        // 1
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: SelectedThemeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 2
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().barTintColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, forBarMetrics: .Default)
        UITabBar.appearance().barTintColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        //UITabBar.appearance().barStyle = theme.barStyle
        //UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        
        //let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.imageWithRenderingMode(.AlwaysTemplate)
        //let tabResizableIndicator = tabIndicator?.resizableImageWithCapInsets(
            //UIEdgeInsets(top: 2.0, left: 0, bottom: 0, right: 2.0))
        //UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
}

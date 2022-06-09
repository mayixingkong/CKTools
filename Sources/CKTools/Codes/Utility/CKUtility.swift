//
//  CKUtility.swift
//  CKTools
//
//  Created by mayi on 2018/3/9.
//  Copyright © 2018年 Inscopy. All rights reserved.
//

import UIKit
import CommonCrypto

public typealias CKHandler = () -> Void

public class CKUtility {

    public static func getWidth() -> CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    public static func getHeight() -> CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    public static func getAppVersion() -> String {
        
        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as! String
        return appVersion
    }
    
    public static func getAppBuildVersion() -> String {
        
        let info = Bundle.main.infoDictionary
        let appBuildVersion = info?["CFBundleVersion"] as! String
        return appBuildVersion
    }
    
    public static func isiPad() -> Bool {
        
        let model = UIDevice.current.model
        if model == "iPad" {
            return true
        }
        else {
            return false
        }
    }
    
    public static func isDebug() -> Bool {
        
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

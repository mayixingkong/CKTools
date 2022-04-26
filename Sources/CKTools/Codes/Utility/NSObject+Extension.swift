//
//  NSObject+Extension.swift
//  NSObject+Extension
//
//  Created by 莹 on 2021/8/4.
//  Copyright © 2021 Inscopy. All rights reserved.
//

import Foundation

public extension NSObject {
    
    class var ck_className:String {
        
        get {
            return String(describing: self)
        }
    }
}

//
//  MBPManager.swift
//  CKTools
//
//  Created by mayi on 2018/3/9.
//  Copyright © 2018年 Inscopy. All rights reserved.
//

import Foundation
import MBProgressHUD

public class MBPManager:NSObject {
    
    public static var shared = MBPManager()

    private var waitHud:MBProgressHUD?

    private override init(){}
    
    public func showDelayText(text:String,view:UIView,delay:TimeInterval = 1.5,completion:CKHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay, execute: {completion?()})
    }
    
    public func showTitle(_ title:String,imageName:String?,view:UIView,delay:TimeInterval = 1.5,completion:CKHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.margin = 30
        
        if let tempImageName = imageName {
            
            hud.mode = .customView
            let imageView = UIImageView(image: UIImage(systemName: tempImageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)))
            imageView.tintColor = UIColor.label
            hud.customView = imageView
        }
        else {
            
            hud.mode = .text
        }
        
        hud.label.text = title
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
    }
    
    public func showSuccess(text:String?,view:UIView,delay:TimeInterval = 1.5,completion:CKHandler? = nil) {
    
        showCustomHud(named: "success", text: text, view: view, delay: delay, completion: completion)
    }
    
    public func showFail(text:String?,view:UIView,delay:TimeInterval = 1.5,completion:CKHandler? = nil) {
        
        showCustomHud(named: "fail", text: text, view: view, delay: delay, completion: completion)
    }
    
    private func showCustomHud(named:String,text:String?,view:UIView,delay:TimeInterval,completion:CKHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: named, in: Bundle.module, with: nil)
        hud.customView = imageView
        
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay, execute: {completion?()})
    }
    
    public func showWait(title:String?, view:UIView) {
        
        waitHud = MBProgressHUD.showAdded(to: view, animated: true)
        waitHud?.label.text = title
        waitHud?.label.numberOfLines = 0
        waitHud?.removeFromSuperViewOnHide = true
    }
    
    public func stopWait() {
        
        waitHud?.hide(animated: true)
        waitHud = nil
    }
}

//
//  MBPManager.swift
//  CKTools

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
    
        showCustomHud(imageNamed: "checkmark", text: text, view: view, delay: delay, completion: completion)
    }
    
    public func showFail(text:String?,view:UIView,delay:TimeInterval = 1.5,completion:CKHandler? = nil) {
        
        showCustomHud(imageNamed: "xmark", text: text, view: view, delay: delay, completion: completion)
    }
    
    private func showCustomHud(imageNamed:String,text:String?,view:UIView,delay:TimeInterval,completion:CKHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = UIImage(systemName: imageNamed)
        imageView.tintColor = UIColor.label
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

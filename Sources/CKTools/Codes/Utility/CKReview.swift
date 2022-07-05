//
//  Review.swift
//  CKTools

import Foundation
import StoreKit

public class CKReview {
    
    static let KEY_REVIEWED = "reviewed"
    static let KEY_DATE_CANCEL = "cancelDate"
    static let KEY_DATE_START  = "startDate"
    static let KEY_LAST_VERSION = "lastVersion"
    
   public static func showReview() {
        
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {return}
        
        let lastVersion = UserDefaults.standard.string(forKey: CKReview.KEY_LAST_VERSION)
        if UserDefaults.standard.bool(forKey: CKReview.KEY_REVIEWED) {
            if currentVersion != lastVersion {
                resetReview(version: currentVersion)
            }
        }
        else {
            if let startData = UserDefaults.standard.object(forKey: CKReview.KEY_DATE_START) as? Date {
                if getDays(date: startData) >= 1 {
                    UserDefaults.standard.setValue(true, forKey: CKReview.KEY_REVIEWED)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                        SKStoreReviewController.requestReview()
                    }
                }
                
                if currentVersion != lastVersion {
                    UserDefaults.standard.setValue(currentVersion, forKey: CKReview.KEY_LAST_VERSION)
                }
            }
            else {
                resetReview(version: currentVersion)
            }
        }
    }
    
    private static func resetReview(version:String) {
        
        UserDefaults.standard.setValue(Date(), forKey: CKReview.KEY_DATE_START)
        UserDefaults.standard.setValue(false, forKey: CKReview.KEY_REVIEWED)
        UserDefaults.standard.setValue(version, forKey: CKReview.KEY_LAST_VERSION)
    }
    
    private static func getDays(date:Date) -> Int {
       
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.day], from: date, to: Date())
        return dateComponents.day!
    }
}

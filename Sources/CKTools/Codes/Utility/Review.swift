//
//  Review.swift
//  InsGet
//
//  Created by 莹 on 2021/6/23.
//

import Foundation
import StoreKit

class Review {
    
    static let KEY_REVIEWED = "reviewed"
    static let KEY_DATE_CANCEL = "cancelDate"
    static let KEY_DATE_START  = "startDate"
    static let KEY_LAST_VERSION = "lastVersion"
    static let shared = Review()
    
    private init() {}
    
    func showReview() {
        
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {return}
        
        let lastVersion = UserDefaults.standard.string(forKey: Review.KEY_LAST_VERSION)
        if UserDefaults.standard.bool(forKey: Review.KEY_REVIEWED) {
            if currentVersion != lastVersion {
                resetReview(version: currentVersion)
            }
        }
        else {
            if let startData = UserDefaults.standard.object(forKey: Review.KEY_DATE_START) as? Date {
                if getDays(date: startData) >= 1 {
                    UserDefaults.standard.setValue(true, forKey: Review.KEY_REVIEWED)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                        SKStoreReviewController.requestReview()
                    }
                }
                
                if currentVersion != lastVersion {
                    UserDefaults.standard.setValue(currentVersion, forKey: Review.KEY_LAST_VERSION)
                }
            }
            else {
                resetReview(version: currentVersion)
            }
        }
    }
    
    private func resetReview(version:String) {
        
        UserDefaults.standard.setValue(Date(), forKey: Review.KEY_DATE_START)
        UserDefaults.standard.setValue(false, forKey: Review.KEY_REVIEWED)
        UserDefaults.standard.setValue(version, forKey: Review.KEY_LAST_VERSION)
    }
    
    private func getDays(date:Date) -> Int {
       
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.day], from: date, to: Date())
        return dateComponents.day!
    }
}

//
//  File.swift
//  
//
//  Created by 莹 on 2022/5/23.
//

import Foundation
import StoreKit

public protocol StoreDelegate: AnyObject {
    
    public func storeProducts(_ products:[SKProduct]?,error:Error?)
    
    public func storePurchaseDidSucceed()
    
    public func storeRestoreDidSucceed()
    
    public func storeError(_ error: SKError?)
    
    public func storeNoRestorablePurchases()
}

public class CKStoreManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    public static let shared = CKStoreManager()
    private weak var delegate:StoreDelegate?
    private var hasRestorablePurchases = false
    
    private override init() {}
    
    public func start(delegate:StoreDelegate?) {
        
        self.delegate = delegate
        SKPaymentQueue.default().add(self)
    }
    
    public func payment(product:SKProduct) {
        
        SKPaymentQueue.default().add(SKMutablePayment(product: product))
    }
    
    public func restore() {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - SKProductsRequest
    
    func getProducts(_ productIds:Set<String>) {
        
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeProducts(response.products, error: nil)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeProducts(nil, error: error)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            transactions.forEach({
                transaction in
                
                switch transaction.transactionState {
                case .purchasing:
                case .deferred:
                case .purchased:
                    self?.handlePurchased(transaction: transaction)
                case .failed:
                    self?.handleFailed(transaction: transaction)
                case .restored:
                    self?.handleRestored(transaction: transaction)
                default:
                }
            })
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeError(error)
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        if !hasRestorablePurchases {
            
            DispatchQueue.main.async {
                [weak self] in
                
                self?.delegate?.storeNoRestorablePurchases()
            }
        }
    }
    
    private func handlePurchased(transaction:SKPaymentTransaction) {
        
        delegate?.storePurchaseDidSucceed()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleFailed(transaction:SKPaymentTransaction) {
        
        delegate?.storeError(transaction.error)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleRestored(transaction:SKPaymentTransaction) {
        
        hasRestorablePurchases = true
        delegate?.storeRestoreDidSucceed()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

//
//  IAPHelper.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/27/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import Foundation
import SwiftyStoreKit


private var sharedInstance: IAPHelper? = nil

class IAPHelper: NSObject {
    
    let productId = "com.nisos.qrcodereader.year"
    var purchased = 0
    var expiryDate = ""
    var remainingDay = 0
    var remainingHour = 0
    var remainingMin = 0
    static func getSharedInstance () -> IAPHelper {
        if sharedInstance == nil {
            sharedInstance = IAPHelper()
        }
        return sharedInstance!
    }
    
    func checkReceipt(completion: @escaping (Int) -> Void){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "ade7c0a1061349c6975f2442a8a0d1ec")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                //let productIds: Set<String> = ["com.nisos.qrcodereader.year"]
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: self.productId, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(self.productId) is valid until \(expiryDate)\n\(items)\n")
                    self.purchased = 1
                    self.expiryDate = AppHelper.sharedInstance.getStringFromDate(time: expiryDate)
                    let calendar = Calendar.current
                    
                    //let date1 = calendar.startOfDay(for: expiryDate)
                    let date2 = Date()
                    
                    //print("\(date1) \(date2)")
                    let components = calendar.dateComponents([.day], from: date2, to: expiryDate)
                    self.remainingDay = components.day ?? 0
                    if self.remainingDay == 0 {
                        let components2 = calendar.dateComponents([.hour], from: date2, to: expiryDate)
                        self.remainingHour = components2.hour ?? 0
                        if self.remainingHour == 0 {
                            let components3 = calendar.dateComponents([.minute], from: date2, to: expiryDate)
                            self.remainingMin = components3.minute ?? 0
                        }
                    }
                     
                case .expired(let expiryDate, let items):
                    print("\(self.productId) is expired since \(expiryDate)\n\(items)\n")
                    self.purchased = 2
                    self.remainingDay = 0
                case .notPurchased:
                    print("The user has never purchased \(self.productId)")
                    self.purchased = 3
                    self.remainingDay = 0
                }
                completion(self.purchased)
            case .error(let error):
                print(error)
                self.purchased = 4
                self.remainingDay = 0
                completion(self.purchased)
            }
            
        }
    }
    
}

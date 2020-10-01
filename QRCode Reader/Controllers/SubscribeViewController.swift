//
//  SubscribeViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/25/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit
import JGProgressHUD
import SwiftyStoreKit

class SubscribeViewController: UIViewController {

    let productID = "com.nisos.qrcodereader.year"

    @IBOutlet weak var yearPlanLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var buyButton: RoundButton!
    
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var purchaseMarkView: ExtensionView!
    
    let hud = JGProgressHUD(style: .light)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud.textLabel.text = ""
        self.hud.show(in: self.view, animated: true)

        SwiftyStoreKit.retrieveProductsInfo([productID]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                let displayName = product.localizedTitle
                let period = product.localizedSubscriptionPeriod
                
                //let membershiponeyear = "\(product.localizedDescription) - \(priceString)"                
                self.yearPlanLabel.text = displayName
                self.priceLabel.text = priceString + " / " + period
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
                print(errorString)
            }
            self.updateScreen()
        }
    }

    func updateScreen(){
        self.hud.show(in: self.view, animated: true)
        IAPHelper.getSharedInstance().checkReceipt { (result) in
            self.hud.dismiss()
            let purchased = IAPHelper.getSharedInstance().purchased
            if(purchased == 1){
//                let membershipText = NSLocalizedString("You have already purchased membership.", comment: "")
//                let expiaryText = NSLocalizedString("Your membership will be expire on ", comment: "") + IAPHelper.getSharedInstance().expiryDate
                
                self.purchaseMarkView.isHidden = false
            }
            else{
                self.purchaseMarkView.isHidden = true
            }
            if(purchased == 3){
                self.restoreButton.isEnabled = false
            }
            else{
                self.restoreButton.isEnabled = true
            }
        }
    }
    
    @IBAction func onMembershipOneYearPressed(_ sender: Any) {
        self.hud.show(in: self.view, animated: true)
        SwiftyStoreKit.purchaseProduct("com.nisos.qrcodereader.year", quantity: 1, atomically: true) { result in
            self.hud.dismiss()
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.hud.show(in: self.view, animated: true)
                IAPHelper.getSharedInstance().checkReceipt { (result) in
                    self.hud.dismiss()
                    let purchased = IAPHelper.getSharedInstance().purchased
                    if(purchased == 1){
        //                let membershipText = NSLocalizedString("You have already purchased membership.", comment: "")
        //                let expiaryText = NSLocalizedString("Your membership will be expire on ", comment: "") + IAPHelper.getSharedInstance().expiryDate
                        
                        self.purchaseMarkView.isHidden = false
                    }
                    else{
                        self.purchaseMarkView.isHidden = true
                    }
                    if(purchased == 3){
                        self.restoreButton.isEnabled = false
                    }
                    else{
                        self.restoreButton.isEnabled = true
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRestorePressed(_ sender: Any) {
        self.hud.show(in: self.view, animated: true)
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.hud.dismiss()
            if results.restoreFailedPurchases.count > 0 {
                //print("Restore Failed: \(results.restoreFailedPurchases)")
                AppHelper.showAlert(vc: self, NSLocalizedString("Restore Failed", comment: ""), "")
                print("Restore Failed")
            }
            else if results.restoredPurchases.count > 0 {
                //print("Restore Success: \(results.restoredPurchases)")
                AppHelper.showAlert(vc: self, NSLocalizedString("Restore Success", comment: ""), "")
                print("Restore Success")
            }
            else {
                print("Nothing to Restore")
            }
//            for purchase in results.restoredPurchases {
//                if purchase.needsFinishTransaction {
//                    // Deliver content from server, then:
//                    SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    print("Restore transaction")
//                }
//            }
        }
    }
    
}

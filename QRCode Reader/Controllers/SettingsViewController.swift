//
//  SettingsViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    
    @IBOutlet weak var vibrateSwitch: UISwitch!
    @IBOutlet weak var beepSwitch: UISwitch!
    @IBOutlet weak var historySwitch: UISwitch!
    
    @IBOutlet weak var purchaseStateLabel: UILabel!
    @IBOutlet weak var remainingDayLabel: UILabel!
    @IBOutlet weak var premiumImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let vibrate = PrefsManager.getVibrate()
        vibrateSwitch.setOn(vibrate == 0 ? true : false, animated: false)
        
        let beep = PrefsManager.getBeep()
        beepSwitch.setOn(beep == 0 ? true : false, animated: false)

        let history = PrefsManager.getHistory()
        historySwitch.setOn(history == 0 ? true : false, animated: false)

        
        let purchased = IAPHelper.getSharedInstance().purchased
        if(purchased == 1){
            self.premiumImageView.isHidden = false
            self.purchaseStateLabel.text = NSLocalizedString("Premium", comment: "")
            let remainingTime = self.remainingTime()
            self.remainingDayLabel.text = remainingTime
        }
        else{
            self.premiumImageView.isHidden = true
            self.purchaseStateLabel.text = NSLocalizedString("Locked", comment: "")
            self.remainingDayLabel.text = ""
        }

    }
    func remainingTime() -> String{
        var remainingTime = ""
        let remainingDay = IAPHelper.getSharedInstance().remainingDay
        if remainingDay != 0{
            let timeprefix = remainingDay == 1 ? NSLocalizedString("day", comment: "") : NSLocalizedString("days", comment: "")
            remainingTime = "\(remainingDay) " + timeprefix
        }
        else{
            let remainingHour = IAPHelper.getSharedInstance().remainingHour
            if remainingHour != 0{
                let timeprefix = remainingHour == 1 ? NSLocalizedString("hour", comment: "") : NSLocalizedString("hours", comment: "")
                remainingTime = "\(remainingHour) " + timeprefix
            }
            else{
                let remainingMin = IAPHelper.getSharedInstance().remainingMin
                let timeprefix = remainingMin == 1 ? NSLocalizedString("min", comment: "") : NSLocalizedString("mins", comment: "")
                remainingTime = "\(remainingMin) " + timeprefix
            }
        }
        return remainingTime
    }
        
    @IBAction func onSwitchChanged(_ sender: Any) {
        let switchButton = sender as! UISwitch
        
        switch(switchButton){
        case vibrateSwitch:
            PrefsManager.setVibrate(val: switchButton.isOn ? 0 : 1)
            break
        case beepSwitch:
            PrefsManager.setBeep(val: switchButton.isOn ? 0 : 1)
            break
        case historySwitch:
            PrefsManager.setHistory(val: switchButton.isOn ? 0 : 1)
            break
        default:
            break
        }
        
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 1{
                let purchased = IAPHelper.getSharedInstance().purchased
                if purchased == 1 {
                    let message = self.remainingTime() + " " + NSLocalizedString("left until the subscription renews", comment: "")
                    AppHelper.showAlert(vc: self, message, "")
                }
                else{
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "subscribeNavigationViewController")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                if let url = URL(string: "https://nisos.co.uk/privacy-policy") {
                    UIApplication.shared.open(url)
                }
            }
            else if indexPath.row == 1{
                if let url = URL(string: "https://nisos.co.uk/terms-and-conditions") {
                    UIApplication.shared.open(url)
                }

            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)

    }

    
}

//
//  CreateQRCoeViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 9/10/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit


class CreateQRCoeViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var avatarView: ExtensionView!

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!

    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondView: ExtensionView!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdView: ExtensionView!
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fourthView: ExtensionView!
    @IBOutlet weak var fourthTextField: UITextField!
    
    @IBOutlet weak var uploadButtonView: UIView!
    

    private var type: String = "url"
    private var itemTitle: String = "Url"
    private var avatarName: String = "ic_url"
    
    private var itemTypeData: ItemTypeData?
    
    private var codeData: MyCodeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if codeData != nil {
            self.type = codeData!.type
        }
        if itemTypeData != nil {
            self.type = itemTypeData!.type
        }
        
        var hexcolor = ""
        if type == "email" {
            hexcolor = "#FF9646"
            self.navigationItem.title = "Email"
            self.avatarName = "ic_email"
            
            // check if new or edit mode
            if codeData == nil {
                self.urlTextField.text = ""
            }
            else{
                let codeURL = URL(string: codeData!.text)
                if codeURL?.scheme == "mailto" {
                    let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                    // email
                    urlTextField.text =  components?.path
                    let cc = components?.queryItems?.first(where: {$0.name == "cc"})?.value
                    let subject = components?.queryItems?.first(where: {$0.name == "subject"})?.value
                    let body = components?.queryItems?.first(where: {$0.name == "body"})?.value
                    secondTextField.text = cc
                    thirdTextField.text = subject
                    fourthTextField.text = body
                }
            }
            self.firstLabel.text = "Email"
            self.secondLabel.isHidden = false
            self.secondView.isHidden = false
            
            self.thirdLabel.isHidden = false
            self.thirdView.isHidden = false
            
            self.fourthLabel.isHidden = false
            self.fourthView.isHidden = false
            
            self.uploadButtonView.isHidden = true
        }
        
        else if type == "doc" {
            hexcolor = "#9868FE"
            self.navigationItem.title = "Document/Menu"
            self.avatarName = "ic_doc"

            if codeData == nil {
                self.urlTextField.text = "https://"
            }
            else{
                self.urlTextField.text = codeData?.text
            }
            
            self.firstLabel.text = "Url"
            self.secondLabel.isHidden = true
            self.secondView.isHidden = true
            
            self.thirdLabel.isHidden = true
            self.thirdView.isHidden = true
            
            self.fourthLabel.isHidden = true
            self.fourthView.isHidden = true
            
            self.uploadButtonView.isHidden = true

        }
        else if type == "facebook" {
            hexcolor = "#4F89F7"
            self.navigationItem.title = "Facebook"
            self.avatarName = "ic_facebook"
            
            if codeData == nil {
                self.urlTextField.text = "https://www.facebook.com/"
            }
            else{
                self.urlTextField.text = codeData?.text
            }
            self.firstLabel.text = "Url"
            self.secondLabel.isHidden = true
            self.secondView.isHidden = true
            
            self.thirdLabel.isHidden = true
            self.thirdView.isHidden = true
            
            self.fourthLabel.isHidden = true
            self.fourthView.isHidden = true

            self.uploadButtonView.isHidden = true
        }
        else if type == "call" {
            hexcolor = "#6BD167"
            self.navigationItem.title = "Phone number"
            self.avatarName = "ic_call"
            
            if codeData == nil {
                self.urlTextField.text = ""
            }
            else{
                let codeURL = URL(string: codeData!.text)
                if codeURL?.scheme == "tel" {
                    let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                    // phone
                    urlTextField.text =  components?.path
                }
            }
            self.firstLabel.text = "Phone number"
            self.secondLabel.isHidden = true
            self.secondView.isHidden = true
            
            self.thirdLabel.isHidden = true
            self.thirdView.isHidden = true
            
            self.fourthLabel.isHidden = true
            self.fourthView.isHidden = true
            
            self.uploadButtonView.isHidden = true

        }
        else if type == "instagram" {
            hexcolor = "#F2586F"
            self.navigationItem.title = "Instagram"
            self.avatarName = "ic_instagram"
            
            if codeData == nil {
                self.urlTextField.text = "https://www.instagram.com/"
            }
            else{
                self.urlTextField.text = codeData?.text
            }
            self.firstLabel.text = "Url"
            self.secondLabel.isHidden = true
            self.secondView.isHidden = true
            
            self.thirdLabel.isHidden = true
            self.thirdView.isHidden = true
            
            self.fourthLabel.isHidden = true
            self.fourthView.isHidden = true
            
            self.uploadButtonView.isHidden = true
        }
        else {
            hexcolor = "#039FC3"
            self.navigationItem.title = "Url"
            self.avatarName = "ic_link_medium"

            if codeData == nil {
                self.urlTextField.text = "https://"
            }
            else{
                self.urlTextField.text = codeData?.text
            }
            
            self.firstLabel.text = "Url"
            self.secondLabel.isHidden = true
            self.secondView.isHidden = true
            
            self.thirdLabel.isHidden = true
            self.thirdView.isHidden = true
            
            self.fourthLabel.isHidden = true
            self.fourthView.isHidden = true
            
            self.uploadButtonView.isHidden = true

        }
        self.avatarImageView.image = UIImage(named: self.avatarName)
        self.avatarView.backgroundColor = UIColor(hexString: hexcolor)
    }
    
    func setItemTypeData(itemTypeData: ItemTypeData) {
        self.itemTypeData = itemTypeData
    }
    
    func setCodeData(codeData: MyCodeData) {
        self.codeData = codeData
    }
    
    @IBAction func onUploadPhotoPressed(_ sender: Any) {
        
    }
    
    @IBAction func onUploadDocumentPressed(_ sender: Any) {
        
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        let urlText = self.urlTextField.text
        let secondText = self.secondTextField.text
        let thirdText = self.thirdTextField.text
        let fourthText = self.fourthTextField.text
        
        if urlText?.trimmingCharacters(in: .whitespaces) == "" || urlText == "https://" || urlText == "http://"{
            AppHelper.showAlert(vc: self, NSLocalizedString("Please enter the text", comment: ""), "")
            return
        }
        var codeText = ""
        if type == "email" {
            codeText = "mailto:" + urlText!
            if secondText != "" {
                codeText += "?cc=" + secondText!
            }
            if thirdText != "" {
                codeText += "&subject=" + thirdText!
            }
            if fourthText != "" {
                codeText += "&body=" + fourthText!
            }
        }
        else if type == "call" {
            codeText = "tel:" + urlText!
        }
        else {
            codeText = urlText!
        }

        if(codeData != nil){
            let myCodeDatas = realm.objects(MyCodeData.self).filter("id = %@", codeData!.id)
            if let myCodeData = myCodeDatas.first {
                try! realm.write{
                    myCodeData.text = codeText
                }
                navigateResultViewController(codeData: myCodeData)
            }
        }
        else{
            let myCodeData = appendDatabase(code: codeText , type: type)
            navigateResultViewController(codeData: myCodeData)
        }
                
    }
    func navigateResultViewController(codeData: MyCodeData){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ResultViewController = mainStoryboard.instantiateViewController(withIdentifier: "resultViewController") as! ResultViewController
        vc.setResultItem(result: codeData)
        //self.navigationController?.popToRootViewController(animated: false)        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func appendDatabase(code: String, type: String) -> MyCodeData{
        let myCodeData = MyCodeData()
        myCodeData.id = myCodeData.increatementId()
        
        myCodeData.type = type
        myCodeData.text = code
        try! realm.write{
            realm.add(myCodeData)
        }
        return myCodeData
    }
    
    
}

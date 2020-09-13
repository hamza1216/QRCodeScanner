//
//  ResultViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit
import JGProgressHUD

class ResultViewController: UIViewController {

    @IBOutlet weak var resultQRCode: UIImageView!
    
    @IBOutlet weak var resultTextLabel: UILabel!
    
    @IBOutlet weak var sendImageView: UIImageView!
    
    @IBOutlet weak var sendLabel: UILabel!
    
    
    let hud = JGProgressHUD(style: .light)
    
    private var codeData: MyCodeData?
    
    private var resultText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if codeData != nil {
            resultText = codeData?.text ?? "https://www.google.com"
            resultQRCode.image = generateQRCode(from: resultText)
            if codeData!.type == "email"{
                let codeURL = URL(string: resultText)
                if codeURL?.scheme == "mailto" {
                    let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                    // email
                    resultText =  components != nil ? components!.path : ""
                }
                sendImageView.image = UIImage(named: "ic_email")
                sendLabel.text = NSLocalizedString("Send", comment: "")
            }
            else if codeData!.type == "call"{
                let codeURL = URL(string: resultText)
                if codeURL?.scheme == "tel" {
                    let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                    // email
                    resultText =  components != nil ? components!.path : ""
                }
                sendImageView.image = UIImage(named: "ic_call")
                sendLabel.text = NSLocalizedString("Call", comment: "")
            }
            resultTextLabel.text = resultText
        }

    }

    func setResultItem(result: MyCodeData){
        self.codeData = result
        
    }
    //MARK: - Add image to Library
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            self.hud.textLabel.text = NSLocalizedString("Can not save QR Code.", comment: "")
            self.hud.show(in: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hud.dismiss()
            }

        } else {
            self.hud.textLabel.text = NSLocalizedString("Saved to the Cameraroll.", comment: "")
            self.hud.show(in: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hud.dismiss()
            }
        }
    }
    
    @IBAction func onCopyPressed(_ sender: Any) {
        //let pasteboard = UIPasteboard.general
        //pasteboard.string = resultText
        
        let size = CGSize(width: resultQRCode.frame.size.width, height: resultQRCode.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        resultQRCode.image?.draw(in: CGRect(origin: .zero, size: size))
        if let qrcodeImage = UIGraphicsGetImageFromCurrentImageContext() {
            //let imageData = qrcodeImage.jpegData(compressionQuality: 1)
            UIImageWriteToSavedPhotosAlbum(qrcodeImage, self, #selector(saveError), nil)
        }
        
        if let imageToBeSaved = generateQRCode(from: codeData?.text ?? "") {
            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, self, #selector(saveError), nil);
        }
    }
    
    @IBAction func onOpenbrowserPressed(_ sender: Any) {
        
//        let isURL = AppHelper.verifyUrl(urlString: resultText)
        var openURL = codeData?.text ?? ""
        if let url = URL(string: openURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onSharePressed(_ sender: Any) {
        let image = generateQRCode(from: codeData?.text ?? "")
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

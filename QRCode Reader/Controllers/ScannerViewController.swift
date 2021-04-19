//
//  ScannerViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/23/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit
import AVFoundation
import JGProgressHUD
import SwiftyStoreKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: ScannerOverlayPreviewLayer!
    var audioPlayer: AVAudioPlayer? = nil
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var flashlightImageView: UIImageView!
    
    var flashstate = false
    
    let hud = JGProgressHUD(style: .light)
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.itf14,
        AVMetadataObject.ObjectType.dataMatrix,
        AVMetadataObject.ObjectType.interleaved2of5,
        AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedCodeTypes
        } else {
            failed()
            return
        }

        previewLayer = ScannerOverlayPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.maskSize = CGSize(width: 200, height: 200)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        metadataOutput.rectOfInterest = previewLayer.rectOfInterest
        
        captureSession.startRunning()
        
        controlView.layer.zPosition = 1
                
    }
    

    func failed() {
        let ac = UIAlertController(title: NSLocalizedString("Scanning not supported", comment: ""), message: NSLocalizedString("Your device does not support scanning a code from an item. Please use a device with a camera.", comment: ""), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        self.hud.show(in: self.view, animated: true)
        IAPHelper.getSharedInstance().checkReceipt(completion: { (result) in
            self.hud.dismiss()
            if(result == 3){
                if PrefsManager.getFirstOpen() != 1 {
                    self.launchSubscribeController()
                    PrefsManager.setFirstOpen(val: 1)
                }
            }
        })
 
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func launchSubscribeController(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "subscribeNavigationViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        playSoundAndVibrate()
/*
        if(IAPHelper.getSharedInstance().purchased != 1){
            DispatchQueue.main.async{
                //self.navigateResultViewController(result: code)
                self.launchSubscribeController()
            }
            return
        }
*/5     
        let historyState = PrefsManager.getHistory()
        if historyState == 0 {
            appendDatabase(code: code)
        }

        DispatchQueue.main.async{
            //self.navigateResultViewController(result: code)
            self.populateMenu(result: code)
        }

    }
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
            //if on { try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel.significand) }
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
    @IBAction func onFlashlightPressed(_ sender: Any) {
        if(flashstate == false){
            flashlightImageView.image = UIImage(named: "ic_flashlight_on")
            toggleTorch(on: true)
        }
        else{
            flashlightImageView.image = UIImage(named: "ic_flashlight_off")
            toggleTorch(on: false)
        }
        flashstate = !flashstate
    }
    
    func appendDatabase(code: String){
        let isURL = AppHelper.verifyUrl(urlString: code)
        
        let historyData = HistoryData()
        historyData.id = historyData.increatementId()
        
        if isURL == true{
            historyData.type = "Url"
        }
        else{
            historyData.type = "Text"
        }
        historyData.text = code
        try! realm.write{
            realm.add(historyData)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func populateMenu(result: String) {
        let isURL = AppHelper.verifyUrl(urlString: result)
        if isURL == true{
            if let url = URL(string: result) {
                UIApplication.shared.open(url)
            }
            self.captureSession.startRunning()
        }
        else{
            let alertController = UIAlertController(title: result, message: nil, preferredStyle: .actionSheet)
            let googlesearchbutton = UIAlertAction(title: NSLocalizedString("Search on google", comment: ""), style: .default) { (_) in
                var keywords = result.replacingOccurrences(of: " ", with: "+")
                keywords = keywords.replacingOccurrences(of: "\n", with: "")
                let urlText = "https://www.google.com/search?tbm=shop&q=\(keywords)"
                if let url = URL(string: urlText) {
                    UIApplication.shared.open(url)
                }
                self.captureSession.startRunning()
            }
            let amazonbutton = UIAlertAction(title: NSLocalizedString("Search on amazon", comment: ""), style: .default) { (_) in
                var keywords = result.replacingOccurrences(of: " ", with: "+")
                keywords = keywords.replacingOccurrences(of: "\n", with: "")
                let urlText = "https://www.amazon.com/s?k=\(keywords)"
                if let url = URL(string: urlText) {
                    UIApplication.shared.open(url)
                }
                self.captureSession.startRunning()
            }
            let copybutton = UIAlertAction(title: NSLocalizedString("Copy", comment: ""), style: .default) { (_) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = result
                self.captureSession.startRunning()
            }

            let sharebutton = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) { (_) in
                let items = [result]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                ac.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed {
                      
                    }
                    self.captureSession.startRunning()
                }
                self.present(ac, animated: true)
                
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
                self.captureSession.startRunning()
            }

            alertController.addAction(googlesearchbutton)
            alertController.addAction(amazonbutton)
            alertController.addAction(copybutton)
            alertController.addAction(sharebutton)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func playSoundAndVibrate(){
        // play sound
        let beepState = PrefsManager.getBeep()
        if beepState == 0 {
            let path = Bundle.main.path(forResource: "beep_beep.mp3", ofType: nil)
            let url = URL(fileURLWithPath: path!)
            do {
                if(self.audioPlayer != nil && self.audioPlayer!.isPlaying){
                    self.audioPlayer?.stop()
                }
                
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch {
                    print(error.localizedDescription)
                }
                self.audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
        // vibrate
        let vibrateState = PrefsManager.getVibrate()
        if vibrateState == 0{
            UIDevice.vibrate()
        }

    }

}

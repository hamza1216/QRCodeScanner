//
//  CreatePDFViewController.swift
//  QRCode Reader
//
//  Created by devstar on 10/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit
import JGProgressHUD
import PDFGenerator

protocol UploadDocumentDelegate {
    func didFileUploaded(url: String)
}
class CreatePDFViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var delegate: UploadDocumentDelegate?
    
    let hud = JGProgressHUD(style: .light)
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var tableView: UITableView!
    var imageList: [UIImage] = []
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    func refreshImageList() {
        tableView.reloadData()
        
        if imageList.count == 0 {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
        
    func actionDelete(at indexPath: IndexPath) {

        let alert = UIAlertController(title: NSLocalizedString("Are you sure to delete this item?", comment: ""), message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { action in
            self.imageList.remove(at: indexPath.row)
            self.refreshImageList()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = imageList[indexPath.row]
        let imageCrop = currentImage.getCropRatio()
        return tableView.frame.width / imageCrop
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.imageList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageViewCell", for: indexPath) as! ImageViewCell
        let item = imageList[indexPath.row]
        
        cell.imageItem.image = item
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let actionDelete = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) {  action, sourceView, completionHandler in
            self.actionDelete(at: indexPath)
            completionHandler(false)
        }
        actionDelete.image = UIImage(named: "ic_trash")

        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    enum ImageSource {
       case photoLibrary
       case camera
    }
    
    @IBAction func onAddPressed(_ sender: Any) {
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.selectImageFrom(.photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.selectImageFrom(.camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: "Choose your image", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
        /*
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
         */
    }
    
    @IBAction func onGeneratePressed(_ sender: Any) {
        if imageList.count == 0 {
            AppHelper.showAlert(vc: self, "Please add the images.", "")
            return
        }
        
        let fileName = "output.pdf"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let pathForPDF = documentsDirectory + "/" + fileName
        
        do {
            let data = try PDFGenerator.generated(by: imageList)
            try data.write(to: URL(fileURLWithPath: pathForPDF))
            self.hud.show(in: self.view, animated: true)
            AppHelper.sharedInstance.uploadDocument(data, filename: "image.pdf") { (response, error) in
                if(response != nil) {
                    if response?.result == "success"{
                        if self.delegate != nil {
                            self.delegate?.didFileUploaded(url: AppHelper.sharedInstance.hostURL + response!.message)
                        }
                        self.hud.textLabel.text = "Uploaded successfully."
                        self.hud.dismiss(afterDelay: 2.0, animated: true)
                        self.dismiss(animated: true, completion: nil)

                    }
                    else{
                        self.hud.textLabel.text = response?.message
                        self.hud.dismiss(afterDelay: 2.0, animated: true)
                    }
                }
                else{
                    self.hud.textLabel.text = "Failed to upload."
                    self.hud.dismiss(afterDelay: 2.0, animated: true)
                }
            }
        } catch (let e) {
            print(e)
        }
    }
    

    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            AppHelper.showAlert(vc: self, "Save error", error.localizedDescription)
        } else {
            AppHelper.showAlert(vc: self, "Saved", "Your image has been saved to your photos.")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
/*
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else{
            return
        }
        self.photoURL = imageURL.path
        let tempURL = URL(fileURLWithPath: self.photoURL!)
        let data = try? Data(contentsOf: tempURL)
        profileImageView.image = UIImage(data: data!)
 */
                
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        let data = image.jpegData(compressionQuality: 0.5)
        
        imageList.append(UIImage(data: data!)!)
        self.refreshImageList()
 
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}

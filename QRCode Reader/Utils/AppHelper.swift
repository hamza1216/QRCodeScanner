//
//  AppHelper.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AppHelper{
    static let sharedInstance = AppHelper()
    var hostURL = "https://theqrcodecreator.com/"

    let time24Formatter = DateFormatter()
    let engFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    
    private init() {
        time24Formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        engFormatter.dateFormat = "MMM d, yyyy h:mm a"
        dateFormatter.dateFormat = "MMM d, yyyy"
    }
    
    
    func get24HourTimeFromString(timeString: String) -> Date? {
        return self.time24Formatter.date(from: timeString)
    }
    
    func get12HourTimeStringFromDate(time: Date) -> String {
        return self.engFormatter.string(from: time)
    }
    
    func getStringFromDate(time: Date) -> String {
        return self.dateFormatter.string(from: time)
    }

    
    func get12HourTimeStringFromString(timeString: String) -> String{
        let date = self.get24HourTimeFromString(timeString: timeString)
        if let d = date {
            return get12HourTimeStringFromDate(time: d)
        }
        return ""
    }
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    static func showAlert(vc: UIViewController, _ title: String, _ message: String){
        let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        ))
        vc.present(alert, animated: true, completion: nil)
    }
    func uploadDocument(_ file: Data, filename : String, withCompletion completion : @escaping (UploadDataResponse?, Error?) -> Void) {
       let headers: HTTPHeaders = [
           "Content-type": "multipart/form-data"
       ]

       AF.upload(
           multipartFormData: { multipartFormData in
               multipartFormData.append(file, withName: "media" , fileName: filename, mimeType: "application/jpeg")
       },
           to: hostURL + "file_upload.php", method: .post , headers: headers)
           .response { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(UploadDataResponse.self, from: data!)
                    if(responseData.result == "success"){
                        completion(responseData, nil)
                    }
                    else{
                        completion(nil, nil)
                    }
                } catch let error {
                    debugPrint("Fetching List Error Error: \(error)")
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
       }
   }
}

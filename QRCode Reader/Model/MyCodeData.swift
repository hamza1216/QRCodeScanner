//
//  MyCodeData.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 9/10/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import Foundation
import RealmSwift

class MyCodeData: Object {
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var text = ""
    @objc dynamic var created = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func increatementId() -> String{
        let uuid = UUID().uuidString
        return uuid
    }
}

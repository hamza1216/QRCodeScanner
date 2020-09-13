//
//  UIDevice+Extension.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

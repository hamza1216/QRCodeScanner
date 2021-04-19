//
//  ImageViewCell.swift
//  QRCode Reader
//
//  Created by devstar on 10/24/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    @IBOutlet weak var imageItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

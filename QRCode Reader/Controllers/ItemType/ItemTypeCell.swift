//
//  ItemTypeCell.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 9/10/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class ItemTypeCell: UITableViewCell {

    @IBOutlet weak var avatarView: ExtensionView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

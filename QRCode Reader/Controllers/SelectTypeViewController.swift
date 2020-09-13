//
//  SelectTypeViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 9/10/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class SelectTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var itemTypes: [ItemTypeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemTypes.append(ItemTypeData(type: "email", title: "Email", icon: "ic_email"))
        itemTypes.append(ItemTypeData(type: "url", title: "Url", icon: "ic_link_medium"))
        itemTypes.append(ItemTypeData(type: "doc", title: "Document/Menu", icon: "ic_doc"))
        itemTypes.append(ItemTypeData(type: "facebook", title: "Facebook", icon: "ic_facebook"))
        itemTypes.append(ItemTypeData(type: "call", title: "Phone number", icon: "ic_call"))
        itemTypes.append(ItemTypeData(type: "instagram", title: "Instagram", icon: "ic_instagram"))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        let item = self.itemTypes[indexPath.row]
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "createQRCodeViewController") as! CreateQRCoeViewController
        vc.setItemTypeData(itemTypeData: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTypeCell", for: indexPath) as! ItemTypeCell
        let item = itemTypes[indexPath.row]
        
        var hexcolor = "#FF9646"
        if item.type == "email" {
            hexcolor = "#FF9646"
        }
        else if item.type == "url" {
            hexcolor = "#039FC3"
        }
        else if item.type == "doc" {
            hexcolor = "#9868FE"
        }
        else if item.type == "facebook" {
            hexcolor = "#4F89F7"
        }
        else if item.type == "call" {
            hexcolor = "#6BD167"
        }
        else if item.type == "instagram" {
            hexcolor = "#F2586F"
        }

        cell.avatarView.backgroundColor = UIColor(hexString: hexcolor)
        cell.itemTitleLabel.text = item.title
        cell.avatarImageView.image = UIImage(named: item.icon)
        return cell
    }

}

//
//  HistoryViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/23/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noHistoryLabel: UILabel!
        
    var historyDatas = realm.objects(HistoryData.self).filter(falsepredicate)
    
    let colorsArray = ["#9868FE", "#039FC3", "#FF9646", "#F2586F"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshHistory()
    }
    
    func refreshHistory(){
        historyDatas = realm.objects(HistoryData.self).sorted(byKeyPath: "created", ascending: false)
        tableView.reloadData()
        if(historyDatas.count == 0){
            noHistoryLabel.isHidden = false
        }
        else{
            noHistoryLabel.isHidden = true
        }
        
    }
    
    func actionDelete(at indexPath: IndexPath) {

        let alert = UIAlertController(title: NSLocalizedString("Are you sure to delete this item?", comment: ""), message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { action in
            let item = self.historyDatas[indexPath.row]
            try! realm.write {
                realm.delete(item)
            }
            self.refreshHistory()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    func populateMenu(result: String) {
        let isURL = AppHelper.verifyUrl(urlString: result)
        if isURL == true{
            if let url = URL(string: result) {
                UIApplication.shared.open(url)
            }
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
            }
            let amazonbutton = UIAlertAction(title: NSLocalizedString("Search on amazon", comment: ""), style: .default) { (_) in
                var keywords = result.replacingOccurrences(of: " ", with: "+")
                keywords = keywords.replacingOccurrences(of: "\n", with: "")
                let urlText = "https://www.amazon.com/s?k=\(keywords)"
                if let url = URL(string: urlText) {
                    UIApplication.shared.open(url)
                }
            }
            let copybutton = UIAlertAction(title: NSLocalizedString("Copy", comment: ""), style: .default) { (_) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = result
            }

            let sharebutton = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) { (_) in
                let items = [result]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
            }

            alertController.addAction(googlesearchbutton)
            alertController.addAction(amazonbutton)
            alertController.addAction(copybutton)
            alertController.addAction(sharebutton)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        let item = self.historyDatas[indexPath.row]
        self.populateMenu(result: item.text)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(historyDatas.count)
        return self.historyDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyDataCell", for: indexPath) as! HistoryDataCell
        let item = historyDatas[indexPath.row]
        
        cell.avatarView.backgroundColor = UIColor(hexString: colorsArray[Int.random(in: 0 ... 3)])
        if item.type.lowercased() == "text" {
            cell.avatar.image = UIImage(named: "ic_text")
        }
        else{
            cell.avatar.image = UIImage(named: "ic_url")
        }
        cell.titleLabel.text = item.text
        let date = AppHelper.sharedInstance.get12HourTimeStringFromDate(time: item.created)
        cell.dateLabel.text = date
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
    
    
}

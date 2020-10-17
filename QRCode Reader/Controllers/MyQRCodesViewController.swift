//
//  MyQRCodesViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 9/10/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit

class MyQRCodesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noHistoryLabel: UILabel!
    
    var historyDatas = realm.objects(MyCodeData.self).filter(falsepredicate)
    
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
        historyDatas = realm.objects(MyCodeData.self).sorted(byKeyPath: "created", ascending: false)
        tableView.reloadData()
        if(historyDatas.count == 0){
            noHistoryLabel.isHidden = false
        }
        else{
            noHistoryLabel.isHidden = true
        }
        
    }
    func actionEdit(at indexPath: IndexPath) {
        let item = self.historyDatas[indexPath.row]
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "createQRCodeViewController") as! CreateQRCoeViewController
        vc.setCodeData(codeData: item)
        self.navigationController?.pushViewController(vc, animated: true)
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

    func navigateResultViewController(codeData: MyCodeData){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ResultViewController = mainStoryboard.instantiateViewController(withIdentifier: "resultViewController") as! ResultViewController
        vc.setResultItem(result: codeData)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        let item = self.historyDatas[indexPath.row]
//        self.populateMenu(result: item.text)
        self.navigateResultViewController(codeData: item)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(historyDatas.count)
        return self.historyDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyDataCell", for: indexPath) as! HistoryDataCell
        let item = historyDatas[indexPath.row]
        
        cell.avatarView.backgroundColor = UIColor(hexString: colorsArray[Int.random(in: 0 ... 3)])
        
        var codeText = item.text
        var hexcolor = "#FF9646"
        var avatarName = "ic_text"
        if item.type == "email" {
            hexcolor = "#FF9646"
            avatarName = "ic_email"
            let codeURL = URL(string: codeText)
            if codeURL?.scheme == "mailto" {
                let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                // email
                codeText =  components != nil ? components!.path : ""
            }
        }
        else if item.type == "doc" {
            hexcolor = "#9868FE"
            avatarName = "ic_doc"
        }
        else if item.type == "facebook" {
            hexcolor = "#4F89F7"
            avatarName = "ic_facebook"
        }
        else if item.type == "call" {
            hexcolor = "#6BD167"
            avatarName = "ic_call"
            let codeURL = URL(string: codeText)
            if codeURL?.scheme == "tel" {
                let components = URLComponents(url: codeURL!, resolvingAgainstBaseURL: false)
                // email
                codeText =  components != nil ? components!.path : ""
            }
        }
        else if item.type == "instagram" {
            hexcolor = "#F2586F"
            avatarName = "ic_instagram"
        }
        else {
            hexcolor = "#039FC3"
            avatarName = "ic_link_medium"
        }

        cell.avatar.image = UIImage(named: avatarName)
        cell.avatarView.backgroundColor = UIColor(hexString: hexcolor)
        cell.titleLabel.text = codeText
        
        let date = AppHelper.sharedInstance.get12HourTimeStringFromDate(time: item.created)
        cell.dateLabel.text = date
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let actionEdit = UIContextualAction(style: .normal, title: NSLocalizedString("Edit", comment: "")) {  action, sourceView, completionHandler in
            self.actionEdit(at: indexPath)
            completionHandler(false)
        }
        let actionDelete = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) {  action, sourceView, completionHandler in
            self.actionDelete(at: indexPath)
            completionHandler(false)
        }
        actionEdit.image = UIImage(named: "ic_edit")
        actionDelete.image = UIImage(named: "ic_trash")

        return UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
    }
    

    @IBAction func onAddQRCodePressed(_ sender: Any) {
        /*
        if(IAPHelper.getSharedInstance().purchased != 1){
            DispatchQueue.main.async{
                //self.navigateResultViewController(result: code)
                self.launchSubscribeController()
            }
            return
        }
 */
 
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "selectTypeViewController")        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func launchSubscribeController(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "subscribeNavigationViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

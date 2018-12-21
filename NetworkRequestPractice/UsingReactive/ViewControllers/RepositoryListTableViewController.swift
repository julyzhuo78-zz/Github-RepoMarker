//
//  RepositoryListTableViewController.swift
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-04.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SafariServices

class RepositoryListTableViewController: UITableViewController {
    
    
    var networkRequestManager:NetworkRequestManagerReactive
    var networkDataStore:NetworkDataStoreReactive
    
    required init?(coder aDecoder: NSCoder) {
        networkRequestManager = NetworkRequestManagerReactive(userDefault: UserDefaults.standard)
        networkDataStore = NetworkDataStoreReactive()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        networkDataStore.refreshRepositoryList()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkDataStore.arrayOfRepoNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reactive", for: indexPath)
        cell.textLabel?.text = networkDataStore.arrayOfRepoNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        self.networkDataStore.currentRepoName = selectedCell?.textLabel?.text
        fetchReadMeContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addURL" {
            let vc = segue.destination as? EnterURLViewController
            vc?.didFinishObservable.subscribe(onNext: { (urlString) in
                self.networkDataStore.addUrl(urlString: urlString)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    
    func fetchReadMeContent() {
        let readMeUrl = networkDataStore.getMeURL()
        if (readMeUrl != nil) {
            networkRequestManager.fetchReadMeContent(readMeURL: readMeUrl!).subscribe(onNext: { (readMeHTML) in
                if readMeHTML.isEmpty {
                    return
                }
                DispatchQueue.main.async {
                    let url = URL(string: readMeHTML)
                    let vc = SFSafariViewController(url: url!)
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }
    }
}

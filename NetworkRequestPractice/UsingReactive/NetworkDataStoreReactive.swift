//
//  NetworkDataStoreReactive.swift
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-04.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

import Foundation
import RxSwift

class NetworkDataStoreReactive: NSObject {
    let userDefaults:UserDefaults
    var arrayOfRepoNames:Array<String>
    var arrayOfURLs:Array<String>
    var currentRepoName:String?
    
    override init() {
        userDefaults = UserDefaults.standard
        arrayOfRepoNames = Array<String>()
        arrayOfURLs = Array<String>()
        currentRepoName = nil
        super.init()
    }
    
    func refreshRepositoryList() {
        arrayOfRepoNames.removeAll()
        guard let arrayOfKeys = userDefaults.value(forKey: "arrayOfKeys") as? Array<String> else {
            return
        }
        arrayOfRepoNames = arrayOfKeys.compactMap { (key) -> String in
            let currentDict = userDefaults.value(forKey: key) as! Dictionary<String, Any>
            return currentDict["repositoryName"] as! String
        }
        
        arrayOfURLs = arrayOfKeys.compactMap { (key) -> String in
            let currentDict = userDefaults.value(forKey: key) as! Dictionary<String, Any>
            return currentDict["urlString"] as? String ?? ""
        }
    }
    
    func addUrl(urlString:String) {
        arrayOfURLs.append(urlString)
        guard let dict = userDefaults.value(forKey: urlString) as? Dictionary<String, Any> else {
            return
        }
        arrayOfRepoNames.append(dict["repositoryName"] as! String)
    }
    
    func getMeURL() -> String? {
        if currentRepoName != nil {
            let pos = arrayOfRepoNames.firstIndex(of: currentRepoName!)
            return arrayOfURLs[pos!]
        }
        return nil
    }
}

//
//  NetworkRequestManagerReactive.swift
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-04.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

import Foundation
import RxSwift

class NetworkRequestManagerReactive: NSObject {
    let networkRequester = NetworkRequesterReactive()
    let userDefaults: UserDefaults
    
    init(userDefault:UserDefaults) {
        self.userDefaults = userDefault
        super.init()
    }
    
    
    func fetchAndSaveRepoNameAndReadMeURL(urlString:String) -> Observable<Bool> {
        guard let url = URL(string: urlString) else { return Observable.just(false) }
        return networkRequester.makeNetworkRequest(url: url)
            // 1st task -> process the raw data to ensure the existence of useful information
            .map({ (array) -> Dictionary<String, String> in
                var userInfo = Dictionary<String, String>()
                guard let resultDict = array as? Dictionary<String, Any>,
                      let repoName = resultDict["full_name"] as? String,
                      let urlString = resultDict["url"] as? String
                else { return userInfo }
                
                userInfo.updateValue(repoName, forKey: "repositoryName")
                userInfo.updateValue(urlString, forKey: "urlString")
                return userInfo
            })
            
            // 2nd task -> save useful data into userDefaults
            .map({ (userInfo) -> Bool in
                if userInfo.isEmpty {
                    return false
                }
                let urlString = userInfo["urlString"]!
                let keys = self.userDefaults.value(forKey: "arrayOfKeys") as? Array<String>
                if  var keyArr = keys  {
                    if keyArr.contains(urlString) {
                        return false
                    }
                    keyArr.append(urlString)
                    self.userDefaults.setValue(keyArr, forKey: "arrayOfKeys")
                } else {
                    var firstKeyArr = Array<String>()
                    firstKeyArr.append(urlString)
                    self.userDefaults.setValue(firstKeyArr, forKey: "arrayOfKeys")
                }
                self.userDefaults.setValue(userInfo, forKey: urlString)
                return true
            })
    }
    
    
    func fetchReadMeContent(readMeURL:String) -> Observable<String> {
        let url = URL(string: readMeURL)
        return networkRequester.makeNetworkRequest(url: url)
            .map({ (array) -> String in
                guard let dict = array as? Dictionary<String, Any>,
                      let readMeHTML = dict["html_url"] as? String
                else {
                    return String()
                    
                }
                return readMeHTML
            })
    }
    
    
}

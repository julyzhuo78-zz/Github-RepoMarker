//
//  NetworkRequesterReactive.swift
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-04.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class NetworkRequesterReactive: NSObject {
    let authorizationToken = "token 765e30ead6006953d850250d0afc2a7ff8577704"

    func makeNetworkRequest(url:URL?) -> Observable<Any> {
        if url != nil {
            var request: URLRequest = URLRequest(url: url!);
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
            return URLSession.shared.rx.json(request: request)
        }
        
        return Observable.just("")
//        return Observable.empty()
    }
}

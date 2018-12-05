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
    let authorizationToken = "token aa3b2093a7186436663a661f507d49d7bb5d1812"

    func makeNetworkRequest(url:URL?) -> Observable<Any> {
        if url != nil {
            var request: URLRequest = URLRequest(url: url!);
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
            return URLSession.shared.rx.json(request: request)
        }
        return Observable.create({ (observer) -> Disposable in
            return Disposables.create()
        })
    }
}

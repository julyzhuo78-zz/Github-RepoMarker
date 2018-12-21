//
//  EnterURLViewController.swift
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-04.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EnterURLViewController: UIViewController {
    let networkRequestManager = NetworkRequestManagerReactive(userDefault: UserDefaults.standard)
    private let didFinishSubject = PublishSubject<String>()
    public var didFinishObservable:Observable<String> {
        get {
            return didFinishSubject.asObserver()
        }
    }
    
    @IBOutlet weak var invalidURLWarning: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        invalidURLWarning.isHidden = true
        
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        var urlEntered = urlTextField.text
        urlEntered = URLConverter().convert(toGitHubApiUrl: urlEntered!)
        makeNetworkRequest(urlString: urlEntered!)
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        invalidURLWarning.isHidden = true
    }
    
    func configureTextField() {
        urlTextField.placeholder = "Sample: https://github.com/user-name/repo-name"
    }
    
    func makeNetworkRequest(urlString:String) {
        networkRequestManager.fetchAndSaveRepoNameAndReadMeURL(urlString: urlString).subscribe(onNext: { (isValid) in
            if isValid == false {
                DispatchQueue.main.async { [weak self] in
                    self?.invalidURLWarning.isHidden = false
                }
                return
            }
            self.didFinishSubject.onNext(urlString)
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}

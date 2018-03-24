//
//  ViewController.swift
//  vkPhoto
//
//  Created by Semyon on 22.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    let requestSender = RequestSender()
    
    //MARK: - IBOutlets
    @IBOutlet weak var sendRequestButton: UIButton!
   
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func sendRequestAction(_ sender: Any) {
        if let viewController = UIStoryboard(name: "AuthVK", bundle: nil).instantiateViewController(withIdentifier: "AuthVKControllerID") as? AuthVKController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

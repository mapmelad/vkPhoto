//
//  ViewController.swift
//  vkPhoto
//
//  Created by Semyon on 22.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sendRequestButton: UIButton!
    
    let requestSender = RequestSender()
   // let authString = "https://oauth.vk.com/authorize?client_id=6343431&scope=messages,pages,audio,video,friends,status,offline,wall,groups,photos,questions,offers&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token"
    let fr = "https://api.vk.com/method/friends.get?fields=city,photo_50,photo_200&access_token=8cbe5208bbdbee0cb8e1cb5280d1bfe3cb4ed36e4b00c531ed6e9a729f0524497a71b028cdb04801b12cc&v=3.8"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.webView.loadRequest(URLRequest(url: URL(string: "https://oauth.vk.com/authorize?client_id=6343431&scope=messages,pages,audio,video,friends,status,offline,wall,groups,photos,questions,offers&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token")!))
        
        //        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        //
        //            if let data = data {
        //                do {
        //                    // Convert the data to JSON
        //                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        //
        //                    if let json = jsonSerialized {
        //                        let redirect_uri = json["redirect_uri"]
        //                        let error = json["error"]
        //                        let token = json["access_token"]
        //
        //                        if let t = token {
        //                            VkAPI.shared.token = token as! String
        //                        } else {
        //                            if error as! String == "need_validation" {
        //
        //                                self.webView.loadRequest(URLRequest(url: URL(string: "https://oauth.vk.com/authorize?client_id=3087106&scope=messages,pages,audio,video,friends,status,offline,wall,groups,photos,questions,offers&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token")!))
        //                            }
        //                        }
        //                    }
        //
        //                }  catch let error as NSError {
        //                    print(error.localizedDescription)
        //                }
        //            } else if let error = error {
        //                print(error.localizedDescription)
        //            }
        //        }
        //
        //        task.resume()
    }
    
    func getFriends() {
        
        requestSender.send(config: fr){ (result: Result<Data>) in
            print("💃\(result)")
            switch result {
            case .Success(let pictures):
                do {
                let jsonSerialized = try JSONSerialization.jsonObject(with: pictures, options: []) as? [String : Any]
                if let json = jsonSerialized {
                    let redirect_uri = json["response"]
                    print(redirect_uri)
                }
                } catch {
                    print(error.localizedDescription)
                }
            case .Fail(let error):
                print(error as String)
            }
        }
        
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        if let viewController = UIStoryboard(name: "AuthVK", bundle: nil).instantiateViewController(withIdentifier: "AuthVKControllerID") as? AuthVKController {
           // viewController.newsObj = newsObj
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
        
//        if let vc = UIStoryboard(name: "AuthVK", bundle: nil).instantiateViewController(withIdentifier: "AuthVKControllerID") as? AuthVKController
//        {
//
//           // vc.newsObj = newsObj
//            present(vc, animated: true, completion: nil)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

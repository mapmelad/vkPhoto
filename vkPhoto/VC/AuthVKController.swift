//
//  AuthVKController.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class AuthVKController: UIViewController, UIWebViewDelegate {
    
    let requestSender = RequestSender()
    let authString = "https://oauth.vk.com/authorize?client_id=2949451&scope=pages,audio,video,friends,status,offline,wall,groups,photos,questions,offers&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token"
    
    //MARK: - IBOutlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Авторизация"
        bindToWebView()
        rightBarButton()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let urlString = webView.request!.url!.absoluteString
        findTokenInUrl(urlString: urlString)
    }
}

//MARK: - Bindings
extension AuthVKController {
    
    @objc private func bindToWebView(){
        self.webView.loadRequest(URLRequest(url: URL(string: authString)!))
    }
    
    private func rightBarButton(){
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action:  #selector(self.bindToWebView))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func findTokenInUrl(urlString: String){
        if let t = urlString.slice(from: "access_token=", to: "&") {
            VkAPI.shared.token = t
            infoLabel.text = "Успешно!"
            if let vc = UIStoryboard(name: "FriendsList", bundle: nil).instantiateViewController(withIdentifier: "FriendsListNavCID") as? FriendsListNavigationController {
                present(vc, animated: true, completion: nil)
            }
        }
    }
}

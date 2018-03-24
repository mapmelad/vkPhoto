//
//  AuthVKController.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class AuthVKController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var infoLabel: UILabel!
    
    let requestSender = RequestSender()
    let authString = "https://oauth.vk.com/authorize?client_id=2949451&scope=pages,audio,video,friends,status,offline,wall,groups,photos,questions,offers&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token"
    
    let logoutString = "https://oauth.vk.com/logout?client_id=2949451"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Авторизация"
        webView.delegate = self
        bindToWebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let urlString = webView.request!.url!.absoluteString
        if let t = urlString.slice(from: "access_token=", to: "&") {
            VkAPI.shared.token = t
            infoLabel.text = "Успешно!"
            if let vc = UIStoryboard(name: "FriendsList", bundle: nil).instantiateViewController(withIdentifier: "FriendsListNavCID") as? FriendsListNavigationController {
                present(vc, animated: true, completion: nil)
            }
        } else if urlString.range(of:"error") != nil {
            removeCookies()
            self.webView.loadRequest(URLRequest(url: URL(string: logoutString)!))
            infoLabel.text = "Пожалуйста, перелогиньтесь!!"
        }
    }
    
    private func bindToWebView(){
        self.webView.loadRequest(URLRequest(url: URL(string: authString)!))
    }
    
    func removeCookies(){
        let cookie = HTTPCookie.self
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}

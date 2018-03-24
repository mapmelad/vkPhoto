//
//  FriendsListController.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController {
    
    let textCellIdentifier = "FriendsTableViewCell"
    let requestSender = RequestSender()
    let vkParse = VkParser()
    let indicator = CustomActivityIndicator()
    var arrayFriends = [Profile?]()
    var getFriendsUrl = ""
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Друзья"
        indicator.customActivityIndicatory(self.view, startAnimate: true)
        getFriends()
    }
    
    //MARK: - IBActions
    @IBAction func exitButtonAction(_ sender: Any) {
        bindExit()
    }
}


//MARK: - Bindings
extension FriendsListController {
    
    private func getFriends(){
        
        if let t = VkAPI.shared.token {
            getFriendsUrl = "https://api.vk.com/method/friends.get?fields=city,photo_50,photo_200_orig&access_token=\(t)&v=5.7"
        }
        
        requestSender.send(config: getFriendsUrl){ (result: Result<Data>) in
            switch result {
            case .Success(let profiles):
                if let t = self.vkParse.parse(data: profiles) {
                    self.arrayFriends = t
                    DispatchQueue.main.async {
                        self.indicator.customActivityIndicatory(self.view, startAnimate: false)
                        self.tableView.reloadData()
                    }
                }
            case .Fail(let error):
                print(error as String)
            }
        }
    }
    
    private func bindExit(){
        
        let logoutString = "https://oauth.vk.com/logout?client_id=2949451"
        
        let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите выйти?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { action in
            self.requestSender.removeCookies()
            self.requestSender.send(config: logoutString){ (result: Result<Data>) in
                switch result {
                case .Success(_):
                    VkAPI.shared.token = nil
                    if let vc = UIStoryboard(name: "Start", bundle: nil).instantiateViewController(withIdentifier: "StartNavigationControllerID") as? StartNavigationController {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .Fail(let error):
                    print(error as String)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate
extension FriendsListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: - UITableViewDataSource
extension FriendsListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsTableViewCell
        cell.nameLabel.text = "\(arrayFriends[indexPath.row]?.last_name ?? "") \(arrayFriends[indexPath.row]?.first_name ?? "")"
        
        if let imageProfile50 = self.arrayFriends[indexPath.row]?.image50 {
            cell.profileImage.image = UIImage(data: imageProfile50)!
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: URL(string: (self.arrayFriends[indexPath.row]?.photo_50)!)!) {
                    self.arrayFriends[indexPath.row]?.image50 = data
                    DispatchQueue.main.async {
                        cell.profileImage.image = UIImage(data: data)!
                    }
                } else {
                    print("Проверьте подключение к интернету")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewControllerID") as? ProfileViewController {
            profileVC.profile = self.arrayFriends[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(profileVC, animated: true)
            }
        }
    }
    
}

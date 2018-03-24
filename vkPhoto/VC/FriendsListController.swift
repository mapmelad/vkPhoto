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
    
    //MARK: - IBActions
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Друзья"
        
        if let t = VkAPI.shared.token {
            getFriendsUrl = "https://api.vk.com/method/friends.get?fields=city,photo_50,photo_200_orig&access_token=\(t)&v=5.7"
        }
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        indicator.customActivityIndicatory(self.view, startAnimate: true)
        
        requestSender.send(config: getFriendsUrl){ (result: Result<Data>) in
            switch result {
            case .Success(let profiles):
                if let t = self.vkParse.parse(data: profiles) {
                    self.arrayFriends = t
                    //self.downloadImage()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Bindings
extension FriendsListController{
    
    func downloadImage() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            for (index, element) in self.arrayFriends.enumerated() {
                let data = try? Data(contentsOf: URL(string: (element?.photo_50)!)!)
                self.arrayFriends[index]?.image50 = data
            }
            DispatchQueue.main.async {
                self.indicator.customActivityIndicatory(self.view, startAnimate: false)
                self.tableView.reloadData()
            }
        }
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
        
        if let imageProgile50 = self.arrayFriends[indexPath.row]?.image50 {
            cell.profileImage.image = UIImage(data: imageProgile50)!
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: URL(string: (self.arrayFriends[indexPath.row]?.photo_50)!)!)
                self.arrayFriends[indexPath.row]?.image50 = data
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data!)!
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

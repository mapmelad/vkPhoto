//
//  FriendsListController.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "FriendsTableViewCell"
    let requestSender = RequestSender()
    let vkParse = VkParser()
    var arrayFriends = [Profile?]()
    var getFriendsUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let t = VkAPI.shared.token {
            getFriendsUrl = "https://api.vk.com/method/friends.get?fields=city,photo_50,photo_200&access_token=\(t)&v=5.7"
        }
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        requestSender.send(config: getFriendsUrl){ (result: Result<Data>) in
            switch result {
            case .Success(let profiles):
                if let t = self.vkParse.parse(data: profiles) as! [Profile]? {
                    self.arrayFriends = t
                    self.tableView.reloadData()
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

extension FriendsListController: UITableViewDelegate {
    
}

extension FriendsListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFriends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsTableViewCell
        cell.nameLabel.text = "\(arrayFriends[indexPath.row]?.last_name ?? "") \(arrayFriends[indexPath.row]?.first_name ?? "")"
        //cell.imageLabel.image = UIImage(data: (self.arrayFriends[indexPath.row]?.image_50)!)!
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: URL(string: (self.arrayFriends[indexPath.row]?.photo_50)!)!)
            DispatchQueue.main.async {
                cell.imageLabel.image = UIImage(data: data!)!
            }
        }
        
        return cell
    }
}

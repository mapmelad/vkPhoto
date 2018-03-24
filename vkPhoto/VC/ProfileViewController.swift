//
//  ProfileController.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile:Profile!
    let indicator = CustomActivityIndicator()
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var linkToProfileLabel: UILabel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Профайл"
        indicator.customActivityIndicatory(self.view, startAnimate: true)
        
        bindLinkToProfileGesture()
        bindUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        UIApplication.shared.open(URL(string : "https://www.vk.com/id\(profile.id)")!, options: [:], completionHandler: { (status) in })
    }
}

//MARK: - Bindings
extension ProfileViewController {
    
    func bindLinkToProfileGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapFunction))
        linkToProfileLabel.addGestureRecognizer(tap)
    }
    
    func bindUI(){
        firstNameLabel.text = profile.first_name
        lastNameLabel.text = profile.last_name
        linkToProfileLabel.attributedText = NSAttributedString(string: "vk.com/id\(profile.id)", attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: URL(string: self.profile.photo_200)!)
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)!
                self.indicator.customActivityIndicatory(self.view, startAnimate: false)
            }
        }
    }
}

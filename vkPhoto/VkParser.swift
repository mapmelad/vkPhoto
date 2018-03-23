//
//  Parser.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class Parser<T> {
    func parse(data: Data) -> T? { return nil }
}

class VkParser: Parser<[Profile]> {
    
    override func parse(data: Data) -> [Profile]? {
        
        var pictureModelds: [Profile] = []
        do {
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let json = jsonSerialized {
                let response = json["response"] as? [String: Any]
                if let items = response!["items"] as? [[String: Any]] {
                    for i in items {
                    if let n = i["first_name"], let ln = i["last_name"], let p50 = i["photo_50"] {
                        var p200 = ""
                        
                        let image50 = try? Data(contentsOf: URL(string: (p50 as! String))!)
                        
                        if let linkToPhoto = i["photo_200"] {
                            p200 = linkToPhoto as! String
                        }
                        pictureModelds.append(Profile(first_name: n as! String, last_name: ln as! String, photo_50: p50 as! String, photo_200: p200, image_50: image50!))
                    }
                }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return pictureModelds
    }
}

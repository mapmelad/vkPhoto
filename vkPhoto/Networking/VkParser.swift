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
                        if let id = i["id"],
                            let fn = i["first_name"],
                            let ln = i["last_name"],
                            let p50 = i["photo_50"],
                            let p200 = i["photo_200_orig"] {
                            // let image50 = try? Data(contentsOf: URL(string: (p50 as! String))!)
                            pictureModelds.append(Profile(
                                id: id as! Int,
                                first_name: fn as! String,
                                last_name: ln as! String,
                                photo_50: p50 as! String,
                                photo_200: p200 as! String,
                                image50: nil)
                            )
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

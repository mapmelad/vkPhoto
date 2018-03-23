//
//  LoginErrorParser.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

class LoginErrorParser: Parser<String> {

    override func parse(data: Data) -> String? {
        
        var response: String? = nil
        
        do {
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let json = jsonSerialized {
                response = json["error"] as? String
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return response
    }
    
}

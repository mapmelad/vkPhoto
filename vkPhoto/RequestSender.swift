//
//  RequestSender.swift
//  vkPhoto
//
//  Created by Semyon on 22.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Fail(String)
}

protocol IRequest {
    var urlRequest: URLRequest? { get }
}


protocol IRequestSender {
    func send<T>(config: String, completionHandler: @escaping (Result<T>) -> Void)
}


class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<T>(config: String, completionHandler: @escaping (Result<T>) -> Void) {
        
        guard let urlRequest = URL(string: config) else {
            completionHandler(Result.Fail("url string can't be parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
    
            if let data = data {
                do {
                    //let jsonSerialized: T = try JSONSerialization.jsonObject(with: data, options: [])  as! T
                    completionHandler(Result.Success(data as! T))
                    return
                    
                } catch let error as NSError {
                    completionHandler(Result.Fail("\(error)"))
                    return
                }
            }
        }
        
        task.resume()
    }
}

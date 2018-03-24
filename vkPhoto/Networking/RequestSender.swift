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

protocol IRequestSender {
    func send<T>(config: String, completionHandler: @escaping (Result<T>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<T>(config: String, completionHandler: @escaping (Result<T>) -> Void) {
        
        guard let urlRequest = URL(string: config) else {
            completionHandler(Result.Fail("Строка не может быть преобразована в URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            
            if let data = data {
                completionHandler(Result.Success(data as! T))
                return
            }
        }
        task.resume()
    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}

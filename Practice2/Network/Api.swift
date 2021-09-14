//
//  Api.swift
//  Practice2
//
//  Created by Batuhan BARAN on 14.09.2021.
//

import Foundation
import Alamofire
import JWTDecode

class Api {
    
    static let shared = Api()
    
    func register(parameters: [String:Any], completion: @escaping (Bool) ->()) {
        guard let url = URL(string: ApiPaths.baseUrl.rawValue + ApiPaths.registerEP.rawValue) else {
            return
        }
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json"])
            .responseJSON { response in
                if response.response?.statusCode == 201 {
                    switch response.result {
                    case .success(_):
                        completion(true)
                    case .failure(_):
                        completion(false)
                    }
                }else {
                    completion(false)
                }
            }
    }
    
    func login(parameters: [String:Any], completion: @escaping (Bool) ->()) {
        guard let url = URL(string: ApiPaths.baseUrl.rawValue + ApiPaths.loginEP.rawValue) else {
            return
        }
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json"])
            .responseData { response in
                if response.response?.statusCode == 200 {
                    switch response.result {
                    case .success(_):
                        do {
                            guard let data = response.data else { return }
                            guard let token = String(data: data, encoding: .utf8) else { return }
                            let jwt = try decode(jwt: token)
                            
                            let emailClaim = jwt.claim(name: "email")
                            
                            if let email = emailClaim.string {
                                UserDefaults.standard.setValue(email, forKey: "currentUserEmail")
                            }
                            
                            let idClaim = jwt.claim(name: "_id")
                            
                            if let email = idClaim.string {
                                UserDefaults.standard.setValue(email, forKey: "currentUserId")
                            }
                            
                            completion(true)
                        }catch {
                            completion(false)
                        }
                    case .failure(_):
                        completion(false)
                    }
                }else {
                    completion(false)
                }
            }
    }
}

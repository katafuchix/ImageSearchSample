//
//  HttpClient.swift
//  ImageSearchSample
//
//  Created by cano on 2018/03/17.
//  Copyright © 2018年 cano. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol HttpClient {
    
    static func get(url: URL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(String)>
    
}

class ImageSearchHttpClient: HttpClient {

    static let manager = Alamofire.SessionManager.default
    
    public static func get(url: URL, parameters: [String : String]?, headers: [String : String]?) -> Observable<(String)> {
        return dataRequest(method:.get, url: url, parameters:parameters,  headers:headers)
    }
    
    static func dataRequest(method: HTTPMethod = .get, url: URL, parameters: [String : String]?, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            let request = Alamofire.request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers).responseString { response in
                observer.onNext(response.result.value!)
                observer.onCompleted()
            }
            return Disposables.create { request.cancel() }
        }
    }
}

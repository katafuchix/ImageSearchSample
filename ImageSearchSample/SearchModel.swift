//
//  SearchModel.swift
//  ImageSearchSample
//
//  Created by cano on 2018/03/17.
//  Copyright © 2018年 cano. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct SearchModel {

    // MARK: - rx
    var searchWord = Variable<String?>("")
    
    func getRequest(_ parameters: [String : String])->DataRequest
    {
        return Alamofire.request(URL(string:"https://search.yahoo.co.jp/image/search")!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
}

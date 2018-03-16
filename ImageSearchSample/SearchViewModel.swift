//
//  SearchViewModel.swift
//  ImageSearchSample
//
//  Created by cano on 2018/03/17.
//  Copyright © 2018年 cano. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HTMLReader

struct SearchViewModel {

    // MARK: - Model
    
    private var model = SearchModel()
    
    // MARK: - rx
    
    var searchWord = Variable<String>("")
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - init
    
    init(){
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        searchWord.asObservable().bind(to: model.searchWord).disposed(by: disposeBag)
    }
    
    func getImageUrls(_ parameters:[String:String]) -> Observable<[String]>
    {
        return Observable<[String]>.create { (observer) -> Disposable in
            let request = self.model.getRequest(parameters).responseString{ response in
                guard let html = response.result.value else{ return }
                guard let data = html.data(using: .utf8) else { return }
                let home = HTMLDocument(data: data, contentTypeHeader:"text/html")
                guard let div = home.firstNode(matchingSelector: "#gridlist") else {
                    print("Failed to match .repository-meta-content, maybe the HTML changed?")
                    return
                }
                var ret = [String]()
                let columns = div.nodes(matchingSelector: "div")
                for column in columns {
                    let ass = column.nodes(matchingSelector: "a").map({ $0.attributes["href"]})
                    if ass.count == 0 { continue }
                    
                    let ims = column.nodes(matchingSelector: "img").map({ $0.attributes["src"]})
                    if ims.count == 0 { continue }
                    
                    let link = ims[0]
                    if let imageLink = link {
                        if ret.contains(imageLink){ continue }
                        ret.append(imageLink)
                    }
                }
                observer.onNext(ret)
                //observer.onError(response.error!)
                observer.onCompleted()
            }
            return Disposables.create { request.cancel() }
        }
    }
}

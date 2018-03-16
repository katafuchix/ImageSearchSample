//
//  ViewController.swift
//  ImageSearchSample
//
//  Created by cano on 2018/03/17.
//  Copyright © 2018年 cano. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let searchWord = self?.textField.text else { return }
            
            print(searchWord)
            self?.viewModel.getImageUrls(["p":searchWord])
                .asObservable()
                .subscribe(
                    onNext:{ urls in
                                for url in urls {
                                    print(url)
                                    print("\n")
                                }
                    }
                )
                .disposed(by: (self?.rx.disposeBag)!)
            
        })
            .disposed(by: self.rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


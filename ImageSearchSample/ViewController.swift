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
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        }
    }
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let searchWord = self?.textField.text else { return }
            self?.viewModel.imageUrls.value = []
            self?.viewModel.getImageUrls(["p":searchWord])
                .asObservable()
                .subscribe(
                    onNext:{ [weak self] urls in
                                for url in urls {
                                    print(url)
                                    print("\n")
                                }
                        self?.viewModel.imageUrls.value = urls
                    }
                )
                .disposed(by: (self?.rx.disposeBag)!)
        })
        .disposed(by: self.rx.disposeBag)

        self.viewModel.imageUrls.asObservable().bind(to:self.collectionView.rx.items(cellIdentifier: "ImageCollectionViewCell", cellType: ImageCollectionViewCell.self))
        { (index, element, cell) in
            cell.configure(element)
            }.disposed(by: self.rx.disposeBag)

        self.collectionView.rx.setDelegate(self).disposed(by: self.rx.disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    //セルの間の余白設定
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    //セルのサイズを指定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.collectionView.frame.width-24*3)/3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}



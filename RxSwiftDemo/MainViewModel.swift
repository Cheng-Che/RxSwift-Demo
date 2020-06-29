//
//  MainViewModel.swift
//  RxSwiftDemo
//
//  Created by Steven Hsieh on 2020/6/18.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    var model: BehaviorRelay<[PhotoModel]> = BehaviorRelay<[PhotoModel]>(value: [])
    var isloading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    
    init() {
        loadData(albums: 1)
    }
    
    func loadData(albums: Int) {
        
        isloading.accept(true)
        do {
            try APIService.shared.getPhoto(albums: albums)?.subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.model.accept(self.model.value + result)
                }, onCompleted: {
                    self.isloading.accept(false)
            }).disposed(by: disposeBag)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
//    func getData() -> [PhotoModel]{
//        return model
//    }
    
    
    
    
}

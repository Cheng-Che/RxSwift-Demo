//
//  APIService.swift
//  MVVMDemo
//
//  Created by Steven Hsieh on 2020/6/5.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class APIService{
    
    static let shared = APIService()
    lazy var requestObservable = RequestObservable()
    var urlSetting = "" {
        didSet{
            urlSetting = "https://jsonplaceholder.typicode.com/albums/\(urlSetting)/photos"
        }
    }
    
    private init(){
    }
    
    func getPhoto(albums: Int) throws -> Observable<[PhotoModel]>?{
        urlSetting = "\(albums)"
        guard let url = URL(string: urlSetting) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return requestObservable.callAPI(request: request)
    }
    
    
}

class RequestObservable {
        
    func callAPI<ItemModel: Decodable>(request: URLRequest) -> Observable<ItemModel> {
        return Observable.create { observer in
                
            let task = URLSession.shared.dataTask(with: request) { (data, resopnse, error) in
                do{
                    let model = try JSONDecoder().decode(ItemModel.self, from: data ?? Data())
                    observer.onNext(model)
                }catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
                
            }
            task.resume()
            
            return Disposables.create{
                task.cancel()
            }
        }
        
    }
    
}

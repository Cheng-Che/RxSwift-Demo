//
//  DetailMainTableViewController.swift
//  RxSwiftDemo
//
//  Created by Steven Hsieh on 2020/6/29.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class DetailMainTableViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var model: PhotoModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = self.model else {
            createEmptyVeiw()
            return
        }
        
        var text = "id: \(model.id) (Album id: \(model.albumId))"
        for _ in 0..<6 {
           text += ("\n" + "IF THERE ARE LOTS OF CONTENT IN THIS LABEL \n" + text)
        }
        
        imageView.sd_setImage(with: URL(string: model.url), completed: nil)
        imageView.autoresizingMask = .flexibleHeight
        imageView.clipsToBounds = true
        titleLabel.text = model.title
        idLabel.text = text
        
        setScrollView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: 0, height: idLabel.frame.maxY)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Detail View"
    }
    
    func createEmptyVeiw() {
        let emptyVeiw = UILabel(frame: view.frame)
        emptyVeiw.text = "Nothing here"
        emptyVeiw.textColor = .black
        emptyVeiw.textAlignment = .center
        view.addSubview(emptyVeiw)
    }
    
    func passViewModel(model: PhotoModel) {
        self.model = model
    }
    
    func setScrollView() {
        
        scrollView.rx.didScroll.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let offset = self.scrollView.contentOffset
            if offset.y < 0.0 {
                var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0)
                let scale = 1.0 + abs(self.scrollView.contentOffset.y) / self.scrollView.frame.size.height
                transform = CATransform3DScale(transform, scale, scale, 1)
                self.imageView.layer.transform = transform
            } else {
                self.imageView.layer.transform = CATransform3DIdentity
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    
}

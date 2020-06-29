//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Steven Hsieh on 2020/6/18.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.backgroundColor = UIColor(red: 206/255, green: 45/255, blue: 82/255, alpha: 1)
        button.setTitle("進入圖庫", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(butonClicked), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints({
            $0.center.equalTo(view.center)
            $0.width.equalTo(view.frame.width * 0.8)
            $0.height.equalTo(60)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Enter View"
    }
    
    @objc func butonClicked() {
        
        let vc = MainViewController(nibName: "MainViewController", bundle: Bundle.main)
        navigationController?.pushViewController(vc, animated: true)
        
    }


}


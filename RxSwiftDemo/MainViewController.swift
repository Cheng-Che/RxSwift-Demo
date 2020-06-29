//
//  MainViewController.swift
//  RxSwiftDemo
//
//  Created by Steven Hsieh on 2020/6/18.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

enum PageStatus {
    case goLoading
    case notLoading
    case firstLoading
}


class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var indicatorView: UIActivityIndicatorView!
    private var model = BehaviorRelay<[PhotoModel]>(value: [])
    private var viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private var status: PageStatus = .firstLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        indicatorView.style = UIActivityIndicatorView.Style.medium
        tableView.tableFooterView = self.indicatorView

        getTableViewData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Main View"
    }
    

    private func getTableViewData() {
        viewModel.isloading.asObservable().subscribe(onNext: { [weak self] (value) in
            guard let self = self else { return }
            
            self.loadingIndicator(isFirstLoading: self.status == .firstLoading ? true : false, isLoading: value)
        }).disposed(by: disposeBag)
    }
    
    private func loadingIndicator(isFirstLoading: Bool, isLoading: Bool) {
        switch (isFirstLoading, isLoading) {
        case (true, true):
            SVProgressHUD.show()
        case (true, false):
            SVProgressHUD.dismiss()
            self.status = .notLoading
            DispatchQueue.main.async {
                self.setTableView()
            }
        case (false, true):
            indicatorView.startAnimating()
        default:
            self.status = .notLoading
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
            }
        }
    }

    private func setTableView() {

        var getAlbumNum = 2
        viewModel.model.bind(to: tableView.rx.items) { (tableView, row, model) -> MainTableViewCell in
            let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as! MainTableViewCell
            cell.setUp(model: model)
            
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            let vc = DetailMainTableViewController(nibName: "DetailMainTableViewController", bundle: .main)
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.subscribe(onNext: { [weak self] cell, indexPath in
            guard let self = self else { return }
            
            let reloadIndex = self.tableView.numberOfRows(inSection: 0) - 2
            if indexPath.row == reloadIndex && self.status == .notLoading {
                self.status = .goLoading
                self.viewModel.loadData(albums: getAlbumNum)
                getAlbumNum += 1
            }
        }).disposed(by: disposeBag)
    }
    

}



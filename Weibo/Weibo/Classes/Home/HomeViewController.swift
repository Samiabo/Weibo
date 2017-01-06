//
//  HomeViewController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/27.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {

    // MARK: - lazy load
    lazy var titleBtn: TitleButton = TitleButton()
    lazy var popOverAnimation: PopOverAnimation = PopOverAnimation {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    
    // MARK: - system call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.addRotateAnimation()
        if !isLogin {
            return
        }
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "StatusViewCell", bundle: nil), forCellReuseIdentifier: "homecellid")
        setupNavigationBar()
        loadStatuses(isNew: false)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        setupHeader()
        setupFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}


// MARK: - 设置UI界面
extension HomeViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        titleBtn.setTitle("hahahah", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func setupHeader() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatus))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
    func setupFooter() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatus))
    }
}

// MARK: - 事件监听函数
extension HomeViewController {
    func titleBtnClick(titleBtn: TitleButton) {
        titleBtn.isSelected = !titleBtn.isSelected
        let vc = PopViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = popOverAnimation
        popOverAnimation.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    
    func loadStatuses(isNew: Bool) {
        var since_id = 0
        var max_id = 0
        
        if isNew {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatus(since_id: since_id, max_id: max_id) {(result, error) -> () in
            if error != nil {
                print(error!)
                return
            }
            guard let statusArr = result else {
                return
            }
            var tempViewModels = [StatusViewModel]()
            
            for statusDict in statusArr {
                let status = StatusModel(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModels.append(viewModel)
            }
            
            if isNew {
                self.viewModels = tempViewModels + self.viewModels
            } else {
                self.viewModels += tempViewModels
            }
            
            self.cacheImages(viewModels: tempViewModels)
        }
    }
    
    func cacheImages(viewModels: [StatusViewModel]) {
        let group = DispatchGroup()
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }))
    }
    
    func loadNewStatus() {
        loadStatuses(isNew: true)
    }
    
    func loadMoreStatus() {
        loadStatuses(isNew: false)
    }
}


// MARK: - Table view data source
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homecellid") as? StatusViewCell
        let viewModel = viewModels[indexPath.row]        
        cell?.viewModel = viewModel
        return cell!
    }
    
}














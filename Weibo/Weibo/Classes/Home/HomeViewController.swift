//
//  HomeViewController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/27.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit
import SDWebImage

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
        loadStatuses()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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
    func loadStatuses() {
        NetworkTools.shareInstance.loadStatus { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let statusArr = result else {
                return
            }
            for statusDict in statusArr {
                let status = StatusModel(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            self.cacheImages(viewModels: self.viewModels)
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
        }))
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














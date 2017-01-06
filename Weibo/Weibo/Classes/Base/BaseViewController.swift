//
//  BaseViewController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/29.
//  Copyright © 2016年 han xuelong. All rights reserved.
//App Key：3337750693  App Secret：e83536cda368fac6fba13053f262fc8b
//https://api.weibo.com/oauth2/authorize?client_id=3337750693&redirect_uri=http://www.baidu.com

import UIKit

class BaseViewController: UITableViewController {

    var isLogin: Bool = UserAccountTool.shareInstance.isLogin
    
    lazy var visitorView: VisitorView = VisitorView.visitorView()
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    private func setupVisitorView() {
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }

            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension BaseViewController {
    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}


extension BaseViewController {
    func registerBtnClick() {
        
    }
    func loginBtnClick() {
        let oauthVc = OAuthViewController()
        let oathNav = UINavigationController(rootViewController: oauthVc)
        present(oathNav, animated: true, completion: nil)
    }
}















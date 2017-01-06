//
//  OAuthViewController.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/3.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit
import SVProgressHUD


class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

// MARK: - UI
extension  OAuthViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        title = "登录页面"
    }
    func setupWebview() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        webView.loadRequest(URLRequest(url: url as URL))
    }
}



// MARK: - 事件监听
extension OAuthViewController {
    func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    func fillItemClick() {
        let jsCode = "document.getElementById('userId').value='lsnbls@126.com';document.getElementById('passwd').value='-yughjbn88-'"
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


// MARK: - webViewDelegate
extension OAuthViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else {
            return true
        }
        let urlString = url.absoluteString
        guard urlString.contains("code=") else {
            return true
        }
        let code = urlString.components(separatedBy: "=").last
        getAccessToken(code: code!)
        return false
    }
}

// MARK: - 请求数据
extension OAuthViewController {
    func getAccessToken(code: String) {
        NetworkTools.shareInstance.loadAccessToken(code: code) {(result, error) -> () in
            if error != nil {
                print(error!)
                return
            }
            guard let accountDict = result else {
                return
            }
            let account = UserAccount(dict: accountDict)
            
            print(account.description)
            self.loadUserInfo(account: account)
        }
    }
    
    func loadUserInfo(account: UserAccount) {
        guard let access_token = account.access_token else {
            return
        }
        guard let uid = account.uid else {
            return
        }
        NetworkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result, error) -> () in
            if error != nil {
                print(error!)
                return
            }
            
            guard let userInfoDict = result else {
                return
            }
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
                    
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountTool.shareInstance.accountPath)
            
            UserAccountTool.shareInstance.account = account
            
            self.dismiss(animated: false, completion: { () -> Void in
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}















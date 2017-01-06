//
//  NetworkTools.swift
//  AFNetwoking的封装
//
//  Created by han xuelong on 2017/1/3.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import AFNetworking

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

// MARK: - 封装请求方法
extension NetworkTools {
    func request(type: RequestType, urlString: String, params: [String : AnyObject], finished: @escaping (_ result: AnyObject?, _ error: Error?) -> ()) {
        
        
        //定义成功的回调
        let successCallBack = {(task: URLSessionDataTask, result: Any?) -> Void in
            finished(result as AnyObject?, nil)
        }
        
        let failureCallBack = {(task: URLSessionDataTask?, error: Error) -> Void in
            finished(nil, error)
        }
        
        if type == .GET {
            get(urlString, parameters: params, progress: nil, success: successCallBack, failure: failureCallBack)

        } else {
            post(urlString, parameters: params, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK: - 请求access token
extension NetworkTools {
    func loadAccessToken(code: String, finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": app_key, "client_secret": app_secret, "grant_type": "authorization_code", "code": code, "redirect_uri": redirect_uri]
        request(type: .POST, urlString: urlString, params: params as [String : AnyObject]) {(result, error: Error?) -> () in
            finished(result as! [String : AnyObject]?, error)
        }
    }
}

// MARK: - 请求用户信息
extension NetworkTools {
    func loadUserInfo(access_token: String, uid: String, finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token": access_token, "uid": uid]
        request(type: .GET, urlString: urlString, params: params as [String : AnyObject]) { (result, error) -> () in
            finished(result as! [String : AnyObject]?, error)
        }
    }
}

// MARK: - 请求微博
extension NetworkTools {
    func loadStatus(finished: @escaping (_ result: [[String: AnyObject]]?, _ error: Error?) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token": UserAccountTool.shareInstance.account?.access_token]
        request(type: .GET, urlString: urlString, params: params as [String : AnyObject]) {(result, error) -> () in
            guard let resultDict = result as? [String: AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}













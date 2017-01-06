//
//  LSPresentationController.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/31.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit

class LSPresentationController: UIPresentationController {

    lazy var coverView: UIView = UIView()
    var presentedFrame: CGRect = .zero
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = presentedFrame
        setupCoverView()
    }
}

// MARK: - UI
extension LSPresentationController {
    func setupCoverView() {
        containerView?.insertSubview(coverView, at: 0)
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        let tap = UITapGestureRecognizer(target: self, action:#selector(LSPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tap)
    }
}

// MARK: - 事件监听
extension LSPresentationController {
    func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

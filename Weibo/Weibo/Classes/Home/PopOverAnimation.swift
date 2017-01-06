//
//  PopOverAnimation.swift
//  Weibo
//
//  Created by han xuelong on 2016/12/31.
//  Copyright © 2016年 han xuelong. All rights reserved.
//

import UIKit

class PopOverAnimation: NSObject {

    var callBack: ((_ isPresented: Bool) -> ())?
    var presentedFrame: CGRect = .zero
    lazy var isPresented: Bool = false
    
    override init() {
        
    }
    
    init(callBack: @escaping (_ presented: Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK: -
extension PopOverAnimation: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            let presentation = LSPresentationController(presentedViewController: presented, presenting: presenting)
            presentation.presentedFrame = presentedFrame

        return presentation
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

// MARK: -
extension PopOverAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        transitionContext.containerView.addSubview(presentedView!)
        presentedView?.transform = CGAffineTransform(scaleX: 1.0,y: 0.0)
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: 0.5, animations: {() -> Void in presentedView?.transform = CGAffineTransform.identity}){(_) -> Void in transitionContext.completeTransition(true)}
    }
    func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)}){(_) -> Void in
                dismissView?.removeFromSuperview()
                transitionContext.completeTransition(true)}
    }
}

//
//  TransitionAnimator.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 24.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    var tabBarController: UITabBarController!
    let animationDuration: TimeInterval = 0.7
    var presenting: Bool = true
    var originFrame: CGRect = .zero
    let cornerRadius: CGFloat = 16.0
     var dismissComletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    
    
    
    
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: presenting ? .from : .to) else {return}
        guard let detailView = transitionContext.view(forKey: presenting ? .to : .from) else {return}
        guard let detailTodayController = transitionContext.viewController(forKey: presenting ? .to : .from) as? DetailTodayController else {return}
        
        
        let tabBarFrame = tabBarController.tabBar.frame
        let tabBarHeight = tabBarFrame.size.height
        let _ = (presenting ? tabBarHeight : -tabBarHeight)
        
        //FRAME
        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame
        
        let initialCornerRadius = presenting ? cornerRadius : 0
        let finalCornerRadius = presenting ? 0 : cornerRadius
        
        //INITIAL SETTINGS
        if presenting {
            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        if presenting {
            topConstraint = detailView.topAnchor.constraint(equalTo: fromView.topAnchor, constant: initialFrame.origin.y)
            leadingConstraint = detailView.leadingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: initialFrame.origin.x)
            widthConstraint = detailView.widthAnchor.constraint(equalToConstant: initialFrame.width)
            heightConstraint = detailView.heightAnchor.constraint(equalToConstant: initialFrame.height)
        } else {
            topConstraint?.constant = 0
            leadingConstraint?.constant = 0
            widthConstraint?.constant = detailView.frame.width
            heightConstraint?.constant = detailView.frame.height
        }
        
        
        detailView.layer.cornerRadius = initialCornerRadius
        
        //PRESENTING
        guard let toView = transitionContext.view(forKey: .to) else {return}
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)
        
        
            [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach{$0?.isActive = true}
            containerView.layoutIfNeeded()
            
        //ANIMATION
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            detailTodayController.tableView.contentOffset = .zero
            
            self.topConstraint?.constant = self.presenting ? 0 : self.originFrame.origin.y
            self.leadingConstraint?.constant = self.presenting ? 0 : self.originFrame.origin.x
            self.widthConstraint?.constant = self.presenting ? fromView.frame.width : self.originFrame.width
            self.heightConstraint?.constant = self.presenting ? fromView.frame.height : self.originFrame.height

            containerView.setNeedsLayout()
            containerView.layoutIfNeeded()
            
            detailView.layer.cornerRadius = finalCornerRadius
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
        
    }
    
    
}

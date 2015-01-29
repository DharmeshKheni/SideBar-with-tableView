//
//  SideBar.swift
//  SideBar
//
//  Created by Anil on 20/11/14.
//  Copyright (c) 2014 Dharmesh. All rights reserved.
//

import UIKit

@objc protocol sideBarDelegate{
    
    func sideBarDidSelectButtonAtIndex(index: Int)
    optional func slideBatWillClose()
    optional func slideBarWillOpen()
}

class SideBar: NSObject, SideBarTableViewControllerDelegate {
    
    let barWidth : CGFloat = 150.0
    let sideBarTableViewTopInset : CGFloat = 64.0
    let sideBarContainerView : UIView = UIView()
    let sideBarTableViewController : SideBarTableViewController = SideBarTableViewController()
    let originView : UIView!
    var animator : UIDynamicAnimator!
    var delegate : sideBarDelegate?
    var isSideBarOpen : Bool = false
    
    override init(){
        super.init()
    }
    
    init(sourceView : UIView, menuIteams : Array<String>) {
        super.init()
        originView  = sourceView
        sideBarTableViewController.tableData = menuIteams
        
        setUpSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
    
    }
    
    func setUpSideBar(){
        
        sideBarContainerView.frame = CGRectMake(-barWidth - 1, originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBarContainerView)
        
        let blurView : UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        sideBarTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }
   
    func handleSwipe(recognizer : UISwipeGestureRecognizer){
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left{
            
            showSideBar(false)
            delegate?.slideBatWillClose?()
            
        }else{
            
            showSideBar(true)
            delegate?.slideBarWillOpen?()
        }
    }
    
    func showSideBar(shouldOpen : Bool){
        
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX : CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude : CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX : CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehaviour : UIGravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehaviour.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour : UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehaviour.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehaviour)
        
        let pushBehaviour : UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = magnitude
        animator.addBehavior(pushBehaviour)
        
        let sideBarBehaviour : UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehaviour.elasticity = 0.3
        animator.addBehavior(sideBarBehaviour)
    }
    func SideBarControlDidSelectRow(indexPath: NSIndexPath) {
        
        delegate?.sideBarDidSelectButtonAtIndex(indexPath.row)
    }
}

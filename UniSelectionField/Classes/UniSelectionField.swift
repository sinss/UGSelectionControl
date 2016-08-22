//
//  UniSelectionField.swift
//  UniSelectionField
//
//  Created by Leo Chang on 8/19/16.
//  Copyright © 2016 Unigreen. All rights reserved.
//

import Foundation
import UIKit

let UniSelectionFieldDefaultHeight : CGFloat = 55

let UniSelectionFieldDidBeginSelectionName = "UniSelectionFieldDidBeginSelectionName"
let UniSelectionFieldDidEndSelectionName = "UniSelectionFieldDidEndSelectionName"

protocol UniSelectionFieldDelegate {
    func selectionField(selectionField : UniSelectionField, didSelect value : String)
    func selectionField(didCancelWithSelectionField : UniSelectionField)
}

class UniSelectionField : UIControl , UITableViewDelegate, UITableViewDataSource {
    
    var delegate : UniSelectionFieldDelegate?
    var editing : Bool = false
    
    private var indicatorLine : UIView?
    private var selectionTableView : UITableView?
    private var titleLabel : UILabel?
    private var valueLabel : UILabel?
    private var maskBg : UIView?
    
    private var downExpandView : UIView?
    private var upExpandView : UIView?
    
    private var tapGesture : UITapGestureRecognizer?
    private var maskTapGesture : UITapGestureRecognizer?
    
    private var title : String?
    private var defaultValue : String?
    private var items : [String]?
    
    private let cellIdentifier = "selectionCellIdentifier"
    private let duration : NSTimeInterval = 0.5
    private let maxItemCount : CGFloat = 5
    let selectionPanelWidth : CGFloat = 150
    
    convenience init(frame: CGRect, title : String, value : String, items : [String]? = nil) {
        self.init(frame: frame)
        self.title = title
        self.defaultValue = value
        self.items = items
        initializeUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = CGRectGetHeight(frame)
        let width = CGRectGetWidth(frame)
        titleLabel?.frame = CGRect(x: 10, y: 0, width: 120, height: height)
        valueLabel?.frame = CGRect(x: width - 220, y: 0, width: 205, height: height)
    }
    
    private func initializeUI() {
        backgroundColor = UIColor.clearColor()
        //Create title Label
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont.systemFontOfSize(16)
        titleLabel?.textAlignment = .Left
        titleLabel?.text = title
        addSubview(titleLabel!)
        //Create value Label
        valueLabel = UILabel(frame: CGRect.zero)
        valueLabel?.textColor = UIColor.whiteColor()
        valueLabel?.font = UIFont.systemFontOfSize(16)
        valueLabel?.textAlignment = .Right
        valueLabel?.text = String(defaultValue ?? "34")
        addSubview(valueLabel!)
        
        indicatorLine = UIView(frame: CGRect(x: 10, y: CGRectGetHeight(frame) - 2, width: 1, height: 1))
        indicatorLine?.backgroundColor = UIColor.whiteColor()
        
        downExpandView = UIView(frame: CGRect.zero)
        downExpandView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        upExpandView = UIView(frame: CGRect.zero)
        upExpandView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        selectionTableView = UITableView(frame: CGRect.zero)
        selectionTableView?.contentInset = UIEdgeInsets(top: CGRectGetHeight(frame)*2, left: 0, bottom: CGRectGetHeight(frame)*2, right: 0)
        selectionTableView?.backgroundColor = UIColor.clearColor()
        selectionTableView?.separatorStyle = .None
        selectionTableView?.delegate = self
        selectionTableView?.dataSource = self
        
        maskBg = UIView(frame: CGRect.zero)
        maskBg?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        maskBg?.addGestureRecognizer(tapGesture!)

    }
    
    //MARK: - Show / Dismiss
    func refresh(items : [String], defaultValue : String? = nil) {
        self.items = items
        selectionTableView?.reloadData()
        
        self.defaultValue = defaultValue
        if let items = self.items, let defaultValue = defaultValue {
            if let index = items.indexOf(defaultValue) {
                selectionTableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .Top, animated: false)
            } else {
                selectionTableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: Int(items.count/2), inSection: 0), atScrollPosition: .Top, animated: false)
            }
        }
        setNeedsLayout()
    }
    
    func begingSelection(in view: UIView, delegate : Any?, animated : Bool) {
        //scroll to default value
        maskBg?.frame = view.frame
        maskBg?.alpha = 0
        selectionTableView?.alpha = 0
        addSubview(indicatorLine!)
        view.addSubview(maskBg!)
        view.addSubview(selectionTableView!)

        //Calcualte frame of selectionTableView
        let itemCount = items?.count ?? 1
        let tableHeight = min(CGFloat(itemCount) * CGRectGetHeight(frame), CGRectGetHeight(frame) * maxItemCount)
        var valueFrame = convertRect(valueLabel!.frame, toView: view)
        valueFrame.origin.x = valueFrame.origin.x + 71
        valueFrame.size.width = selectionPanelWidth
        //downloadExpanding animation
        downExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: selectionPanelWidth, height: 1)
        downExpandView?.alpha = 0
        upExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: selectionPanelWidth, height: 1)
        upExpandView?.alpha = 0
        let downTargetFrame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y, width: selectionPanelWidth, height: UniSelectionFieldDefaultHeight*3)
        let upTargetFrame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y - UniSelectionFieldDefaultHeight*2, width: selectionPanelWidth, height: UniSelectionFieldDefaultHeight*2)
        view.insertSubview(downExpandView!, belowSubview: selectionTableView!)
        view.insertSubview(upExpandView!, belowSubview: selectionTableView!)
        valueFrame.origin.y = valueFrame.origin.y + valueFrame.size.height/2 - tableHeight/2
        let targetFrame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y, width: selectionPanelWidth, height: tableHeight)
        selectionTableView?.frame = valueFrame
        
        //draw a line with animation
        var indicatorFrame = CGRect(x: 0, y: CGRectGetHeight(frame) - 2, width: 1, height: 1)
        indicatorLine?.frame = indicatorFrame
        indicatorFrame.size.width = CGRectGetWidth(frame)
        
        UIView.animateWithDuration(animated ? duration : 0, animations: {
            self.indicatorLine?.frame = indicatorFrame
            
        }) { (success) in
            UIView.animateWithDuration(animated ? self.duration : 0, animations: {
                self.maskBg?.alpha = 1
                self.selectionTableView?.frame = targetFrame
                self.downExpandView?.frame = downTargetFrame
                self.upExpandView?.frame = upTargetFrame
                self.downExpandView?.alpha = 1
                self.upExpandView?.alpha = 1
                self.valueLabel?.alpha = 0
                
            }) { (success) in
                UIView.animateWithDuration(0.3, animations: { 
                    self.selectionTableView?.alpha = 1
                })
                //Notification for selection state changed
                NSNotificationCenter.defaultCenter().postNotificationName(UniSelectionFieldDidBeginSelectionName, object: self, userInfo: nil)
                self.editing = true
            }
        }
    }
    
    func endSelection(animated : Bool) {
        var targetFrame = selectionTableView!.frame
        targetFrame.size.height = CGRectGetHeight(frame)
        var valueFrame = convertRect(valueLabel!.frame, toView: downExpandView?.superview)
        valueFrame.origin.x = valueFrame.origin.x + 71
        valueFrame.size.width = selectionPanelWidth
        UIView.animateWithDuration(animated ? duration * 1.5 : 0, animations: {
            self.maskBg?.alpha = 0
            self.selectionTableView?.alpha = 0
            self.selectionTableView?.frame = targetFrame
            self.valueLabel?.alpha = 1
            self.downExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: self.selectionPanelWidth, height: 1)
            self.downExpandView?.alpha = 0
            self.upExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: self.selectionPanelWidth, height: 1)
            self.upExpandView?.alpha = 0
            
        }) { (success) in
            self.editing = false
            self.maskBg?.removeFromSuperview()
            self.selectionTableView?.removeFromSuperview()
            self.downExpandView?.removeFromSuperview()
            self.upExpandView?.removeFromSuperview()
        }
        //invoke the delegate
        if let value = valueLabel?.text {
            delegate?.selectionField(self, didSelect: value)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(UniSelectionFieldDidEndSelectionName, object: self, userInfo: nil)
    }
    
    func hideValueLabel() {
        UIView.animateWithDuration(0.3) { 
            self.valueLabel?.alpha = 0
        }
    }
    
    func showValueLabel() {
        UIView.animateWithDuration(0.3) {
            self.valueLabel?.alpha = 1
        }
    }

    
    //MARK: - UITapGestureRecognizer
    func handleTap() {
        endSelection(true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {
            return 0
        }
        return items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UniSelectionFieldDefaultHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textColor = UIColor.grayColor()
            cell?.textLabel?.textAlignment = .Right
            cell?.textLabel?.font = UIFont.systemFontOfSize(16)
            cell?.selectionStyle = .None
        }
        if let items = items {
            let item = items[indexPath.row]
            cell?.textLabel?.text = item
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + CGRectGetHeight(frame)*2
        let index = Int(offset / UniSelectionFieldDefaultHeight)
        guard let items = items where items.indices.contains(index) else {
            return
        }
        let value = items[index]
        valueLabel?.text = value
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offset = scrollView.contentOffset.y + CGRectGetHeight(frame)*2 + 22
            autoAdjustingIndexPath(with: offset)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + CGRectGetHeight(frame)*2 + 22
        autoAdjustingIndexPath(with: offset)
    }
    
    //MARK: - Private
    private func autoAdjustingIndexPath(with offset : CGFloat) {
        let index = Int(offset / UniSelectionFieldDefaultHeight)
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if let _ = selectionTableView?.cellForRowAtIndexPath(indexPath) {
            selectionTableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
}
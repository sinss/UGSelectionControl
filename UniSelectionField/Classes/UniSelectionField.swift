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
    func selectionField(_ selectionField : UniSelectionField, didSelect value : String)
    func selectionField(_ didCancelWithSelectionField : UniSelectionField)
}

class UniSelectionField : UIControl , UITableViewDelegate, UITableViewDataSource {
    
    var delegate : UniSelectionFieldDelegate?
    var editing : Bool = false
    
    fileprivate var indicatorLine : UIView?
    fileprivate var selectionTableView : UITableView?
    fileprivate var titleLabel : UILabel?
    fileprivate var valueLabel : UILabel?
    fileprivate var maskBg : UIView?
    
    fileprivate var downExpandView : UIView?
    fileprivate var upExpandView : UIView?
    
    fileprivate var tapGesture : UITapGestureRecognizer?
    fileprivate var maskTapGesture : UITapGestureRecognizer?
    
    fileprivate var title : String?
    fileprivate var defaultValue : String?
    fileprivate var items : [String]?
    
    fileprivate let cellIdentifier = "selectionCellIdentifier"
    fileprivate let duration : TimeInterval = 0.5
    fileprivate let maxItemCount : CGFloat = 5
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
        let height = frame.height
        let width = frame.width
        titleLabel?.frame = CGRect(x: 10, y: 0, width: 120, height: height)
        valueLabel?.frame = CGRect(x: width - 220, y: 0, width: 205, height: height)
    }
    
    fileprivate func initializeUI() {
        backgroundColor = UIColor.clear
        //Create title Label
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleLabel?.textAlignment = .left
        titleLabel?.text = title
        addSubview(titleLabel!)
        //Create value Label
        valueLabel = UILabel(frame: CGRect.zero)
        valueLabel?.textColor = UIColor.white
        valueLabel?.font = UIFont.systemFont(ofSize: 16)
        valueLabel?.textAlignment = .right
        valueLabel?.text = String(defaultValue ?? "34")
        addSubview(valueLabel!)
        
        indicatorLine = UIView(frame: CGRect(x: 10, y: frame.height - 2, width: 1, height: 1))
        indicatorLine?.backgroundColor = UIColor.white
        
        downExpandView = UIView(frame: CGRect.zero)
        downExpandView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        upExpandView = UIView(frame: CGRect.zero)
        upExpandView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        selectionTableView = UITableView(frame: CGRect.zero)
        selectionTableView?.contentInset = UIEdgeInsets(top: frame.height*2, left: 0, bottom: frame.height*2, right: 0)
        selectionTableView?.backgroundColor = UIColor.clear
        selectionTableView?.separatorStyle = .none
        selectionTableView?.delegate = self
        selectionTableView?.dataSource = self
        
        maskBg = UIView(frame: CGRect.zero)
        maskBg?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        maskBg?.addGestureRecognizer(tapGesture!)

    }
    
    //MARK: - Show / Dismiss
    func refresh(_ items : [String], defaultValue : String? = nil) {
        self.items = items
        selectionTableView?.reloadData()
        
        self.defaultValue = defaultValue
        if let items = self.items, let defaultValue = defaultValue {
            if let index = items.index(of: defaultValue) {
                selectionTableView?.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
            } else {
                selectionTableView?.scrollToRow(at: IndexPath(row: Int(items.count/2), section: 0), at: .top, animated: false)
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
        let tableHeight = min(CGFloat(itemCount) * frame.height, frame.height * maxItemCount)
        var valueFrame = convert(valueLabel!.frame, to: view)
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
        var indicatorFrame = CGRect(x: 0, y: frame.height - 2, width: 1, height: 1)
        indicatorLine?.frame = indicatorFrame
        indicatorFrame.size.width = frame.width
        
        UIView.animate(withDuration: animated ? duration : 0, animations: {
            self.indicatorLine?.frame = indicatorFrame
            
        }, completion: { (success) in
            UIView.animate(withDuration: animated ? self.duration : 0, animations: {
                self.maskBg?.alpha = 1
                self.selectionTableView?.frame = targetFrame
                self.downExpandView?.frame = downTargetFrame
                self.upExpandView?.frame = upTargetFrame
                self.downExpandView?.alpha = 1
                self.upExpandView?.alpha = 1
                self.valueLabel?.alpha = 0
                
            }, completion: { (success) in
                UIView.animate(withDuration: 0.3, animations: { 
                    self.selectionTableView?.alpha = 1
                })
                //Notification for selection state changed
                NotificationCenter.default.post(name: Notification.Name(rawValue: UniSelectionFieldDidBeginSelectionName), object: self, userInfo: nil)
                self.editing = true
            }) 
        }) 
    }
    
    func endSelection(_ animated : Bool) {
        var targetFrame = selectionTableView!.frame
        targetFrame.size.height = frame.height
        var valueFrame = convert(valueLabel!.frame, to: downExpandView?.superview)
        valueFrame.origin.x = valueFrame.origin.x + 71
        valueFrame.size.width = selectionPanelWidth
        UIView.animate(withDuration: animated ? duration * 1.5 : 0, animations: {
            self.maskBg?.alpha = 0
            self.selectionTableView?.alpha = 0
            self.selectionTableView?.frame = targetFrame
            self.valueLabel?.alpha = 1
            self.downExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: self.selectionPanelWidth, height: 1)
            self.downExpandView?.alpha = 0
            self.upExpandView?.frame = CGRect(x: valueFrame.origin.x, y: valueFrame.origin.y + UniSelectionFieldDefaultHeight/2, width: self.selectionPanelWidth, height: 1)
            self.upExpandView?.alpha = 0
            
        }, completion: { (success) in
            self.editing = false
            self.maskBg?.removeFromSuperview()
            self.selectionTableView?.removeFromSuperview()
            self.downExpandView?.removeFromSuperview()
            self.upExpandView?.removeFromSuperview()
        }) 
        //invoke the delegate
        if let value = valueLabel?.text {
            delegate?.selectionField(self, didSelect: value)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: UniSelectionFieldDidEndSelectionName), object: self, userInfo: nil)
    }
    
    func hideValueLabel() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.valueLabel?.alpha = 0
        }) 
    }
    
    func showValueLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.valueLabel?.alpha = 1
        }) 
    }

    
    //MARK: - UITapGestureRecognizer
    func handleTap() {
        endSelection(true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UniSelectionFieldDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.gray
            cell?.textLabel?.textAlignment = .right
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell?.selectionStyle = .none
        }
        if let items = items {
            let item = items[indexPath.row]
            cell?.textLabel?.text = item
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + frame.height*2
        let index = Int(offset / UniSelectionFieldDefaultHeight)
        guard let items = items, items.indices.contains(index) else {
            return
        }
        let value = items[index]
        valueLabel?.text = value
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offset = scrollView.contentOffset.y + frame.height*2 + 22
            autoAdjustingIndexPath(with: offset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + frame.height*2 + 22
        autoAdjustingIndexPath(with: offset)
    }
    
    //MARK: - Private
    fileprivate func autoAdjustingIndexPath(with offset : CGFloat) {
        let index = Int(offset / UniSelectionFieldDefaultHeight)
        let indexPath = IndexPath(row: index, section: 0)
        if let _ = selectionTableView?.cellForRow(at: indexPath) {
            selectionTableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

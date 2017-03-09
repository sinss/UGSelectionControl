//
//  UniSelectionTableViewCell.swift
//  UniSelectionField
//
//  Created by Leo Chang on 8/19/16.
//  Copyright © 2016 Unigreen. All rights reserved.
//

import UIKit

class UniSelectionTableViewCell: UITableViewCell, UniSelectionFieldDelegate {

    static let cellIdentifier = "UniSelectionTableViewCellID"
    var inputControl : UniSelectionField?
    var items : [String]?
    var defaultValue : String?
    
    weak var targetView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(UniSelectionFieldDidBeginSelection), name: NSNotification.Name(rawValue: UniSelectionFieldDidBeginSelectionName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UniSelectionFieldDidEndSelection), name: NSNotification.Name(rawValue: UniSelectionFieldDidEndSelectionName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupControl(for title : String, value : String, items : [String]?, inView : UIView) {
        self.defaultValue = value
        self.items = items
        self.targetView = inView
        if inputControl == nil {
            inputControl = UniSelectionField(frame: bounds, title: title, value: value, items: items)
            inputControl?.delegate = self
            inputControl?.addTarget(self, action: #selector(inputFieldPressed(_:)), for: .touchUpInside)
            addSubview(inputControl!)
        }
    }
    
    func inputFieldPressed(_ sender : UIControl) {
        guard let targetView = targetView, let items = items else {
            return
        }
        inputControl?.refresh(items, defaultValue: defaultValue)
        inputControl?.begingSelection(in: targetView, delegate: self, animated: true)
    }
    
    //MARK: - UniSelectionFieldDelegate
    func selectionField(_ selectionField : UniSelectionField, didSelect value : String) {
        defaultValue = value
    }
    
    func selectionField(_ didCancelWithSelectionField : UniSelectionField) {
        
    }
    
    //MARK: - Notifications
    func UniSelectionFieldDidBeginSelection() {
        inputControl?.hideValueLabel()
    }
    
    func UniSelectionFieldDidEndSelection() {
        inputControl?.showValueLabel()
    }
}

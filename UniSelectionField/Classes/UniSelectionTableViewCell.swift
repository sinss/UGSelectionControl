//
//  UniSelectionTableViewCell.swift
//  UniSelectionField
//
//  Created by Leo Chang on 8/19/16.
//  Copyright © 2016 Unigreen. All rights reserved.
//

import UIKit

class UniSelectionTableViewCell: UITableViewCell {

    static let cellIdentifier = "UniSelectionTableViewCellID"
    var inputControl : UniSelectionField?
    var items : [String]?
    var defaultValue : String?
    
    weak var targetView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupControl(for title : String, value : String, items : [String]?, inView : UIView) {
        self.defaultValue = value
        self.items = items
        self.targetView = inView
        if inputControl == nil {
            inputControl = UniSelectionField(frame: bounds, title: title, value: value, items: items)
            inputControl?.addTarget(self, action: #selector(inputFieldPressed(_:)), forControlEvents: .TouchUpInside)
            addSubview(inputControl!)
        }
    }
    
    func inputFieldPressed(sender : UIControl) {
        guard let targetView = targetView, let items = items else {
            return
        }
        inputControl?.refresh(items, defaultValue: defaultValue)
        inputControl?.begingSelection(in: targetView, delegate: self, animated: true)
    }
    
}

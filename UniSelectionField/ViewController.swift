//
//  ViewController.swift
//  UniSelectionField
//
//  Created by Leo Chang on 8/19/16.
//  Copyright © 2016 Unigreen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var inputField : UniSelectionField?
    
    let yearIdentifier = "yearIdentifier"
    let monthIdentifier = "monthIdentifier"
    let dayIdentifier = "dayIdentifier"
    let hourIdentifier = "hourIdentifier"
    let minuteIdentifier = "minuteIdentifier"
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: yearIdentifier)
        tableView.registerNib(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: monthIdentifier)
        tableView.registerNib(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: dayIdentifier)
        tableView.registerNib(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: hourIdentifier)
        tableView.registerNib(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: minuteIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func inputFieldPressed(sender : UIControl) {
        var items = [String]()
        for i in 1..<105 {
            items.append(String(i))
        }
        inputField?.refresh(items, defaultValue: "34")
        inputField?.begingSelection(in: view, delegate: self, animated: true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(view.frame), height: 22))
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(11)
        if section == 0 {
            label.text = "Birthday date"
        } else if section == 1 {
            label.text = "Birthday time"
        }
        return label
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                var items = [String]()
                for i in 1..<105 {
                    items.append(String(i+1911))
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(yearIdentifier, forIndexPath: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupControl(for: "Year", value: "1982", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 1 {
                var items = [String]()
                for i in 1...12 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(monthIdentifier, forIndexPath: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupControl(for: "Month", value: "8", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 2 {
                var items = [String]()
                for i in 1...31 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(dayIdentifier, forIndexPath: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupControl(for: "Date", value: "17", items: items, inView: self.view)
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                var items = [String]()
                for i in 1..<24 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(hourIdentifier, forIndexPath: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupControl(for: "Hour", value: "2", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 1 {
                var items = [String]()
                for i in 1...60 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(minuteIdentifier, forIndexPath: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupControl(for: "Minute", value: "1", items: items, inView: self.view)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}


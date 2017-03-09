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
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: yearIdentifier)
        tableView.register(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: monthIdentifier)
        tableView.register(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: dayIdentifier)
        tableView.register(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: hourIdentifier)
        tableView.register(UINib(nibName: "UniSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: minuteIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func inputFieldPressed(_ sender : UIControl) {
        var items = [String]()
        for i in 1..<105 {
            items.append(String(i))
        }
        inputField?.refresh(items, defaultValue: "34")
        inputField?.begingSelection(in: view, delegate: self, animated: true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 22))
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 11)
        if section == 0 {
            label.text = "Birthday date"
        } else if section == 1 {
            label.text = "Birthday time"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                var items = [String]()
                for i in 1..<105 {
                    items.append(String(i+1911))
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: yearIdentifier, for: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.setupControl(for: "Year", value: "1982", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 1 {
                var items = [String]()
                for i in 1...12 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: monthIdentifier, for: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.setupControl(for: "Month", value: "8", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 2 {
                var items = [String]()
                for i in 1...31 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: dayIdentifier, for: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.setupControl(for: "Date", value: "17", items: items, inView: self.view)
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                var items = [String]()
                for i in 1..<24 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: hourIdentifier, for: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.setupControl(for: "Hour", value: "2", items: items, inView: self.view)
                return cell
            } else if indexPath.row == 1 {
                var items = [String]()
                for i in 1...60 {
                    items.append(String(i))
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: minuteIdentifier, for: indexPath) as! UniSelectionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.setupControl(for: "Minute", value: "1", items: items, inView: self.view)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}


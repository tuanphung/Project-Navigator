//
//  ExMultiItemsPicker.swift
//  places
//
//  Created by Tuan Phung on 5/2/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

class ExItemPicker {
    var key: String!
    var value: AnyObject!
    var selected: Bool = false
    
    convenience init(key: String, value: AnyObject, selected: Bool! = false) {
        self.init()
        
        self.key = key
        self.value = value
        self.selected = selected
    }
}

class ExMultiItemsPickerController: ExViewController {
    private var tableView: UITableView!
    var items: [ExItemPicker]!
    var onDidSelectItems:((selectedItems: [ExItemPicker]) -> ())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(items: [ExItemPicker]) {
        self.init()
        
        self.items = items
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func ex_setUpComponentsOnLoad() {
        super.ex_setUpComponentsOnLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.tableView)
        
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0.0-[tableView]-0.0-|", options: nil, metrics: nil, views: ["tableView": self.tableView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0.0-[tableView]-0.0-|", options: nil, metrics: nil, views: ["tableView": self.tableView]))
    }
    
    func enableCancel(enabled: Bool) {
        if (enabled) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        var selectedItems = self.items.filter { $0.selected == true }
        
        self.onDidSelectItems?(selectedItems: selectedItems)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ExMultiItemsPickerController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as! UITableViewCell
        cell.textLabel?.text = item.key
        cell.accessoryType = UITableViewCellAccessoryType.None
        if item.selected {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var item = self.items[indexPath.row]
        item.selected = !item.selected
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
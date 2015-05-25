//
//  ExTableView.swift
//  places
//
//  Created by Tuan Phung on 5/11/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

class ExDynamicTableViewCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nibName(), bundle: nil)
    }
    
    //MARK: Override in subclasses
    class func reuseIdentifier() -> String {
        return "ExTableViewCell"
    }
    
    class func nibName() -> String {
        return "ExTableViewCell"
    }
    
    class func height(model: AnyObject) -> CGFloat { return 0 }
    func renderModel(model: AnyObject) { }
}

class ExCellConfiguration: NSObject {
    var cellClass: ExDynamicTableViewCell.Type!
    var modelClass: AnyClass!
    
    var useNib: Bool = true
    
    init(cellClass: ExDynamicTableViewCell.Type, modelClass: AnyClass, useNib: Bool! = true) {
        super.init()
        
        self.cellClass = cellClass
        self.modelClass = modelClass
        self.useNib = useNib
    }
}

class ExDynamicTableView: UITableView {
    
    var source = [AnyObject]()
    private var registeredCellConfigurations = [ExCellConfiguration]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initialize()
    }
    
    func initialize() {
        self.dataSource = self
        self.delegate = self
        if self.respondsToSelector(Selector("setLayoutMargins:")) {
            self.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func registerClass(cellClass: ExDynamicTableViewCell.Type, model: AnyClass) {
        var configuration = ExCellConfiguration(cellClass: cellClass, modelClass: model, useNib: false)
        self.registeredCellConfigurations.append(configuration)
        self.registerClass(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier())
    }
    
    func registerNib(cellClass: ExDynamicTableViewCell.Type, model: AnyClass) {
        var configuration = ExCellConfiguration(cellClass: cellClass, modelClass: model, useNib: true)
        self.registeredCellConfigurations.append(configuration)
        self.registerNib(cellClass.nib(), forCellReuseIdentifier: cellClass.reuseIdentifier())
    }
}

extension ExDynamicTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var model: AnyObject = self.source[indexPath.row]
        var matchedConfiguration: ExCellConfiguration!
        
        for configuration in self.registeredCellConfigurations {
            if (model.isKindOfClass(configuration.modelClass)) {
                matchedConfiguration = configuration
                break;
            }
        }
        
        var className = matchedConfiguration.cellClass
        var cell = tableView.dequeueReusableCellWithIdentifier(matchedConfiguration.cellClass.reuseIdentifier()) as! ExDynamicTableViewCell
        cell.renderModel(model)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var model: AnyObject = self.source[indexPath.row]
        var matchedConfiguration: ExCellConfiguration!
        
        for configuration in self.registeredCellConfigurations {
            if (model.isKindOfClass(configuration.modelClass)) {
                matchedConfiguration = configuration
                break;
            }
        }
        
        var cellClass = matchedConfiguration.cellClass
        return cellClass.height(model)
    }
}

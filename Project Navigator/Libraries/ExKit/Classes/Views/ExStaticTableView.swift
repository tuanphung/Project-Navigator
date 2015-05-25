//
//  ExStaticTableView.swift
//  upaty
//
//  Created by Tuan Phung on 5/23/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

class ExStaticTableView: UITableView {
//    var cells = [UITableViewCell]()
    let staticCellIdentifier = "StaticCellIdentifier"
    var cellViews = [ExView]() {
        didSet {
//            for view in self.cellViews {
//                var cell = UITableViewCell()
//                cell.contentView.addSubview(view)
//                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0.0-[view]-0.0-|", options: nil, metrics: nil, views: ["view": view]))
//                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0.0-[view]-0.0-|", options: nil, metrics: nil, views: ["view": view]))
//                self.cells.append(cell)
//            }
//            self.reloadData()
        }
    }
    
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
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: staticCellIdentifier)
        self.tableFooterView = UIView(frame: CGRectZero)
        if self.respondsToSelector(Selector("setLayoutMargins:")) {
            self.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func reloadViews(views: [ExView]) {
        var indexPaths = [NSIndexPath]()
        for view in views {
            if let index = self.cellViews.indexOf(view) {
                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        self.reloadData()
//        self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
}

extension ExStaticTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellView = self.cellViews[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(staticCellIdentifier) as! UITableViewCell
        println(cellView.frame)
        cell.contentView.addSubview(cellView)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        var cellView = self.cellViews[indexPath.row]
        println("\(indexPath.row) \(cellView.bounds.size)")
        return cellView.bounds.size.height + 1
        
//        cellView.setNeedsUpdateConstraints()
//        cellView.updateConstraintsIfNeeded()
//        
////        cellView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 0)
//
//        cellView.layoutIfNeeded()
//        
//        var size = cellView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
////        var size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        
//        // Add an extra point to the height to account for the cell separator, which is added between the bottom
//        // of the cell's contentView and the bottom of the table view cell.
//        height = size.height + 1
//        
//        println("\(indexPath.row) \(size)")
//        return height
    }
}
//
//  MainViewController.swift
//  Project Navigator
//
//  Created by Tuan Phung on 5/25/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import UIKit

class MainViewController: ExViewController {

    @IBOutlet var mapView: AppleMapView!
    
    override func ex_setUpComponentsOnLoad() {
        super.ex_setUpComponentsOnLoad()
        
        self.setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        var searchBar = UISearchBar(frame: CGRectInset(self.view.bounds, 16, 0))
        searchBar.placeholder = "Search by address"
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}


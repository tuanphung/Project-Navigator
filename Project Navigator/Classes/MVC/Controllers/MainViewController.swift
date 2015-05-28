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
    
    var searchBar: UISearchBar!
    var places = [SPGooglePlacesAutocompletePlace]()
    @IBOutlet var placesTableView: UITableView!
    
    override func ex_setUpComponentsOnLoad() {
        super.ex_setUpComponentsOnLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.setUpNavigationBar()
        self.setUpPlaceSearch()
    }
    
    func setUpNavigationBar() {
        self.searchBar = UISearchBar(frame: CGRectInset(self.view.bounds, 16, 0))
        self.searchBar.placeholder = "Search by address"
        self.searchBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.searchBar.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func setUpPlaceSearch() {
        /* Create an instance of UITableView to populate search places
        * By default, hide it until user perform a search */
        self.placesTableView = UITableView()
        self.placesTableView.alpha = 0
        self.placesTableView.keyboardDismissMode = .OnDrag
        self.placesTableView.dataSource = self
        self.placesTableView.delegate = self
        self.placesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.placesTableView)
        
        self.placesTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0.0-[view]-0.0-|", options: nil, metrics: nil, views: ["view": self.placesTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0.0-[view]-0.0-|", options: nil, metrics: nil, views: ["view": self.placesTableView]))
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        UIView.animateWithDuration(0.5, animations: {
            self.placesTableView.alpha = 1
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchPlaceWithAddress(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.hidePlaceSearch()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (self.places.count > 0) {
            // By default, pick the first place to search
            var place = self.places[0]
            self.performSearchPlaceWithAddress(place.name)
        }
        
        self.hidePlaceSearch()
    }
    
    /*
    * Create a query instance to fetch place with user input
    * Then, populate places are found on UI under UITableView
    * query.fetchPlaces will cancel previous uncompleted request, to make sure that the response is belong to last request */
    func searchPlaceWithAddress(address: String) {
        var query = SPGooglePlacesAutocompleteQuery(apiKey: GOOGLE_API_KEY)
        query.types = SPGooglePlacesAutocompletePlaceType.PlaceTypeAll
        query.input = address
        query.fetchPlaces { (places, error) -> Void in
            if (error == nil) {
                println("Found \(places.count) place(s)")
                self.places = places as! [SPGooglePlacesAutocompletePlace]
                self.placesTableView.reloadData()
            }
        }
    }
    
    func hidePlaceSearch() {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, animations: {
            self.placesTableView.alpha = 0
        })
    }
    
    func performSearchPlaceWithAddress(address: String) {
        self.searchBar.text = address
        
        GGApi.coordinateFromAddress(address, completion: { (coordinate) -> () in
            if let _coordinate = coordinate {
                self.mapView.dropNewPin(_coordinate, address: address, autoShowDirection: true)
                self.mapView.setCenterCoordinate(_coordinate, zoomLevel: self.mapView.zoomLevel, animated: true)
            }
        })
    }
}

//MARK: Implement Datasouce and Delegate for Autocomplete Search Place
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var place = self.places[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.font = UIFont.HelveticaRegular(14)
        cell.textLabel?.text = place.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.hidePlaceSearch()
        var place = self.places[indexPath.row]
        self.performSearchPlaceWithAddress(place.name)
    }
}


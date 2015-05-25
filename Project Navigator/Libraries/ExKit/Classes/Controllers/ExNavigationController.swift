//
//  ExNavigationController.swift
//  places
//
//  Created by Tuan Phung on 5/11/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

class ExNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ex_setUpComponentsOnLoad()
        
        self.ex_onDidLoad()?()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.ex_setUpComponentsOnWillAppear()
        
        self.ex_onWillAppear()?()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ex_setUpComponentsOnDidAppear()
        
        self.ex_onDidAppear()?()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.ex_setUpComponentsOnWillDisappear()
        
        self.ex_onWillDisappear()?()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.ex_setUpComponentsOnDidDisappear()
        
        self.ex_onDidDisappear()?()
    }
}
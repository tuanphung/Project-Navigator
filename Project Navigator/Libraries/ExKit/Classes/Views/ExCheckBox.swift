//
//  ExCheckBox.swift
//  upaty
//
//  Created by Tuan Phung on 5/23/15.
//  Copyright (c) 2015 Tuan Phung. All rights reserved.
//

import Foundation

@IBDesignable
class ExCheckBoxDesignable: ExImageView {
    @IBInspectable
    var checked: Bool = false {
        didSet {
            self.image = self.checked ? self.checkedImage : self.unCheckedImage
        }
    }
    
    @IBInspectable
    var checkedImage: UIImage = UIImage()
    
    @IBInspectable
    var unCheckedImage: UIImage = UIImage()
}

class ExCheckBox: ExCheckBoxDesignable {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UITapGestureRecognizer(block: {[unowned self] in
            self.checked = !self.checked
        }))
    }
}
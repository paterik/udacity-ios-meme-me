//
//  UIMemeTextField.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 15.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class UIMemeTextField: UITextField {
    
    var contentDefault: String = ""
    
    func differsFromDefault() -> Bool {

        return self.text != contentDefault
    }
}

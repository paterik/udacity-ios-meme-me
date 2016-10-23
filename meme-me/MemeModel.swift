//
//  MemeModel.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 15.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: Meme Model Definition
//

struct Meme {
    
    var textTop: String?
    var textBottom: String?
    var imageOrigin: UIImage?
    var image: UIImage?
    var fresh: Bool?
    let created: Date?
}

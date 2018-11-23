//
//  Category.swift
//  UdemyNotesOnTheGo
//
//  Created by Cristian Misael Almendro Lazarte on 11/19/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import Foundation
import UIKit;


extension Category {

    var color: UIColor? {
        
        get {
            guard let hex = colorHex else{ return nil }
            
            return UIColor(hex: hex);
        }
        set (newColor){
            if let newColor = newColor {
                colorHex = newColor.toHex;
            }
        }
    }
    
}

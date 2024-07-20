//
//  DefaultInsulin.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData

@Model
class DefaultInsulin{
    var insulin: String
    var administration: Int
    
    init(insulin: String, administration: Int) {
        self.insulin = insulin
        self.administration = administration
    }
}

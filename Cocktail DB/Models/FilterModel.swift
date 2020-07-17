//
//  FilterModel.swift
//  Cocktail DB
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct FilterModel: Codable & Equatable {
    var strCategory: String?
}

struct UIFilterModel: Codable & Equatable {
    let filter: FilterModel
    var isSelected: Bool = true
    
    static func == (lhs: UIFilterModel, rhs: UIFilterModel) -> Bool {
        return lhs.filter == rhs.filter && lhs.isSelected == rhs.isSelected
    }
}

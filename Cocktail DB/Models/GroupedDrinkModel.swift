//
//  GroupedDrinkModel.swift
//  Cocktail DB
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

class GroupedDrinkModel {
    var groupName: String
    var drinks: [DrinkModel]
    
    init(groupName: String, drinks: [DrinkModel]) {
        self.groupName = groupName
        self.drinks = drinks
    }
}

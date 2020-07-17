//
//  Constants.swift
//  Cocktail DB
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct URLs {
    static let Base = "https://www.thecocktaildb.com/api/json/v1/1"
    
    static let AllFilters = "/list.php?c=list"
    static let Drinks = "/filter.php?c="
}

struct Segues {
    static let Filters = "FiltersSegue"
}

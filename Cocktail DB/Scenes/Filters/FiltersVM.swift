//
//  FiltersVM.swift
//  Cocktail DB
//
//  Created by Oleksii Kaharov on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

class FiltersVM {
    var filters: [UIFilterModel]
    var initialFilters: [UIFilterModel]
    
    init(filters: [UIFilterModel]) {
        self.filters = filters
        self.initialFilters = filters
    }
}

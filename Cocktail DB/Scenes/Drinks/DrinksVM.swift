//
//  DrinksVM.swift
//  Cocktail DB
//
//  Created by Oleksii Kaharov on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

class DrinksVM {
    var groupedDrinks: [GroupedDrinkModel] = []
    var filters: [UIFilterModel] = []
    
    var needsDownload = false
    
    var filtersLoaded = 0
}

extension DrinksVM {
    func loadDrinksForFilter(_ filter: String, success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.getDrinks(filter: filter, success: { (response) in
            let decoder = JSONDecoder()
            
            do {
                let decodedDrinks = try decoder.decode([String:[DrinkModel]].self, from: response)
                
                if let dictValue = decodedDrinks["drinks"] {
                    let drinks = dictValue
                    
                    self.groupedDrinks.append(GroupedDrinkModel(groupName: filter, drinks: drinks))
                    success?()
                }
                
            } catch let error {
                print(error)
                failure?(error.localizedDescription)
            }
        }, failure: { (error) in
            print(error)
            failure?(error.localizedDescription)
        })
    }
    
    func loadNextDrinksList(index: Int, success: (()->Void)?, failure: ((String)->Void)?) {
        let selectedFilters = filters.filter({ $0.isSelected == true })
        
        if (selectedFilters.count > 0) && (groupedDrinks.count < selectedFilters.count) {
            loadDrinksForFilter(selectedFilters[index].filter.strCategory!, success: {
                success?()
            }, failure: { (error) in
                failure?(error)
            })
        }
    }
    
    func loadAllFilters(success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.getFilters(success: { (response) in
            let decoder = JSONDecoder()
            
            do {
                let decodedFilters = try decoder.decode([String:[FilterModel]].self, from: response)
                
                if let dictValue = decodedFilters["drinks"] {
                    let simpleFilters = dictValue
                    
                    var uiFilters = [UIFilterModel]()
                    
                    simpleFilters.forEach({
                        uiFilters.append(UIFilterModel(filter: $0, isSelected: true))
                    })
                    
                    self.filters = uiFilters
                    
                    success?()
                }
                
            } catch let error {
                print(error)
                failure?(error.localizedDescription)
            }
            
        }, failure: { (error) in
            print(error)
            failure?(error.localizedDescription)
        })
    }
}

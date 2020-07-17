//
//  DrinksVC.swift
//  Cocktail DB
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class DrinksVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var viewModel: DrinksVM = DrinksVM()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Functions
    
    
    // MARK: - IBActions
    
}

// MARK: - UITableView DataSource Extension
extension DrinksVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedDrinks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedDrinks[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTVC.identifier, for: indexPath) as? DrinkTVC else { return UITableViewCell() }
        
        cell.drinkTitleLabel.text = viewModel.groupedDrinks[indexPath.section].drinks[indexPath.row].strDrink
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.groupedDrinks.map({ $0.groupName })
    }
}

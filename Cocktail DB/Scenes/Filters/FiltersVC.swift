//
//  FiltersVC.swift
//  Cocktail DB
//
//  Created by Oleksii Kaharov on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class FiltersVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    // MARK: - Variables
    var viewModel: FiltersVM!
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    
    // MARK: - IBActions
    @IBAction func onApplyButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView DataSource Extension
extension FiltersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        
        footerView.backgroundColor = .clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewModel.filters == viewModel.initialFilters ? 0 : 80
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.identifier, for: indexPath) as? FilterTVC else { return UITableViewCell() }
        
        cell.checkmarkImage.isHidden = !viewModel.filters[indexPath.row].isSelected
        cell.filterTitleLabel.text = viewModel.filters[indexPath.row].filter.strCategory
        
        return cell
    }
}

// MARK: - UITableView Delegate Extension
extension FiltersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.filters[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
        
        applyButton.isHidden = viewModel.filters == viewModel.initialFilters
    }
}

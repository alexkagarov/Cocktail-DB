//
//  DrinksVC.swift
//  Cocktail DB
//
//  Created by Oleksii Kaharov on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class DrinksVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    // MARK: - Variables
    var viewModel: DrinksVM = DrinksVM()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK: - Functions
    private func setupView() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
        retryButton.isHidden = true
    }
    
    private func completeLoading() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    private func loadData() {
        loadingLabel.text = "Loading filters..."
        
        if viewModel.filters.isEmpty {
            viewModel.loadAllFilters(success: {
                self.loadingLabel.text = "Loading drinks according to filters..."
                self.viewModel.filtersLoaded = 0
                
                self.updateData(success: {
                    self.completeLoading()
                    self.tableView.reloadData()
                })
                
            }, failure: { (error) in
                print(error)
                APIManager.shared.cancelAllTasks()
                self.loadingLabel.text = error
                self.retryButton.isHidden = false
            })
        } else {
            self.viewModel.filtersLoaded = 0
            self.viewModel.groupedDrinks = []
            self.loadingLabel.text = "Loading drinks according to filters..."
            
            self.updateData(success: {
                self.completeLoading()
                self.tableView.reloadData()
            })
        }
    }
    
    private func updateData(success: (()->Void)?) {
        viewModel.loadNextDrinksList(index: viewModel.filtersLoaded, success: {
            self.viewModel.filtersLoaded += 1
            
            success?()
            
        }, failure: { (error) in
            print(error)
            APIManager.shared.cancelAllTasks()
            self.loadingLabel.text = error
            self.retryButton.isHidden = false
        })
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Filters {
            guard let dest = segue.destination as? FiltersVC else { return }
            
            let vm = FiltersVM(filters: viewModel.filters)
            dest.viewModel = vm
        }
    }
    
    // MARK: - IBActions
    @IBAction func onFilterButtonTapped(_ sender: UIBarButtonItem) {
        if viewModel.filters.count > 0 {
            performSegue(withIdentifier: Segues.Filters, sender: self)
        }
    }
    
    @IBAction func onRetryButtonTapped(_ sender: UIButton) {
        setupView()
        loadData()
    }
}

// MARK: - UITableView DataSource Extension
extension DrinksVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedDrinks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedDrinks[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.groupedDrinks[section].groupName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTVC.identifier, for: indexPath) as? DrinkTVC else { return UITableViewCell() }
        
        cell.drinkTitleLabel.text = viewModel.groupedDrinks[indexPath.section].drinks[indexPath.row].strDrink
        if let thumbnail = viewModel.groupedDrinks[indexPath.section].drinks[indexPath.row].strDrinkThumb {
            cell.drinkImage.kf.setImage(with: URL(string: thumbnail))
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate Extension
extension DrinksVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedFilters = viewModel.filters.filter({ $0.isSelected == true })
        
        if (viewModel.groupedDrinks.count == selectedFilters.count) &&
            indexPath.section == (viewModel.groupedDrinks.count) - 1 &&
            indexPath.row == (viewModel.groupedDrinks[indexPath.section].drinks.count) - 1 {
//            self.viewModel.needsDownload = false
            
            let alert = UIAlertController(title: "All data loaded", message: "You've reached the end of all drinks in Cocktail DB", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            alert.view.tintColor = .black
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if (viewModel.groupedDrinks.count < selectedFilters.count) {
            if indexPath.row == viewModel.groupedDrinks[indexPath.section].drinks.count - 1 &&
                indexPath.section == viewModel.filtersLoaded-1 {
                
                self.updateData(success: {
                    self.tableView.reloadData()
                })
            }
        }
    }
}

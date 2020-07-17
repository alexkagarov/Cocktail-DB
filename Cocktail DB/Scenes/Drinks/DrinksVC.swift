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
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    
    // MARK: - Variables
    var viewModel: DrinksVM = DrinksVM()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        loadData()
    }
    
    // MARK: - Functions
    private func setupView() {
        loadingView.isHidden = false
        retryButton.isHidden = true
    }
    
    private func completeLoading() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    private func loadData() {
        retryButton.isHidden = true
        loadingLabel.text = "Loading filters..."
        
        if viewModel.filters.isEmpty {
            viewModel.loadAllFilters(success: {
                self.loadingLabel.text = "Loading drinks according to filters..."
                
                self.updateData(success: {
                    self.activityIndicator.stopAnimating()
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                })
                
            }, failure: { (error) in
                print(error)
                self.loadingLabel.text = error
                self.retryButton.isHidden = false
            })
        } else {
            
        }
    }
    
    private func updateData(success: (()->Void)?) {
        viewModel.groupedDrinks = []
        
        viewModel.loadNextDrinksList(index: 0, success: {
            success?()
            
        }, failure: { (error) in
            print(error)
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
        
        if viewModel.groupedDrinks.count < viewModel.filters.count {
            if indexPath.row == viewModel.groupedDrinks[indexPath.section].drinks.count - 1 {
                viewModel.loadNextDrinksList(index: indexPath.section+1, success: {
                    tableView.reloadData()
                }, failure: { (error) in
                    print(error)
                })
            }
        } else {
            let alert = UIAlertController(title: "All data loaded", message: "You've reached the end of all drinks in Cocktail DB", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            alert.view.tintColor = .black
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return cell
    }
}

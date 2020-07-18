//
//  CustomVC.swift
//  Cocktail DB
//
//  Created by Mac on 18.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CustomVC: UIViewController {

    @IBOutlet weak var navBar: CustomNavBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTranslucentNavigationBar()
        setupView()
        customNavBarShadow()
    }
    
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = Colors.WhiteToBlack
    }
    
    private func setTranslucentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func customNavBarShadow() {
        navBar?.layer.masksToBounds = false
        navBar?.layer.shadowColor = UIColor.gray.cgColor
        navBar?.layer.shadowOpacity = 0.5
        navBar?.layer.shadowOffset = CGSize(width: 0, height: 4)
        navBar?.layer.shadowRadius = 2
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

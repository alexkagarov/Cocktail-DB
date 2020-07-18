//
//  CustomNavBar.swift
//  Cocktail DB
//
//  Created by Oleksii Kaharov on 18.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

protocol CustomNavBarDelegate: class {
    func backBtnAction()
    func rightBtnAction()
}

class CustomNavBar: UIView {
    internal var nibName : String {
        return "CustomNavBar"
    }
    
    // MARK: IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var backBtn: UIButton!
    @IBOutlet private weak var backBtnView: UIView!
    
    @IBOutlet private weak var titleLbl: UILabel!
    
    @IBOutlet private weak var rightBtn: UIButton!
    @IBOutlet private weak var rightBtnView: UIView!
    
    // MARK: Manage items variables
    var isBackBtnHidden: Bool = true {
        didSet {
            backBtnView.isHidden = isBackBtnHidden ? true : false
        }
    }
    
    var isRightBtnHidden: Bool = true {
        didSet {
            rightBtnView.isHidden = isRightBtnHidden ? true : false
        }
    }
    
    var title: String = "" {
        didSet {
            titleLbl.text = title
        }
    }
    
    weak var delegate: CustomNavBarDelegate?
    
    // MARK: Setup view
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        let bundle = Bundle(for: CustomNavBar.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        
        isBackBtnHidden = true
        isRightBtnHidden = true
        
        title = ""
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        delegate?.backBtnAction()
    }
    
    @IBAction func rightBtnPressed(_ sender: UIButton) {
        delegate?.rightBtnAction()
    }
}

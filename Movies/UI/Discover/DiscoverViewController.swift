//
//  DiscoverViewController.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiscoverViewController: MovieListViewController {
    var sortButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setRightBarButton(sortButtonItem, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.navigationItem.setRightBarButton(nil, animated: animated)
    }
    
    @objc func sortAction(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Sort", message: "Choose the desire option", preferredStyle: .actionSheet)
        
        for option in SortOption.allOptions {
            actionSheet.addAction(
                UIAlertAction(title: option.humanized, style: .default, handler: { [weak self] _ in
                    var vm = self?.viewModel.input as? DiscoverViewModelInput
                    vm?.sortOption = option
                })
            )
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

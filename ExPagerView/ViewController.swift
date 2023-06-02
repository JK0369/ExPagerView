//
//  ViewController.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    private let tabView = TabView()
    var dataSource = (0...20).map(String.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.dataSource = self
        tabView.delegate = self
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
    }
}

extension ViewController: TabViewDataSource {
    var items: [String] {
        dataSource
    }
}

extension ViewController: TabViewDelegate {
    func didTap(index: Int) {
        
    }
}

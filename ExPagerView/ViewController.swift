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
    // tab
    private let tabView = TabView()
    
    // page
    private lazy var pagerView: PagerView = {
        return PagerView(items: self.items)
    }()
    
    private let items = (0...20).map(String.init)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.dataSource = items
        setupLayout()
        handleScroll()
    }
    
    private func setupLayout() {
        view.addSubview(tabView)
        view.addSubview(pagerView)
        
        tabView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        pagerView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func handleScroll() {
        tabView.syncUnderlineView(index: 0, underlineView: tabView.highlightView)
        
        tabView.didTap = { [weak self] index in
            guard let self else { return }
            pagerView.scroll(to: index)
            tabView.syncUnderlineView(index: index, underlineView: tabView.highlightView)
        }
        
        pagerView.didScroll = { [weak self] ratioX in
            guard let self else { return }
            tabView.scroll(to: ratioX)
            tabView.syncUnderlineView(ratio: ratioX, underlineView: tabView.highlightView)
        }
        
        pagerView.didEndScroll = { [weak self] index in
            guard let self else { return }
            tabView.syncUnderlineView(index: index, underlineView: tabView.highlightView)
        }
    }
}

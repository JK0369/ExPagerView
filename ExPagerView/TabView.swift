//
//  TabView.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

final class TabView: UIView {
    // MARK: UI
    private let stackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .horizontal
    }
    private let tabScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    let highlightView = UIView().then {
        $0.backgroundColor = .gray
    }
    private var contentLabels = [UILabel]()
    
    // MARK: Property
    var dataSource: [String]? {
        didSet { setItems() }
    }
    var didTap: ((Int) -> Void)?
    
    // MARK: Initializer
    required init() {
        super.init(frame: .zero)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Method
    private func configure() {
        addSubview(tabScrollView)
        tabScrollView.addSubview(stackView)
        tabScrollView.addSubview(highlightView)
        
        tabScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.height.equalToSuperview()
        }
        highlightView.snp.remakeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setItems() {
        guard let items = dataSource else { return }
        items
            .enumerated()
            .forEach { offset, item in
                let label = UILabel().then {
                    $0.text = item
                    $0.numberOfLines = 0
                    $0.font = .systemFont(ofSize: 14, weight: .regular)
                    $0.textColor = .black
                    $0.textAlignment = .center
                    $0.isUserInteractionEnabled = true
                }
                label.tag = offset
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapItem))
                label.addGestureRecognizer(tapGesture)
                self.stackView.addArrangedSubview(label)
                self.contentLabels.append(label)
            }
    }
    
    @objc private func tapItem(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        didTap?(tag)
    }
}

extension TabView: ScrollFitable {
    var tabContentViews: [UIView] {
        contentLabels
    }
    
    var scrollView: UIScrollView {
        tabScrollView
    }
    var countOfItems: Int {
        dataSource?.count ?? 0
    }
}

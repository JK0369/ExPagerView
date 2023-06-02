//
//  TabView.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

protocol TabViewDataSource: AnyObject {
    var items: [String] { get }
}

protocol TabViewDelegate: AnyObject {
    func didTap(index: Int)
}

final class TabView: UIView {
    // MARK: UI
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let scrollView = UIScrollView()
    
    // MARK: Property
    weak var dataSource: TabViewDataSource? {
        didSet { setItems() }
    }
    weak var delegate: TabViewDelegate?
    
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
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.height.equalToSuperview()
        }
    }
    
    private func setItems() {
        guard let items = dataSource?.items else { return }
        items
            .enumerated()
            .forEach { offset, item in
                let label = UILabel().then {
                    $0.text = item
                    $0.numberOfLines = 0
                    $0.font = .systemFont(ofSize: 16, weight: .regular)
                    $0.textColor = .black
                    $0.textAlignment = .center
                    $0.isUserInteractionEnabled = true
                }
                label.tag = offset
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapItem))
                label.addGestureRecognizer(tapGesture)
                self.stackView.addArrangedSubview(label)
            }
    }
    
    @objc private func tapItem(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        delegate?.didTap(index: tag)
    }
}

//
//  LabelViewController.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

final class LabelViewController: UIViewController {
    private let label = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupTitle(_ text: String) {
        label.text = text
    }
}

//
//  PagerView.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/03.
//

import UIKit
import Then
import SnapKit

final class PagerView: UIView {
    private lazy var collectionView: UICollectionView = {
        UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout().then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
            }
        ).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.register(PagerCell.self, forCellWithReuseIdentifier: "pager")
        }
    }()
    
    private let items: [String]
    var didScrollByManual: ((Double) -> ())?
    var isManualScrolled = false
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented")
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.setTrackingScroll()
    }
}

extension PagerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pager", for: indexPath) as? PagerCell
        else { return UICollectionViewCell() }
        cell.prepare(title: items[indexPath.row])
        return cell
    }
}

extension PagerView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratioX = scrollView.contentOffset.x / scrollView.contentSize.width
        print("test PagerView")
        guard isManualScrolled else { return }
        didScrollByManual?(ratioX)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isManualScrolled = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isManualScrolled = false
    }
}

extension PagerView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        frame.size
    }
}

extension PagerView: ScrollFitable {
    var scrollView: UIScrollView {
        collectionView
    }
    var countOfItems: Int {
        items.count
    }
}

// MARK: - PagerCell
final class PagerCell: UICollectionViewCell {
    // MARK: UI
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 24, weight: .regular)
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(title: nil)
    }
    
    func prepare(title: String?) {
        titleLabel.text = title
    }
}

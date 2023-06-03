//
//  ScrollFitable.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/03.
//

import UIKit

private struct AssociatedKeys {
    static var lastWidthKey = "lastWidth"
}

// Use this protocol to fitting scroll
protocol ScrollFitable: AnyObject {
    var scrollView: UIScrollView { get }
    var countOfItems: Int { get }
    var tabContentViews: [UIView] { get }
    
    func scroll(to index: Int)
    func scroll(to ratio: Double)
}

extension ScrollFitable {
    var lastWidth: Double {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.lastWidthKey) as? Double ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var tabContentViews: [UIView] {
        []
    }
    
    func scroll(to index: Int) {
        let offset = getStartOffset(index: index)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func scroll(to ratio: Double) {
        let rect = getTargetRect(ratio: ratio)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    // 핵심: 뷰 기준으로 해야 width값을 뷰의 동적 사이즈 대응이 가능
    func syncUnderlineView(index: Int, underlineView: UIView) {
        guard index < tabContentViews.count else { return }
        let targetLabel = tabContentViews[index]
        lastWidth = targetLabel.frame.width
        
        underlineView.snp.remakeConstraints {
            $0.width.equalTo(targetLabel)
            $0.height.equalTo(8)
            $0.leading.equalTo(targetLabel)
            $0.bottom.equalToSuperview()
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: { self.scrollView.layoutIfNeeded() }
        )
    }
    
    // 핵심: 뷰 기준으로 정하면 안됨 (view기준으로하면 뚝뚝 끊기는 스크롤이 되므로 실수값으로 해야함)
    func syncUnderlineView(ratio: Double, underlineView: UIView) {
        let leading = scrollView.contentSize.width * ratio
        
        underlineView.snp.remakeConstraints {
            $0.width.equalTo(lastWidth)
            $0.height.equalTo(8)
            $0.leading.equalTo(leading)
            $0.bottom.equalToSuperview()
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: { self.scrollView.layoutIfNeeded() }
        )
    }
    
    private func getStartOffset(index: Int) -> CGPoint {
        let totalWidth = scrollView.contentSize.width
        let widthPerItem = totalWidth / Double(countOfItems)
        let startOffsetX = widthPerItem * Double(index)
        return .init(
            x: startOffsetX,
            y: scrollView.contentOffset.y
        )
    }
    
    private func getTargetRect(ratio: Double) -> CGRect {
        let totalWidth = scrollView.contentSize.width
        
        let rect = CGRect(
            x: totalWidth * ratio,
            y: scrollView.frame.minY,
            width: scrollView.frame.width,
            height: scrollView.frame.height
        )
        return rect
    }
}
